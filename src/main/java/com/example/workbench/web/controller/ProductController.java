package com.example.workbench.web.controller;

import com.example.common.util.ConstantUtil;
import com.example.common.util.FileUtil;
import com.example.common.util.QiniuyunFileUploadUtil;
import com.example.common.vo.ProductVo;
import com.example.common.vo.ResultVo;
import com.example.settings.domain.User;
import com.example.settings.service.DicValueService;
import com.example.workbench.domain.Product;
import com.example.workbench.service.ProductService;
import com.example.workbench.service.RedisService;
import com.github.pagehelper.PageInfo;
import com.google.gson.JsonObject;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.ObjectUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * @类名 ProductController
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/16 22:12
 * @版本 1.0
 */
@Controller
@RequestMapping("/product")
@Slf4j
public class ProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private RedisService redisService;

    private String fileName;
    private String key;

    @GetMapping("/index.do")
    public String toIndex(Model model) {
        List<Object> objects = dicValueService.queryDicValueType(ConstantUtil.PRODUCT_TYPE);
        model.addAttribute("dicValues", objects);
        return "workbench/product/index";
    }

    @GetMapping("/splitPage.do")
    public @ResponseBody PageInfo<Product> splitPage(Integer startPage, Integer pageSize) {
        return productService.queryProductList(startPage, pageSize);
    }

    @PostMapping("/saveProduct.do")
    public @ResponseBody ResultVo saveProduct(@RequestParam Map<String, Object> map, HttpSession session) {
        if (ObjectUtils.allNotNull(key)) {
            try {
                map.put("uid", ((User) session.getAttribute(ConstantUtil.SESSION_USER)).getUid());
                productService.saveProduct(map);
                redisService.add(ConstantUtil.PRODUCT_SAVE__IMAGE_NAME_SET, fileName);
                return new ResultVo(ConstantUtil.SUCCESS_CODE);
            } catch (Exception e) {
                e.printStackTrace();
                return new ResultVo(ConstantUtil.FAIL_CODE, ConstantUtil.SAVE_PRODUCT_FAIL);
            }
        } else {
            return new ResultVo(ConstantUtil.FAIL_CODE, ConstantUtil.SAVE_PRODUCT_FAIL);
        }
    }

    @PostMapping(value = "/createProductImage.do")
    public @ResponseBody String createProductImage(@RequestBody MultipartFile productImg) {
        //获取文件原来的名称
        String originalFileName = productImg.getOriginalFilename();
        //生成文件名称
        fileName = FileUtil.generateFileName(Objects.requireNonNull(originalFileName));
        JsonObject jsonObject = new JsonObject();
        try {
            key = QiniuyunFileUploadUtil.uploadFile(productImg.getBytes(), fileName);
            redisService.add(ConstantUtil.PRODUCT_IMAGE_NAME_SET, fileName);
            jsonObject.addProperty("imgName", fileName);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jsonObject.toString();
    }

    @RequestMapping(value = "/queryProductVoByPid.do", method = RequestMethod.GET)
    public @ResponseBody ProductVo queryProductByPid(@RequestParam String pid) {
        return productService.queryProductVoByPid(pid);
    }

    @PostMapping("/editProduct.do")
    public @ResponseBody ResultVo editProduct(@RequestParam Map<String, String> map) {
        ResultVo resultVo = new ResultVo();
        try {
            productService.editProduct(map);
            resultVo.setCode(ConstantUtil.SUCCESS_CODE);
        } catch (Exception e) {
            resultVo.setCode(ConstantUtil.FAIL_CODE);
            resultVo.setMessage(ConstantUtil.UPDATE_PRODUCT_FAIL);
            e.printStackTrace();
        }
        return resultVo;
    }

    @PostMapping("/removeProducts.do")
    public @ResponseBody ResultVo removeProducts(@RequestParam String[] pids) {
        ResultVo resultVo = new ResultVo();
        try {
            productService.removeProducts(pids);
            resultVo.setCode(ConstantUtil.SUCCESS_CODE);
            resultVo.setNum(pids.length);
        } catch (Exception e) {
            resultVo.setCode(ConstantUtil.FAIL_CODE);
            resultVo.setMessage(ConstantUtil.REMOVE_PRODUCT_FAIL);
        }
        return resultVo;
    }
}

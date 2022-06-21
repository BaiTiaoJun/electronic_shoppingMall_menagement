package com.example.settings.web.controller;

import com.example.common.util.ConstantUtil;
import com.example.common.vo.ResultVo;
import com.example.settings.domain.DicType;
import com.example.settings.service.DicTypeService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * @类名 DirectoryTypeController
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/19 16:07
 * @版本 1.0
 */
@Controller
@RequestMapping("/settings/dictionary/type")
public class DirectoryTypeController {

    @Autowired
    private DicTypeService dicTypeService;

    @GetMapping("/index.do")
    public String toIndex() {
        return "settings/dictionary/type/index";
    }

    @GetMapping(value = "/splitPageQuery.do")
    public @ResponseBody
    PageInfo<DicType> splitPageQuery(Integer startPage, Integer pageSize) {
        return dicTypeService.splitPageQuery(startPage, pageSize);
    }

    @PostMapping("/saveDicType.do")
    public @ResponseBody
    ResultVo saveDicValue(@RequestParam Map<String, String> map) {
        try {
            int res = dicTypeService.saveDicValue(map);
            if (res == 0) {
                return new ResultVo(ConstantUtil.FAIL_CODE, ConstantUtil.CREATE_DICTYPE_FAIL);
            }
            return new ResultVo(ConstantUtil.SUCCESS_CODE);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultVo(ConstantUtil.FAIL_CODE, ConstantUtil.CREATE_DICTYPE_FAIL);
        }
    }

    @GetMapping("/queryEditTypeValue.do")
    public @ResponseBody
    DicType queryEditTypeValue(@RequestParam String code) {
        return dicTypeService.queryDicTypeByCode(code);
    }

    @PostMapping("/editDicValue.do")
    public @ResponseBody
    ResultVo editDicValue(@RequestParam Map<String, String> map) {
        try {
            int res = dicTypeService.editDicType(map);
            if (res == 0) {
                return new ResultVo(ConstantUtil.FAIL_CODE, ConstantUtil.UPDATE_DIC_TYPE_FAIL);
            }
            return new ResultVo(ConstantUtil.SUCCESS_CODE);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultVo(ConstantUtil.FAIL_CODE, ConstantUtil.UPDATE_DIC_TYPE_FAIL);
        }
    }

    @PostMapping("/removeTypeValue.do")
    public @ResponseBody ResultVo removeTypeValue(@RequestParam String[] codes) {
        ResultVo resultVo = new ResultVo();
        try {
            int res = dicTypeService.removeDicTypeByCodes(codes);
            if (res == 0) {
                resultVo.setCode(ConstantUtil.FAIL_CODE);
                resultVo.setMessage(ConstantUtil.REMOVE_DIC_TYPE_FAIL);
            } else {
                resultVo.setCode(ConstantUtil.SUCCESS_CODE);
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultVo.setCode(ConstantUtil.FAIL_CODE);
            resultVo.setMessage(ConstantUtil.REMOVE_DIC_TYPE_FAIL);
        }
        return resultVo;
    }
}
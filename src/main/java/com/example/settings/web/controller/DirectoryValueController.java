package com.example.settings.web.controller;

import com.example.common.util.ConstantUtil;
import com.example.common.vo.ResultVo;
import com.example.settings.domain.DicValue;
import com.example.settings.service.DicTypeService;
import com.example.settings.service.DicValueService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * @类名 DirectoryValueController
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/19 14:53
 * @版本 1.0
 */
@Controller
@RequestMapping("/settings/dictionary/value")
public class DirectoryValueController {

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private DicTypeService dicTypeService;

    @GetMapping("/index.do")
    public String toIndex() {
        return "settings/dictionary/value/index";
    }

    @GetMapping(value = "/splitPageQuery.do")
    public @ResponseBody
    PageInfo<DicValue> splitPageQuery(Integer startPage, Integer pageSize) {
        return dicValueService.splitPageQuery(startPage, pageSize);
    }

    @GetMapping("/queryDicType.do")
    public @ResponseBody
    List<Object> queryDicType() {
        return dicTypeService.queryDicTypeList();
    }

    @GetMapping("/queryEditTypeValue.do")
    public @ResponseBody DicValue queryEditTypeValue(@RequestParam String id) {
        return dicValueService.queryTypeValueById(id);
    }

    @PostMapping("/editDicValue.do")
    public @ResponseBody
    ResultVo editDicValue(@RequestParam Map<String, String> map) {
        try {
            int res = dicValueService.editDicValue(map);
            if (res == 0) {
                return new ResultVo(ConstantUtil.FAIL_CODE, ConstantUtil.UPDATE_TYPE_FAIL);
            }
            return new ResultVo(ConstantUtil.SUCCESS_CODE);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultVo(ConstantUtil.FAIL_CODE, ConstantUtil.UPDATE_TYPE_FAIL);
        }
    }

    @PostMapping("/saveDicValue.do")
    public @ResponseBody ResultVo saveDicValue(@RequestParam Map<String, String> map) {
        try {
            int res = dicValueService.saveDicValue(map);
            if (res == 0) {
                return new ResultVo(ConstantUtil.FAIL_CODE, ConstantUtil.CREATE_DICVALUE_FAIL);
            }
            return new ResultVo(ConstantUtil.SUCCESS_CODE);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultVo(ConstantUtil.FAIL_CODE, ConstantUtil.CREATE_DICVALUE_FAIL);
        }
    }

    @PostMapping("/removeTypeValue.do")
    public @ResponseBody ResultVo removeTypeValue(@RequestParam String[] ids) {
        ResultVo resultVo = new ResultVo();
        try {
            dicValueService.removeTypeValueByIds(ids);
            resultVo.setCode(ConstantUtil.SUCCESS_CODE);
        } catch (Exception e) {
            e.printStackTrace();
            resultVo.setCode(ConstantUtil.FAIL_CODE);
            resultVo.setMessage(ConstantUtil.REMOVE_TYPEVALUE_FAIL);
        }
        return resultVo;
    }
}

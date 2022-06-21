package com.example.settings.web.controller;

import com.example.common.util.ConstantUtil;
import com.example.common.vo.ResultVo;
import com.example.settings.domain.User;
import com.example.settings.service.UserService;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.Map;

/**
 * @类名 AdminController
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/18 18:09
 * @版本 1.0
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

    @Resource
    private UserService userService;

//    @Resource
//    private DicValueService dicValueService;

    @GetMapping("/toIndex.do")
    public String toIndex(Model model) {
//        List<Object> dicValues = dicValueService.queryDicValueType(ConstantUtil.USER_TYPE);
//        model.addAttribute("dicValues", dicValues);
        return "workbench/admin/index";
    }

    @GetMapping("/splitPageQuery.do")
    public @ResponseBody PageInfo<User> splitPageQuery(Integer startPage, Integer pageSize) {
        return userService.splitPageQuery(startPage, pageSize);
    }

    @PostMapping("/saveUser.do")
    public @ResponseBody ResultVo saveUser(@RequestParam Map<String, String> map) {
        try {
            int res = userService.saveUser(map);
            if (res == 0) {
                return new ResultVo(ConstantUtil.FAIL_CODE, ConstantUtil.SAVE_USER_FAIL);
            }
            return new ResultVo(ConstantUtil.SUCCESS_CODE);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultVo(ConstantUtil.FAIL_CODE, ConstantUtil.SAVE_USER_FAIL);
        }
    }

    @GetMapping("/queryEditUser.do")
    public @ResponseBody User queryEditUser(@RequestParam String uid) {
        return userService.queryEditUser(uid);
    }

    @PostMapping("/editUser.do")
    public @ResponseBody ResultVo editUser(@RequestParam Map<String, String> map) {
        try {
            int res = userService.editUser(map);
            if (res == 0) {
                return new ResultVo(ConstantUtil.FAIL_CODE, ConstantUtil.EDIT_USER_FAIL);
            }
            return new ResultVo(ConstantUtil.SUCCESS_CODE);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultVo(ConstantUtil.FAIL_CODE, ConstantUtil.EDIT_USER_FAIL);
        }
    }

    @PostMapping("/removeUser.do")
    public @ResponseBody ResultVo removeUser(@RequestParam String[] uids) {
        try {
            userService.removeUser(uids);
            return new ResultVo(ConstantUtil.SUCCESS_CODE);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultVo(ConstantUtil.FAIL_CODE, ConstantUtil.REMOVE_USER_FAIL);
        }
    }
}

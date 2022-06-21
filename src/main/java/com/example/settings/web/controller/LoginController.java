package com.example.settings.web.controller;

import com.example.common.util.ConstantUtil;
import com.example.common.vo.ResultVo;
import com.example.settings.domain.User;
import com.example.settings.service.UserService;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Map;

/**
 * @类名 LoginController
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/16 12:22
 * @版本 1.0
 */
@Controller
@RequestMapping("/settings")
public class LoginController {

    @Autowired
    private UserService userService;

    @GetMapping("/qx/user/toLogin.do")
    public String toLogin() {
        return "settings/qx/user/login";
    }

    @PostMapping("/qx/user/login.do")
    public @ResponseBody ResultVo login(@RequestParam Map<String, String> map, HttpSession session, HttpServletResponse response) {

        String isRem = map.get("isRemPwd");
        String username = map.get("loginAct");
        String password = map.get("loginPwd");

        User user = userService.queryUser(map);
        if (ObjectUtils.isEmpty(user)) {
            return new ResultVo(ConstantUtil.FAIL_CODE, ConstantUtil.LOGIN_FAIL);
        } else if (!StringUtils.equals(user.getType(), ConstantUtil.USER_TYPE_MANAGER)) {
            return new ResultVo(ConstantUtil.FAIL_CODE, ConstantUtil.NOT_ACCESS);
        } else {
            session.setAttribute(ConstantUtil.SESSION_USER, user);

            Cookie cookieUsername = new Cookie(ConstantUtil.USERNAME, username);
            Cookie cookiePassword = new Cookie(ConstantUtil.PASSWORD, password);

            if (StringUtils.equals(isRem, "true")) {
                cookieUsername.setMaxAge(60 * 60 * 24 * 10);
                cookiePassword.setMaxAge(60 * 60 * 24 * 10);
            } else {
                cookieUsername.setMaxAge(0);
                cookiePassword.setMaxAge(0);
            }

            response.addCookie(cookieUsername);
            response.addCookie(cookiePassword);

            return new ResultVo(ConstantUtil.SUCCESS_CODE);
        }
    }

    @GetMapping("/qx/user/toLogout.do")
    public String toLoginOut(HttpSession session, HttpServletResponse response) {
        Cookie cookieUsername = new Cookie(ConstantUtil.USERNAME, "");
        Cookie cookiePassword = new Cookie(ConstantUtil.PASSWORD, "");
        cookieUsername.setMaxAge(0);
        cookiePassword.setMaxAge(0);
        response.addCookie(cookieUsername);
        response.addCookie(cookiePassword);
        session.invalidate();
        return "settings/qx/user/login";
    }
}

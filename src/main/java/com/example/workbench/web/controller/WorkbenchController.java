package com.example.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @类名 IndexController
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/16 21:20
 * @版本 1.0
 */
@Controller
@RequestMapping("/workbench")
public class WorkbenchController {

    @GetMapping("/index.do")
    public String index() {
        return "workbench/index";
    }
}

package com.example.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * @类名 IndexController
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/16 11:24
 * @版本 1.0
 */

@Controller
public class IndexController {

    @GetMapping("/")
    public String toIndex() {
        return "index";
    }
}

package com.example.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @类名 DictionaryController
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/19 14:39
 * @版本 1.0
 */
@Controller
@RequestMapping("/settings/dictionary")
public class DictionaryController {

    @GetMapping("/index.do")
    public String toIndex() {
        return "settings/dictionary/index";
    }
}

package com.example.workbench.web.controller;

import com.example.common.vo.OrderVo;
import com.example.workbench.domain.Order;
import com.example.workbench.service.OrderService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @类名 OrderController
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/19 21:17
 * @版本 1.0
 */
@Controller
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @GetMapping("/index.do")
    public String index() {
        return "workbench/order/index";
    }

    @GetMapping("/splitPageQuery.do")
    public @ResponseBody
    PageInfo<OrderVo> splitPageQuery(Integer startPage, Integer pageSize) {
        return orderService.queryProductList(startPage, pageSize);
    }
}

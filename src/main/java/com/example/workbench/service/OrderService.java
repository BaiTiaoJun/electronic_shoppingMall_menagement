package com.example.workbench.service;

import com.example.common.vo.OrderVo;
import com.github.pagehelper.PageInfo;

/**
 * @类名 OrderService
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/19 21:32
 * @版本 1.0
 */
public interface OrderService {
    PageInfo<OrderVo> queryProductList(Integer startPage, Integer pageSize);
}

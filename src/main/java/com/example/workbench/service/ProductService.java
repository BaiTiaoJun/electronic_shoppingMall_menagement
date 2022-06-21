package com.example.workbench.service;

import com.example.common.vo.ProductVo;
import com.example.workbench.domain.Product;
import com.github.pagehelper.PageInfo;

import java.util.Map;

/**
 * @类名 ProductService
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/16 22:20
 * @版本 1.0
 */
public interface ProductService {
    PageInfo<Product> queryProductList(Integer startPage, Integer pageSize);

    void saveProduct(Map<String, Object> map) throws Exception;

    ProductVo queryProductVoByPid(String pid);

    void editProduct(Map<String, String> map) throws Exception;

    void removeProducts(String[] pids) throws Exception;
}

package com.example.workbench.dao;

import com.example.workbench.domain.Product;

import java.util.List;

public interface ProductMapper {
    int deleteByPrimaryKey(String pid);

    int insert(Product record);

    int insertSelective(Product record);

    Product selectByPrimaryKey(String pid);

    int updateByPrimaryKeySelective(Product record);

    int updateByPrimaryKey(Product record);

    List<Product> selectProductList();

    Product selectProductBySid(String sid);
}
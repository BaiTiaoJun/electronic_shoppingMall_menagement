package com.example.workbench.dao;

import com.example.workbench.domain.ProductColor;

public interface ProductColorMapper {
    int deleteByPrimaryKey(String cid);

    int insert(ProductColor record);

    int insertSelective(ProductColor record);

    ProductColor selectByPrimaryKey(String cid);

    int updateByPrimaryKeySelective(ProductColor record);

    int updateByPrimaryKey(ProductColor record);

    int deleteProductColorByPid(String pid);
}
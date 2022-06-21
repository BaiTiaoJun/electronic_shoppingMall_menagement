package com.example.workbench.dao;

import com.example.workbench.domain.ProductRemark;

public interface ProductRemarkMapper {
    int deleteByPrimaryKey(String rid);

    int insert(ProductRemark record);

    int insertSelective(ProductRemark record);

    ProductRemark selectByPrimaryKey(String rid);

    int updateByPrimaryKeySelective(ProductRemark record);

    int updateByPrimaryKey(ProductRemark record);
}
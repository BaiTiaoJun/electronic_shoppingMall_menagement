package com.example.workbench.dao;

import com.example.workbench.domain.Sku;

public interface SkuMapper {
    int deleteByPrimaryKey(String skuId);

    int insert(Sku record);

    int insertSelective(Sku record);

    Sku selectByPrimaryKey(String skuId);

    int updateByPrimaryKeySelective(Sku record);

    int updateByPrimaryKey(Sku record);
}
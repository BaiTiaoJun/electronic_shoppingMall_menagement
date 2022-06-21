package com.example.workbench.dao;

import com.example.workbench.domain.ProductSeries;

public interface ProductSeriesMapper {
    int deleteByPrimaryKey(String sid);

    int insert(ProductSeries record);

    int insertSelective(ProductSeries record);

    ProductSeries selectByPrimaryKey(String sid);

    int updateByPrimaryKeySelective(ProductSeries record);

    int updateByPrimaryKey(ProductSeries record);
}
package com.example.workbench.dao;

import com.example.workbench.domain.ProductSetMeal;

public interface ProductSetMealMapper {
    int deleteByPrimaryKey(String sid);

    int insert(ProductSetMeal record);

    int insertSelective(ProductSetMeal record);

    ProductSetMeal selectByPrimaryKey(String sid);

    int updateByPrimaryKeySelective(ProductSetMeal record);

    int updateByPrimaryKey(ProductSetMeal record);

    int deleteProductSetMealByPid(String pid);
}
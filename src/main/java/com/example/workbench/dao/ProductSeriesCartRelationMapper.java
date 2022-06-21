package com.example.workbench.dao;

import com.example.workbench.domain.ProductSeriesCartRelation;

public interface ProductSeriesCartRelationMapper {
    int deleteByPrimaryKey(String id);

    int insert(ProductSeriesCartRelation record);

    int insertSelective(ProductSeriesCartRelation record);

    ProductSeriesCartRelation selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ProductSeriesCartRelation record);

    int updateByPrimaryKey(ProductSeriesCartRelation record);

    int deleteByCid(String cid);
}
package com.example.settings.dao;

import com.example.settings.domain.DicValue;

import java.util.List;

public interface DicValueMapper {
    int deleteByPrimaryKey(String id);

    int insert(DicValue record);

    int insertSelective(DicValue record);

    DicValue selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(DicValue record);

    int updateByPrimaryKey(DicValue record);

    List<Object> selectDicValueByTypeCode(String typeCode);

    List<DicValue> selectDicValueListByTypeCode(String productType);

    List<DicValue> selectDicValueList();
}
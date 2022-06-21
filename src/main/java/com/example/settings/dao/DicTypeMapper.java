package com.example.settings.dao;

import com.example.settings.domain.DicType;
import com.example.settings.domain.DicValue;

import java.util.List;

public interface DicTypeMapper {
    int deleteByPrimaryKey(String code);

    int insert(DicType record);

    int insertSelective(DicType record);

    DicType selectByPrimaryKey(String code);

    int updateByPrimaryKeySelective(DicType record);

    int updateByPrimaryKey(DicType record);

    List<Object> selectDicTypeList();

    List<DicType> selectDicTypes();
}
package com.example.settings.service;

import com.example.settings.domain.DicType;
import com.github.pagehelper.PageInfo;

import java.util.List;
import java.util.Map;

/**
 * @类名 DicTypeService
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/18 15:30
 * @版本 1.0
 */
public interface DicTypeService {
    List<Object> queryDicTypeList();

    PageInfo<DicType> splitPageQuery(Integer startPage, Integer pageSize);

    int saveDicValue(Map<String, String> map);

    DicType queryDicTypeByCode(String code);

    int editDicType(Map<String, String> map);

    int removeDicTypeByCodes(String[] codes);
}

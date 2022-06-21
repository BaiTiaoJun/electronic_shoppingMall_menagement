package com.example.settings.service;

import com.example.settings.domain.DicValue;
import com.github.pagehelper.PageInfo;

import java.util.List;
import java.util.Map;

/**
 * @类名 DicValueService
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/17 10:39
 * @版本 1.0
 */
public interface DicValueService {

    List<Object> queryDicValueType(String typeCode);

    PageInfo<DicValue> splitPageQuery(Integer startPage, Integer pageSize);

    int saveDicValue(Map<String, String> map);

    DicValue queryTypeValueById(String id);

    int editDicValue(Map<String, String> map);

    void removeTypeValueByIds(String[] ids) throws Exception;
}

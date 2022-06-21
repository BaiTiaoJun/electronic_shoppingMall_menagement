package com.example.settings.service.impl;

import com.example.common.util.ConstantUtil;
import com.example.common.util.UUIDUtil;
import com.example.settings.dao.DicTypeMapper;
import com.example.settings.dao.DicValueMapper;
import com.example.settings.domain.DicType;
import com.example.settings.domain.DicValue;
import com.example.settings.service.DicTypeService;
import com.example.workbench.service.RedisService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.commons.lang3.ObjectUtils;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisOperations;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * @类名 DicTypeServiceImpl
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/18 15:31
 * @版本 1.0
 */
@Service("dicTypeService")
public class DicTypeServiceImpl implements DicTypeService {

    @Resource
    private DicTypeMapper dicTypeMapper;

    @Resource
    private RedisOperations<Object, Object> redisTemplate;

    @Resource
    private RedisService redisService;

    @Override
    public List<Object> queryDicTypeList() {
        ListOperations<Object, Object> operations = redisTemplate.opsForList();

        List<Object> dicValues = operations.range(ConstantUtil.DIC_TYPE_KEY, 0, -1);

        if (dicValues.size() == 0) {
            synchronized (this) {
                dicValues = operations.range(ConstantUtil.DIC_TYPE_KEY, 0, -1);
                if (dicValues.size() == 0) {
                    dicValues = dicTypeMapper.selectDicTypeList();
                    for (Object dicValue : dicValues) {
                        operations.rightPush(ConstantUtil.DIC_TYPE_KEY, dicValue);
                    }
                }
            }
        }
        return dicValues;
    }

    @Override
    public PageInfo<DicType> splitPageQuery(Integer startPage, Integer pageSize) {
        if (ObjectUtils.allNull(startPage) && ObjectUtils.allNull(pageSize)) {
            PageHelper.startPage(1, ConstantUtil.DEFAULT_PAGE_SIZE);
        } else {
            PageHelper.startPage(startPage, pageSize);
        }
        List<DicType> dicTypes = dicTypeMapper.selectDicTypes();
        PageInfo<DicType> pageInfo = new PageInfo<>(dicTypes);
        return pageInfo;
    }

    @Override
    public int saveDicValue(Map<String, String> map) {
        DicType dicType = new DicType();
        dicType.setCode(map.get("typeCode"));
        dicType.setName(map.get("typeName"));
        int res = dicTypeMapper.insertSelective(dicType);
        if (res != 0) {
            redisService.delList((String) ConstantUtil.DIC_TYPE_KEY);
        }
        return res;
    }

    @Override
    public DicType queryDicTypeByCode(String code) {
        return dicTypeMapper.selectByPrimaryKey(code);
    }

    @Override
    public int editDicType(Map<String, String> map) {
        DicType dicType = new DicType();
        dicType.setCode(map.get("typeCode"));
        dicType.setName(map.get("typeName"));
        int res = dicTypeMapper.updateByPrimaryKeySelective(dicType);
        if (res != 0) {
            redisService.delList((String) ConstantUtil.DIC_TYPE_KEY);
        }
        return res;
    }

    @Override
    public int removeDicTypeByCodes(String[] codes) {
        int res = 0;
        for (String code : codes) {
            res = dicTypeMapper.deleteByPrimaryKey(code);
        }
        redisService.delList((String) ConstantUtil.DIC_TYPE_KEY);
        return res;
    }
}

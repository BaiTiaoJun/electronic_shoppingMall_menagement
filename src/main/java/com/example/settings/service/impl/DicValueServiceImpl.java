package com.example.settings.service.impl;

import com.example.common.util.ConstantUtil;
import com.example.common.util.UUIDUtil;
import com.example.settings.dao.DicValueMapper;
import com.example.settings.domain.DicValue;
import com.example.settings.service.DicValueService;
import com.example.workbench.service.RedisService;
import com.fasterxml.jackson.databind.ser.std.StringSerializer;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.commons.lang3.ObjectUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * @类名 DicValueServiceImpl
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/17 10:40
 * @版本 1.0
 */
@Service("dicValueService")
public class DicValueServiceImpl implements DicValueService {

    @Resource
    private DicValueMapper dicValueMapper;

    @Resource
    private RedisTemplate<Object, Object> redisTemplate;

    @Resource
    private RedisService redisService;

    @Override
    public List<Object> queryDicValueType(String typeCode) {
        redisTemplate.setKeySerializer(new StringRedisSerializer());
        ListOperations<Object, Object> operations = redisTemplate.opsForList();

        List<Object> dicValues = operations.range(typeCode, 0, -1);

        if (dicValues.size() == 0) {
            synchronized (this) {
                dicValues = operations.range(typeCode, 0, -1);
                if (dicValues.size() == 0) {
                    dicValues = dicValueMapper.selectDicValueByTypeCode(typeCode);
                    for (Object dicValue : dicValues) {
                        operations.rightPush(typeCode, dicValue);
                    }
                }
            }
        }
        return dicValues;
    }

    @Override
    public PageInfo<DicValue> splitPageQuery(Integer startPage, Integer pageSize) {
        if (ObjectUtils.allNull(startPage) && ObjectUtils.allNull(pageSize)) {
            PageHelper.startPage(1, ConstantUtil.DEFAULT_PAGE_SIZE);
        } else {
            PageHelper.startPage(startPage, pageSize);
        }
        List<DicValue> dicValues = dicValueMapper.selectDicValueList();
        PageInfo<DicValue> pageInfo = new PageInfo<>(dicValues);
        return pageInfo;
    }

    @Override
    public int saveDicValue(Map<String, String> map) {
        DicValue dicValue = new DicValue();
        dicValue.setId(UUIDUtil.getUUID());
        dicValue.setValue(map.get("value"));
        dicValue.setText(map.get("text"));
        dicValue.setTypeCode(map.get("typeCode"));
        int res = dicValueMapper.insert(dicValue);
        if (res != 0) {
            redisService.delList(ConstantUtil.PRODUCT_TYPE);
        }
        return res;
    }

    @Override
    public DicValue queryTypeValueById(String id) {
        return dicValueMapper.selectByPrimaryKey(id);
    }

    @Override
    public int editDicValue(Map<String, String> map) {
        DicValue dicValue = new DicValue();
        dicValue.setId(map.get("id"));
        dicValue.setValue(map.get("value"));
        dicValue.setText(map.get("text"));
        int res = dicValueMapper.updateByPrimaryKeySelective(dicValue);
        if (res != 0) {
            redisService.delList(ConstantUtil.PRODUCT_TYPE);
        }
        return res;
    }


    @Override
    public void removeTypeValueByIds(String[] ids) throws Exception {
        for (String id : ids) {
            int res = dicValueMapper.deleteByPrimaryKey(id);
            if (res == 0) {
                throw new Exception();
            }
            redisService.delList(ConstantUtil.PRODUCT_TYPE);
        }
    }
}

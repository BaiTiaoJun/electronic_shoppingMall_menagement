package com.example.workbench.service.impl;

import com.example.workbench.service.RedisService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.SetOperations;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import org.springframework.stereotype.Service;

import java.util.Set;
import java.util.concurrent.TimeUnit;

/**
 * @类名 RedisServiceImpl
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/1 14:05
 * @版本 1.0
 */
@Service("redisService")
public class RedisServiceImpl implements RedisService {

    @Autowired
    private RedisTemplate<Object, Object> redisTemplate;

    @Override
    public void put(String key, Object value, Integer expireTime) {
        ValueOperations<Object, Object> operations = redisTemplate.opsForValue();
        operations.set(key, value, expireTime, TimeUnit.MINUTES);
    }

    @Override
    public Object get(String key) {
        ValueOperations<Object, Object> operations = redisTemplate.opsForValue();
        return operations.get(key);
    }

    @Override
    public void add(String key, Object... value) {
        SetOperations<Object, Object> operations = redisTemplate.opsForSet();
        operations.add(key, value);
    }

    @Override
    public Object getSet(String key) {
        SetOperations<Object, Object> operations = redisTemplate.opsForSet();
        return operations.members(key);
    }

    @Override
    public Set<Object> sdiff(String keyOnIneffective, String keyOnEffective) {
        SetOperations<Object, Object> operations = redisTemplate.opsForSet();
        return operations.difference(keyOnIneffective, keyOnEffective);
    }

    @Override
    public void remove(String keyOnIneffective, Object... value) {
        SetOperations<Object, Object> operations = redisTemplate.opsForSet();
        operations.remove(keyOnIneffective, value);
    }

    @Override
    public void delList(String key) {
        redisTemplate.delete(key);
    }
}

package com.example.workbench.dao;

import com.example.workbench.domain.PayOrder;

public interface PayOrderMapper {
    int deleteByPrimaryKey(String payOrderNo);

    int insert(PayOrder record);

    int insertSelective(PayOrder record);

    PayOrder selectByPrimaryKey(String payOrderNo);

    int updateByPrimaryKeySelective(PayOrder record);

    int updateByPrimaryKey(PayOrder record);
}
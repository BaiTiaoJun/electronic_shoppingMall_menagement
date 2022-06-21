package com.example.workbench.dao;

import com.example.workbench.domain.Cart;

public interface CartMapper {
    int deleteByPrimaryKey(String cid);

    int insert(Cart record);

    int insertSelective(Cart record);

    Cart selectByPrimaryKey(String cid);

    int updateByPrimaryKeySelective(Cart record);

    int updateByPrimaryKey(Cart record);

    Cart selectCartByUid(String uid);
}
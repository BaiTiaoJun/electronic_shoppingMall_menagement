package com.example.workbench.dao;

import com.example.workbench.domain.Address;

public interface AddressMapper {
    int deleteByPrimaryKey(String aid);

    int insert(Address record);

    int insertSelective(Address record);

    Address selectByPrimaryKey(String aid);

    int updateByPrimaryKeySelective(Address record);

    int updateByPrimaryKey(Address record);
}
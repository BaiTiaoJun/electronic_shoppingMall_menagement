package com.example.workbench.dao;

import com.example.workbench.domain.UserAddressRelation;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserAddressRelationMapper {
    int deleteByPrimaryKey(String id);

    int insert(UserAddressRelation record);

    int insertSelective(UserAddressRelation record);

    UserAddressRelation selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(UserAddressRelation record);

    int updateByPrimaryKey(UserAddressRelation record);

    List<UserAddressRelation> selectAidByUid(String uid);

    int deleteAddressRelationByUid(String uid);
}
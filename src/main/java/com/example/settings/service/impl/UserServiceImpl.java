package com.example.settings.service.impl;

import com.example.common.util.ConstantUtil;
import com.example.common.util.DateUtil;
import com.example.common.util.MD5Util;
import com.example.common.util.UUIDUtil;
import com.example.settings.dao.UserMapper;
import com.example.settings.domain.User;
import com.example.settings.service.UserService;
import com.example.workbench.dao.*;
import com.example.workbench.domain.Address;
import com.example.workbench.domain.Cart;
import com.example.workbench.domain.UserAddressRelation;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * @类名 UserService
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/16 18:29
 * @版本 1.0
 */
@Service(value = "userService")
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private CartMapper cartMapper;

    @Autowired
    private ProductSeriesCartRelationMapper productSeriesCartRelationMapper;

    @Autowired
    private AddressMapper addressMapper;

    @Autowired
    private UserAddressRelationMapper userAddressRelationMapper;

    @Override
    public User queryUser(Map<String, String> map) {
        map.put("loginPwd", MD5Util.getMD5(map.get("loginPwd")));
        return userMapper.selectByMap(map);
    }

    @Override
    public PageInfo<User> splitPageQuery(Integer startPage, Integer pageSize) {
        if (ObjectUtils.allNull(startPage) && ObjectUtils.allNull(pageSize)) {
            PageHelper.startPage(1, ConstantUtil.DEFAULT_PAGE_SIZE);
        } else {
            PageHelper.startPage(startPage, pageSize);
        }
        List<User> users = userMapper.selectUserList();
        for (User user : users) {
            user.setName(user.getName() == null? "" : user.getName());
            user.setAddress(user.getAddress() == null? "" : user.getAddress());
            user.setBirthday(user.getBirthday() == null? "" : user.getBirthday());
            user.setEmail(user.getEmail() == null? "" : user.getEmail());
            user.setPhone(user.getPhone() == null? "" : user.getPhone());
            user.setIdCard(user.getIdCard() == null? "" : user.getIdCard());
            user.setGender(user.getGender() == null? "" : user.getGender());
        }
        PageInfo<User> pageInfo = new PageInfo<>(users);
        return pageInfo;
    }

    @Override
    public int saveUser(Map<String, String> map) {
        User user = new User();
        user.setUid(UUIDUtil.getUUID());
//        user.setAddress(map.get("address") + map.get("detailAddress"));
        user.setUsername(map.get("username"));
        user.setPassword(MD5Util.getMD5(map.get("password")));
//        user.setName(map.get("realName"));
//        user.setGender(map.get("gender"));
//        user.setIdCard(map.get("idCard"));
//        user.setPhone(map.get("phone"));
//        user.setEmail(map.get("email"));
//        user.setBirthday(map.get("birthday"));
        user.setRegisterTime(DateUtil.getDate());
        user.setLastLoginTime(DateUtil.getDate());
        user.setType(ConstantUtil.USER_TYPE_MANAGER);
        return userMapper.insertSelective(user);
    }

    @Override
    public User queryEditUser(String uid) {
        User user = userMapper.selectByPrimaryKey(uid);
//        String aId = user.getAddress();
//        Address address = addressMapper.selectByPrimaryKey(aId);
//        if (StringUtils.isNotEmpty(address)) {
//            String[] addressArr = address.split("/");
//
//        }
        return user;
    }

    @Override
    public int editUser(Map<String, String> map) {
        User user = new User();
        user.setUid(map.get("uid"));
        user.setName(map.get("name"));
        user.setGender(map.get("gender"));
        user.setIdCard(map.get("idCard"));
        user.setPhone(map.get("phone"));
        user.setEmail(map.get("email"));
        user.setBirthday(map.get("birthday"));
        return userMapper.updateByPrimaryKeySelective(user);
    }

    @Override
    public void removeUser(String[] uids) throws Exception {
        for (String uid : uids) {
            //查询用户类型，判断是否是买家
            User user = userMapper.selectByPrimaryKey(uid);
            if (StringUtils.equals(user.getType(), ConstantUtil.USER_TYPE_BUYER)) {
                Cart cart = cartMapper.selectCartByUid(uid);
                //查询如果存在此用户的购物车就进行删除
                if (ObjectUtils.allNotNull(cart)) {
                    String cid = cart.getCid();
                    //先删除购物车和商品的关联关系
                    int res = productSeriesCartRelationMapper.deleteByCid(cid);
                    if (res == 0) {
                        throw new Exception();
                    }
                    //再删除购物车
                    int cartRes = cartMapper.deleteByPrimaryKey(cid);
                    if (cartRes == 0) {
                        throw new Exception();
                    }
                }
                //如果存在用户和地址的关系，删除用户地址
                List<UserAddressRelation> userAddressRelations = userAddressRelationMapper.selectAidByUid(uid);
                if (ObjectUtils.allNotNull(userAddressRelations)) {
                    for (UserAddressRelation userAddressRelation : userAddressRelations) {
                        //通过对应的aid删除所有地址记录
                        String aid = userAddressRelation.getAid();
                        int res = addressMapper.deleteByPrimaryKey(aid);
                        if (res == 0) {
                            throw new Exception();
                        }
                    }
                    //删除所有此用户和地址的关联关系记录
                    int res = userAddressRelationMapper.deleteAddressRelationByUid(uid);
                    if (res == 0) {
                        throw new Exception();
                    }
                }
            }
            //最后删除此用户
            int res = userMapper.deleteByPrimaryKey(uid);
            if (res == 0) {
                throw new Exception();
            }
        }
    }
}
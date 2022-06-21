package com.example.settings.service;

import com.example.settings.domain.User;
import com.github.pagehelper.PageInfo;

import java.util.Map;

/**
 * @类名 UserService
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/16 19:09
 * @版本 1.0
 */
public interface UserService {
    User queryUser(Map<String, String> map);

    PageInfo<User> splitPageQuery(Integer startPage, Integer pageSize);

    int saveUser(Map<String, String> map);

    User queryEditUser(String uid);

    int editUser(Map<String, String> map);

    void removeUser(String[] uids) throws Exception;
}

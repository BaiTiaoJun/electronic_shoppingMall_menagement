package com.example.common.util;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.Objects;

/**
 * @类名 FileNameUtil
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/4 14:55
 * @版本 1.0
 */
public class FileUtil {
    public static String generateFileName(String fileName) {
        String prefix = UUIDUtil.getUUID();
        String suffix = fileName.substring(fileName.lastIndexOf("."));
        return prefix + suffix;
    }

    public static String getFilePathOnClassPath(Class<?> clazz) {
        String localFilePath = null;
        try {
            String classPath = Objects.requireNonNull(clazz.getResource("/static/images/about/")).getPath();
            localFilePath = URLDecoder.decode(classPath, "utf-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return localFilePath;
    }
}

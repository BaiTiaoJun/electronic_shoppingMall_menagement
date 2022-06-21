package com.example.common.vo;

/**
 * @类名 ResultVo
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/16 17:19
 * @版本 1.0
 */
public class ResultVo {
    private String code;
    private String message;
    private int num;

    public int getNum() {
        return num;
    }

    public void setNum(int num) {
        this.num = num;
    }

    public ResultVo() {
    }

    public ResultVo(String code) {
        this.code = code;
    }

    public ResultVo(String code, String message) {
        this.code = code;
        this.message = message;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}

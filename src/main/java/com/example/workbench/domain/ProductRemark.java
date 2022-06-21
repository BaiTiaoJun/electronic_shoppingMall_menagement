package com.example.workbench.domain;

public class ProductRemark {
    private String rid;

    private String content;

    private String pid;

    private String remarkBy;

    private String remarkTime;

    private String score;

    public String getRid() {
        return rid;
    }

    public void setRid(String rid) {
        this.rid = rid;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getRemarkBy() {
        return remarkBy;
    }

    public void setRemarkBy(String remarkBy) {
        this.remarkBy = remarkBy;
    }

    public String getRemarkTime() {
        return remarkTime;
    }

    public void setRemarkTime(String remarkTime) {
        this.remarkTime = remarkTime;
    }

    public String getScore() {
        return score;
    }

    public void setScore(String score) {
        this.score = score;
    }
}
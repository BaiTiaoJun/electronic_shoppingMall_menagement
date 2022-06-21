package com.example.workbench.service.impl;

import com.example.common.util.ConstantUtil;
import com.example.common.vo.OrderVo;
import com.example.workbench.dao.OrderMapper;
import com.example.workbench.dao.ProductMapper;
import com.example.workbench.dao.ProductSeriesMapper;
import com.example.workbench.domain.Order;
import com.example.workbench.domain.Product;
import com.example.workbench.domain.ProductSeries;
import com.example.workbench.service.OrderService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.commons.lang3.ObjectUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * @类名 OrderServiceImpl
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/19 21:33
 * @版本 1.0
 */
@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private ProductSeriesMapper productSeriesMapper;

    @Autowired
    private ProductMapper productMapper;

    @Override
    public PageInfo<OrderVo> queryProductList(Integer startPage, Integer pageSize) {
        List<OrderVo> orderVos = new ArrayList<>();

        //根据统计订单
        int total = orderMapper.countOrders();

        if (ObjectUtils.allNull(startPage, pageSize)) {
            PageHelper.startPage(1, ConstantUtil.DEFAULT_PAGE_SIZE);
        } else {
            PageHelper.startPage(startPage, pageSize);
        }

        List<Order> orderList = orderMapper.selectOrderList();
        for (Order order : orderList) {
            String sid = order.getSid();
            ProductSeries productSeries = productSeriesMapper.selectByPrimaryKey(sid);
            String brand = productSeries.getBrand();
            Product product = productMapper.selectProductBySid(sid);
            String name = product.getName();
            Double price = product.getNewPrice();
            OrderVo orderVo = new OrderVo();
            orderVo.setOid(order.getOid());
            orderVo.setName(name);
            orderVo.setBrand(brand);
            orderVo.setPrice(price);
            orderVo.setTotalNumber(order.getTotalNumber());
            orderVo.setPurcharseTime(order.getPurcharseTime());
            orderVo.setTotalPrice(order.getTotalPrice());
            orderVo.setPayStatus(order.getPayStatus());
            orderVo.setReceiveTime(order.getReceiveTime() == null? "":order.getReceiveTime());
            orderVo.setColor(order.getColor());
            orderVo.setSetMeal(order.getSetMeal());
            orderVo.setOrderStatus(order.getOrderStatus());
            orderVo.setPayOrderNo(order.getPayOrderNo());
            orderVo.setCreateTime(order.getCreateTime());
            orderVos.add(orderVo);
        }
        //根据创建日期对list进行排序
//        orderVos.sort((o1, o2) -> o2.getCreateTime().compareTo(o1.getCreateTime()));
        //创建pageinfo
        PageInfo<OrderVo> pageInfo = new PageInfo<>(orderVos);
        //设置总页数
        int pages = total % ConstantUtil.DEFAULT_PAGE_SIZE;
        if (pages == 0) {
            if (total <= ConstantUtil.DEFAULT_PAGE_SIZE) {
                pages = 1;
                pageInfo.setPages(pages);
            } else {
                pages = total / ConstantUtil.DEFAULT_PAGE_SIZE;
                pageInfo.setPages(pages);
            }
        } else {
            pages = total / ConstantUtil.DEFAULT_PAGE_SIZE + 1;
            pageInfo.setPages(pages);
        }
        //设置总条数
        pageInfo.setTotal(total);
        //设置下一页和上一页
        if (ObjectUtils.isNotEmpty(startPage)) {
            if (startPage == pages) {
                pageInfo.setNextPage(1);
            } else {
                pageInfo.setNextPage(startPage + 1);
            }
            if (startPage != 1) {
                pageInfo.setPrePage(startPage - 1);
            } else {
                pageInfo.setPrePage(pageInfo.getPages());
            }
        }
        //设置当前页数
        if (ObjectUtils.isNotEmpty(startPage)) {
            pageInfo.setPageNum(startPage);
        }
        return pageInfo;
    }
}

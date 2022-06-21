package com.example.workbench.service.impl;

import com.example.common.util.ConstantUtil;
import com.example.common.util.DateUtil;
import com.example.common.util.UUIDUtil;
import com.example.common.vo.ProductVo;
import com.example.settings.dao.DicValueMapper;
import com.example.settings.domain.DicValue;
import com.example.settings.service.DicValueService;
import com.example.workbench.dao.ProductColorMapper;
import com.example.workbench.dao.ProductMapper;
import com.example.workbench.dao.ProductSeriesMapper;
import com.example.workbench.dao.ProductSetMealMapper;
import com.example.workbench.domain.Product;
import com.example.workbench.domain.ProductColor;
import com.example.workbench.domain.ProductSeries;
import com.example.workbench.domain.ProductSetMeal;
import com.example.workbench.service.ProductService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.ibatis.logging.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * @类名 ProductServiceImpl
 * @描述 TODO
 * @作者 白条君
 * @创建日期 2022/6/16 22:20
 * @版本 1.0
 */
@Service(value = "productService")
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductMapper productMapper;

    @Autowired
    private ProductColorMapper productColorMapper;

    @Autowired
    private ProductSetMealMapper productSetMealMapper;

    @Autowired
    private ProductSeriesMapper productSeriesMapper;

    @Autowired
    private DicValueMapper dicValueMapper;

    @Override
    public PageInfo<Product> queryProductList(Integer startPage, Integer pageSize) {
        if (ObjectUtils.allNull(startPage, pageSize)) {
            PageHelper.startPage(1, ConstantUtil.DEFAULT_PAGE_SIZE);
        } else {
            PageHelper.startPage(startPage, pageSize);
        }
        List<Product> products = productMapper.selectProductList();
        return new PageInfo<>(products);
    }

    @Override
    public void saveProduct(Map<String, Object> map) throws Exception {
        ProductSeries productSeries = new ProductSeries();
        String sid = UUIDUtil.getUUID();
        productSeries.setSid(sid);
        productSeries.setName((String) map.get("series"));
        productSeries.setAvaliable(Integer.valueOf((String) map.get("productNum")));
        productSeries.setBrand((String) map.get("brand"));
        productSeries.setScore("0");
        int productSeriesRes = productSeriesMapper.insertSelective(productSeries);
        if (productSeriesRes == 0) {
            throw new Exception();
        }

        Product product = new Product();
        String pid = UUIDUtil.getUUID();
        product.setPid(pid);
        product.setName((String) map.get("productName"));
        product.setNewPrice(Double.valueOf((String) map.get("price")));
        product.setType((String) map.get("productType"));
        product.setCreateBy(DateUtil.getDate());
        product.setSeries(sid);
        product.setDescription((String) map.get("description"));
        product.setImage((String) map.get("productImage1"));
        product.setImageTransform((String) map.get("productImage2"));
        product.setCreateTime(DateUtil.getDate());
        product.setCreateBy((String) map.get("uid"));
        product.setOldPrice(Double.valueOf((String) map.get("price")));
        String productImgList = map.get("productImage1") + "," + map.get("productImage2");
        product.setImageList(productImgList);
        int productRes = productMapper.insertSelective(product);
        if (productRes == 0) {
            throw new Exception();
        }

        ProductColor productColor = new ProductColor();
        productColor.setCid(UUIDUtil.getUUID());
        productColor.setColor((String) map.get("color"));
        productColor.setPid(pid);
        int productColorRes = productColorMapper.insertSelective(productColor);
        if (productColorRes == 0) {
            throw new Exception();
        }

        ProductSetMeal productSetMeal = new ProductSetMeal();
        productSetMeal.setSid(UUIDUtil.getUUID());
        productSetMeal.setSetMeal((String) map.get("setMeal"));
        productSetMeal.setPid(pid);
        int productSetMealRes = productSetMealMapper.insertSelective(productSetMeal);
        if (productSetMealRes == 0) {
            throw new Exception();
        }
    }

    @Override
    public ProductVo queryProductVoByPid(String pid) {
        Product product = productMapper.selectByPrimaryKey(pid);
        String sid = product.getSeries();
        String id = product.getType();

        ProductSeries productSeries = productSeriesMapper.selectByPrimaryKey(sid);
        String brand = productSeries.getBrand();
        Integer available = productSeries.getAvaliable();
        String series = productSeries.getName();

        ProductVo productVo = new ProductVo();
        productVo.setPid(pid);
        productVo.setBrand(brand);
        productVo.setDescription(product.getDescription());
        productVo.setSeries(series);
        productVo.setName(product.getName());
        productVo.setAvailable(available);
        productVo.setImage1(product.getImage());
        productVo.setImage2(product.getImageTransform());
        productVo.setNewPrice(product.getNewPrice());
        productVo.setOldPrice(product.getOldPrice());
        productVo.setType(product.getType());
        return productVo;
    }

    @Override
    public void editProduct(Map<String, String> map) throws Exception {
        String pid = map.get("pid");
        String productName = map.get("productName");
        Double newPrice2 = Double.valueOf(map.get("newPrice"));
        String type = map.get("type");
        String series = map.get("series");
        Integer available = Integer.valueOf(map.get("available"));
        String brand = map.get("brand");
        String description = map.get("description");
        String productImage1 = map.get("productImage1");
        String productImage2 = map.get("productImage2");

        Product product = productMapper.selectByPrimaryKey(pid);
        String sid = product.getSeries();
        Double newPrice1 = product.getOldPrice();

        ProductSeries productSeries = new ProductSeries();
        productSeries.setName(series);
        productSeries.setSid(sid);
        productSeries.setAvaliable(available);
        productSeries.setBrand(brand);
        int seriesRes = productSeriesMapper.updateByPrimaryKeySelective(productSeries);
        if (seriesRes == 0) {
            throw new Exception();
        }

        product = new Product();
        product.setPid(pid);
        product.setName(productName);
        product.setNewPrice(newPrice2);
        product.setOldPrice(newPrice1);
        product.setDescription(description);
        product.setImage(productImage1);
        product.setImageTransform(productImage2);
        product.setType(type);
        int productRes = productMapper.updateByPrimaryKeySelective(product);
        if (productRes == 0) {
            throw new Exception();
        }
    }

    @Override
    public void removeProducts(String[] pids) throws Exception {
        for (String pid : pids) {
            Product product = productMapper.selectByPrimaryKey(pid);
            String sid = product.getSeries();

            int productSeriesRes = productSeriesMapper.deleteByPrimaryKey(sid);
            if (productSeriesRes == 0) {
                throw new Exception();
            }

            int productColorRes = productColorMapper.deleteProductColorByPid(pid);
            if (productColorRes == 0) {
                throw new Exception();
            }

            int productSetMealRes = productSetMealMapper.deleteProductSetMealByPid(pid);
            if (productSetMealRes == 0) {
                throw new Exception();
            }

            int productRes = productMapper.deleteByPrimaryKey(pid);
            if (productRes == 0) {
                throw new Exception();
            }
        }
    }
}

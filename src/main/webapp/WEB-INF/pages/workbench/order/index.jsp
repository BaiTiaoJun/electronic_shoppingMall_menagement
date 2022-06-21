<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/"; %>
<html>
<head>
<base href="<%=basePath%>">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link href="css/product-index.css" type="text/css" rel="stylesheet" />
<link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">

	$(function(){

		paginationQuery();
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });
	});

	function paginationQuery(startPage, pageSize) {
		$.ajax({
			url: "order/splitPageQuery.do",
			data: {
				startPage:startPage,
				pageSize:pageSize
			},
			type: "get",
			dataType: "json",
			success: function (data) {
				let htmlStr = "";
				$.each(data.list, function (i, n) {
					htmlStr += "<tr style=\"text-align: center;\">";
					htmlStr += "<td><input type=\"checkbox\"value='" + n.oid + "' /></td>";
					htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='detail.html';\">" + n.oid + "</a></td>";
					htmlStr += "<td>" + n.name + "</td>";
					htmlStr += "<td>" + n.brand + "</td>";
					htmlStr += "<td>" + n.price + "</td>";
					htmlStr += "<td>" + n.totalNumber + "</td>";
					htmlStr += "<td>" + n.purcharseTime + "</td>";
					htmlStr += "<td>" + n.totalPrice + "</td>";
					htmlStr += "<td>" + n.payStatus + "</td>";
					htmlStr += "<td>" + n.receiveTime + "</td>";
					htmlStr += "<td>" + n.color + "</td>";
					htmlStr += "<td>" + n.setMeal + "</td>";
					htmlStr += "<td>" + n.orderStatus + "</td>";
					htmlStr += "<td>" + n.payOrderNo + "</td>";
					htmlStr += "</tr>";
				})
				$("#content").html(htmlStr);

				//分页插件
				$("#page").bs_pagination({
					//当前在第几页
					currentPage:data.pageNum,
					//总的记录条数
					totalRows:data.total,
					//每页显示记录条数
					rowsPerPage:data.pageSize,
					//总页数
					totalPages:data.pages,
					//每页显示的卡片数
					visiblePageLinks:data.pages,
					//是否显示跳转到部分
					showGoToPage: true,
					//是否显示“每页显示条数”部分
					showRowsPerPage: true,
					//是否显示记录的信息
					rowsInfo:true,
					//用户每次触发都自动触发此函数
					onChangePage:function (event, pageObj) {
						paginationQuery(pageObj.currentPage, pageObj.rowsPerPage);
					}
				})
			}
		})
	}
</script>
</head>
<body>
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>订单</h3>
			</div>
		</div>
	</div>

	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">订单单号</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button type="submit" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div style="position: relative;top: 20px;width:  2000px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;text-align: center;">
							<td><input type="checkbox" /></td>
							<td>订单单号</td>
							<td>商品名称</td>
							<td>商品品牌</td>
							<td>商品单价</td>
							<td>购买总数</td>
							<td>购买时间</td>
							<td>总金额</td>
							<td>支付状态</td>
							<td>收货时间</td>
							<td>颜色</td>
							<td>套餐</td>
							<td>订单状态</td>
							<td>支付编号</td>
						</tr>
					</thead>
					<tbody id="content">
<%--						<tr style="text-align: center;">--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">123454654534235435</a></td>--%>
<%--							<td>国潮风无线蓝牙耳机</td>--%>
<%--							<td>国潮</td>--%>
<%--							<td>699</td>--%>
<%--							<td>4</td>--%>
<%--							<td>2022-06-15 09:45</td>--%>
<%--							<td>2056</td>--%>
<%--							<td>支付成功</td>--%>
<%--							<td>2022-06-15 09:45</td>--%>
<%--							<td>港版Z50+16-35mm F4</td>--%>
<%--							<td>摄影中级套餐</td>--%>
<%--							<td>已支付</td>--%>
<%--							<td>1925268233816576</td>--%>
<%--						</tr>--%>

					</tbody>
				</table>
				<div id="page"></div>
			</div>

		</div>
		
	</div>
</body>
</html>
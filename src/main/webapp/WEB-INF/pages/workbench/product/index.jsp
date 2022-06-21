<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/"; %>
<html>
<head>
<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet" />
<link href="css/product-index.css" type="text/css" rel="stylesheet">

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
<script type="text/javascript" src="jquery/ajaxfileupload.js"></script>

<script type="text/javascript">
	$(function(){
		paginationQuery();
		//打开创建商品模态窗口
		$("#createBtn").on('click', function () {
			$("#form")[0].reset();
			$("#createProductModal").modal('show');
		})
		//保存商品
		$("#saveBtn").click(function () {
			let productName = $.trim($("#create-productName").val());
			let price = $.trim($("#create-newPrice").val());
			let productType = $("#create-productType").val();
			let series = $.trim($("#create-series").val());
			let color = $.trim($("#create-color").val());
			let productNum = $.trim($("#create-productNum").val());
			let brand = $.trim($("#create-brand").val());
			let setMeal = $.trim($("#create-setMeal").val());
			let description = $.trim($("#create-description").val());
			let productImage1 = $("#productImg1").attr("src");
			let productImage2 = $("#productImg2").attr("src");
			productImage1 = productImage1.substring(productImage1.lastIndexOf("/") + 1);
			productImage2 = productImage2.substring(productImage2.lastIndexOf("/") + 1);

			if (productName === "") {
				alert("产品名称不能为空");
				return false;
			}

			if (price === "") {
				alert("价格不能为空");
				return false;
			} else if (!/(^[1-9]\d*$)/.test(price)) {
				alert("价格必须是大于0的整数");
				return false;
			}

			if (series === "") {
				alert("系列名称不能为空");
				return false;
			}

			if (color === "") {
				alert("颜色不能为空");
				return false;
			}

			if (series === "") {
				alert("系列名称不能为空");
				return false;
			}

			if (productNum === "") {
				alert("数量不能为空");
				return false;
			} else if (!/(^[1-9]\d*$)/.test(productNum)) {
				alert("数量必须是大于0的整数");
				return false;
			}

			if (setMeal === "") {
				alert("套餐不能为空");
				return false;
			}

			if (brand === "") {
				alert("品牌名称不能为空");
				return false;
			}

			$.ajax({
				url: "/product/saveProduct.do",
				data: {
					productName:productName,
					price:price,
					productType:productType,
					series:series,
					color:color,
					productNum:productNum,
					brand:brand,
					setMeal:setMeal,
					description:description,
					productImage1:productImage1,
					productImage2:productImage2
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if (data.code === "1") {
						//关闭模态窗口
						$("#createProductModal").modal("hide");
						//刷新市场活动列，显示第一页数据，保持每页显示条数不变
						paginationQuery(1, $("#page").bs_pagination('getOption', 'rowsPerPage'));
					} else {
						//提示信息
						alert(data.message);
						//模态窗口不关闭
						$("#createProductModal").modal("show");
					}
				}
			})
		})
		//打开修改的模态窗口
		$("#editBtn").on('click', function () {
			let checked = $("#content input[type='checkbox']:checked");

			if (checked.length < 1) {
				alert("请选择要修改的商品");
				return false;
			} else if (checked.length > 1) {
				alert("只能选择一个商品进行修改");
				return false;
			}

			//获取选中的checkbox的id
			let pid = checked.val();
			//查询当前选中的市场活动信息但会到修改界面
			$.ajax({
				url: "product/queryProductVoByPid.do",
				data: {
					pid:pid
				},
				dataType: "json",
				type: "get",
				success:function (res) {
					$("#edit-productId").val(res.pid);
					$("#edit-productName").val(res.name);
					$("#edit-newPrice").val(res.newPrice);
					$("#edit-productType [value='" + res.type + "']").attr("selected", true);
					$("#edit-series").val(res.series);
					$("#edit-productNum").val(res.available);
					$("#edit-brand").val(res.brand);
					$("#edit-description").val(res.description);
					$("#productImg3").attr("src", "http://rcxsumzdq.hn-bkt.clouddn.com/" + res.image1);
					$("#productImg4").attr("src", "http://rcxsumzdq.hn-bkt.clouddn.com/" + res.image2);

					$("#editProductModal").modal("show");
				}
			})
		})
		//点击修改按钮，对商品进行更新
		$("#updateBtn").on('click', function () {
			let productId = $("#edit-productId").val();
			let productName = $.trim($("#edit-productName").val());
			let newPrice = $.trim($("#edit-newPrice").val());
			let type = $("#edit-productType").val();
			let series = $.trim($("#edit-series").val());
			let available = $.trim($("#edit-productNum").val());
			let brand = $.trim($("#edit-brand").val());
			let description = $.trim($("#edit-description").val());
			let productImage1 = $("#productImg3").attr("src");
			let productImage2 = $("#productImg4").attr("src");
			productImage1 = productImage1.substring(productImage1.lastIndexOf("/") + 1);
			productImage2 = productImage2.substring(productImage2.lastIndexOf("/") + 1);

			if (productName === "") {
				alert("产品名称不能为空");
				return false;
			}

			if (newPrice === "") {
				alert("价格不能为空");
				return false;
			} else if (!/(^[1-9]\d*$)/.test(newPrice)) {
				alert("价格必须是大于0的整数");
				return false;
			}

			if (series === "") {
				alert("系列名称不能为空");
				return false;
			}

			if (available === "") {
				alert("数量不能为空");
				return false;
			} else if (!/(^[1-9]\d*$)/.test(available)) {
				alert("数量必须是大于0的整数");
				return false;
			}

			if (brand === "") {
				alert("品牌名称不能为空");
				return false;
			}

			$.ajax({
				url: "/product/editProduct.do",
				data: {
					pid:productId,
					productName:productName,
					newPrice:newPrice,
					type:type,
					series:series,
					available:available,
					brand:brand,
					description:description,
					productImage1:productImage1,
					productImage2:productImage2
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if (data.code === "1") {
						//关闭模态窗口
						$("#editProductModal").modal("hide");
						//刷新市场活动列，显示第一页数据，保持每页显示条数不变
						paginationQuery(1, $("#page").bs_pagination('getOption', 'rowsPerPage'));
					} else {
						//提示信息
						alert(data.message);
						//模态窗口不关闭
						$("#editProductModal").modal("show");
					}
				}
			})
		})
		//删除记录
		$("#checkAll").click(function () {
			let checkbox = $("#content input[type='checkbox']");
			if ($(this).prop('checked')) {
				checkbox.prop('checked', true);
			} else {
				checkbox.prop('checked', false);
			}
		})

		$("#content").on('click', $("#content input[type='checkbox']"), function () {
			let checkbox = $("#content input[type='checkbox']");
			let checkedList = $("#content input[type='checkbox']:checked");
			if (checkbox.size() === checkedList.size()) {
				$("#checkAll").prop('checked', true);
			} else {
				$("#checkAll").prop('checked', false);
			}
		})

		$("#removeBtn").on('click', function () {
			let pids = "";
			let checked = $("#content input[type='checkbox']:checked");

			if (checked.size() === 0) {
				alert("请选择要删除的商品");
				return false;
			}

			if (confirm("确定删除？")) {
				$.each(checked, function (i, n) {
					pids += "pids=" + $(n).val() + "&";
				})
				pids = pids.substring(0, pids.length - 1);

				$.ajax({
					url: "product/removeProducts.do",
					data: pids,
					type: "post",
					dataType: "json",
					success: function (res) {
						if (res.code === "1") {
							alert("成功删除" + res.num + "条商品记录");
							//刷新市场活动列，显示第一页数据，保持每页显示条数不变
							paginationQuery(1, $("#page").bs_pagination('getOption', 'rowsPerPage'));
						} else {
							alert(res.message);
						}
					},
					error:function () {
						alert("系统忙，请稍后再试");
					}
				})
			}
		})
	});

	function paginationQuery(startPage, pageSize) {
		$.ajax({
			url: "product/splitPage.do",
			data: {
				startPage:startPage,
				pageSize:pageSize
			},
			type: "get",
			dataType: "json",
			success: function (data) {
				let htmlStr = "";
				$.each(data.list, function (i, n) {
					htmlStr += "<tr style=\"text-align: center;\" >";
					htmlStr += "<td class=\"ling-padding-top\"><input type=\"checkbox\" value='" + n.pid + "' /></td>";
					htmlStr += "<td style=\"height: 80px;width: 80px;cursor: pointer\"><img src=\"http://rcxsumzdq.hn-bkt.clouddn.com/" + n.image + "\" class=\"product-img\"></td>";
					htmlStr += "<td class=\"ling-padding-top\"><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='detail.html';\" class=\"product-name\">" + n.name + "</a></td>";
					htmlStr += "<td class=\"ling-padding-top\">" + n.newPrice + "</td>";
					htmlStr += "<td class=\"ling-padding-top\">" + n.oldPrice + "</td>";
					htmlStr += "<td class=\"ling-padding-top\">" + n.type + "</td>";
					htmlStr += "<td class=\"ling-padding-top\">" + n.available + "</td>";
					htmlStr += "<td class=\"ling-padding-top\">" + n.brand + "</td>";
					htmlStr += "<td class=\"ling-padding-top\">" + n.createBy + "</td>";
					htmlStr += "<td class=\"ling-padding-top\">" + n.sname + "</td>";
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

	function createProductImage(elId, divId, imgId) {
		$.ajaxFileUpload({
			url: "product/createProductImage.do",
			fileElementId: elId,
			type: "post",
			success: function (data) {
				//清空原有数据
				$("#" + divId).empty();
				//创建img 标签对象
				let imgObj = $("<img>");
				//给img标签对象追加属性
				imgObj.attr("src","http://rcxsumzdq.hn-bkt.clouddn.com/" + data.imgName);
				imgObj.attr("id", imgId);
				imgObj.css("width","100%");
				imgObj.css("height","100%");
				//将图片img标签追加到imgDiv末尾
				$("#" + divId).append(imgObj);
			},
			error: function () {
				alert("图片上传异常");
			}
		})
	}
	
</script>
</head>
<body>

	<!-- 创建模态窗口 -->
	<div class="modal fade" id="createProductModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header" style="border-bottom: 0px !important;">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建商品</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="form">
					
						<div class="form-group">
                            <label for="create-productName" class="col-sm-2 control-label">名称</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-productName">
                            </div>
							<label for="create-newPrice" class="col-sm-2 control-label">价格</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-newPrice">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-productType" class="col-sm-2 control-label">类别</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-productType">
									<c:forEach items="${requestScope.dicValues}" var="dic">
										<option value="${dic.id}">${dic.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-series" class="col-sm-2 control-label">系列</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-series">
							</div>
						</div>

						<div class="form-group">
							<label for="create-color" class="col-sm-2 control-label">颜色</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-color">
							</div>
							<label for="create-setMeal" class="col-sm-2 control-label">套餐</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-setMeal">
							</div>
						</div>

						<div class="form-group">
							<label for="create-productNum" class="col-sm-2 control-label">数量</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-productNum">
							</div>
							<label for="create-brand" class="col-sm-2 control-label">品牌</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-brand">
							</div>
						</div>

						<div class="form-group">
							<div class="col-sm-10" style="width: 200px;">
								<br><div id="imgDiv1" style="display:block; width: 100px;height: 100px;margin-left: 180px;margin-top: -10px;">
									<img src="image/productImg-tip.png" style="width: 100%;height: 100%;">
								</div><br><br><br><br>
								<div class="col-sm-10" style="width: 300px;">
									<input onchange="createProductImage('create-productImage1', 'imgDiv1', 'productImg1')" type="file" id="create-productImage1" style="margin-left: 164px;margin-top: -55px;" name="productImg">
								</div>
							</div>
							<div class="col-sm-10" style="width: 20px;">
								<br><div id="imgDiv2" style="display:block; width: 100px;height: 100px;margin-left: 170px;margin-top: -10px;">
								<img src="image/productImg-tip.png" style="width: 100%;height: 100%;">
							</div><br><br><br><br>
								<div class="col-sm-10" style="width: 300px;">
									<input onchange="createProductImage('create-productImage2', 'imgDiv2', 'productImg2')" type="file" id="create-productImage2" style="margin-left: 156px;margin-top: -55px;" name="productImg">
								</div>
							</div>
						</div>

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改模态窗口 -->
	<div class="modal fade" id="editProductModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改商品</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-productId">
						<div class="form-group">
							<label for="edit-productName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-productName">
							</div>
							<label for="edit-newPrice" class="col-sm-2 control-label">价格</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-newPrice">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-productType" class="col-sm-2 control-label">类别<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-productType">
									<c:forEach items="${requestScope.dicValues}" var="dic">
										<option value="${dic.id}">${dic.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-series" class="col-sm-2 control-label">系列</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-series">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-productNum" class="col-sm-2 control-label">数量</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-productNum">
							</div>
							<label for="edit-brand" class="col-sm-2 control-label">品牌</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-brand">
							</div>
						</div>

						<div class="form-group">
							<div class="col-sm-10" style="width: 200px;">
								<br><div id="imgDiv3" style="display:block; width: 100px;height: 100px;margin-left: 180px;margin-top: -10px;">
								<img src="image/productImg-tip.png" style="width: 100%;height: 100%;" id="productImg3">
							</div><br><br><br><br>
								<div class="col-sm-10" style="width: 300px;">
									<input onchange="createProductImage('edit-productImage1', 'imgDiv3', 'productImg3')" type="file" id="edit-productImage1" style="margin-left: 164px;margin-top: -55px;" name="productImg">
								</div>
							</div>
							<div class="col-sm-10" style="width: 20px;">
								<br><div id="imgDiv4" style="display:block; width: 100px;height: 100px;margin-left: 170px;margin-top: -10px;">
								<img src="image/productImg-tip.png" style="width: 100%;height: 100%;margin-left: 60px;" id="productImg4">
							</div><br><br><br><br>
								<div class="col-sm-10" style="width: 300px;">
									<input onchange="createProductImage('edit-productImage2', 'imgDiv4', 'productImg4')" type="file" id="edit-productImage2" style="margin-left: 156px;margin-top: -55px;" name="productImg">
								</div>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>商品</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="removeBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
			</div>
			<div style="position: relative;top: 10px;">
<!--				商品信息列表-->
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;text-align: center;">
							<td><input type="checkbox" id="checkAll"/></td>
							<td>图片</td>
							<td>名称</td>
                            <td>折扣价</td>
							<td>原价</td>
                            <td>类别</td>
							<td>数量</td>
							<td>品牌</td>
                            <td>所有人</td>
                            <td>系列</td>
						</tr>
					</thead>
					<tbody id="content">
					</tbody>
				</table>
				<%--分页--%>
				<div id="page"></div>
			</div>
			</div>
			
		</div>
		
	</div>
</body>
</html>
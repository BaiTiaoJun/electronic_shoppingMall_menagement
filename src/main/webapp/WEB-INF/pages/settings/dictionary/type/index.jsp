<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/"; %>
<html>
<head>
<base href="<%=basePath%>">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet" />
<link href="css/product-index.css" rel="stylesheet">

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
</head>

<script>
	$(function () {
		paginationQuery();

		$("#createBtn").click(function () {
			$("#form")[0].reset();
			$("#createDirectoryTypeModal").modal("show");
		})

		$("#saveBtn").click(function () {
			let typeCode = $.trim($("#create-dicTypeCode").val());
			let typeName = $.trim($("#create-dicTypeName").val());

			if (typeCode === "") {
				alert("编码不能为空");
				return false;
			}

			if (typeName === "") {
				alert("名称不能为空");
				return false;
			}

			$.ajax({
				url: "settings/dictionary/type/saveDicType.do",
				data: {
					typeCode:typeCode,
					typeName:typeName
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if (data.code === "1") {
						paginationQuery(1, $("#page").bs_pagination('getOption', 'rowsPerPage'));
						$("#createDirectoryTypeModal").modal("hide");
					} else {
						alert(data.message);
						$("#createDirectoryTypeModal").modal("show");
					}
				}
			})
		})

		$("#editBtn").click(function () {
			let checked = $("#content input[type='checkbox']:checked");

			if (checked.size() === 0){
				alert("请选择需要编辑的字典类型");
				return false;
			} else if (checked.size() > 1) {
				alert("只能选择一个字典类型进行编辑");
				return false;
			}

			$.ajax({
				url: "settings/dictionary/type/queryEditTypeValue.do",
				data: {
					code:checked.val()
				},
				type: "get",
				dataType: "json",
				success: function (res) {
					$("#edit-dicTypeCode").val(res.code);
					$("#edit-dicTypeName").val(res.name);
				}
			})

			$("#editDirectionTypeModal").modal("show");
		})

		$("#updateBtn").click(function () {
			let typeCode = $("#edit-dicTypeCode").val();
			let typeName = $.trim($("#edit-dicTypeName").val());

			if (typeName === "") {
				alert("名称不能为空");
				return false;
			}

			$.ajax({
				url: "settings/dictionary/type/editDicValue.do",
				data: {
					typeCode:typeCode,
					typeName:typeName
				},
				type: "post",
				dataType: "json",
				success: function (res) {
					if (res.code === "1") {
						paginationQuery(1, $("#page").bs_pagination('getOption', 'rowsPerPage'));
						$("#editDirectionTypeModal").modal('hide');
					} else {
						alert(res.message);
						$("#editDirectionTypeModal").modal('show');
					}
				}
			})
		})

		$("#checkAll").click(function () {
			let checkedList = $("#content input[type='checkbox']");
			if ($(this).prop('checked')) {
				checkedList.prop('checked', true);
			} else {
				checkedList.prop('checked', false);
			}
		})

		$("#content").on('click', $("#content input[type='checkbox']"), function () {
			let checkedList = $("#content input[type='checkbox']");
			let checked = $("#content input[type='checkbox']:checked");
			if (checkedList.size() === checked.size()) {
				$("#checkAll").prop('checked', true);
			} else {
				$("#checkAll").prop('checked', false);
			}
		})

		$("#removeBtn").click(function () {
			let checked = $("#content input[type='checkbox']:checked");

			if (checked.size() === 0) {
				alert("请选择要删除的类型");
				return false;
			}

			if (confirm("确定删除？")) {
				let codes = "";
				$.each(checked, function () {
					codes += "codes=" + $(this).val() + "&";
				})
				codes = codes.substring(0, codes.length - 1);

				$.ajax({
					url: "settings/dictionary/type/removeTypeValue.do",
					data: codes,
					type: "post",
					dataType: "json",
					success: function (res) {
						if (res.code === "1") {
							paginationQuery(1, $("#page").bs_pagination('getOption', 'rowsPerPage'));
						} else {
							alert(res.message);
						}
					}
				})
			}
		})
	})

	function paginationQuery(startPage, pageSize) {
		$("#checkAll").prop("checked", false);

		$.ajax({
			url: "settings/dictionary/type/splitPageQuery.do",
			data: {
				startPage:startPage,
				pageSize:pageSize
			},
			type: "get",
			dataType: "json",
			success: function (data) {
				let htmlStr = "";
				$.each(data.list, function (i, n) {
					htmlStr += "<tr>";
					htmlStr += "<td><input type=\"checkbox\" value='" + n.code + "' /></td>";
					htmlStr += "<td>" + n.code + "</td>";
					htmlStr += "<td>" + n.name + "</td>";
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
<body>

	<!-- 创建字典类型模态窗口 -->
	<div class="modal fade" id="createDirectoryTypeModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建商品字典类型</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form" id="form">

						<div class="form-group">
							<label for="create-dicTypeCode" class="col-sm-2 control-label">编码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-dicTypeCode">
							</div>
							<label for="create-dicTypeName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-dicTypeName">
							</div>
						</div>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="saveBtn" class="btn btn-default">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改字典模态窗口 -->
	<div class="modal fade" id="editDirectionTypeModal" role="dialog">

		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改字典类型</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">
						<input type="hidden" id="id">
						<div class="form-group">
							<label for="edit-dicTypeCode" class="col-sm-2 control-label">编码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-dicTypeCode" readonly >
							</div>
							<label for="edit-dicTypeName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-dicTypeName">
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
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典类型列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" id="createBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" class="btn btn-danger" id="removeBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="checkAll" /></td>
					<td>编码</td>
					<td>名称</td>
				</tr>
			</thead>
			<tbody id="content">
<%--				<tr class="active">--%>
<%--					<td><input type="checkbox" /></td>--%>
<%--					<td>sex</td>--%>
<%--					<td>性别</td>--%>
<%--				</tr>--%>
			</tbody>
		</table>
		<div id="page"></div>
	</div>
	
</body>
</html>
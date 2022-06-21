<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/"; %>
<html>
<head>
<base href="<%=basePath%>">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet" />
<link href="css/product-index.css" rel="stylesheet">

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">

	$(function(){
		paginationQuery();

		$.ajax({
			url: "settings/dictionary/value/queryDicType.do",
			type: "get",
			dataType: "json",
			success: function (res) {
				let htmlStr = "";
				$.each(res, function () {
					htmlStr += "<option value=\"" + this.code + "\">" + this.name + "</option>";
				})
				$("#edit-typeCode").html(htmlStr);
				$("#create-typeCode").html(htmlStr);
			}
		})

		//打开创建类型的模态窗口
		$("#createBtn").click(function () {
			$("#form")[0].reset();
			$("#createDirectionModal").modal('show');
		})
		//字典值添加
		$("#saveBtn").on('click', function() {
			let value = $.trim($("#create-typeValue").val());
			let text = $.trim($("#create-typeText").val());
			let typeCode = $("#create-typeCode option:selected").val();

			if (value === "") {
				alert("value不能为空");
				return false;
			}

			if (text === "") {
				alert("text不能为空");
				return false;
			}

			$.ajax({
				url: "settings/dictionary/value/saveDicValue.do",
				data: {
					value:value,
					text:text,
					typeCode:typeCode
				},
				type: "post",
				dataType: "json",
				success: function (res) {
					if (res.code === "1") {
						paginationQuery(1, $("#page").bs_pagination('getOption', 'rowsPerPage'));
						$("#createDirectionModal").modal('hide');
					} else {
						alert(res.message);
						$("#createDirectionModal").modal('show');
					}
				}
			})
		})
		//打开编辑模态窗口
		$("#editBtn").click(function () {
			let checked = $("#content input[type='checkbox']:checked");

			if (checked.size() === 0){
				alert("请选择需要编辑的字典值");
				return false;
			} else if (checked.size() > 1) {
				alert("只能选择一个字典值进行编辑");
				return false;
			}

			$.ajax({
				url: "settings/dictionary/value/queryEditTypeValue.do",
				data: {
					id:checked.val()
				},
				type: "get",
				dataType: "json",
				success: function (res) {
					$("#id").val(res.id);
					$("#edit-typeValue").val(res.value);
					$("#edit-typeText").val(res.text);
					$("#edit-typeCode option[value='" + res.typeCode + "']").prop('selected', true);
				}
			})
			$("#editDirectionModal").modal('show');
		})
		//更新字典值
		$("#updateBtn").on('click', function () {
			let id = $("#id").val();
			let value = $.trim($("#edit-typeValue").val());
			let text = $.trim($("#edit-typeText").val());

			if (value === "") {
				alert("value不能为空");
				return false;
			}

			if (text === "") {
				alert("text不能为空");
				return false;
			}

			$.ajax({
				url: "settings/dictionary/value/editDicValue.do",
				data: {
					value:value,
					text:text,
					id:id
				},
				type: "post",
				dataType: "json",
				success: function (res) {
					if (res.code === "1") {
						paginationQuery(1, $("#page").bs_pagination('getOption', 'rowsPerPage'));
						$("#editDirectionModal").modal('hide');
					} else {
						alert(res.message);
						$("#editDirectionModal").modal('show');
					}
				}
			})
		})
		//删除字典值
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
				let ids = "";
				$.each(checked, function () {
					ids += "ids=" + $(this).val() + "&";
				})
				ids = ids.substring(0, ids.length - 1);

				$.ajax({
					url: "settings/dictionary/value/removeTypeValue.do",
					data: ids,
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
	});

	function paginationQuery(startPage, pageSize) {
		$("#checkAll").prop("checked", false);

		$.ajax({
			url: "settings/dictionary/value/splitPageQuery.do",
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
					htmlStr += "<td><input type=\"checkbox\" value='" + n.id + "' /></td>";
					htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='detail.html';\">" + n.value + "</a></td>";
					htmlStr += "<td>" + n.text + "</td>";
					htmlStr += "<td>" + n.typeCode + "</td>";
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

	<!-- 创建字典模态窗口 -->
	<div class="modal fade" id="createDirectionModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建商品字典</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form" id="form">

						<div class="form-group">
                            <label for="create-typeValue" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-typeValue">
                            </div>
							<label for="create-typeText" class="col-sm-2 control-label">文本<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-typeText">
							</div>
						</div>

						<div class="form-group">
							<label for="create-typeCode" class="col-sm-2 control-label">字典类型编码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-typeCode" style="width: 100%;">
								</select>
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
	<div class="modal fade" id="editDirectionModal" role="dialog">

		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改商品字典</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">
						<input type="hidden" id="id">
						<div class="form-group">
							<label for="edit-typeValue" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-typeValue">
							</div>
							<label for="edit-typeText" class="col-sm-2 control-label">文本<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-typeText">
							</div>
						</div>
						<div class="form-group">
							<label for="edit-typeCode" class="col-sm-2 control-label">字典类型编码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-typeCode" style="width: 100%;" disabled>
								</select>
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
				<h3>商品类别</h3>
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
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;text-align: center;">
							<td><input type="checkbox" id="checkAll"/></td>
							<td>字典值</td>
                            <td>文本</td>
							<td>字典编码</td>
						</tr>
					</thead>
					<tbody id="content">
					</tbody>
				</table>
				<div id="page"></div>
			</div>
			
		</div>
	</div>
</body>
</html>
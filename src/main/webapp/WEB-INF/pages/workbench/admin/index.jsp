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
<!--必要样式-->
<link href="jquery/city-picker-master/css/city-picker.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
<script src="jquery/city-picker-master/js/city-picker.data.js"></script>
<script src="jquery/city-picker-master/js/city-picker.js"></script>

<script type="text/javascript">

	$(function(){

		paginationQuery();

		//日历插件
		$(".date").datetimepicker({
			format: 'yyyy-mm-dd',
			minView:'month',
			language:'zh-CN',
			autoclose:true,
			initialDate:new Date(),
			todayBtn:true,
			clearBtn:true,
		})
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		$("#crateBtn").click(function () {
			$("#form")[0].reset();
			$("#createUserModal").modal('show');
		})

		$("#saveBtn").click(function () {
			let username = $("#create-userName").val();
			let password = $("#create-userPass").val();
			// let realName = $("#create-realName").val();
			// let gender = $("input[name='gender']:checked").val();
			// let idCard = $("#create-idCard").val();
			// let phone = $("#create-cellPhone").val();
			// let email = $("#create-email").val();
			// let address = $("#create-address").val();
			// let birthday = $("#create-birthday").val();
			// let detailAddress = $("#create-detailAddress").val();

			if (username === "") {
				alert("用户名不能为空");
				return false;
			}

			if (password === "") {
				alert("密码不能为空");
				return false;
			} else if(password.length < 6 || password.length > 16) {
				alert("密码必须是6到16位");
				return false;
			} else if(!/^[0-9a-zA-Z]+$/.test(password)) {
				alert("密码只可使用数字和大小写英文字母");
				return false;
			} else if (!/^(([a-zA-Z]+[0-9]+)|([0-9]+[a-zA-Z]+))[a-zA-Z0-9]*/.test(password)) {
				alert("密码应同时包含英文和数字");
				return false;
			}

			// if (phone === "") {
			// 	alert("手机号码不能为空");
			// 	return false;
			// } else if (!/^1[1-9]\d{9}$/.test(phone)) {
			// 	alert("手机号码格式错误");
			// 	return false;
			// }
			//
			// if (!/^[\u4e00-\u9fa5]{2,4}$/.test(realName) && realName !== "") {
			// 	alert("只能是2-4位的汉字作为名字");
			// 	return false;
			// }
			//
			// if (!/(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/.test(idCard) && idCard !== "") {
			// 	alert("身份证格式不正确");
			// 	return false;
			// }
			//
			// if (!/^\w+@[a-zA-Z0-9]{2,10}(?:\.[a-z]{2,4}){1,3}$/.test(email) && email !== "") {
			// 	alert("邮箱格式不正确");
			// 	return false;
			// }

			$.ajax({
				url: "admin/saveUser.do",
				data: {
					username:username,
					password:password,
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if (data.code === "1") {
						paginationQuery(1, $("#page").bs_pagination('getOption', 'rowsPerPage'));
						//关闭模态窗口
						$("#createUserModal").modal("hide");
					} else {
						alert(data.message);
						$("#createUserModal").modal("show");
					}
				}
			})
		})

		// $("#editBtn").click(function () {
		// 	let checked = $("#content input[type='checkbox']:checked");
		//
		// 	if (checked.size() === 0) {
		// 		alert("请选择要修改的用户");
		// 		return false;
		// 	}
		// 	if (checked.size() > 1) {
		// 		alert("只能选择一个用户进行修改");
		// 		return false;
		// 	}
		//
		// 	$.ajax({
		// 		url: "admin/queryEditUser.do",
		// 		data: {
		// 			uid:checked.val()
		// 		},
		// 		type: "get",
		// 		dateType: "json",
		// 		success: function (data) {
		// 			$("#edit-realName").val(data.name);
		// 			let $gender = $("input[name='gender']");
		// 			$.each($gender, function () {
		// 				if ($(this).val() === data.gender) {
		// 					$(this).prop("checked", true);
		// 				}
		// 			})
		// 			$("#edit-idCard").val(data.idCard);
		// 			$("#edit-cellPhone").val(data.phone);
		// 			$("#edit-email").val(data.email);
		// 			// $("#edit-address").citypicker('reset');
		// 			// $("#edit-address").citypicker('destroy');
		// 			// $("#edit-address").citypicker({
		// 			// 	province:"湖北省",
		// 			// 	city:"孝感市",
		// 			// 	district:"孝南区"
		// 			// });
		// 			$("#edit-birthday").val(data.birthday);
		// 			// $("#edit-detailAddress").val(data.detailAddress);
		// 		}
		// 	})
		//
		// 	$("#editUserModal").modal('show');
		// })

		// $("#updateBtn").click(function () {
		// 	let uid = $("#content input[type='checkbox']:checked").val();
		// 	let name = $.trim($("#edit-realName").val());
		// 	let gender = $.trim($("input[name='gender']:checked").val());
		// 	let idCard = $.trim($("#edit-idCard").val());
		// 	let phone = $.trim($("#edit-cellPhone").val());
		// 	let email = $.trim($("#edit-email").val());
		// 	let birthday = $("#edit-birthday").val();
		//
		// 	if (phone === "") {
		// 		alert("手机号码不能为空");
		// 		return false;
		// 	} else if (!/^1[1-9]\d{9}$/.test(phone)) {
		// 		alert("手机号码格式错误");
		// 		return false;
		// 	}
		//
		// 	if (!/^[\u4e00-\u9fa5]{2,4}$/.test(name) && name !== "") {
		// 		alert("只能是2-4位的汉字作为名字");
		// 		return false;
		// 	}
		//
		// 	if (!/(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/.test(idCard) && idCard !== "") {
		// 		alert("身份证格式不正确");
		// 		return false;
		// 	}
		//
		// 	if (!/^\w+@[a-zA-Z0-9]{2,10}(?:\.[a-z]{2,4}){1,3}$/.test(email) && email !== "") {
		// 		alert("邮箱格式不正确");
		// 		return false;
		// 	}
		//
		// 	$.ajax({
		// 		url: "admin/editUser.do",
		// 		data: {
		// 			uid:uid,
		// 			name:name,
		// 			gender:gender,
		// 			idCard:idCard,
		// 			phone:phone,
		// 			email:email,
		// 			birthday:birthday
		// 		},
		// 		type: "post",
		// 		dataType: "json",
		// 		success: function (data) {
		// 			if (data.code === "1") {
		// 				paginationQuery(1, $("#page").bs_pagination('getOption', 'rowsPerPage'));
		// 				//关闭模态窗口
		// 				$("#editUserModal").modal("hide");
		// 			} else {
		// 				alert(data.message);
		// 				$("#editUserModal").modal("show");
		// 			}
		// 		}
		// 	})
		// })

		$("#checkAll").click(function () {
			let checked = $("#content input[type='checkbox']");
			if ($(this).prop('checked')) {
				checked.prop('checked', true);
			} else {
				checked.prop('checked', false);
			}
		})

		$("#content").on('click', $("content input[type='checkbox']"), function () {
			let checkList = $("#content input[type='checkbox']");
			let checked = $("#content input[type='checkbox']:checked");
			if (checkList.size() === checked.size()) {
				$("#checkAll").prop('checked', true);
			} else {
				$("#checkAll").prop('checked', false);
			}
		})

		$("#removeBtn").click(function () {
			let checked = $("#content input[type='checkbox']:checked");

			if (checked.size() === 0) {
				alert("请选择要删除的用户");
				return false;
			}

			let flag = false;
			$.each(checked, function () {
				if ("${sessionScope.user.uid}" === $(this).val()) {
					alert("不能包含当前登录用户:" + "${sessionScope.user.username}");
					flag = true;
				}
			});
			if (flag === true) {
				return false;
			}

			if (confirm("确定删除？")) {
				let uids = "";
				$.each(checked, function () {
					uids += "uids=" + $(this).val() + "&";
				})
				uids = uids.substring(0, uids.length - 1);

				$.ajax({
					url: "admin/removeUser.do",
					data: uids,
					type: "post",
					dataType: "json",
					success: function (data) {
						if (data.code === "1") {
							paginationQuery(1, $("#page").bs_pagination('getOption', 'rowsPerPage'));
						} else {
							alert(data.message);
						}
					}
				})
			}
		})
	});

	function paginationQuery(startPage, pageSize) {
		$.ajax({
			url: "admin/splitPageQuery.do",
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
					htmlStr += "<td><input type=\"checkbox\" value='" + n.uid + "'/></td>";
					htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='detail.html';\">" + n.username + "</a></td>";
					// htmlStr += "<td>" + n.password + "</td>";
					htmlStr += "<td>" + n.name + "</td>";
					htmlStr += "<td>" + n.gender + "</td>";
					htmlStr += "<td>" + n.idCard + "</td>";
					htmlStr += "<td>" + n.phone + "</td>";
					htmlStr += "<td>" + n.email + "</td>";
					// htmlStr += "<td>" + n.address + "</td>";
					htmlStr += "<td>" + n.registerTime + "</td>";
					htmlStr += "<td>" + n.lastLoginTime + "</td>";
					htmlStr += "<td>" + n.birthday + "</td>";
					htmlStr += "<td>" + n.type + "</td>";
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

<style>
	.city-picker-span {
		width: 270px !important;
		height: 34px;
		line-height: 33px;
	}

	.city-picker-dropdown {
		width: 420px !important;
	}

	.table > thead > tr > td,.table > tbody > tr > td {
		padding: 7px !important;
	}
</style>

</head>
<body>

	<!-- 创建管理员的模态窗口 -->
	<div class="modal fade" id="createUserModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建管理员用户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="form">
					
						<div class="form-group">
							<label for="create-userName" class="col-sm-2 control-label">用户名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-userName">
							</div>
							<label for="create-userPass" class="col-sm-2 control-label">密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-userPass">
							</div>
						</div>
						
<%--						<div class="form-group">--%>
<%--                            <label for="create-realName" class="col-sm-2 control-label">姓名</label>--%>
<%--                            <div class="col-sm-10" style="width: 300px;">--%>
<%--                                <input type="text" class="form-control" id="create-realName">--%>
<%--                            </div>--%>
<%--							<label class="col-sm-2 control-label">性别</label>--%>
<%--							<div class="col-sm-10" style="width: 300px;margin-top: 6px;font-size: 16px;">--%>
<%--								<input type="radio" name="gender" value="男" style="cursor: pointer" checked> 男--%>
<%--								<input type="radio" name="gender" value="女" style="margin-left: 20px;cursor: pointer"> 女--%>
<%--							</div>--%>
<%--						</div>--%>

<%--						<div class="form-group">--%>
<%--							<label for="create-idCard" class="col-sm-2 control-label">身份证号码</label>--%>
<%--							<div class="col-sm-10" style="width: 300px;">--%>
<%--								<input type="text" class="form-control" id="create-idCard">--%>
<%--							</div>--%>
<%--							<label for="create-cellPhone" class="col-sm-2 control-label">手机号码<span style="font-size: 15px; color: red;">*</span></label>--%>
<%--							<div class="col-sm-10" style="width: 300px;">--%>
<%--								<input type="text" class="form-control" id="create-cellPhone">--%>
<%--							</div>--%>
<%--						</div>--%>

<%--						<div class="form-group">--%>
<%--							<label for="create-email" class="col-sm-2 control-label">邮箱地址</label>--%>
<%--							<div class="col-sm-10" style="width: 300px;">--%>
<%--								<input type="text" class="form-control" id="create-email">--%>
<%--							</div>--%>
<%--							<label for="create-address" class="col-sm-2 control-label">收货地址</label>--%>
<%--							<div class="col-sm-10" style="width: 300px;">--%>
<%--								<input type="text" class="form-control" id="create-address" data-toggle="city-picker">--%>
<%--							</div>--%>
<%--						</div>--%>

<%--						<div class="form-group">--%>
<%--							<label for="create-birthday" class="col-sm-2 control-label">出生年月</label>--%>
<%--							<div class="col-sm-10" style="width: 300px;">--%>
<%--								<input type="text" class="form-control" id="create-birthday" readonly style="cursor: pointer">--%>
<%--							</div>--%>
<%--							<label for="create-detailAddress" class="col-sm-2 control-label">详细地址</label>--%>
<%--							<div class="col-sm-10" style="width: 300px;">--%>
<%--								<input type="text" class="form-control" id="create-detailAddress">--%>
<%--							</div>--%>
<%--						</div>--%>
<%--						<div class="form-group">--%>
<%--							<label for="create-type" class="col-sm-2 control-label">类型</label>--%>
<%--							<div class="col-sm-10" style="width: 300px;">--%>
<%--								<select id="create-type" class="form-control" >--%>
<%--									<c:forEach items="${requestScope.dicValues}" var="dic">--%>
<%--										<option value="${dic.id}">${dic.text}</option>--%>
<%--									</c:forEach>--%>
<%--								</select>--%>
<%--							</div>--%>
<%--						</div>--%>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改所有用户的模态窗口 -->
<%--	<div class="modal fade" id="editUserModal" role="dialog">--%>
<%--		<div class="modal-dialog" role="document" style="width: 85%;">--%>
<%--			<div class="modal-content">--%>
<%--				<div class="modal-header">--%>
<%--					<button type="button" class="close" data-dismiss="modal">--%>
<%--						<span aria-hidden="true">×</span>--%>
<%--					</button>--%>
<%--					<h4 class="modal-title" id="myModalLabel">修改用户</h4>--%>
<%--				</div>--%>
<%--				<div class="modal-body">--%>
<%--					<form class="form-horizontal" role="form">--%>
<%--						<div class="form-group">--%>
<%--							<label for="edit-realName" class="col-sm-2 control-label">姓名</label>--%>
<%--							<div class="col-sm-10" style="width: 300px;">--%>
<%--								<input type="text" class="form-control" id="edit-realName">--%>
<%--							</div>--%>
<%--							<label class="col-sm-2 control-label">性别</label>--%>
<%--							<div class="col-sm-10" style="width: 300px;margin-top: 6px;font-size: 16px;">--%>
<%--								<input type="radio" value="男" name="gender" id="edit-male" style="cursor: pointer" checked> 男--%>
<%--								<input type="radio" value="女" name="gender" id="edit-female" style="margin-left: 20px;cursor: pointer"> 女--%>
<%--							</div>--%>
<%--						</div>--%>

<%--						<div class="form-group">--%>
<%--							<label for="edit-idCard" class="col-sm-2 control-label">身份证号码</label>--%>
<%--							<div class="col-sm-10" style="width: 300px;">--%>
<%--								<input type="text" class="form-control" id="edit-idCard">--%>
<%--							</div>--%>
<%--							<label for="edit-cellPhone" class="col-sm-2 control-label">手机号码<span style="font-size: 15px; color: red;">*</span></label>--%>
<%--							<div class="col-sm-10" style="width: 300px;">--%>
<%--								<input type="text" class="form-control" id="edit-cellPhone">--%>
<%--							</div>--%>
<%--						</div>--%>

<%--						<div class="form-group">--%>
<%--							<label for="edit-email" class="col-sm-2 control-label">邮箱地址</label>--%>
<%--							<div class="col-sm-10" style="width: 300px;">--%>
<%--								<input type="text" class="form-control" id="edit-email">--%>
<%--							</div>--%>
<%--							<label for="edit-birthday" class="col-sm-2 control-label">出生年月</label>--%>
<%--							<div class="col-sm-10" style="width: 300px;">--%>
<%--								<input type="text" class="form-control date" id="edit-birthday" readonly style="cursor: pointer">--%>
<%--							</div>--%>
<%--						</div>--%>

<%--&lt;%&ndash;						<div class="form-group">&ndash;%&gt;--%>
<%--&lt;%&ndash;							<label for="edit-address" class="col-sm-2 control-label">收货地址</label>&ndash;%&gt;--%>
<%--&lt;%&ndash;							<div class="col-sm-10" style="width: 300px;">&ndash;%&gt;--%>
<%--&lt;%&ndash;								&lt;%&ndash;								<input type="text" class="form-control" id="edit-address" data-toggle="city-picker">&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;								<input type="text" class="form-control" id="edit-address" >&ndash;%&gt;--%>
<%--&lt;%&ndash;							</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;						</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;						<div class="form-group">&ndash;%&gt;--%>
<%--&lt;%&ndash;							<label for="edit-type" class="col-sm-2 control-label">类型</label>&ndash;%&gt;--%>
<%--&lt;%&ndash;							<div class="col-sm-10" style="width: 300px;">&ndash;%&gt;--%>
<%--&lt;%&ndash;								<select id="edit-type" class="form-control" >&ndash;%&gt;--%>
<%--&lt;%&ndash;									<c:forEach items="${requestScope.dicValues}" var="dic">&ndash;%&gt;--%>
<%--&lt;%&ndash;										<option value="${dic.id}">${dic.text}</option>&ndash;%&gt;--%>
<%--&lt;%&ndash;									</c:forEach>&ndash;%&gt;--%>
<%--&lt;%&ndash;								</select>&ndash;%&gt;--%>
<%--&lt;%&ndash;							</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;						</div>&ndash;%&gt;--%>

<%--					</form>--%>
<%--					--%>
<%--				</div>--%>
<%--				<div class="modal-footer">--%>
<%--					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>--%>
<%--					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>
<%--	</div>--%>

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>用户列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;width: 100% !important;">
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="crateBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
<%--				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>--%>
				  <button type="button" class="btn btn-danger" id="removeBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
					<tr style="color: #B3B3B3;text-align: center;">
						<td><input type="checkbox" id="checkAll" /></td>
						<td>用户名</td>
<%--						<td>密码</td>--%>
						<td>真实名称</td>
						<td>性别</td>
						<td>身份证</td>
						<td>手机号</td>
						<td>邮箱地址</td>
<%--						<td>收货地址</td>--%>
						<td>注册时间</td>
						<td>最后登录时间</td>
						<td>出生年月</td>
						<td>用户类型</td>
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
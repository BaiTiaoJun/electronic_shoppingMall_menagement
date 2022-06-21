<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/"; %>
<html>
<head>
<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

	<style>
		.logo {
			vertical-align: middle;
			width: 150px;
			margin-left: 20px;
			margin-top: 6px;
		}

		.on:hover {
			background-color: #d05509 !important;
		}
	</style>

	<script>
		$(function () {
			$("#loginAct").focus();
			//点击登录按钮提交请求
			$("#loginBtn").click(function () {
				login();
			})
			//回车提交请求
			$(window).keydown(function(event) {
				if (event.keyCode === 13) {
					login();
				}
			})
		})

		function login() {
			let loginAct = $.trim($("#loginAct").val());
			let loginPwd = $.trim($("#loginPwd").val());
			let isRemPwd = $("#isRemPwd").prop("checked");

			if (loginAct === "" || loginPwd === "") {
				$("#msg").html("账户或密码不能为空");
				return false;
			}

			$.ajax({
				url:"settings/qx/user/login.do",
				data:{
					loginAct:loginAct,
					loginPwd:loginPwd,
					isRemPwd:isRemPwd
				},
				type:"post",
				dataType:"json",
				success:function (resp) {
					if (resp.code === "1") {
						window.location.href = "workbench/index.do";
					} else {
						$("#msg").html(resp.message);
					}
				},
				beforeSend:function () {
					$("#msg").html("请等待...");
				}
			})
		}
	</script>
</head>
<body>
	<div style="position: absolute; top: -20px; left: 0px; width: 60%;height: 900px;">
		<img src="image/png2.png" style="width: 100%; height: 100%; position: relative; top: 10px;">
	</div>
	<div id="top" style="height: 70px; background-color: #0d2a62; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'"><img src="image/logo5.png" class="logo"><span style="font-size: 12px;">&copy;2022&nbsp;淘淘乐</span></div>
	</div>

	<div style="position: absolute; top: 160px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5;">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1 style="color: #5e5e5e;">登录</h1>
			</div>
			<form action="#" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" type="text" placeholder="用户名" id="loginAct" value="${cookie.loginAct.value}">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" type="password" placeholder="密码" id="loginPwd" value="${cookie.loginPwd.value}">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
							<c:if test="${not empty cookie.loginAct.value and not empty cookie.loginPwd.value}">
								<input type="checkbox" id="isRemPwd" checked>
							</c:if>
							<c:if test="${empty cookie.loginAct.value and empty cookie.loginPwd.value}">
								<input type="checkbox" id="isRemPwd">
							</c:if>
							十天内免登录
						</label>
						&nbsp;&nbsp;
						<span id="msg" style="color: #ea1515"></span>
					</div>
					<button id="loginBtn" type="button" class="btn btn-primary btn-lg btn-block on"  style="width: 350px; position: relative;top: 45px;background-color: #ec610a;border-color: #ec610a;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>
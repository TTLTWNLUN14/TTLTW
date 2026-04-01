<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>JSP - Hello World</title>
</head>
<body>
<h1><%= "Hello World!" %></h1>
<br/>
<a href="helloServlet">Hello Servlet</a>
<a href="list-product">list-product</a>
<a href="list-product/product?id=1">product</a>
<a href="brand">brand</a>
<a href="${pageContext.request.contextPath}/login" class="btn-login">Đăng nhập</a>
<a href="${pageContext.request.contextPath}/register" class="btn-register">Đăng ký</a>
<a href="${pageContext.request.contextPath}/profile" class="btn-profile">Hồ Sơ</a>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Xác Nhận Đơn Hàng - Auto Cars</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/payment_confirmation.css">
</head>
<body>
<nav class="global-nav">
  <div class="nav-inner">
    <a class="nav-logo" href="${pageContext.request.contextPath}/assets/html/index.html">AUTO CARS</a>
    <div class="nav-links">
      <a class="nav-link" href="${pageContext.request.contextPath}/assets/html/index.html">Trang chủ</a>
      <a class="nav-link active" href="${pageContext.request.contextPath}/assets/html/list-cars.html">Xe</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/WEB-INF/views/cars-brand.html">Hãng xe</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/assets/html/booking.html">Đặt xe</a>
      <a class="nav-link" href="my-shopping-cart">Giỏ hàng (${sessionScope.cart.totalQuantity != null ? sessionScope.cart.totalQuantity : 0})</a>
    </div>
    <div class="nav-actions" id="navActions">
      <a href="#" class="btn-login">Đăng nhập</a>
      <a href="#" class="btn-login" style="margin-left: 20px">Đăng ký</a>
    </div>
  </div>
</nav>

<main class="confirm-page">
  <div class="confirm-container">

    <div class="success-header">
      <div class="success-text">
        <h1>Cảm ơn quý khách chúc quý khách thượng lộ bình an!</h1>
      </div>
    </div>

    <div class="confirm-actions">
      <button class="btn-back"><a href="../../assets/html/index.html" style="text-decoration: none; color: #333;">← Quay về trang chủ</a></button>
      <button class="btn-next"><a href="../../assets/html/booking.html" style="text-decoration: none; color: white;">Tiếp tục mua hàng →</a></button>
    </div>
  </div>
</main>

<script src="../../assets/js/payment_confirmation.js"></script>
</body>
</html>
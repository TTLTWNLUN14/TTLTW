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
    <a class="nav-logo" href="index.html">AUTO CARS</a>
    <div class="nav-links">
      <a class="nav-link" href="index.html">Trang chủ</a>
      <a class="nav-link" href="list-cars.html">Xe</a>
      <a class="nav-link" href="../../WEB-INF/views/cars-brand.jsp">Hãng xe</a>
      <a class="nav-link" href="../../WEB-INF/views/booking.jsp">Đặt xe</a>
      <a class="nav-link" href="../../WEB-INF/views/shopping-cart.jsp">Giỏ hàng</a>
    </div>
    <div class="nav-actions" id="navActions">
      <a href="#" class="btn-login">Đăng nhập</a>
      <a href="#" class="btn-login" style="margin-left: 20px">Đăng ký</a>
    </div>
  </div>
</nav>

<main class="confirm-page">
  <div class="confirm-container">
    <h1>Cảm ơn quý khách đã đặt xe!</h1>
    <p class="sub-msg">
      Đơn đặt xe của bạn đã được ghi nhận thành công.<br>
      Chúc quý khách thượng lộ bình an!
    </p>

    <c:if test="${not empty param.price}">
      <div class="price-tag">
        Đã thanh toán: <fmt:formatNumber value="${param.price}" type="number"/>đ
      </div>
    </c:if>

    <c:if test="${param.payType == 'DEPOSIT'}">
      <div class="info-note">
          Bạn đã chọn <strong>đặt cọc</strong>. Vui lòng thanh toán đầy đủ trước khi sử dụng dịch vụ.
        Liên hệ tổng đài <strong>1900-1026</strong> nếu cần hỗ trợ thêm.
      </div>
    </c:if>

    <div class="confirm-actions">
      <button class="btn-back">
        <a href="${pageContext.request.contextPath}/index.jsp"
           style="text-decoration:none; color:#333;">← Quay về trang chủ</a>
      </button>
      <button class="btn-next">
        <a href="${pageContext.request.contextPath}/booking"
           style="text-decoration:none; color:white;">Tiếp tục đặt xe →</a>
      </button>
    </div>

  </div>
</main>

</body>
</html>
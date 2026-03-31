<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QR Thanh Toán - Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/payment_pr.css">
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

<main class="qr-page">
    <div class="qr-container">
        <h2>Thanh toán qua mã QR</h2>
        <p class="qr-desc">Vui lòng dùng ứng dụng ngân hàng hoặc MoMo để quét mã dưới đây.</p>

        <div class="qr-box">
            <img src="https://upload.wikimedia.org/wikipedia/commons/d/d0/QR_code_for_mobile_English_Wikipedia.svg" alt="Mã QR Thanh Toán">
        </div>

        <div class="qr-amount">
            <span>Số tiền cần chuyển:</span>
            <strong>1.000.000đ</strong>
        </div>

        <div class="qr-actions" style="margin-top: 20px; display: flex; gap: 15px; justify-content: center;">
            <button class="btn-back" style="padding: 10px 20px; cursor: pointer;">
                <a href="payment.jsp?error=qr_failed" style="text-decoration: none; color: #333;">Hủy giao dịch</a>
            </button>
            <button class="btn-next" style="padding: 10px 20px; background: #007bff; border: none; cursor: pointer;">
                <a href="/PaymentConfirmationController" style="text-decoration: none; color: white;">Tôi đã thanh toán</a>
            </button>
        </div>
    </div>
</main>

<script src="../../assets/js/payment_qr.js"></script>
</body>
</html>
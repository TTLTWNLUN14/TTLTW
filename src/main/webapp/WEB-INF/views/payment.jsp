<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán - Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/payment.css">
</head>

<body>
<nav class="global-nav">
    <div class="nav-inner">
        <a class="nav-logo" href="${pageContext.request.contextPath}/assets/html/index.html">AUTO CARS</a>
        <div class="nav-links">
            <a class="nav-link" href="${pageContext.request.contextPath}/assets/html/index.html">Trang chủ</a>
            <a class="nav-link" href="list-product">Xe</a>
            <a class="nav-link" href="cars-brand">Hãng xe</a>
            <a class="nav-link active" href="booking">Đặt xe</a>
            <a class="nav-link" href="my-shopping-cart">Giỏ hàng</a>
        </div>
        <div class="nav-actions" id="navActions">
            <a href="#" class="btn-login">Đăng nhập</a>
            <a href="#" class="btn-login" style="margin-left: 20px">Đăng ký</a>
        </div>
    </div>
</nav>

<main class="payment-page">
    <div class="payment-layout">
        <div class="checkout-container">
            <h2>Chọn phương thức thanh toán</h2>

            <form action="${pageContext.request.contextPath}/payments" method="POST">

                <input type="hidden" name="bookingId" value="${param.bookingId}">
                <input type="hidden" name="price" value="${param.price}">
                <input type="hidden" name="km" value="${param.km}">
                <input type="hidden" name="payType" value="100%">

                <div class="payment-methods">
                    <label class="payment-option">
                        <input type="radio" name="method" value="TRANSFER" required>
                        <span class="payment-name">Chuyển khoản MoMo</span>
                    </label>
                    <label class="payment-option">
                        <input type="radio" name="method" value="CASH" required checked>
                        <span class="payment-name">Tiền mặt</span>
                    </label>
                </div>

                <div class="action-buttons" style="margin-top: 20px;">
                    <button type="button" class="btn-back" onclick="history.back()">← Quay lại</button>
                    <button type="submit" class="btn-next">Xác nhận thanh toán →</button>
                </div>
            </form>
        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/assets/js/payment.js"></script>
</body>
</html>
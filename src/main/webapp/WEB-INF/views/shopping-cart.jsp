<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shopping-cart.css">
</head>
<body>
<nav class="global-nav">
    <div class="nav-inner">
        <a class="nav-logo" href="${pageContext.request.contextPath}/assets/html/index.html">AUTO CARS</a>
        <div class="nav-links">
            <a class="nav-link" href="${pageContext.request.contextPath}/assets/html/index.html">Trang chủ</a>
            <a class="nav-link" href="list-product">Xe</a>
            <a class="nav-link" href="cars-brand">Hãng xe</a>
            <a class="nav-link" href="booking">Đặt xe</a>
            <a class="nav-link active" href="shopping-cart">Giỏ hàng</a>
        </div>
        <div class="nav-actions" id="navActions">
            <a href="login" class="btn-login">Đăng nhập</a>
            <a href="login" class="btn-login" style="margin-left: 20px">Đăng ký</a>
        </div>
    </div>
</nav>
<div class="container">
    <div class="left-panel">
        <div class="tabs">
            <div class="tab active">Lịch sử đơn</div>
            <div class="tab">Chờ thanh toán</div>
            <div class="tab">Đang xử lý</div>
        </div>

        <div class="order-list">
            <c:forEach items="${sessionScope.cart.items}" var="ci">
                <div class="order-card">
                    <div class="order-card">
                        <input type="checkbox" class="order-checkbox" checked>
                        <div class="order-info">
                            <h4><a href="product?id=1" style="text-decoration: none; color: inherit;">${ci.product.name} </a></h4>

                            <p><span class="highlight-text">Giá 1 đơn:</span> ${ci.price}</p>

                            <div style="display: flex; align-items: center; margin-top: 5px;">
                                <span class="highlight-text" style="margin-right: 10px;">Số lượng: ${ci.quantity}</span>
                                <div>${ci.total}</div>

                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <div class="right-panel">
        <h3>Thanh toán</h3>

        <hr>

        <div class="total-price">
            <span>Tổng tiền:</span>
            <span>${sessionScope.cart.total}  VND</span>
        </div>

        <a class="btn-payment" href="../../assets/html/info-booking.html">
            Thanh toán
        </a>
    </div>
</div>

</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Giỏ hàng - Auto Cars</title>
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
            <a class="nav-link active" href="my-shopping-cart">Giỏ hàng</a>
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
                <div class="order-card"
                     data-product-id="${ci.product.id}"
                     data-price="${ci.price}"
                     data-quantity="${ci.quantity}">
                    <input type="checkbox"
                           class="order-checkbox cart-select"
                           checked
                           onchange="recalcTotal()">
                    <div class="order-info">
                        <h4>
                            <a href="product?id=${ci.product.id}"
                               style="text-decoration:none; color:inherit;">
                                    ${ci.product.name}
                            </a>
                        </h4>

                        <p><span class="highlight-text">Giá 1 đơn:</span> ${ci.price} VND/KM</p>

                        <div style="display:flex; align-items:center; gap:8px; margin-top:5px;">
                            <span class="highlight-text">Số lượng:</span>

                            <form action="update-cart" method="post" style="margin:0">
                                <input type="hidden" name="productId" value="${ci.product.id}">
                                <input type="hidden" name="quantity"
                                       value="${ci.quantity > 1 ? ci.quantity - 1 : 1}">
                                <button type="submit" class="qty-btn"
                                    ${ci.quantity <= 1 ? 'disabled' : ''}>−</button>
                            </form>

                            <span class="qty-display">${ci.quantity}</span>

                            <form action="update-cart" method="post" style="margin:0">
                                <input type="hidden" name="productId" value="${ci.product.id}">
                                <input type="hidden" name="quantity" value="${ci.quantity + 1}">
                                <button type="submit" class="qty-btn">+</button>
                            </form>
                        </div>

                        <p>Thành tiền: <strong>${ci.total} VND</strong></p>

                        <div class="card-actions">
                            <form action="del-item" method="post" style="margin:0">
                                <input type="hidden" name="productId" value="${ci.product.id}">
                                <button type="submit" class="btn-delete">Xóa</button>
                            </form>

                            <button class="btn-pay-item"
                                    onclick="payItem(${ci.product.id})">
                                Thanh toán
                            </button>

                            <button class="btn-detail"
                                    onclick="toggleDetail(this, ${ci.product.id})">
                                Xem chi tiết ▾
                            </button>
                        </div>

                        <div class="detail-panel"  id="detail-${ci.product.id}">
                            <div class="detail-grid">

                                <div class="detail-section-title">Thông tin xe</div>

                                <div class="detail-field">
                                    <label>Hãng xe</label>
                                    <input type="text" value="FORD" readonly>
                                </div>
                                <div class="detail-field">
                                    <label>Tên xe</label>
                                    <input type="text" value="${ci.product.name}" readonly>
                                </div>
                                <div class="detail-field">
                                    <label>Loại xe</label>
                                    <input type="text" placeholder="VD: Pickup, Sedan...">
                                </div>
                                <div class="detail-field">
                                    <label>Số chỗ ngồi</label>
                                    <input type="text" placeholder="VD: 5 chỗ">
                                </div>

                                <div class="detail-section-title">Lộ trình</div>

                                <div class="detail-field">
                                    <label>Điểm đón</label>
                                    <input type="text" placeholder="Nhập địa chỉ đón...">
                                </div>
                                <div class="detail-field">
                                    <label>Điểm tới</label>
                                    <input type="text" placeholder="Nhập địa chỉ đến...">
                                </div>
                                <div class="detail-field">
                                    <label>Thời gian đi</label>
                                    <input type="datetime-local">
                                </div>
                                <div class="detail-field">
                                    <label>Thời gian về</label>
                                    <input type="datetime-local">
                                </div>

                                <div class="detail-section-title">Liên hệ khách hàng</div>

                                <div class="detail-field">
                                    <label>Email</label>
                                    <input type="email" placeholder="example@email.com">
                                </div>
                                <div class="detail-field">
                                    <label>Số điện thoại</label>
                                    <input type="tel" placeholder="0901 234 567">
                                </div>
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
            <span>Tổng tiền đã chọn:</span>
            <span id="total-display">${sessionScope.cart.total} VND</span>
        </div>
        <a class="btn-payment" href="../../assets/html/info-booking.html">
            Thanh toán
        </a>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/shopping-cart.js"></script>
</body>
</html>
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

<main class="payment-page">
    <div class="payment-layout">
        <div class="checkout-container">
            <div class="checkout-header">
                <h2>Thanh toán</h2>
            </div>

            <div class="checkout-section info-section">
                <h3 class="section-title"><span class="red-dot"></span> THÔNG TIN CHUYẾN ĐI</h3>
                <div class="info-grid">
                    <div class="info-row">
                        <span>Mã đặt xe:</span>
                        <strong>#${not empty param.bookingId ? param.bookingId : bookingId}</strong>
                    </div>
                    <div class="info-row">
                        <span>Số km:</span>
                        <strong>${not empty param.km ? param.km : km} km</strong>
                    </div>
                    <div class="info-row">
                        <span>Số tiền:</span>
                        <strong>${not empty param.price ? param.price : price} VND</strong>
                    </div>
                </div>
            </div>

            <div class="checkout-section discount-section">
                <h3 class="section-title"><span class="red-dot"></span> MÃ GIẢM GIÁ</h3>
                <p class="discount-subtitle">Mã ưu đãi của bạn:</p>

                <div class="coupon-list">
                    <c:forEach var="voucher" items="${vouchers}">
                        <div class="coupon-item">
                            <div class="coupon-info">
                                <strong>${voucher.code}</strong>
                                <span>${voucher.nameVoucher}</span>
                            </div>
                            <div class="coupon-percent">-${voucher.discount * 100}<sup>%</sup></div>
                        </div>
                    </c:forEach>
                </div>

                <div class="discount-input-row">
                    <input type="text" id="discount-code" placeholder="Chọn mã giảm giá..." readonly>
                    <button class="btn-apply">Áp dụng</button>
                </div>
                <div style="text-align: center; margin-top: 20px;">
                    <a href="${pageContext.request.contextPath}/voucher"
                       class="btn-more-voucher">
                        Xem thêm các mã giảm giá khác &raquo;
                    </a>
                </div>
            </div>

            <div class="checkout-section payment-methods-section">
                <h3 class="section-title"><span class="red-dot"></span> PHƯƠNG THỨC THANH TOÁN</h3>

                <div class="payment-grid">
                    <label class="payment-card active">
                        <input type="radio" name="payment_method" value="online" checked>
                        <span class="payment-name">Thanh toán ngay (Online / Mã QR)</span>
                    </label>

                    <label class="payment-card">
                        <input type="radio" name="payment_method" value="deposit">
                        <span class="payment-name">Đặt cọc (Thanh toán sau)</span>
                    </label>
                </div>

                <div class="terms-group">
                    <input type="checkbox" id="agree-terms">
                    <label for="agree-terms">Tôi đồng ý với <a href="#">điều khoản dịch vụ</a>
                        và <a href="#">chính sách thuê xe</a>
                    </label>
                </div>

                <div class="total-summary">
                    <div class="summary-line">
                        <span>Tạm tính:</span>
                        <span>${price} VND</span>
                    </div>
                    <div class="summary-line">
                        <span>Giảm giá:</span>
                        <span>${voucherDiscount != null ? voucherDiscount : 0} VND</span>
                    </div>
                    <div class="summary-line final-total">
                        <span>Tổng thanh toán:</span>
                        <strong>${price - (voucherDiscount != null ? voucherDiscount : 0)} VND</strong>
                    </div>
                </div>

                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/booking" class="btn-back">← Quay lại</a>
                    <a href="${pageContext.request.contextPath}/payment-qr" class="btn-next">Đặt xe ngay →</a>
                </div>
            </div>
        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/assets/js/payment.js"></script>
</body>
</html>
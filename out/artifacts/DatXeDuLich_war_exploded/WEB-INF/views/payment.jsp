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
                        <span>Khách hàng:</span>
                        <strong>Nguyễn Văn A - 0901234567</strong>
                    </div>
                    <div class="info-row">
                        <span>Số chuyến đi:</span>
                        <strong>1 chiều</strong>
                    </div>
                    <div class="info-row">
                        <span>Ngày đi:</span>
                        <strong>15/05/2026 - 8:00</strong>
                    </div>
                    <div class="info-row">
                        <span>Ngày đến:</span>
                        <strong>15/05/2026</strong>
                    </div>
                </div>
            </div>

            <div class="checkout-section discount-section">
                <h3 class="section-title"><span class="red-dot"></span> MÃ GIẢM GIÁ</h3>
                <p class="discount-subtitle">Mã ưu đãi của bạn:</p>

                <div class="coupon-list">
                    <div class="coupon-item">
                        <div class="coupon-info">
                            <strong>WELCOME10</strong>
                            <span>Chào mừng thành viên mới - Giảm 10%</span>
                        </div>
                        <div class="coupon-percent">-10<sup>%</sup></div>
                    </div>
                </div>

                <div class="discount-input-row">
                    <input type="text" id="discount-code" placeholder="Chọn mã giảm giá..." readonly>
                    <button class="btn-apply">Áp dụng</button>
                </div>
            </div>

            <div class="checkout-section payment-methods-section">
                <h3 class="section-title"><span class="red-dot"></span> PHƯƠNG THỨC THANH TOÁN</h3>

                <div class="payment-grid">
                    <label class="payment-card active" data-target="payment_qr.jsp">
                        <input type="radio" name="payment_method" value="online" checked>
                        <span class="payment-name">Thanh toán ngay (Online / Mã QR)</span>
                    </label>

                    <label class="payment-card" data-target="payment_confirmation.jsp">
                        <input type="radio" name="payment_method" value="deposit">
                        <span class="payment-name">Đặt cọc (Thanh toán sau)</span>
                    </label>
                </div>

                <div class="terms-group">
                    <input type="checkbox" id="agree-terms">
                    <label for="agree-terms">Tôi đồng ý với <a href="#">điều khoản dịch vụ</a> và <a href="#">chính sách thuê xe</a></label>
                </div>

                <div class="total-summary">
                    <div class="summary-line">
                        <span>Tạm tính (1 chuyến):</span>
                        <span>1.000.000đ</span>
                    </div>
                    <div class="summary-line">
                        <span>Giảm giá:</span>
                        <span id="discount-amount">0đ</span>
                    </div>
                    <div class="summary-line final-total">
                        <span>Tổng thanh toán:</span>
                        <strong id="final-price">1.000.000đ</strong>
                    </div>
                </div>

                <div class="action-buttons">
                    <a href="javascript:history.back()" class="btn-back" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center; box-sizing: border-box;">← Quay lại</a>
                    <a href="/PaymentQRController" id="link-submit-payment" class="btn-next" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center; box-sizing: border-box;">Đặt xe ngay →</a>
                </div>
            </div>
        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/assets/js/payment.js"></script>
</body>
</html>
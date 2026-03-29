<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Chi tiết xe - Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/list-cars.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/car-detail.css">
</head>
<body>
<nav class="global-nav">
    <div class="nav-inner">
        <a class="nav-logo" href="../../assets/html/index.html">AUTO CARS</a>
        <div class="nav-links">
            <a class="nav-link" href="../../assets/html/index.html">Trang chủ</a>
            <a class="nav-link active" href="${pageContext.request.contextPath}/list-product">Xe</a>
            <a class="nav-link" href="cars-brand.jsp">Hãng xe</a>
            <a class="nav-link" href="booking.jsp">Đặt xe</a>
            <a class="nav-link" href="shopping-cart.jsp">Giỏ hàng</a>
        </div>
        <div class="nav-actions" id="navActions">
            <a href="#" class="btn-login">Đăng nhập</a>
            <a href="#" class="btn-login" style="margin-left: 20px">Đăng ký</a>
        </div>
    </div>
</nav>

<div class="page-main">
    <div class="page-wrap-lg">

        <ul class="breadcrumb">
            <li><a href="../../assets/html/index.html">Trang chủ</a></li>
            <li><a href="${pageContext.request.contextPath}/list-product">Xe</a></li>
            <li>Ford Ranger</li>
        </ul>

        <div class="cd-layout">
            <div class="cd-left">
                <div class="cd-gallery">
                    <div class="cd-main-img">
                        <span class="badge-stock">3 xe có sẵn</span>
                        <img height="400px" src="${product.image}" alt="">
                    </div>
                    <div class="cd-thumb-list">
                        <div class="cd-thumb active"></div>
                        <div class="cd-thumb"></div>
                        <div class="cd-thumb"></div>
                        <div class="cd-thumb"></div>
                    </div>
                </div>

                <div class="cd-details">
                    <h2 class="cd-section-title">Đặc điểm nổi bật</h2>
                    <div class="cd-specs-grid">
                        <div class="spec-item">
                            <span class="spec-label">Số chỗ ngồi</span>
                            <span class="spec-value">5 chỗ</span>
                        </div>
                        <div class="spec-item">
                            <span class="spec-label">Nhiên liệu</span>
                            <span class="spec-value">Diesel</span>
                        </div>
                        <div class="spec-item">
                            <span class="spec-label">Kiểu dáng</span>
                            <span class="spec-value">Pickup</span>
                        </div>
                        <div class="spec-item">
                            <span class="spec-label">Truyền động</span>
                            <span class="spec-value">Số tự động</span>
                        </div>
                    </div>

                    <h2 class="cd-section-title">Mô tả xe</h2>
                    <p class="cd-desc-text">
                        Ford Ranger mang đến sự kết hợp hoàn hảo giữa sức mạnh vận hành và tiện nghi hiện đại.
                        Không gian nội thất rộng rãi, được trang bị màn hình giải trí thông minh, hệ thống an toàn
                        chủ động cao cấp. Phù hợp cho cả những chuyến đi trong đô thị lẫn địa hình hiểm trở.
                    </p>

                    <h2 class="cd-section-title">Tiện nghi có sẵn</h2>
                    <div class="cd-features">
                        <span class="feature-tag">Điều hòa tự động</span>
                        <span class="feature-tag">Bluetooth/USB</span>
                        <span class="feature-tag">Camera lùi</span>
                        <span class="feature-tag">Cảnh báo điểm mù</span>
                        <span class="feature-tag">Cửa sổ trời</span>
                    </div>
                </div>
            </div>

            <div class="cd-right">
                <div class="cd-booking-card">
                    <div class="car-brand">FORD</div>
                    <h1 class="cd-car-name">${product.name}</h1>

                    <div class="cd-price-wrap">
                        <div class="cd-price-item">
                            <span class="cd-price-val">${product.priceDay}</span>
                            <span class="cd-price-unit">đ/ngày</span>
                        </div>
                        <div class="cd-price-item">
                            <span class="cd-price-val">${product.priceKm}</span>
                            <span class="cd-price-unit">đ/km</span>
                        </div>
                    </div>

                    <div class="cd-form">
                        <div class="form-group">
                            <label>Hình thức thuê</label>
                            <div style="display: flex; gap: 20px; margin-top: 8px;">
                                <label style="cursor: pointer;">
                                    <input type="radio" name="rentalType" value="self_drive" checked> Tự lái (Chỉ thuê xe)
                                </label>
                                <label style="cursor: pointer;">
                                    <input type="radio" name="rentalType" value="with_driver"> Có tài xế
                                </label>
                            </div>
                        </div>

                        <div class="form-group" style="margin-top: 15px;">
                            <label>Số lượng xe</label>
                            <div style="display: flex; align-items: center; gap: 10px; margin-top: 8px;">
                                <button type="button" onclick="this.nextElementSibling.stepDown()" style="width: 35px; height: 35px; border: 1px solid #ccc; background: #fff; cursor: pointer;">-</button>
                                <input type="number" name="quantity" min="1" value="1" style="width: 60px; height: 35px; text-align: center; border: 1px solid #ccc; border-radius: 4px;">
                                <button type="button" onclick="this.previousElementSibling.stepUp()" style="width: 35px; height: 35px; border: 1px solid #ccc; background: #fff; cursor: pointer;">+</button>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Ngày nhận xe</label>
                                <input type="date" class="form-control">
                            </div>
                            <div class="form-group">
                                <label>Ngày trả xe</label>
                                <input type="date" class="form-control">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Địa điểm giao nhận</label>
                            <input type="text" class="form-control" placeholder="Nhập địa chỉ...">
                        </div>
                    </div>

                    <div class="cd-total">
                        <span>Tạm tính (1 ngày):</span>
                        <span class="total-price">1.600.000đ</span>
                    </div>

                    <button class="btn-primary w-100"><a href="booking.jsp">Đặt xe ngay</a></button>
                    <button class="btn-outline w-100 mt-10">Liên hệ tư vấn</button>
                </div>
            </div>
        </div>

    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/car-detail.js"></script>

</body>
</html>
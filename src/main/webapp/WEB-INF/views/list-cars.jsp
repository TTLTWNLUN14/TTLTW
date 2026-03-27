<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/list-cars.css">
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

<div class="page-main">
    <div class="page-wrap-lg">

        <div class="cars-hero">
            <h1>Chọn xe phù hợp với bạn</h1>
            <p>Hơn 100+ mẫu xe cao cấp từ các thương hiệu uy tín – Giao/nhận tận nơi</p>
        </div>

        <div class="brands-filter-bar" id="brandFilterBar">
            <button class="brand-pill active">Tất cả</button>
            <button class="brand-pill">Toyota</button>
            <button class="brand-pill">Honda</button>
        </div>

        <div class="cars-layout">

            <div class="cars-sidebar">
                <div class="filter-section">
                    <div class="filter-title">Loại xe</div>
                    <div class="filter-chips">
                        <span class="chip active">Tất cả</span>
                        <span class="chip">Sedan</span>
                        <span class="chip">SUV</span>
                        <span class="chip">MPV</span>
                        <span class="chip">Pickup</span>
                    </div>
                </div>
                <div class="filter-section">
                    <div class="filter-title">Số chỗ ngồi</div>
                    <div class="filter-chips">
                        <span class="chip active">Tất cả</span>
                        <span class="chip">4 chỗ</span>
                        <span class="chip">5 chỗ</span>
                        <span class="chip">7 chỗ</span>
                        <span class="chip">8+ chỗ</span>
                    </div>
                </div>
                <div class="filter-section">
                    <div class="filter-title">Nhiên liệu</div>
                    <div class="filter-chips">
                        <span class="chip active">Tất cả</span>
                        <span class="chip">Xăng</span>
                        <span class="chip">Điện</span>
                        <span class="chip">Hybrid</span>
                        <span class="chip">Diesel</span>
                    </div>
                </div>
                <div class="filter-section">
                    <div class="filter-title">Hình thức thuê</div>
                    <div class="filter-chips">
                        <span class="chip active">Tất cả</span>
                        <span class="chip">Có tài xế</span>
                        <span class="chip">Tự lái</span>
                    </div>
                </div>
                <div class="filter-section">
                    <div class="filter-title">Giá/km tối đa</div>
                    <div class="price-range">
                        <input class="price-slider" type="range" id="maxPrice" min="3000" max="15000" step="500" value="15000">
                        <div class="price-labels"><span>3.000đ</span><span id="priceLabel">15.000đ</span></div>
                    </div>
                </div>
                <button class="btn-ghost" id="resetFiltersBtn" style="margin-top:4px">↺ Xóa bộ lọc</button>
            </div>

            <div class="cars-main">
                <div class="cars-header">
                    <span class="car-count">14 loại xe</span>
                </div>

                <div  class="cars-grid" id="carGrid" >
                    <c:forEach var="p" items="${list}">
                        <div class="car-card">
                            <div class="car-img-box">
                                <img style="width: 197px" src="${p.image}" alt="img-cars">
                                <span class="badge-stock">3 xe có sẵn</span>
                            </div>
                            <div class="car-body">
                                <div class="car-brand">FORD</div>
                                <h3 class="car-title"><a href="list-product/product?id=${p.id}">${p.name}</a></h3>
                                <div class="car-tags">
                                    <span class="car-tag">5 chỗ</span>
                                    <span class="car-tag">Diesel</span>
                                    <span class="car-tag">Pickup</span>
                                </div>

                                <div class="car-prices">
                                    <div class="price-col">
                                        <div class="main-price">${p.priceKm}</div>
                                        <div>VNĐ/KM</div>
                                    </div>
                                    <div class="price-col right-align">
                                        <div class="main-price">${p.priceDay}</div>
                                        <div>VNĐ/Ngày</div>
                                    </div>
                                </div>

                                <div class="car-action" style="margin-top: 15px; text-align: center;">
                                    <a href="add-cart?productId=${p.id}&quantity=1&isDriver=true"
                                       style="display: block; padding: 10px; background-color: #007bff; color: white; text-decoration: none; border-radius: 5px; font-weight: bold;">
                                        Thêm vào giỏ hàng
                                    </a>
                                </div>
                            </div>
                        </div>

                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>

 <script src="${pageContext.request.contextPath}/assets/js/list-cars.js"></script>

</body>
</html>

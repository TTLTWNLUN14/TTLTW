<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Giỏ hàng - Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cars-brand.css">
</head>
<body>
    <nav class="global-nav">
        <div class="nav-inner">
            <a class="nav-logo" href="../../assets/html/index.html">AUTO CARS</a>
        <div class="nav-links">
            <a class="nav-link" href="../../assets/html/index.html">Trang chủ</a>
            <a class="nav-link" href="list-product">Xe</a>
            <a class="nav-link active" href="brand">Hãng xe</a>
            <a class="nav-link" href="booking.jsp">Đặt xe</a>
            <a class="nav-link" href="my-shopping-cart">Giỏ hàng</a>
        </div>
        <div class="nav-actions" id="navActions">
            <a href="#" class="btn-login">Đăng nhập</a>
            <a href="#" class="btn-login" style="margin-left: 20px">Đăng ký</a>
        </div>
        </div>
    </nav>

    <div class="brands-hero">
        <h1>Các hãng xe đối tác</h1>
        <p>Khám phá đội xe từ các thương hiệu uy tín hàng đầu thế giới</p>
        <div class="brand-filter-tabs" id="filterTabs">
            <button class="bft-btn active" >Tất cả</button>
            <button class="bft-btn" >Nhật Bản</button>
            <button class="bft-btn" >Hàn Quốc</button>
            <button class="bft-btn" >Việt Nam</button>
            <button class="bft-btn" >Đức</button>
            <button class="bft-btn" >Mỹ</button>
        </div>
    </div>
    <div class="brands-wrapper">
        <div class="brands-header">
            <span class="brand-count">9 hãng xe</span>
        </div>

        <div class="brands-grid">
            <c:forEach var="b" items="${listBrand}">
                <div class="brand-card">
                    <a href="list-product?brandId=${b.brandId}" style="text-decoration: none; color: inherit;">
                    <div class="card-top">
                        <h3 class="brand-name">${b.brandName}</h3>
                        <span class="brand-country">${b.country}</span>
                    </div>
                    <div class="card-middle">
                        <p class="brand-desc">${b.descriptionBrand}</p>
                    </div>
                    <div class="card-stats">
                        <div class="stat-item">
                            <span class="stat-value">4</span>
                            <span class="stat-label">Loại xe</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-value">3.800đ</span>
                            <span class="stat-label">Từ/km</span>
                        </div>
                    </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>
    <div class="modal-overlay" id="brandModal">
        <div class="modal-content">

            <div class="modal-header">
                <h2 class="modal-title">Honda</h2>
                <button class="close-icon" id="closeIcon">&times;</button>
            </div>

            <div class="modal-body">

                <div class="brand-info-box">
                    <h3 class="info-title">Honda</h3>
                    <p class="info-meta">
                        <span style="color: #ef4444;">📍</span> Nhật Bản • 2 loại xe • 6 xe có sẵn
                    </p>
                    <p class="info-desc">Công nghệ tiên tiến, tiết kiệm nhiên liệu</p>
                </div>

                <div class="car-types-section">
                    <h4 class="section-title">CÁC LOẠI XE</h4>

                    <div class="car-types-grid">
                        <a href="list-cars.html" class="car-type-card">
                            <div class="car-image-placeholder">Honda CR-V</div>
                            <div class="car-details">
                                <h5 class="car-name">Honda CR-V</h5>
                                <p class="car-price">4.800đ/km • 1.600.000đ/ngày</p>
                                <div class="car-badges">
                                    <span class="badge badge-green">3 xe</span>
                                    <span class="badge badge-gray">5 chỗ</span>
                                    <span class="badge badge-gray">Xăng</span>
                                </div>
                            </div>
                        </a>

                        <a href="list-cars.html" class="car-type-card">
                            <div class="car-image-placeholder">Honda BR-V</div>
                            <div class="car-details">
                                <h5 class="car-name">Honda BR-V</h5>
                                <p class="car-price">3.900đ/km • 1.400.000đ/ngày</p>
                                <div class="car-badges">
                                    <span class="badge badge-green">3 xe</span>
                                    <span class="badge badge-gray">7 chỗ</span>
                                    <span class="badge badge-gray">Xăng</span>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>

            </div>

            <div class="modal-footer">
                <button class="btn btn-outline" id="closeBtn">Đóng</button>
                <button class="btn btn-primary"><a href="list-cars.html">Xem tất cả xe &rarr;</a>
                </button>
            </div>

        </div>
    </div>

</body>
<script src="../../assets/js/cars-brand.js"></script>
</html>
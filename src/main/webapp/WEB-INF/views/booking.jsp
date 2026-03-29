<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/booking.css">
</head>
<body>
<nav class="global-nav">
    <div class="nav-inner">
        <a class="nav-logo" href="../../assets/html/index.html">AUTO CARS</a>
        <div class="nav-links">
            <a class="nav-link" href="../../assets/html/index.html">Trang chủ</a>
            <a class="nav-link" href="list-product">Xe</a>
            <a class="nav-link" href="brand">Hãng xe</a>
            <a class="nav-link active" href="booking">Đặt xe</a>
            <a class="nav-link" href="my-shopping-cart">Giỏ hàng</a>
        </div>
        <div class="nav-actions" id="navActions">
            <a href="#" class="btn-login">Đăng nhập</a>
            <a href="#" class="btn-login" style="margin-left: 20px">Đăng ký</a>
        </div>
    </div>
</nav>
<div class="booking-page">
    <div class="booking-container">
        <div class="booking-main">
            <div id="step-1" class="booking-step active">
                <div class="b-header">
                    <h1>Đặt xe</h1>
                </div>
                <div class="b-body">
                    <h3>Chọn hãng xe</h3>
                    <div class="list-brand">
                        <c:forEach var="item" items="${listBrand}">

                            <a href="duong-dan?id=${item.id}" class="nut-bam ${item.id == idDangChon ? 'active' : ''}">
                                    ${item.ten}
                            </a>

                        </c:forEach>
                    </div>
                    <div class="rental-types">
                        <div class="rt-card active">
                            <div class="rt-title">Thuê xe có tài xế</div>
                            <div class="rt-desc">Tài xế đưa đón tận nơi</div>
                        </div>
                        <div class="rt-card">
                            <div class="rt-title">Tự lái</div>
                            <div class="rt-desc">Xe giao đến địa chỉ bạn</div>
                        </div>
                    </div>

                    <div class="mini-filters">
                        <input type="text" class="form-control" placeholder="Tất cả hãng">
                        <input type="text" class="form-control" placeholder="Tất cả loại">
                        <input type="text" class="form-control" placeholder="Số chỗ">
                    </div>

                    <div class="compact-cars-grid">
                        <div class="cc-card">
                            <div class="cc-img">VinFast VF 8</div>
                            <div class="cc-brand">VINFAST</div>
                            <h4 class="cc-name">VinFast VF 8</h4>
                            <div class="cc-tags">
                                <span class="cc-tag">5 chỗ</span>
                                <span class="cc-tag">Điện</span>
                                <span class="cc-tag">SUV</span>
                                <span class="cc-tag text-green">4 xe</span>
                            </div>
                            <div class="cc-price">1.500.000đ<span>/ngày</span></div>
                        </div>

                        <div class="cc-card active">
                            <div class="cc-img">Toyota Fortuner</div>
                            <div class="cc-brand">TOYOTA</div>
                            <h4 class="cc-name">Toyota Fortuner</h4>
                            <div class="cc-tags">
                                <span class="cc-tag">7 chỗ</span>
                                <span class="cc-tag">Diesel</span>
                                <span class="cc-tag">SUV</span>
                                <span class="cc-tag text-green">2 xe</span>
                            </div>
                            <div class="cc-price">2.500.000đ<span>/ngày</span></div>
                        </div>

                        <div class="cc-card">
                            <div class="cc-img">Toyota Camry</div>
                            <div class="cc-brand">TOYOTA</div>
                            <h4 class="cc-name">Toyota Camry</h4>
                            <div class="cc-tags">
                                <span class="cc-tag">5 chỗ</span>
                                <span class="cc-tag">Hybrid</span>
                                <span class="cc-tag">Sedan</span>
                                <span class="cc-tag text-green">2 xe</span>
                            </div>
                            <div class="cc-price">2.200.000đ<span>/ngày</span></div>
                        </div>
                    </div>
                </div>
                <div class="b-footer">
                    <button class="btn-next"><a href="../../assets/html/info-booking.html">Tiếp theo →</a> </button>
                </div>
            </div>
        </div>

    </div>
</div>
<script src="../../assets/js/booking.js"></script>
</body>
</html>
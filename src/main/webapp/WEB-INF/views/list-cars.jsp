<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Danh sách xe - Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/list-cars.css">
</head>
<body>

<nav class="global-nav">
    <div class="nav-inner">
        <a class="nav-logo" href="${pageContext.request.contextPath}/index.jsp">AUTO CARS</a>
        <div class="nav-links">
            <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a>
            <a class="nav-link active" href="${pageContext.request.contextPath}/list-product">Xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/cars-brand">Hãng xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/booking">Đặt xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/my-shopping-cart">
                Giỏ hàng (<c:out value="${sessionScope.cart.totalQuantity != null ? sessionScope.cart.totalQuantity : 0}"/>)
            </a>
        </div>
        <div class="nav-actions" id="navActions">
            <a href="#" class="btn-login">Đăng nhập</a>
            <a href="#" class="btn-login" style="margin-left: 20px">Đăng ký</a>
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
            <button class="brand-pill active" onclick="filterBrand(0, this)">Tất cả</button>
            <c:forEach items="${brands}" var="b">
                <button class="brand-pill" onclick="filterBrand(${b.brandId}, this)">${b.brandName}</button>
            </c:forEach>
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
                    <span class="car-count"> loại xe</span>
                </div>

                <div class="cars-grid" id="carGrid">
                    <c:forEach var="p" items="${list}">
                        <div class="car-card">
                            <div class="car-img-box">
                                <img style="width: 197px" src="${p.img}" alt="img-cars">
                                <span class="badge-stock">${p.count} xe có sẵn</span>
                            </div>
                            <div class="car-body">
                                <div class="car-brand">
                                    <c:forEach items="${brands}" var="b">
                                        <c:if test="${b.brandId == p.brandId}">${b.brandName}</c:if>
                                    </c:forEach>
                                </div>
                                <h3 class="car-title">
                                    <a href="${pageContext.request.contextPath}/list-product/product?typeId=${p.typeId}">${p.typeName}</a>
                                </h3>
                                <div class="car-tags">
                                    <span class="car-tag">${p.seatingPlan} chỗ</span>
                                    <span class="car-tag">${p.fuel}</span>
                                    <span class="car-tag">${p.category}</span>
                                </div>

                                <div class="car-prices">
                                    <div class="price-col">
                                        <div class="main-price">${p.priceKm}</div>
                                        <div>VNĐ/KM</div>
                                    </div>
                                    <div class="price-col right-align">
                                        <div class="main-price">${p.priceDay}</div>
                                        <div>VNĐ/Ngày</div>
                                    </div>
                                </div>

                                <div class="car-action" style="margin-top: 15px; text-align: center;">
                                    <a href="${pageContext.request.contextPath}/add-cart?productId=${p.typeId}&quantity=1&isDriver=true"
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

<script>
function filterBrand(brandId, btn) {
    document.querySelectorAll('.brand-pill').forEach(function(b){ b.classList.remove('active'); });
    btn.classList.add('active');
    if (brandId === 0) {
        window.location.href = '${pageContext.request.contextPath}/list-product';
    } else {
        window.location.href = '${pageContext.request.contextPath}/list-product?brandId=' + brandId;
    }
}
</script>
<script src="${pageContext.request.contextPath}/assets/js/list-cars.js"></script>

</body>
</html>

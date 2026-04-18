<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<html>
<head>
    <title>${product.typeName} - Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/list-cars.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/car-detail.css">
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
        <div class="nav-actions">
            <a href="#" class="btn-login">Đăng nhập</a>
            <a href="#" class="btn-login" style="margin-left:20px">Đăng ký</a>
        </div>
    </div>
</nav>

<div class="page-main">
    <div class="page-wrap-lg">

        <%-- Breadcrumb --%>
        <ul class="breadcrumb">
            <li><a href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a></li>
            <li><a href="${pageContext.request.contextPath}/list-product">Xe</a></li>
            <c:if test="${not empty brand}">
                <li>
                    <a href="${pageContext.request.contextPath}/list-product?brandId=${brand.brandId}">
                            ${brand.brandName}
                    </a>
                </li>
            </c:if>
            <li>${product.typeName}</li>
        </ul>

        <div class="cd-layout">

            <div class="cd-left">

                <div class="cd-gallery">
                    <div class="cd-main-img">
                        <span class="badge-stock">${product.count} xe có sẵn</span>
                        <c:choose>
                            <c:when test="${not empty product.img}">
                                <img src="${product.img}" alt="${product.typeName}">
                            </c:when>
                            <c:otherwise>
                                <div class="img-placeholder">Chưa có ảnh</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="cd-details">
                    <h2 class="cd-section-title">Thông số kỹ thuật</h2>
                    <div class="cd-specs-grid">
                        <div class="spec-item">
                            <span class="spec-label">Hãng xe</span>
                            <span class="spec-value">
                                <c:choose>
                                    <c:when test="${not empty brand}">${brand.brandName}</c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="spec-item">
                            <span class="spec-label">Kiểu dáng</span>
                            <span class="spec-value">
                                <c:choose>
                                    <c:when test="${not empty product.category}">${product.category}</c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="spec-item">
                            <span class="spec-label">Số chỗ ngồi</span>
                            <span class="spec-value">
                                <c:choose>
                                    <c:when test="${product.seatingPlan > 0}">${product.seatingPlan} chỗ</c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="spec-item">
                            <span class="spec-label">Nhiên liệu</span>
                            <span class="spec-value">
                                <c:choose>
                                    <c:when test="${not empty product.fuel}">${product.fuel}</c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="spec-item">
                            <span class="spec-label">Số xe có sẵn</span>
                            <span class="spec-value">${product.count}</span>
                        </div>
                        <div class="spec-item">
                            <span class="spec-label">Trạng thái</span>
                            <span class="spec-value">
                                <c:choose>
                                    <c:when test="${product.isActive}">
                                        <span class="badge-active">Đang hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-inactive">Ngừng hoạt động</span>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>

                    <c:if test="${not empty product.descriptionType}">
                        <h2 class="cd-section-title">Mô tả xe</h2>
                        <p class="cd-desc-text">${product.descriptionType}</p>
                    </c:if>
                </div>

            </div>

            <div class="cd-right">
                <div class="cd-booking-card">

                    <c:if test="${not empty brand}">
                        <div class="car-brand">${brand.brandName}</div>
                    </c:if>

                    <h1 class="cd-car-name">${product.typeName}</h1>

                    <%-- Bảng giá 3 cột từ DB --%>
                    <div class="cd-price-wrap">
                        <div class="cd-price-item">
                            <span class="cd-price-unit">Tự lái/km</span>
                            <span class="cd-price-val">
                                <c:choose>
                                    <c:when test="${product.priceKm > 0}">
                                        <fmt:formatNumber value="${product.priceKm}" type="number"/>đ
                                    </c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="cd-price-divider"></div>
                        <div class="cd-price-item">
                            <span class="cd-price-unit">Theo ngày</span>
                            <span class="cd-price-val">
                                <c:choose>
                                    <c:when test="${product.priceDay > 0}">
                                        <fmt:formatNumber value="${product.priceDay}" type="number"/>đ
                                    </c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>

                    <%-- Tags --%>
                    <div class="cd-tags">
                        <c:if test="${product.seatingPlan > 0}">
                            <span class="cd-tag">${product.seatingPlan} chỗ</span>
                        </c:if>
                        <c:if test="${not empty product.fuel}">
                            <span class="cd-tag">${product.fuel}</span>
                        </c:if>
                        <c:if test="${not empty product.category}">
                            <span class="cd-tag">${product.category}</span>
                        </c:if>
                        <c:if test="${product.count > 0}">
                            <span class="cd-tag text-green">${product.count} xe có sẵn</span>
                        </c:if>
                    </div>

                    <%-- Nút: Đặt xe → /booking pre-select xe này --%>
                    <a href="${pageContext.request.contextPath}/booking?typeId=${product.typeId}&isDriver=true"
                       class="btn-primary w-100">
                        Đặt xe ngay
                    </a>
                    <a href="${pageContext.request.contextPath}/add-cart?productId=${product.typeId}&quantity=1&isDriver=true"
                       class="btn-outline w-100 mt-10">
                        Thêm vào giỏ hàng
                    </a>

                </div>
            </div>

        </div>

    </div>
</div>

</body>
</html>

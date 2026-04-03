<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<html>
<head>
    <title>Giỏ hàng - Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shopping-cart.css">
</head>
<body>
<nav class="global-nav">
    <div class="nav-inner">
        <a class="nav-logo" href="${pageContext.request.contextPath}/index.jsp">AUTO CARS</a>
        <div class="nav-links">
            <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/list-product">Xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/cars-brand">Hãng xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/booking">Đặt xe</a>
            <a class="nav-link active" href="${pageContext.request.contextPath}/my-shopping-cart">
                Giỏ hàng (<c:out value="${sessionScope.cart.totalQuantity != null ? sessionScope.cart.totalQuantity : 0}"/>)
            </a>
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
                <c:set var="itemTypeIdStr">${ci.product.typeId}</c:set>
                <c:set var="isOpen" value="${param.openDetailId == itemTypeIdStr}" />

                <div class="order-card">
                    <div class="order-info">
                        <h4>
                            <a href="${pageContext.request.contextPath}/list-product/product?typeId=${ci.product.typeId}"
                               style="text-decoration:none; color:inherit;">
                                    ${ci.product.typeName}
                            </a>
                        </h4>
                        <p>
                            <span class="highlight-text">Giá/KM:</span>
                            <strong><fmt:formatNumber value="${ci.price}" type="number"/></strong> VND/KM
                            &nbsp;|&nbsp;
                            <span class="highlight-text">Số KM:</span>
                            <strong>${ci.km}</strong> km
                        </p>

                        <div style="display:flex; align-items:center; gap:8px; margin-top:5px;">
                            <span class="highlight-text">Số lượng:</span>
                            <form action="${pageContext.request.contextPath}/update-cart" method="post" style="margin:0">
                                <input type="hidden" name="productId" value="${ci.product.typeId}">
                                <input type="hidden" name="quantity" value="${ci.quantity > 1 ? ci.quantity - 1 : 1}">
                                <button type="submit" class="qty-btn" ${ci.quantity <= 1 ? 'disabled' : ''}>−</button>
                            </form>
                            <span class="qty-display">${ci.quantity}</span>
                            <form action="${pageContext.request.contextPath}/update-cart" method="post" style="margin:0">
                                <input type="hidden" name="productId" value="${ci.product.typeId}">
                                <input type="hidden" name="quantity" value="${ci.quantity + 1}">
                                <button type="submit" class="qty-btn">+</button>
                            </form>
                        </div>

                        <p>Thành tiền:
                            <strong><fmt:formatNumber value="${ci.price * ci.km * ci.quantity}" type="number"/> VND</strong>
                        </p>

                        <div class="card-actions">
                            <form action="${pageContext.request.contextPath}/del-item" method="post" style="margin:0">
                                <input type="hidden" name="productId" value="${ci.product.typeId}">
                                <button type="submit" class="btn-delete">Xóa</button>
                            </form>
                            <a href="${pageContext.request.contextPath}/payments" class="btn-pay-item">Thanh toán</a>
                            <button type="button" class="btn-detail" onclick="toggleDetail(this, '${ci.product.typeId}')">
                                <c:choose>
                                    <c:when test="${isOpen}">Ẩn chi tiết ▴</c:when>
                                    <c:otherwise>Xem chi tiết ▾</c:otherwise>
                                </c:choose>
                            </button>

                            <div class="detail-panel <c:if test='${isOpen}'>open</c:if>" id="detail-${ci.product.typeId}">
                                <form action="${pageContext.request.contextPath}/update-cart-detail" method="post" accept-charset="UTF-8">
                                    <input type="hidden" name="productId" value="${ci.product.typeId}">
                                    <div class="detail-grid">
                                        <div class="detail-section-title">Thông tin xe</div>
                                        <div class="detail-field">
                                            <label>Hãng xe</label>
                                            <select name="brandId" onchange="this.form.submit()">
                                                <option value="">-- Chọn hãng xe --</option>
                                                <c:forEach items="${brands}" var="b">
                                                    <option value="${b.brandId}" <c:if test="${b.brandId == ci.selectedBrandId}">selected</c:if>>
                                                            ${b.brandName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="detail-field">
                                            <label>Tên xe</label>
                                            <select name="selectedTypeId" onchange="this.form.submit()">
                                                <option value="">-- Chọn tên xe --</option>
                                                <c:if test="${ci.selectedBrandId > 0}">
                                                    <c:forEach items="${carsMap[ci.selectedBrandId]}" var="ct">
                                                        <option value="${ct.typeId}" <c:if test="${ct.typeId == ci.selectedTypeId}">selected</c:if>>
                                                                ${ct.typeName}
                                                        </option>
                                                    </c:forEach>
                                                </c:if>
                                            </select>
                                        </div>
                                        <div class="detail-field">
                                            <label>Loại xe</label>
                                            <input type="text" value="${ci.selectedCategory}" readonly>
                                        </div>
                                        <div class="detail-field">
                                            <label>Số chỗ ngồi</label>
                                            <input type="text" value="${ci.selectedSeatingPlan}" readonly>
                                        </div>

                                        <div class="detail-section-title">Điểm đón &amp; Điểm tới</div>
                                        <div class="detail-field">
                                            <label>Điểm đón</label>
                                            <select name="fromProvinceId" onchange="updateProv(this,'fromProv_${ci.product.typeId}'); this.form.submit()">
                                                <option value="">-- Chọn tỉnh/thành phố --</option>
                                                <c:forEach items="${provinces}" var="prov">
                                                    <option value="${prov.provinceId}" <c:if test="${prov.provinceId == ci.fromProvinceId}">selected</c:if>>
                                                            ${prov.provinceName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <input type="hidden" name="fromProvinceName" id="fromProv_${ci.product.typeId}" value="${ci.fromProvinceName}">
                                        </div>
                                        <div class="detail-field">
                                            <label>Điểm tới</label>
                                            <select name="toProvinceId" onchange="updateProv(this,'toProv_${ci.product.typeId}'); this.form.submit()">
                                                <option value="">-- Chọn tỉnh/thành phố --</option>
                                                <c:forEach items="${provinces}" var="prov">
                                                    <option value="${prov.provinceId}" <c:if test="${prov.provinceId == ci.toProvinceId}">selected</c:if>>
                                                            ${prov.provinceName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <input type="hidden" name="toProvinceName" id="toProv_${ci.product.typeId}" value="${ci.toProvinceName}">
                                        </div>
                                        <div class="detail-field">
                                            <label>Khoảng cách (km)</label>
                                            <input type="text" value="${ci.km > 0 ? ci.km : 'Chưa tính'}" readonly>
                                        </div>
                                        <div class="detail-field">
                                            <label>Thời gian đi</label>
                                            <input type="datetime-local" name="pickupTime" value="${ci.pickupTime}">
                                        </div>
                                        <div class="detail-field">
                                            <label>Thời gian về</label>
                                            <input type="datetime-local" name="returnTime" value="${ci.returnTime}">
                                        </div>

                                        <div class="detail-section-title">Thông tin cá nhân</div>
                                        <div class="detail-field">
                                            <label>Email</label>
                                            <input type="email" name="email" value="${ci.email}" onblur="this.form.submit()">
                                        </div>
                                        <div class="detail-field">
                                            <label>Số điện thoại</label>
                                            <input type="tel" name="phone" value="${ci.phone}" onblur="this.form.submit()">
                                        </div>
                                        <div class="detail-field" style="grid-column: 1/-1; text-align: right;">
                                            <button type="submit" class="btn-save-detail">💾 Lưu thông tin</button>
                                        </div>
                                    </div>
                                </form>
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
            <strong><fmt:formatNumber value="${sessionScope.cart.total}" type="number"/> VND</strong>
        </div>
        <c:forEach items="${sessionScope.cart.items}" var="ci">
            <div style="font-size:13px; color:#555; margin-bottom:4px;">
                    ${ci.product.typeName}:
                <fmt:formatNumber value="${ci.price}" type="number"/> × ${ci.km} km × ${ci.quantity} =
                <strong><fmt:formatNumber value="${ci.price * ci.km * ci.quantity}" type="number"/> VND</strong>
            </div>
        </c:forEach>
        <hr>
        <a class="btn-payment" href="${pageContext.request.contextPath}/payments">Thanh toán</a>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/shopping-cart.js"></script>
</body>
</html>
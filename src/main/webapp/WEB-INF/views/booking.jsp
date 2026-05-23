<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="vi_VN"/>

<html>
<head>
    <title>Đặt xe - Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/booking.css">
</head>
<body>

<nav class="global-nav">
    <div class="nav-inner">
        <a class="nav-logo" href="${pageContext.request.contextPath}/index.jsp">AUTO CARS</a>
        <div class="nav-links">
            <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/list-product">Xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/cars-brand">Hãng xe</a>
            <a class="nav-link active" href="${pageContext.request.contextPath}/booking">Đặt xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/my-shopping-cart">
                Giỏ hàng (${not empty sessionScope.cart ? sessionScope.cart.totalQuantity : 0})
                <%-- ch lm reload trang bang ajax --%>
            </a>
        </div>
    </div>
</nav>

<div class="booking-page">
    <div class="booking-container">

        <div class="booking-left">
            <h2>Thông tin đặt xe</h2>

            <form id="bookingForm" action="${pageContext.request.contextPath}/add-cart" method="get">

                <input type="hidden" name="productId" value="${selTypeId}">

                <div class="form-group">
                    <label>Hình thức thuê</label>
                    <div class="rental-types" style="margin-top: 10px;">
                        <label>
                            <input type="radio" name="isDriver" value="false" ${not selIsDriver ? 'checked' : ''}
                                   onchange="this.form.action='${pageContext.request.contextPath}/booking'; this.form.submit();">
                            Tự lái
                        </label>
                        <label>
                            <input type="radio" name="isDriver" value="true" ${selIsDriver ? 'checked' : ''}
                                   onchange="this.form.action='${pageContext.request.contextPath}/booking'; this.form.submit();">
                            Có tài xế
                        </label>
                    </div>
                </div>

                <div class="form-group">
                    <label>Hãng xe</label>
                    <select name="brandId" class="form-control" onchange="this.form.action='${pageContext.request.contextPath}/booking'; this.form.submit();">
                        <option value="0">-- Chọn hãng xe --</option>
                        <c:forEach items="${brands}" var="b">
                            <option value="${b.brandId}" ${selBrandId == b.brandId ? 'selected' : ''}>${b.brandName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label>Tên xe</label>
                    <select name="typeId" class="form-control" onchange="this.form.action='${pageContext.request.contextPath}/booking'; this.form.submit();">
                        <option value="0">-- Chọn xe --</option>
                        <c:if test="${selBrandId > 0}">
                            <c:forEach items="${carsMap[selBrandId]}" var="ct">
                                <option value="${ct.typeId}" ${selTypeId == ct.typeId ? 'selected' : ''}>${ct.typeName}</option>
                            </c:forEach>
                        </c:if>
                    </select>
                </div>

                <div class="form-group">
                    <label>Số lượng xe</label>
                    <input type="number" name="quantity" class="form-control" value="1" min="1">
                </div>

                <div class="form-actions" style="margin-top: 25px;">
                    <button type="submit" class="btn-submit" ${selTypeId <= 0 ? 'disabled' : ''}>
                        Thêm vào giỏ hàng
                    </button>
                </div>
            </form>
        </div>

        <div class="booking-right">
            <c:choose>
                <c:when test="${not empty selCar}">
                    <div class="car-preview">
                        <img src="${selCar.img}" alt="${selCar.typeName}">
                        <h3>${selCar.typeName}</h3>
                        <div class="tags">
                            <span class="tag">${selCar.seatingPlan} chỗ</span>
                            <span class="tag">${selCar.fuel}</span>
                            <span class="tag">${selCar.category}</span>
                        </div>
                        <div class="price">
                            <fmt:formatNumber value="${selCar.priceKm}" type="number"/> VND<span> / km</span>
                        </div>
                        <p style="color: #64748b; margin-top: 5px;">
                            <fmt:formatNumber value="${selCar.priceDay}" type="number"/> VND / ngày
                        </p>
                        <p style="margin-top: 25px; font-size: 0.95rem; color: #475569; line-height: 1.5;">
                                ${selCar.descriptionType}
                        </p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-preview">
                        Vui lòng chọn Hãng xe và Tên xe ở danh sách bên trái để xem trước thông tin.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</div>

</body>
</html>
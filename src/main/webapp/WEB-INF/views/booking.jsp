<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Định dạng số kiểu Việt Nam --%>
<fmt:setLocale value="vi_VN"/>

<html>
<head>
    <title>Đặt xe - Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/booking.css">
    <style>
        /* CSS cho menu thả xuống */
        select.form-control, input.form-control {
            width: 100%; padding: 12px; border: 1px solid #cbd5e1;
            border-radius: 6px; font-size: 1rem; outline: none; margin-top: 5px;
        }

        /* CSS cho khung xem trước xe bên phải */
        .car-preview {
            background: #fff; border-radius: 12px; padding: 40px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); text-align: center;
        }
        .car-preview img {
            max-width: 100%; height: 280px; object-fit: contain; margin-bottom: 20px;
        }
        .car-preview h3 { font-size: 1.8rem; color: #0b1a30; margin-bottom: 15px; }
        .car-preview .tags { display: flex; justify-content: center; gap: 10px; margin-bottom: 20px; }
        .car-preview .tag { background: #f1f5f9; padding: 6px 12px; border-radius: 6px; font-weight: 600; color: #475569; }
        .car-preview .price { font-size: 1.5rem; color: #ea580c; font-weight: bold; margin-bottom: 10px; }
        .empty-preview {
            background: #f8fafc; border: 2px dashed #cbd5e1; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            height: 100%; min-height: 400px; color: #64748b; font-size: 1.1rem;
        }
    </style>
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
                Giỏ hàng (<c:out value="${sessionScope.cart.totalQuantity != null ? sessionScope.cart.totalQuantity : 0}"/>)
            </a>
        </div>
    </div>
</nav>

<div class="booking-page">
    <div class="booking-container">

        <%-- ===== CỘT TRÁI: FORM CHỌN XE BẰNG MENU THẢ XUỐNG ===== --%>
        <div class="booking-left">
            <h2>Thông tin đặt xe</h2>

            <%-- Mặc định Form sẽ submit về trang Thêm vào Giỏ (add-cart) --%>
            <form id="bookingForm" action="${pageContext.request.contextPath}/add-cart" method="get">

                <%-- Biến ẩn này truyền ID xe chuẩn cho AddCartController --%>
                <input type="hidden" name="productId" value="${selTypeId}">

                <div class="form-group">
                    <label>Hình thức thuê</label>
                    <div class="rental-types" style="margin-top: 10px;">
                        <label>
                            <%-- onchange: Nếu đổi hình thức, tạm chuyển form về trang /booking để tải lại dữ liệu --%>
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
                    <%-- Nút khóa (disabled) nếu chưa chọn Tên xe --%>
                    <button type="submit" class="btn-submit" ${selTypeId <= 0 ? 'disabled' : ''}>
                        Thêm vào giỏ hàng
                    </button>
                </div>
            </form>
        </div>

        <%-- ===== CỘT PHẢI: HIỂN THỊ TRỰC QUAN XE ĐÃ CHỌN ===== --%>
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
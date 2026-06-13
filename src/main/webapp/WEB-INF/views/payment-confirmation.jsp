<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt xe thành công - Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/payment_confirmation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nav.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/includes/header.jsp">
</jsp:include>
<div class="confirm-page">
    <div class="success-banner">
        <span class="success-icon"></span>
        <div class="success-title">Đặt xe thành công!</div>
        <div class="success-sub">
            Đơn đặt xe của bạn đã được ghi nhận.<br>
            AutoCars sẽ liên hệ xác nhận trong vòng <strong>30 phút</strong>.
            Chúc quý khách thượng lộ bình an!
        </div>
    </div>

    <c:choose>
        <c:when test="${method == 'CASH'}">
            <div class="method-note cash">
                <strong>Thanh toán tiền mặt (COD):</strong>
                Vui lòng chuẩn bị
                <strong><fmt:formatNumber value="${grandTotal}" type="number"/>đ</strong>
                để thanh toán khi tài xế đến đón.
            </div>
        </c:when>
        <c:when test="${method == 'TRANSFER'}">
            <div class="method-note transfer">
                <strong>Thanh toán chuyển khoản / MoMo:</strong>
                Đơn của bạn đang chờ xác nhận thanh toán.
                Vui lòng hoàn tất chuyển khoản để kích hoạt chuyến đi.
            </div>
        </c:when>
    </c:choose>

    <div class="order-detail-card">
        <div class="card-header">
            📋 Chi tiết đơn đặt xe (${fn:length(bookings)} xe)
        </div>

        <c:forEach items="${bookings}" var="bk" varStatus="st">
            <div class="booking-row">
                <div class="booking-name">
                    Đơn #${bk.bookingId} — ${bk.carName}
                </div>

                <div class="info-grid">
                    <div class="info-item">
                        <div class="lbl">Tuyến đường</div>
                        <div class="val">${bk.pickupProvince} → ${bk.dropoffProvince}</div>
                    </div>
                    <div class="info-item">
                        <div class="lbl">Khoảng cách</div>
                        <div class="val">${bk.km} km</div>
                    </div>
                    <div class="info-item">
                        <div class="lbl">Ngày đón</div>
                        <div class="val">${bk.pickupTime}</div>
                    </div>
                    <div class="info-item">
                        <div class="lbl">Ngày trả xe</div>
                        <div class="val">${bk.returnTime}</div>
                    </div>
                    <div class="info-item">
                        <div class="lbl">Người đặt</div>
                        <div class="val">${bk.bookerName}</div>
                    </div>
                    <div class="info-item">
                        <div class="lbl">Số điện thoại</div>
                        <div class="val">${bk.bookerPhone}</div>
                    </div>
                    <div class="info-item">
                        <div class="lbl">Địa chỉ đón</div>
                        <div class="val">${bk.bookerAddress}</div>
                    </div>
                    <div class="info-item">
                        <div class="lbl">Trạng thái</div>
                        <div class="val">
                            <span style="color:#f9a01b; font-weight:bold;">⏳ Chờ xác nhận</span>
                        </div>
                    </div>
                    <c:if test="${not empty bk.note}">
                        <div class="info-item" style="grid-column:1/-1">
                            <div class="lbl">Ghi chú</div>
                            <div class="val">${bk.note}</div>
                        </div>
                    </c:if>
                </div>

                <div class="booking-amount">
                    <fmt:formatNumber value="${bk.totalPrice}" type="number"/> VND
                </div>
            </div>
        </c:forEach>

        <div class="grand-total-bar">
            <span class="lbl">Tổng thanh toán:</span>
            <span class="total">
                <fmt:formatNumber value="${grandTotal}" type="number"/>đ
            </span>
        </div>
    </div>

    <div class="confirm-actions">
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn-home">
            Về trang chủ
        </a>
        <a href="${pageContext.request.contextPath}/my-shopping-cart" class="btn-orders">
            Xem đơn của tôi
        </a>
        <a href="${pageContext.request.contextPath}/list-product" class="btn-book-more">
            Đặt thêm xe
        </a>
    </div>

</div>
</body>
</html>
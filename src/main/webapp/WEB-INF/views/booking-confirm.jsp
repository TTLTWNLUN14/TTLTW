<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận đặt xe - Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/booking-confirm.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nav.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/includes/header.jsp">
  <jsp:param name="activePage" value="booking"/>
</jsp:include>
<div class="page-header">
    <h2>Xác nhận đặt xe</h2>
    <div class="breadcrumb">
        Giỏ hàng → <span>Xác nhận thông tin</span> → Thanh toán → Hoàn tất
    </div>
</div>

<div class="confirm-container">

    <div>
        <div class="summary-card">
            <div class="card-header">
                <h3>Tóm tắt đơn đặt xe (${fn:length(selectedItems)} xe)</h3>
            </div>

            <c:forEach items="${selectedItems}" var="ci" varStatus="st">
                <div class="item-row">
                    <div class="item-name">${st.index + 1}. ${ci.selectedTypeName}</div>
                    <div class="item-detail">
                        Tuyến đường:
                        <span>
                            <c:out value="${not empty ci.fromProvinceName ? ci.fromProvinceName : '(chưa chọn)'}"/>
                            →
                            <c:out value="${not empty ci.toProvinceName ? ci.toProvinceName : '(chưa chọn)'}"/>
                        </span>
                        <c:if test="${ci.km > 0}">
                            (<span>${ci.km} km</span>)
                        </c:if>
                        <br>
                        Ngày đón: <span>${not empty ci.pickupTime ? ci.pickupTime : '(chưa chọn)'}</span>
                        &nbsp;|&nbsp;
                        Ngày trả: <span>${not empty ci.returnTime ? ci.returnTime : '(chưa chọn)'}</span>
                        <br>
                        Giá: <span><fmt:formatNumber value="${ci.price}" type="number"/> VND/km</span>
                        × ${ci.km} km × ${ci.quantity}
                    </div>
                    <div class="item-total">
                        Thành tiền: <fmt:formatNumber value="${ci.price * ci.km * ci.quantity}" type="number"/> VND
                    </div>
                </div>
            </c:forEach>

            <div class="grand-total-bar">
                <span class="label">Tổng cộng (${fn:length(selectedItems)} xe):</span>
                <span class="amount"><fmt:formatNumber value="${grandTotal}" type="number"/> VND</span>
            </div>
        </div>
    </div>

    <div class="booker-card">
        <h3>👤 Thông tin người đặt xe</h3>

        <div class="info-note">
            Thông tin này sẽ được dùng để liên hệ xác nhận chuyến xe.
            Có thể điền tên người khác nếu đặt hộ.
        </div>

        <c:if test="${not empty errorMsg}">
            <div class="error-msg">⚠ ${errorMsg}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/booking" method="post">
            <input type="hidden" name="step" value="2">

            <div class="form-group">
                <label>Họ và tên <span class="req">*</span></label>
                <input type="text"
                       name="bookerName"
                       maxlength="100"
                       placeholder="Nguyễn Văn A"
                       value="${not empty param.bookerName ? param.bookerName : (member != null ? member.fullName : '')}"
                       required>
            </div>

            <div class="form-group">
                <label>Số điện thoại <span class="req">*</span></label>
                <input type="tel"
                       name="bookerPhone"
                       maxlength="10"
                       pattern="\d{10}"
                       placeholder="0901234567"
                       value="${not empty param.bookerPhone ? param.bookerPhone : (member != null ? member.phone : '')}"
                       required>
            </div>

            <div class="form-group">
                <label>Địa chỉ đón <span class="req">*</span></label>
                <input type="text"
                       name="bookerAddress"
                       maxlength="300"
                       placeholder="123 Nguyễn Huệ, Quận 1, TP.HCM"
                       value="${not empty param.bookerAddress ? param.bookerAddress : ''}"
                       required>
            </div>

            <div class="form-group">
                <label>Ghi chú thêm</label>
                <textarea name="note"
                          maxlength="500"
                          placeholder="Ví dụ: có trẻ em, cần ghế con, đón sớm...">${not empty param.note ? param.note : ''}</textarea>
            </div>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/my-shopping-cart" class="btn-back">
                    ← Quay lại giỏ hàng
                </a>
                <button type="button" class="btn-cancel-order" onclick="openCancelModal()">
                    x Hủy đơn
                </button>
                <button type="submit" class="btn-confirm">
                    Xác nhận đặt xe →
                </button>
            </div>
        </form>
    </div>

</div>

<div id="cancelModal" class="modal-overlay">
    <div class="modal-box">
        <h3 class="modal-title">Xác nhận hủy đơn</h3>
        <p class="modal-text">
            Bạn có chắc muốn hủy tất cả <strong>${fn:length(selectedItems)} xe</strong> trong đơn này không?<br>
            Đơn sẽ được lưu vào <em>Lịch sử → Đã hủy</em> và không thể hoàn tác.
        </p>
        <form action="${pageContext.request.contextPath}/booking" method="post">
            <input type="hidden" name="step" value="2">
            <input type="hidden" name="action" value="cancel">
            <div class="modal-actions">
                <button type="button" onclick="closeCancelModal()" class="btn-modal-close">
                    Không, ở lại
                </button>
                <button type="submit" class="btn-modal-submit">
                    Có, hủy đơn
                </button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/booking-confirm.js"></script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán - Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/payment.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nav.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/includes/header.jsp">
    <jsp:param name="activePage" value="payment"/>
</jsp:include>
<div class="page-header">
    <h2>Thanh toán</h2>
    <div class="breadcrumb">
        Giỏ hàng → Xác nhận thông tin → <span>Thanh toán</span> → Hoàn tất
    </div>
</div>

<div class="payment-layout">
    <c:if test="${not empty errorMsg}">
        <div class="error-msg">${errorMsg}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/payments" method="post" id="paymentForm">

        <c:forEach items="${bookings}" var="bk">
            <input type="hidden" name="bookingIds" value="${bk.bookingId}">
        </c:forEach>
        <input type="hidden" name="payType" value="FULL">

        <div class="checkout-section">
            <h3 class="section-title">THÔNG TIN CHUYẾN ĐI</h3>
            <c:choose>
                <c:when test="${empty bookings}">
                    <div style="padding:16px 18px; color:#888;">Không tìm thấy đơn đặt xe.</div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${bookings}" var="bk" varStatus="st">
                        <div class="trip-card">
                            <div class="trip-card-header">
                                <span>Đơn #${st.index + 1} — ${bk.carName}</span>
                                <span class="trip-card-total">
                                    <fmt:formatNumber value="${bk.totalPrice}" type="number"/> VND
                                </span>
                            </div>
                            <div class="trip-row">
                                <span class="label">Tuyến đường</span>
                                <span class="value">${bk.pickupProvince} → ${bk.dropoffProvince}</span>
                            </div>
                            <div class="trip-row">
                                <span class="label">Ngày đón</span>
                                <span class="value">${bk.pickupTime}</span>
                            </div>
                            <div class="trip-row">
                                <span class="label">Ngày trả</span>
                                <span class="value">${bk.returnTime}</span>
                            </div>
                            <div class="trip-row">
                                <span class="label">Người đặt</span>
                                <span class="value">${bk.bookerName} — ${bk.bookerPhone}</span>
                            </div>
                            <div class="trip-row">
                                <span class="label">Địa chỉ đón</span>
                                <span class="value">${bk.bookerAddress}</span>
                            </div>
                            <c:if test="${not empty bk.note}">
                                <div class="trip-row">
                                    <span class="label">Ghi chú</span>
                                    <span class="value">${bk.note}</span>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="checkout-section">
            <h3 class="section-title">💳 PHƯƠNG THỨC THANH TOÁN</h3>
            <div class="payment-grid">
                <label class="payment-card">
                    <input type="radio" name="method" value="CASH" id="methodCash" checked
                           onchange="updateTotal()">
                    <div>
                        <div class="payment-name">Tiền mặt (COD)</div>
                        <div class="payment-desc">Thanh toán khi tài xế đến đón</div>
                    </div>
                </label>
                <label class="payment-card">
                    <input type="radio" name="method" value="TRANSFER" id="methodTransfer"
                           onchange="updateTotal()">
                    <div>
                        <div class="payment-name">Chuyển khoản / MoMo</div>
                        <div class="payment-desc">Quét QR, xác nhận tức thì</div>
                    </div>
                </label>
            </div>
        </div>
        <div class="checkout-section">
            <h3 class="section-title">TỔNG TIỀN</h3>
            <div class="total-summary">
                <div class="summary-line">
                    <span>Tiền hàng (${fn:length(bookings)} xe):</span>
                    <span><fmt:formatNumber value="${subtotal}" type="number"/>đ</span>
                </div>
                <div class="summary-line discount" id="discountRow" style="display:none">
                    <span>Giảm giá (<span id="voucherLabel"></span>):</span>
                    <span id="discountAmt">-0đ</span>
                </div>
                <div class="summary-line final-total">
                    <span>Tổng thanh toán:</span>
                    <strong id="grandTotal"><fmt:formatNumber value="${grandTotal}" type="number"/>đ</strong>
                </div>
            </div>

            <div class="terms-section">
                <label class="terms-label">
                    <input type="checkbox" name="acceptTerms" id="termsChk"
                           onchange="toggleSubmitBtn()">
                    Tôi đồng ý với
                    <a href="${pageContext.request.contextPath}/terms" target="_blank">Điều khoản và Dịch vụ</a>
                    của AutoCars
                </label>
                <div class="terms-error" id="termsError">
                    ✗ Vui lòng đồng ý điều khoản trước khi thanh toán.
                </div>
            </div>

            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/my-shopping-cart" class="btn-back">
                    ← Quay lại
                </a>
                <button type="submit" class="btn-next" id="btnSubmit" disabled
                        onclick="return validateForm()">
                    Đặt xe ngay →
                </button>
            </div>
        </div>

    </form>
</div>

<script src="${pageContext.request.contextPath}/assets/js/payment.js"></script>
</body>
</html>
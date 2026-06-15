<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chọn Voucher - Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/voucher.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nav.css">
</head>

<body>

<jsp:include page="/WEB-INF/views/includes/header.jsp">
    <jsp:param name="activePage" value="voucher"/>
</jsp:include>

<div class="page-header">
    <h2>Mã Giảm Giá</h2>
    <div class="breadcrumb">
        Giỏ hàng → Xác nhận thông tin → Thanh toán → <span>Mã giảm giá</span>
    </div>
</div>

<main class="voucher-container">
    <c:if test="${not empty errorMsg}">
        <div class="error-msg" style="margin-bottom: 20px;">
            ⚠ ${errorMsg}
        </div>
    </c:if>

    <div class="voucher-header">
        <h3>Mã giảm giá khả dụng cho bạn</h3>
        <p>Chọn một mã giảm giá để áp dụng cho đơn hàng của bạn</p>
    </div>

    <c:if test="${empty vouchers}">
        <div class="voucher-empty-state">
            <p>Hiện không có mã giảm giá nào khả dụng cho bạn.</p>
            <p class="empty-desc">Vui lòng quay lại trang thanh toán để tiếp tục.</p>
            <a href="${pageContext.request.contextPath}/payments" class="btn-back-to-payment">
                ← Quay lại thanh toán
            </a>
        </div>
    </c:if>

    <div class="vouchers-grid">
        <c:forEach var="v" items="${vouchers}">
            <div class="voucher-card">
                <div class="voucher-content">
                    <h4 class="voucher-name">${v.nameVoucher}</h4>
                    <div class="voucher-badge">Mã: <strong>${v.code}</strong></div>

                    <div class="voucher-details">
                        <div class="detail-row">
                            <span class="detail-label">Giảm giá:</span>
                            <span class="detail-value">
                                <c:choose>
                                    <c:when test="${v.discount * 100 == 100}">
                                        <fmt:formatNumber value="${v.priceMaxDiscount}" type="number"/>đ
                                    </c:when>
                                    <c:otherwise>
                                        ${v.discount * 100}% (Tối đa <fmt:formatNumber value="${v.priceMaxDiscount}" type="number"/>đ)
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label">Đơn tối thiểu:</span>
                            <span class="detail-value"><fmt:formatNumber value="${v.minOrder}" type="number"/>VND</span>
                        </div>
                        <c:if test="${v.usesLeft > 0 and v.usesLeft <= 5}">
                            <div class="detail-row warning">
                                <span class="detail-label">Lượt còn lại:</span>
                                <span class="detail-value">${v.usesLeft}</span>
                            </div>
                        </c:if>
                    </div>

                    <form action="${pageContext.request.contextPath}/voucher" method="POST" class="voucher-form">
                        <input type="hidden" name="voucherId" value="${v.voucherId}">
                        <input type="hidden" name="action" value="apply">
                        <button type="submit" class="btn-apply-voucher">Chọn mã này
                        </button>
                    </form>
                </div>
            </div>
        </c:forEach>
    </div>

    <c:if test="${not empty vouchers}">
        <div class="voucher-footer">
            <a href="${pageContext.request.contextPath}/payments" class="btn-skip-voucher">
                ← Bỏ qua, quay lại thanh toán
            </a>
        </div>
    </c:if>
</main>
</body>
</html>

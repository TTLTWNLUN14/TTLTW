<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh Toán - Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/payment.css">
</head>
<body>
<nav class="global-nav">
    <div class="nav-inner">
        <a class="nav-logo" href="${pageContext.request.contextPath}/index.jsp">AUTO CARS</a>
        <div class="nav-links">
            <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/list-product">Xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/my-shopping-cart">
                Giỏ hàng (${sessionScope.cart.totalQuantity != null ? sessionScope.cart.totalQuantity : 0})
            </a>
        </div>
    </div>
</nav>

<main class="payment-page">
    <form action="${pageContext.request.contextPath}/payments" method="post">
        <input type="hidden" name="bookingId" value="1"> <%-- id booking =1 do chưa có logic tạo booking --%>
        <input type="hidden" name="price" value="${sessionScope.cart.total}">
        <input type="hidden" name="payType" value="FULL">

        <div class="payment-layout">
            <div class="checkout-container">
                <div class="checkout-section">
                    <h3 class="section-title">THÔNG TIN CHUYẾN ĐI</h3>
                    <c:choose>
                        <c:when test="${empty sessionScope.cart or empty sessionScope.cart.items}">
                            <div class="no-cart-msg">Giỏ hàng trống.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="trip-list">
                                <c:forEach items="${sessionScope.cart.items}" var="ci" varStatus="st">
                                    <div class="trip-card">
                                        <div class="trip-card-header">
                                            <span>Đơn #${st.index + 1} - ${ci.selectedTypeName}</span>
                                            <span class="trip-card-total">
                                                <fmt:formatNumber value="${ci.price * ci.km * ci.quantity}" type="number"/> VND
                                            </span>
                                        </div>
                                        <div class="trip-rows">
                                            <div class="trip-row">
                                                <span class="label">Tên xe & Loại xe</span>
                                                <span class="value">${ci.selectedTypeName} (${ci.selectedCategory})</span>
                                            </div>
                                            <div class="trip-row">
                                                <span class="label">Tuyến đường</span>
                                                <span class="value">
                                                    <c:out value="${not empty ci.fromProvinceName ? ci.fromProvinceName : 'Chưa chọn'}"/>
                                                    &rarr;
                                                    <c:out value="${not empty ci.toProvinceName ? ci.toProvinceName : 'Chưa chọn'}"/>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="checkout-section">
                    <h3 class="section-title">PHƯƠNG THỨC THANH TOÁN</h3>
                    <div class="payment-grid">
                        <label class="payment-card">
                            <input type="radio" name="method" value="TRANSFER" checked>
                            <span class="payment-name">Thanh toán ngay (Mã QR)</span>
                        </label>
                        <label class="payment-card">
                            <input type="radio" name="method" value="CASH">
                            <span class="payment-name">Tiền mặt tại văn phòng</span>
                        </label>
                    </div>

                    <div class="total-summary">
                        <div class="summary-line final-total">
                            <span>Tổng thanh toán:</span>
                            <strong><fmt:formatNumber value="${sessionScope.cart.total}" type="number"/>đ</strong>
                        </div>
                    </div>

                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/my-shopping-cart" class="btn-back">← Quay lại</a>
                        <button type="submit" class="btn-next">Đặt xe ngay →</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</main>
</body>
</html>
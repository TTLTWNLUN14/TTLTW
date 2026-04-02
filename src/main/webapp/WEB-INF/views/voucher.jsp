<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chọn Voucher - Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/voucher.css">
</head>

<body>
<nav class="global-nav">
    <div class="nav-inner">
        <a class="nav-logo" href="index.html">AUTO CARS</a>
        <div class="nav-links">
            <a class="nav-link" href="index.html">Trang chủ</a>
            <a class="nav-link" href="list-cars.html">Xe</a>
            <a class="nav-link" href="../../WEB-INF/views/cars-brand.jsp">Hãng xe</a>
            <a class="nav-link" href="../../WEB-INF/views/booking.jsp">Đặt xe</a>
            <a class="nav-link" href="../../WEB-INF/views/shopping-cart.jsp">Giỏ hàng</a>
        </div>
    </div>
</nav>

<main class="voucher-container">
    <h2>Mã giảm giá dành cho bạn</h2>
    <hr>

    <c:if test="${empty vouchers}">
        <div style="text-align: center; padding: 40px;">
            <p>Hiện không có mã giảm giá nào khả dụng cho đơn hàng này.</p>
            <a href="payment?bookingId=${bookingId}&price=${price}&km=${km}" style="color: #e53935;">Quay lại thanh toán</a>
        </div>
    </c:if>

    <c:forEach var="v" items="${vouchers}">
        <div class="voucher-item">
            <div class="voucher-info">
                <h4>${v.nameVoucher}</h4>
                <p>Mã: <strong>${v.code}</strong></p>
                <p>Giảm: ${v.discount * 100}% (Tối đa ${v.priceMaxDiscount}đ)</p>
                <p>Đơn tối thiểu: ${v.minOrder}đ</p>
            </div>

            <form action="voucher" method="POST">
                <input type="hidden" name="voucherId" value="${v.voucherId}">
                <input type="hidden" name="bookingId" value="${bookingId}">
                <input type="hidden" name="price" value="${price}">
                <input type="hidden" name="km" value="${km}">
                <input type="hidden" name="redirect" value="payment">
                <button type="submit" class="btn-apply">Áp dụng</button>
            </form>
        </div>
    </c:forEach>
</main>
</body>
</html>
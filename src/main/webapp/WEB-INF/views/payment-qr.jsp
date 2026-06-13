<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QR Thanh Toán - Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/payment_pr.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nav.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/includes/header.jsp">
</jsp:include>
<main class="qr-page">
    <div class="qr-container">
        <h2>Thanh toán qua mã QR</h2>
        <p class="qr-desc">Vui lòng dùng ứng dụng MoMo để quét mã dưới đây.</p>

        <div class="qr-box">
            <img src=""
                 alt="Mã QR Thanh Toán">
        </div>

        <div class="qr-amount">
            <span>Số tiền cần chuyển:</span>
            <strong style="color:#ef4444; font-size:22px;">
                ${not empty param.price ? param.price : price} VND
            </strong>
        </div>

        <p style="font-size:13px; color:#6b7280; margin-top:12px;">
            Nội dung chuyển khoản: <strong>Thanh toán đặt xe</strong>
        </p>

        <div class="qr-actions" style="margin-top: 24px; display: flex; gap: 15px; justify-content: center;">
            <a href="${pageContext.request.contextPath}/payment" class="btn-back"
               style="padding:10px 20px; text-decoration:none; display:inline-flex; align-items:center; border:1px solid #d1d5db; border-radius:6px; color:#4b5563;">
                ← Hủy giao dịch
            </a>
            <a href="${pageContext.request.contextPath}/payment-confirmation?payType=ONLINE&method=TRANSFER&price=${not empty param.price ? param.price : price}"
               class="btn-next"
               style="padding:10px 20px; background:#1e3a8a; color:white; text-decoration:none; display:inline-flex; align-items:center; border-radius:6px; font-weight:600;">
                Tôi đã thanh toán →
            </a>
        </div>
    </div>
</main>

<script src="../../assets/js/payment_qr.js"></script>
</body>
</html>
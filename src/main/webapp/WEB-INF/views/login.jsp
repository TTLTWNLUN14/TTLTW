<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Đăng nhập – Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
    <style>
        /* ── Chỉ CSS cho các thành phần MỚI thêm vào ── */
        .social-divider {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 14px 0;
            color: #888;
            font-size: .8rem;
        }
        .social-divider::before,
        .social-divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: rgba(255,255,255,.12);
        }
        .btn-social {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            padding: 10px;
            border-radius: 8px;
            font-size: .88rem;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            margin-bottom: 8px;
            border: none;
            transition: opacity .2s;
        }
        .btn-social:hover { opacity: .85; }
        .btn-google   { background: #fff; color: #333; }
        .btn-facebook { background: #1877F2; color: #fff; }
        .btn-social svg { width: 18px; height: 18px; flex-shrink: 0; }
        .reg-error { color: #ff5c5c; font-size: .85rem; margin-bottom: 8px; display: none; }
        .oauth-error { color: #ff5c5c; font-size: .85rem; margin-bottom: 10px; }
    </style>
</head>
<body>
<nav class="navbar" style="position:relative;">
    <div class="navbar__inner">
        <a href="../../assets/html/index.html" class="navbar__logo">Auto<span>Cars</span></a>
        <div class="nav-links">
            <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a>
            <a class="nav-link active" href="${pageContext.request.contextPath}/WEB-INF/views/car-detail.jsp">Xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/WEB-INF/views/cars-brand.jsp">Hãng xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/WEB-INF/views/booking.jsp">Đặt xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/WEB-INF/views/shopping-cart.jsp">Giỏ hàng</a>
        </div>
    </div>
</nav>
<div class="login-wrap">
    <div class="login-box">
        <div class="login-logo">
            <span>Auto<em>Cars</em></span>
            <div>Đặt xe du lịch dễ dàng</div>
        </div>

        <div class="tabs">
            <button class="tab-btn active" id="tLogin"    onclick="setTab('login')">Đăng nhập</button>
            <button class="tab-btn"        id="tRegister" onclick="setTab('register')">Đăng ký</button>
        </div>

        <div class="form-panel show" id="pLogin">
            <form method="POST" action="${pageContext.request.contextPath}/login">
                <div class="form-group">
                    <label>Tên đăng nhập</label>
                    <input name="username" id="lUser" class="form-control" placeholder="username">
                </div>
                <div class="form-group">
                    <label>Mật khẩu</label>
                    <input name="password" id="lPass" class="form-control" type="password" placeholder="••••••••">
                </div>

                <c:if test="${not empty loginError}">
                    <div style="color:red; margin-bottom:8px;">${loginError}</div>
                </c:if>
                <c:if test="${not empty registerSuccess}">
                    <div style="color:green; margin-bottom:8px;">${registerSuccess}</div>
                </c:if>
                <c:if test="${not empty oauthError}">
                    <div class="oauth-error">${oauthError}</div>
                </c:if>

                <label style="font-size:0.9rem;">
                    <input type="checkbox" name="rememberMe"> Ghi nhớ đăng nhập
                </label>

                <button type="submit" class="btn btn-primary" style="width:100%;margin-top:8px;">
                    Đăng nhập
                </button>
            </form>

            <div class="social-divider">hoặc đăng nhập với</div>
            <a href="${pageContext.request.contextPath}/oauth/google" class="btn-social btn-google">
                <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
                    <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
                    <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
                    <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
                </svg>
                Google
            </a>
            <a href="${pageContext.request.contextPath}/oauth/facebook" class="btn-social btn-facebook">
                <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="#fff">
                    <path d="M24 12.073C24 5.405 18.627 0 12 0S0 5.405 0 12.073C0 18.1 4.388 23.094 10.125 24v-8.437H7.078v-3.49h3.047V9.41c0-3.025 1.792-4.697 4.533-4.697 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.93-1.956 1.886v2.286h3.328l-.532 3.49h-2.796V24C19.612 23.094 24 18.1 24 12.073z"/>
                </svg>
                Facebook
            </a>

            <div class="forgot-link">Quên mật khẩu? <span onclick="setTab('forgot')">Lấy lại ngay</span></div>
        </div>

        <%-- ══ PANEL: ĐĂNG KÝ ══ (CẬP NHẬT: thêm <form> + fullName + submit thật) --%>
        <div class="form-panel" id="pRegister">

            <c:if test="${not empty registerError}">
                <div style="color:red; margin-bottom:8px;">${registerError}</div>
            </c:if>

            <form method="POST" action="${pageContext.request.contextPath}/register"
                  id="registerForm" onsubmit="return validateRegister(event)">
                <div class="form-group">
                    <label>Họ và tên</label>
                    <input name="fullName" id="rFullName" class="form-control"
                           placeholder="Nguyễn Văn A" value="${param.fullName}" required>
                </div>
                <div class="form-group">
                    <label>Tên đăng nhập</label>
                    <input name="username" id="rUser" class="form-control"
                           placeholder="username" value="${param.username}" required>
                </div>
                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input name="phone" id="rPhone" class="form-control"
                           placeholder="09xxxxxxxx" value="${param.phone}" required>
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input name="email" id="rEmail" class="form-control" type="email"
                           placeholder="email@example.com" value="${param.email}" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Mật khẩu</label>
                        <input name="password" id="rPass" class="form-control"
                               type="password" placeholder="Tối thiểu 6 ký tự" required>
                    </div>
                    <div class="form-group">
                        <label>Nhập lại</label>
                        <input name="confirmPassword" id="rPass2" class="form-control"
                               type="password" placeholder="••••••••" required>
                    </div>
                </div>

                <div id="regClientError" class="reg-error"></div>

                <button type="submit" class="btn btn-gold" style="width:100%;margin-top:8px;">
                    Tạo tài khoản
                </button>
            </form>

            <%-- Nút đăng ký nhanh bên thứ 3 (MỚI THÊM) --%>
            <div class="social-divider">hoặc đăng ký với</div>
            <a href="${pageContext.request.contextPath}/oauth/google" class="btn-social btn-google">
                <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
                    <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
                    <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
                    <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
                </svg>
                Google
            </a>
            <a href="${pageContext.request.contextPath}/oauth/facebook" class="btn-social btn-facebook">
                <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="#fff">
                    <path d="M24 12.073C24 5.405 18.627 0 12 0S0 5.405 0 12.073C0 18.1 4.388 23.094 10.125 24v-8.437H7.078v-3.49h3.047V9.41c0-3.025 1.792-4.697 4.533-4.697 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.93-1.956 1.886v2.286h3.328l-.532 3.49h-2.796V24C19.612 23.094 24 18.1 24 12.073z"/>
                </svg>
                Facebook
            </a>
        </div>

        <%-- ══ PANEL: QUÊN MẬT KHẨU ══ (giữ nguyên) --%>
        <div class="form-panel" id="pForgot">
            <div class="form-group">
                <label>Email đã đăng ký</label>
                <input id="fEmail" class="form-control" type="email" placeholder="email@example.com">
            </div>
            <button class="btn btn-primary" style="width:100%;margin-top:8px;" onclick="doForgot()">Gửi mã khôi phục</button>
            <div class="forgot-link"><span onclick="setTab('login')">← Quay lại đăng nhập</span></div>
        </div>

        <%-- ══ PANEL: ĐẶT LẠI MẬT KHẨU ══ (giữ nguyên) --%>
        <div class="form-panel" id="pReset">
            <div class="form-group">
                <label>Mã xác nhận</label>
                <input id="resetCode" class="form-control" placeholder="Nhập mã 6 số">
            </div>
            <div class="form-group">
                <label>Mật khẩu mới</label>
                <input id="resetPass" class="form-control" type="password" placeholder="••••••••">
            </div>
            <button class="btn btn-primary" style="width:100%;margin-top:8px;" onclick="doReset()">Cập nhật mật khẩu</button>
        </div>
    </div>
</div>

<div id="toast"></div>

<script src="${pageContext.request.contextPath}/js/login.js"></script>
<script>
    /* Mở đúng tab khi server trả về lỗi / thành công */
    <c:if test="${not empty registerError}">setTab('register');</c:if>
    <c:if test="${not empty registerSuccess}">setTab('login');</c:if>

    /* Validate register phía client */
    function validateRegister(e) {
        var errEl = document.getElementById('regClientError');
        errEl.style.display = 'none';

        var fname = document.getElementById('rFullName').value.trim();
        var user  = document.getElementById('rUser').value.trim();
        var phone = document.getElementById('rPhone').value.trim();
        var email = document.getElementById('rEmail').value.trim();
        var pass  = document.getElementById('rPass').value;
        var pass2 = document.getElementById('rPass2').value;

        function err(msg) {
            errEl.textContent = msg;
            errEl.style.display = 'block';
            e.preventDefault();
            return false;
        }

        if (!fname || !user || !phone || !email || !pass || !pass2)
            return err('Vui lòng điền đầy đủ tất cả các trường.');
        if (user.length < 3 || user.length > 20)
            return err('Tên đăng nhập phải từ 3 đến 20 ký tự.');
        if (pass.length < 6)
            return err('Mật khẩu phải ít nhất 6 ký tự.');
        if (pass !== pass2)
            return err('Mật khẩu xác nhận không khớp.');
        if (!/^\d{9,11}$/.test(phone))
            return err('Số điện thoại không hợp lệ (9–11 chữ số).');
        return true;
    }
</script>
</body>
</html>

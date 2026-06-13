<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Đăng nhập – Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nav.css">
    
</head>
<body>
<jsp:include page="/WEB-INF/views/includes/header.jsp">
    <jsp:param name="activePage" value="cars"/>
</jsp:include>

<div class="login-wrap">
    <div class="login-box">
        <div class="login-logo">
            <span>Auto<em>Cars</em></span>
            <div>Đặt xe du lịch dễ dàng</div>
        </div>

        <div class="tabs">
            <button class="tab-btn active" id="tLogin" onclick="setTab('login')">Đăng nhập</button>
            <button class="tab-btn" id="tRegister" onclick="setTab('register')">Đăng ký</button>
        </div>

        <div class="form-panel show" id="pLogin">
            <form method="POST" action="${pageContext.request.contextPath}/login" id="loginForm">
                <div class="form-group">
                    <label>Tên đăng nhập</label>
                    <input name="username" id="lUser" class="form-control" placeholder="username" required>
                </div>

                <div class="form-group password-toggle">
                    <label>Mật khẩu</label>
                    <input name="password" id="lPass" class="form-control" type="password" placeholder="••••••••" required>
                </div>

                <c:if test="${not empty loginError}">
                    <div class="form-error show">${loginError}</div>
                </c:if>

                <label style="font-size:0.9rem; display: flex; align-items: center; gap: 6px;">
                    <input type="checkbox" name="rememberMe" style="width: 16px; height: 16px; cursor: pointer;">
                    Ghi nhớ đăng nhập (48 giờ)
                </label>

                <button type="submit" class="btn btn-primary" style="width:100%;margin-top:12px;">
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
                    <path d="M24 12.073C24 5.405 18.627 0 12 0S0 5.405 0 12.073C0 18.1 4.388 23.094 10.125 24v-8.437H7.078v-3.49h3.047V9.41c0-3.025 1.792-4.697 4.533-4.697 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796V24c5.728-.904 10.125-5.894 10.125-11.927z"/>
                </svg>
                Facebook
            </a>

            <div class="forgot-link">Quên mật khẩu? <span onclick="setTab('forgot')">Lấy lại ngay</span></div>
        </div>

        <div class="form-panel" id="pRegister">
            <c:if test="${not empty registerError}">
                <div class="form-error show">${registerError}</div>
            </c:if>
            <c:if test="${not empty registerSuccess}">
                <div class="form-success">${registerSuccess}</div>
            </c:if>

            <form method="POST" action="${pageContext.request.contextPath}/register"
                  id="registerForm" onsubmit="return validateRegister(event)">

                <div class="form-group">
                    <label>Họ và tên <span style="color: #ef4444;">*</span></label>
                    <input name="fullName" id="rFullName" class="form-control"
                           placeholder="Nguyễn Văn A" value="${param.fullName}" required>
                    <small style="color: #999;">Tên đầy đủ của bạn</small>
                </div>

                <div class="form-group">
                    <label>Tên đăng nhập <span style="color: #ef4444;">*</span></label>
                    <input name="username" id="rUser" class="form-control"
                           placeholder="username" value="${param.username}" required>
                    <small style="color: #999;">3-20 ký tự, không chứa khoảng trắng</small>
                </div>

                <div class="form-group">
                    <label>Email <span style="color: #ef4444;">*</span></label>
                    <input name="email" id="rEmail" class="form-control" type="email"
                           placeholder="email@example.com" value="${param.email}" required>
                    <small style="color: #999;">Dùng để khôi phục mật khẩu</small>
                </div>

                <div class="form-group">
                    <label>Số điện thoại <span style="color: #ef4444;">*</span></label>
                    <input name="phone" id="rPhone" class="form-control"
                           placeholder="09xxxxxxxx" value="${param.phone}" required>
                    <small style="color: #999;">Số di động 9-11 chữ số</small>
                </div>

                <div class="form-row">
                    <div class="form-group password-toggle">
                        <label>Mật khẩu <span style="color: #ef4444;">*</span></label>
                        <input name="password" id="rPass" class="form-control"
                               type="password" placeholder="Tối thiểu 6 ký tự" required>
                        <small style="color: #999; display: block; margin-top: 4px;">Ít nhất 6 ký tự</small>
                    </div>
                    <div class="form-group password-toggle">
                        <label>Nhập lại mật khẩu <span style="color: #ef4444;">*</span></label>
                        <input name="confirmPassword" id="rPass2" class="form-control"
                               type="password" placeholder="••••••••" required>

                    </div>
                </div>

                <div id="regClientError" class="form-error"></div>

                <button type="submit" class="btn btn-gold" style="width:100%;margin-top:12px;">
                     Tạo tài khoản
                </button>
            </form>
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
                    <path d="M24 12.073C24 5.405 18.627 0 12 0S0 5.405 0 12.073C0 18.1 4.388 23.094 10.125 24v-8.437H7.078v-3.49h3.047V9.41c0-3.025 1.792-4.697 4.533-4.697 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796V24c5.728-.904 10.125-5.894 10.125-11.927z"/>
                </svg>
                Facebook
            </a>
        </div>

        <div class="form-panel" id="pForgot">
            <div class="form-group">
                <label>Email đã đăng ký</label>
                <input id="fEmail" class="form-control" type="email" placeholder="email@example.com">
            </div>
            <button class="btn btn-primary" style="width:100%;margin-top:8px;" onclick="doForgot()">Gửi mã khôi phục</button>
            <div class="forgot-link"><span onclick="setTab('login')">← Quay lại đăng nhập</span></div>
        </div>

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

<script src="${pageContext.request.contextPath}/assets/js/login.js"></script>
<script>
    <c:if test="${not empty registerError}">setTab('register');</c:if>
    <c:if test="${not empty registerSuccess}">setTab('login');</c:if>

</script>
</body>
</html>

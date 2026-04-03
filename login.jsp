<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Đăng nhập – Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
</head>
<body>
<nav class="navbar" style="position:relative;">
    <div class="navbar__inner">
        <a href="../../assets/html/index.html" class="navbar__logo">Auto<span>Cars</span></a>
        <div class="nav-links">
            <a class="nav-link" href="../../assets/html/index.html">Trang chủ</a>
            <a class="nav-link active" href="${pageContext.request.contextPath}/list-cars.jsp">Xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/cars-brand.jsp">Hãng xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/booking.jsp">Đặt xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/shopping-cart.jsp">Giỏ hàng</a>
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
            <button class="tab-btn active" id="tLogin" onclick="setTab('login')">Đăng nhập</button>
            <button class="tab-btn" id="tRegister" onclick="setTab('register')">Đăng ký</button>
        </div>


        <div class="form-panel show" id="pLogin">
            <c:if test="${not empty loginError}">
                <div class="alert alert-error">
                    <strong>Lỗi!</strong> ${loginError}
                </div>
            </c:if>

            <c:if test="${not empty loginMessage}">
                <div class="alert alert-success">
                        ${loginMessage}
                </div>
            </c:if>

            <form method="POST" action="${pageContext.request.contextPath}/login"  novalidate>
                <div class="form-group">
                    <label>Tên đăng nhập</label>
                    <input class="form-control" type="text" name="username" placeholder="username" required>
                </div>
                <div class="form-group">
                    <label>Mật khẩu</label>
                    <input class="form-control" type="password" name="password" placeholder="••••••••" required>
                </div>
                <button type="submit" class="btn btn-primary" style="width:100%;margin-top:8px;">Đăng nhập</button>
            </form>

            <div class="social-divider"><span>Hoặc</span></div>
            <div class="social-login">
                <a href="${pageContext.request.contextPath}/login-google" class="btn-social google">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg" alt="Google">
                    Google
                </a>
                <a href="${pageContext.request.contextPath}/login-facebook" class="btn-social facebook">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/b/b8/2021_Facebook_icon.svg" alt="Facebook">
                    Facebook
                </a>
            </div>
            <div class="forgot-link">Quên mật khẩu? <span onclick="setTab('forgot')">Lấy lại ngay</span></div>
        </div>


        <div class="form-panel" id="pRegister">
            <c:if test="${not empty registerError}">
                <div class="alert alert-error">
                    <strong>Lỗi!</strong> ${registerError}
                </div>
            </c:if>

            <c:if test="${not empty registerSuccess}">
                <div class="alert alert-success">
                    <strong>Thành công!</strong> ${registerSuccess}
                </div>
            </c:if>

            <form method="POST" action="${pageContext.request.contextPath}/register"  novalidate>
                <div class="form-group">
                    <label>Tên đăng nhập</label>
                    <input class="form-control" type="text" name="username" placeholder="3-20 ký tự" minlength="3" maxlength="20" required>
                </div>
                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input class="form-control" type="tel" name="phone" placeholder="0xxxxxxxxx" pattern="[0-9]{9,11}" required>
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input class="form-control" type="email" name="email" placeholder="email@example.com" required>
                </div>
                <div class="form-group">
                    <label>Họ và tên</label>
                    <input class="form-control" type="text" name="fullName" placeholder="Nhập họ và tên" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Mật khẩu</label>
                        <input class="form-control" type="password" name="password" placeholder="••••••••" minlength="6" required>
                    </div>
                    <div class="form-group">
                        <label>Xác nhận mật khẩu</label>
                        <input class="form-control" type="password" name="confirmPassword" placeholder="••••••••" minlength="6" required>
                    </div>
                    <div class="form-group">
                        <label>
                            <input type="checkbox" name="rememberMe" value="true"> Nhớ tôi trong 48 giờ
                        </label>
                    </div>
                </div>
                <button type="submit" class="btn btn-gold" style="width:100%;margin-top:8px;">Tạo tài khoản</button>
            </form>
        </div>


        <div class="form-panel" id="pForgot">
            <c:if test="${not empty forgotError}">
                <div class="alert alert-error">
                    <strong>Lỗi!</strong> ${forgotError}
                </div>
            </c:if>

            <c:if test="${not empty forgotSuccess}">
                <div class="alert alert-success">
                    <strong>Thành công!</strong> ${forgotSuccess}
                </div>
            </c:if>

            <div id="forgotStep1" class="forgot-step">
                <p class="forgot-desc">Nhập email hoặc tên đăng nhập để lấy lại mật khẩu</p>
                <div class="form-group">
                    <label>Email hoặc Tên đăng nhập</label>
                    <input id="forgotEmail" class="form-control" placeholder="email@example.com hoặc username" required>
                </div>
                <button class="btn btn-primary" style="width:100%;margin-top:8px;" onclick="sendForgotEmail()">Gửi mã xác nhận</button>
                <div class="back-link"><span onclick="setTab('login')">← Quay lại</span></div>
            </div>

            <div id="forgotStep2" class="forgot-step" style="display:none;">
                <p class="forgot-desc">Nhập mã xác nhận được gửi đến email của bạn</p>
                <div class="form-group">
                    <label>Mã xác nhận</label>
                    <input id="forgotOtp" class="form-control" placeholder="000000" maxlength="6" pattern="[0-9]{6}" required>
                </div>
                <button class="btn btn-primary" style="width:100%;margin-top:8px;" onclick="verifyOtp()">Xác nhận</button>
                <div class="back-link"><span onclick="resetForgotForm()">← Quay lại</span></div>
            </div>

            <div id="forgotStep3" class="forgot-step" style="display:none;">
                <p class="forgot-desc">Nhập mật khẩu mới</p>
                <div class="form-group">
                    <label>Mật khẩu mới</label>
                    <input id="forgotNewPass" class="form-control" type="password" placeholder="••••••••" minlength="6" required>
                </div>
                <div class="form-group">
                    <label>Xác nhận mật khẩu</label>
                    <input id="forgotNewPassConfirm" class="form-control" type="password" placeholder="••••••••" minlength="6" required>
                </div>
                <button class="btn btn-primary" style="width:100%;margin-top:8px;" onclick="resetPassword()">Đặt lại mật khẩu</button>
                <div class="back-link"><span onclick="resetForgotForm()">← Quay lại</span></div>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/login.js"></script>
</body>
</html>
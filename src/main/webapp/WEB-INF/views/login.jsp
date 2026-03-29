<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
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
           <a class="nav-link" href="${pageContext.request.contextPath}/assets/html/index.html">Trang chủ</a>
           <a class="nav-link active" href="${pageContext.request.contextPath}/assets/html/list-cars.html">Xe</a>
           <a class="nav-link" href="${pageContext.request.contextPath}/WEB-INF/views/cars-brand.html">Hãng xe</a>
           <a class="nav-link" href="${pageContext.request.contextPath}/WEB-INF/views/booking.html">Đặt xe</a>
           <a class="nav-link" href="${pageContext.request.contextPath}/assets/html/shopping-cart.html">Giỏ hàng</a>
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
                           <div class="form-group">
                               <label>Tên đăng nhập</label>
                               <input id="lUser" class="form-control" placeholder="username">
                           </div>
                           <div class="form-group">
                               <label>Mật khẩu</label>
                               <input id="lPass" class="form-control" type="password" placeholder="••••••••">
                           </div>
                           <button class="btn btn-primary" style="width:100%;margin-top:8px;" onclick="doLogin()">Đăng nhập</button>

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
                <div class="form-group">
                    <label>Tên đăng nhập</label>
                    <input id="rUser" class="form-control" placeholder="username">
                </div>
                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input id="rPhone" class="form-control" placeholder="09xxxxxxxx">
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input id="rEmail" class="form-control" type="email" placeholder="email@example.com">
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Mật khẩu</label>
                        <input id="rPass" class="form-control" type="password" placeholder="••••••••">
                    </div>
                    <div class="form-group">
                        <label>Nhập lại</label>
                        <input id="rPass2" class="form-control" type="password" placeholder="••••••••">
                    </div>
                </div>
                <button class="btn btn-gold" style="width:100%;margin-top:8px;" onclick="doRegister()">Tạo tài khoản</button>
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

    <script src="${pageContext.request.contextPath}/js/login.js"></script>
</body>
</html>

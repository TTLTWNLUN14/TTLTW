<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Đặt xe du lịch - Auto Cars</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css">
  <style>
    .global-nav {
      background: #0d1b2e; height: 70px; display: flex; align-items: center;
      position: sticky; top: 0; z-index: 100; box-shadow: 0 2px 8px rgba(0,0,0,.1);
    }
    .nav-inner {
      width: 100%; max-width: 1400px; margin: 0 auto;
      display: flex; justify-content: space-between; align-items: center; padding: 0 40px;
    }
    .nav-logo {
      color: #ffa500; font-weight: bold; font-size: 1.3rem; letter-spacing:.05em;
      display: flex; align-items: center; gap: 10px; text-decoration: none;
    }
    .nav-logo:hover { color: #fff; }
    .nav-links { display: flex; gap: 40px; flex: 1; margin-left: 40px; align-items: center; }
    .nav-link {
      color: #cbd5e1; font-size: .95rem; padding: 6px 0;
      transition: color .2s; text-decoration: none;
    }
    .nav-link:hover { color: #fff; }
    .nav-link.active { color: #ffa500; }
    .nav-link.admin-link {
      color: #f5b82e; font-weight: 700; border: 1.5px solid rgba(245,184,46,.4);
      border-radius: 6px; padding: 4px 14px; font-size: .82rem;
    }
    .nav-link.admin-link:hover { background: rgba(245,184,46,.12); }
    .nav-actions { display: flex; gap: 16px; align-items: center; }

    .btn-login, .btn-register {
      padding: 8px 20px; border-radius: 6px; cursor: pointer;
      font-weight: 600; font-size: .9rem; transition: all .2s;
      text-decoration: none; display: inline-block;
    }
    .btn-login  { color: #fff; background: transparent; border: 1.5px solid rgba(255,255,255,.4); }
    .btn-login:hover  { background: rgba(255,255,255,.1); }
    .btn-register { background: #ffa500; color: #0d1b2e; border: none; }
    .btn-register:hover { background: #e69500; }
    .section-brands {
      padding: 40px 0;
      background: #f8fafc; /* Màu nền nhẹ để nổi bật logo */
      text-align: center;
    }
    .section-brands h3 {
      margin-bottom: 30px;
      color: #0f172a;
      font-size: 1.2rem;
    }
    #brandsRow {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 30px;
      flex-wrap: wrap;
      max-width: 1200px;
      margin: 0 auto;
    }
    .brand {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 8px;
      transition: transform 0.3s;
    }
    .brand:hover {
      transform: translateY(-5px);
    }
    .brand img {
      width: 50px; /* Độ rộng logo */
      height: 50px;
      object-fit: contain;
      filter: grayscale(100%); /* Để logo màu xám cho chuyên nghiệp */
      opacity: 0.7;
      transition: all 0.3s;
    }
    .brand:hover img {
      filter: grayscale(0%); /* Hiện màu gốc khi hover */
      opacity: 1;
    }
    .brand span {
      font-size: 0.85rem;
      font-weight: 600;
      color: #64748b;
    }
    .user-avatar {
      width: 38px; height: 38px; border-radius: 50%; background: #ffa500; color: #0d1b2e;
      display: flex; align-items: center; justify-content: center;
      font-weight: 700; font-size: 1rem; flex-shrink: 0;
    }
    .user-name {
      color: #fff; font-size: .9rem; font-weight: 500;
      max-width: 130px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
    }
    .dropdown { position: relative; display: flex; align-items: center; }
    .dropdown-toggle { display: flex; align-items: center; gap: 10px; cursor: pointer; }
    .dropdown-toggle:hover .user-name { color: #ffa500; }
    .dropdown-caret { color: #ffa500; font-size: .7rem; }
    .dropdown-menu {
      display: none; position: absolute; top: calc(100% + 12px); right: 0;
      background: #fff; border-radius: 10px; min-width: 220px;
      box-shadow: 0 8px 24px rgba(0,0,0,.15); overflow: hidden; z-index: 200;
    }
    .dropdown-menu.open { display: block; }
    .dropdown-header { padding: 14px 16px 10px; border-bottom: 1px solid #f1f5f9; }
    .dropdown-header-name { font-weight: 700; font-size: .9rem; color: #0f172a; }
    .dropdown-header-role { font-size: .75rem; color: #64748b; margin-top: 2px; }
    .dropdown-item {
      padding: 11px 16px; color: #334155; text-decoration: none;
      display: flex; align-items: center; gap: 10px;
      font-size: .88rem; transition: background .15s;
    }
    .dropdown-item:hover { background: #f8fafc; }
    .dropdown-item.admin { color: #92400e; font-weight: 600; background: #fffbeb; }
    .dropdown-item.admin:hover { background: #fef3c7; }
    .dropdown-item.logout { color: #dc2626; border-top: 1px solid #f1f5f9; }
    .dropdown-item.logout:hover { background: #fef2f2; }
    .notif-wrap { position: relative; cursor: pointer; color: #94a3b8; font-size: 1.15rem; }
    .notif-wrap:hover { color: #fff; }
    .notif-badge {
      position: absolute; top: -5px; right: -6px; background: #ef4444; color: #fff;
      width: 18px; height: 18px; border-radius: 50%; font-size: .68rem; font-weight: 700;
      display: flex; align-items: center; justify-content: center;
    }
    .footer {
      background: #0d1b2e;
      padding: 60px 0 30px;
      color: #fff;
      border-top: 1px solid rgba(255,255,255,0.05);
    }

    .footer-grid {
      max-width: 1400px;
      margin: 0 auto;
      padding: 0 40px;


      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      flex-wrap: wrap;
      gap: 30px;
    }


    .footer-grid > div {
      flex: 1;
      min-width: 200px;
    }

    .footer-grid > div:first-child {
      flex: 1.5;
    }

    .footer-title {
      color: #fff;
      font-weight: 700;
      font-size: 1rem;
      margin-bottom: 20px;
      text-transform: uppercase;
      letter-spacing: 0.05em;
    }

    .footer-link {
      display: block;
      color: #94a3b8;
      text-decoration: none;
      font-size: 0.85rem;
      margin-bottom: 12px;
      transition: color 0.2s;
    }

    .footer-link:hover {
      color: #ffa500;
    }

    .footer-bottom {
      text-align: center;
      margin-top: 50px;
      padding-top: 25px;
      border-top: 1px solid rgba(255,255,255,0.05);
      color: #64748b;
      font-size: 0.8rem;
    }
  </style>
</head>
<body>
<div id="toastC" class="toast-container"></div>

<nav class="global-nav">
  <div class="nav-inner">

    <a class="nav-logo" href="${pageContext.request.contextPath}/index">AUTO CARS</a>

    <div class="nav-links">
      <a class="nav-link active" href="${pageContext.request.contextPath}/index">Trang chủ</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/list-product">Xe</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/brand">Hãng xe</a>


      <c:choose>
        <c:when test="${not empty sessionScope.account_id}">
          <a class="nav-link" href="${pageContext.request.contextPath}/booking">Đặt xe</a>
          <a class="nav-link" href="${pageContext.request.contextPath}/cart">Member</a>
        </c:when>
        <c:otherwise>

          <a class="nav-link" href="${pageContext.request.contextPath}/login">Đặt xe</a>
        </c:otherwise>
      </c:choose>

      <c:if test="${sessionScope.role_id == 3}">
        <a class="nav-link admin-link" href="${pageContext.request.contextPath}/admin/dashboard">
          Dashboard
        </a>
      </c:if>
    </div>

    <div class="nav-actions">
      <c:choose>


        <c:when test="${empty sessionScope.account_id}">
          <a href="${pageContext.request.contextPath}/login"    class="btn-login">Đăng nhập</a>
          <a href="${pageContext.request.contextPath}/register" class="btn-register">Đăng ký</a>
        </c:when>


        <c:otherwise>
          <a class="notif-wrap" href="${pageContext.request.contextPath}/profile">
            🔔
            <c:if test="${unreadCount > 0}">
              <span class="notif-badge">${unreadCount}</span>
            </c:if>
          </a>

          <div class="dropdown">
            <div class="dropdown-toggle" onclick="toggleDropdown(event)">
              <div class="user-avatar">
                  ${fn:substring(sessionScope.full_name, 0, 1)}
              </div>
              <span class="user-name">${sessionScope.full_name}</span>
              <span class="dropdown-caret">▼</span>
            </div>

            <div class="dropdown-menu" id="dropdownMenu">
              <div class="dropdown-header">
                <div class="dropdown-header-name">${sessionScope.full_name}</div>
                <div class="dropdown-header-role">
                  <c:choose>
                    <c:when test="${sessionScope.role_id == 3}"> Quản trị viên</c:when>
                    <c:otherwise> Khách hàng</c:otherwise>
                  </c:choose>
                </div>
              </div>

              <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Hồ sơ cá nhân</a>
              <a class="dropdown-item" href="${pageContext.request.contextPath}/my-bookings"> Đơn đặt xe</a>
              <a class="dropdown-item" href="${pageContext.request.contextPath}/cart"> Member</a>


              <c:if test="${sessionScope.role_id == 3}">
                <a class="dropdown-item admin" href="${pageContext.request.contextPath}/admin/dashboard">
                  Dashboard Admin
                </a>
              </c:if>

              <a class="dropdown-item logout" href="${pageContext.request.contextPath}/logout"> Đăng xuất</a>
            </div>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

  </div>
</nav>

<section class="hero">
  <div class="hero-content">
    <h1 class="hero-title">Khám phá Việt Nam<br><span class="gold-text">Đẳng cấp và Thoải mái</span></h1>
    <p class="hero-sub">100+ mẫu xe cao cấp · Tài xế xác thực · Giá ưu đãi cho thành viên · 24/7</p>
  </div>
</section>

<section class="section-brands">
  <div class="container">
    <h3>Đối tác thương hiệu xe uy tín</h3>
    <div id="brandsRow">
      <div class="brand">
        <img src="https://autovina.com/uploads/files/2017/11/01/45/lich-su-bieu-tuong-logo-toyota-autovina3.jpg" alt="Toyota">
        <span>Toyota</span>
      </div>
      <div class="brand">
        <img src="https://i.pinimg.com/736x/da/9c/a5/da9ca5610b6a94b59294e9cc37657cb1.jpg" alt="Honda">
        <span>Honda</span>
      </div>
      <div class="brand">
        <img src="https://vinfastbinhthanh.com/wp-content/uploads/2024/02/logo_Vinfast_binh_thanh.webp" alt="VinFast">
        <span>VinFast</span>
      </div>
      <div class="brand">
        <img src="https://muaxegiatot.com/wp-content/uploads/2018/06/hyundai-logo-thumb.png" alt="Hyundai">
        <span>Hyundai</span>
      </div>
      <div class="brand">
        <img src="https://5.imimg.com/data5/SELLER/Default/2020/11/VD/XW/GN/36279429/mercedes-logo-500x500.jpg" alt="Mercedes">
        <span>Mercedes</span>
      </div>
      <div class="brand">
        <img src="https://inkythuatso.com/uploads/images/2021/11/logo-ford-inkythuatso-01-15-10-52-49.jpg" alt="Ford">
        <span>Ford</span>
      </div>
      <div class="brand">
        <img src="https://upload.wikimedia.org/wikipedia/commons/4/47/KIA_logo2.svg" alt="Kia">
        <span>Kia</span>
      </div>
      <div class="brand">
        <img src="https://muaxegiatot.com/wp-content/uploads/2018/06/mazda-logo-thumb-1.png" alt="Mazda">
        <span>Mazda</span>
      </div>
      <div class="brand">
        <img src="https://vienauto.com/wp-content/uploads/2019/01/Mitsubishi-logo.jpg" alt="Mitsubishi">
        <span>Mitsubishi</span>
      </div>
    </div>
  </div>
</section>

<section class="section-dark">
  <div class="container">
    <div class="sec-header">
      <h2>Dịch vụ của chúng tôi</h2>
      <p class="sec-sub">Hai hình thức thuê linh hoạt</p>
    </div>
    <div class="services-grid">
      <div class="svc-card">
        <h3>Thuê xe có tài xế</h3>
        <p>Tài xế chuyên nghiệp, đúng giờ. Bạn chỉ cần ngồi thư giãn tận hưởng chuyến đi.</p>
        <ul class="svc-list">
          <li>✓ Tài xế được xác thực CCCD & GPLX</li>
          <li>✓ Theo dõi hành trình realtime</li>
          <li>✓ Nhận/trả khách theo yêu cầu</li>
          <li>✓ Bảo hiểm đầy đủ</li>
        </ul>
        <div class="">Từ <strong>3.000đ/km</strong></div>
        <c:choose>
          <c:when test="${not empty sessionScope.account_id}">
            <a href="${pageContext.request.contextPath}/booking?type=with_driver"

          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/login"
               class="" style="margin-top:16px;display:block;text-align:center;text-decoration:none;"></a>
          </c:otherwise>
        </c:choose>
      </div>
      <div class="svc-card">
        <h3>Thuê xe tự lái</h3>
        <p>Tự do khám phá theo lịch trình riêng. Xe giao tận nơi, đủ tiện nghi.</p>
        <ul class="svc-list">
          <li>✓ Giao xe tận địa điểm</li>
          <li>✓ Định vị xe GPS 24/7</li>
          <li>✓ Trả xe linh hoạt</li>
          <li>✓ Hỗ trợ cứu hộ 24/7</li>
        </ul>
        <div class="">Từ <strong>900.000đ/ngày</strong></div>
        <c:choose>
          <c:when test="${not empty sessionScope.account_id}">
            <a href="${pageContext.request.contextPath}/booking?type=self_drive"
               class="btn btn-outline btn-full"
               style="margin-top:16px;display:block;text-align:center;text-decoration:none;color:#fff;border-color:rgba(255,255,255,.5)"></a>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/login"
               class="btn btn-outline btn-full"
               style="margin-top:16px;display:block;text-align:center;text-decoration:none;color:#fff;border-color:rgba(255,255,255,.5)"></a>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>
</section>

<footer class="footer">
  <div class="footer-grid">
    <div>
      <div class="nav-logo" style="margin-bottom:14px">AUTO CARS</div>
      <p style="font-size:.82rem;line-height:1.7;color:#94a3b8;max-width:280px">
        Nền tảng đặt xe du lịch cao cấp hàng đầu Việt Nam.
      </p>
    </div>
    <div>
      <div class="footer-title">Dịch vụ</div>
      <a class="footer-link" href="${pageContext.request.contextPath}/list-cars">Danh sách xe</a>
      <a class="footer-link" href="${pageContext.request.contextPath}/brands">Hãng xe</a>
    </div>
    <div>
      <div class="footer-title">Tài khoản</div>
      <c:choose>
        <c:when test="${empty sessionScope.account_id}">
          <a class="footer-link" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
          <a class="footer-link" href="${pageContext.request.contextPath}/register">Đăng ký</a>
        </c:when>
        <c:otherwise>
          <a class="footer-link" href="${pageContext.request.contextPath}/profile">Hồ sơ cá nhân</a>
          <a class="footer-link" href="${pageContext.request.contextPath}/my-bookings">Đơn đặt xe</a>
          <c:if test="${sessionScope.role_id == 3}">
            <a class="footer-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard Admin</a>
          </c:if>
        </c:otherwise>
      </c:choose>
    </div>
    <div>
      <div class="footer-title">Liên hệ</div>
      <p style="font-size:.83rem;color:#94a3b8;line-height:2.1">
        1800-AUTO-CAR<br>support@autocars.vn<br>
        123 Nguyễn Huệ, Q1, HCM<br>24/7 hỗ trợ
      </p>
    </div>
  </div>
  <div class="footer-bottom">© 2025 AUTO CARS. All rights reserved.</div>
</footer>

<script>
  function toggleDropdown(event) {
    event.stopPropagation();
    document.getElementById('dropdownMenu').classList.toggle('open');
  }
  document.addEventListener('click', function () {
    const m = document.getElementById('dropdownMenu');
    if (m) m.classList.remove('open');
  });

  function goBook() {
    const pickup  = document.getElementById('inPickup').value.trim();
    const dropoff = document.getElementById('inDropoff').value.trim();
    const date    = document.getElementById('inDate').value;
    if (!pickup || !dropoff || !date) { alert('Vui lòng điền đầy đủ thông tin'); return; }
    window.location.href =
            '${pageContext.request.contextPath}/booking' +
            '?pickup='  + encodeURIComponent(pickup) +
            '&dropoff=' + encodeURIComponent(dropoff) +
            '&date='    + date;
  }

  function quickBook(pickup, dropoff) {
    document.getElementById('inPickup').value  = pickup;
    document.getElementById('inDropoff').value = dropoff;
    document.getElementById('inDate').focus();
  }
</script>
<script src="${pageContext.request.contextPath}/assets/js/index.js"></script>
</body>
</html>

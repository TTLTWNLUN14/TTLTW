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
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nav.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/includes/header.jsp">
  <jsp:param name="activePage" value="home"/>
</jsp:include>

<div id="toastC" class="toast-container"></div>


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


<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>


<script>
  const CONTEXT_PATH = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/assets/js/index.js"></script>
</body>
</html>

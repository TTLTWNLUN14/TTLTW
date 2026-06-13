<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer class="footer">
  <div class="footer-grid">
    <%-- Cột 1: Thương hiệu --%>
    <div>
      <div class="nav-logo" style="margin-bottom:14px">AUTO CARS</div>
      <p class="footer-brand-desc">
        Nền tảng đặt xe du lịch cao cấp hàng đầu Việt Nam.
      </p>
    </div>
    <%-- Cột 2: Dịch vụ --%>
    <div>
      <div class="footer-title">Dịch vụ</div>
      <a class="footer-link" href="${pageContext.request.contextPath}/list-product">Danh sách xe</a>
      <a class="footer-link" href="${pageContext.request.contextPath}/brand">Hãng xe</a>
    </div>
    <%-- Cột 3: Tài khoản (thay đổi theo trạng thái đăng nhập) --%>
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
    <%-- Cột 4: Liên hệ --%>
    <div>
      <div class="footer-title">Liên hệ</div>
      <p class="footer-contact-info">
        1800-AUTO-CAR<br>
        support@autocars.vn<br>
        123 Nguyễn Huệ, Q1, HCM<br>
        24/7 hỗ trợ
      </p>
    </div>

  </div>
  <div class="footer-bottom">2025 AUTO CARS</div>
</footer>

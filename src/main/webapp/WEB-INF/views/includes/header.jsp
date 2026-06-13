<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<nav class="global-nav">
  <div class="nav-inner">

    <a class="nav-logo" href="${pageContext.request.contextPath}/index">AUTO CARS</a>

    <div class="nav-links">
      <a class="nav-link ${param.activePage == 'home' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/index">Trang chủ</a>

      <a class="nav-link ${param.activePage == 'cars' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/list-product">Xe</a>

      <a class="nav-link ${param.activePage == 'brand' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/brand">Hãng xe</a>

      <%-- đặt xe: chưa đn → /login, đã đn → /booking --%>
      <c:choose>
        <c:when test="${not empty sessionScope.account_id}">
          <a class="nav-link ${param.activePage == 'booking' ? 'active' : ''}"
             href="${pageContext.request.contextPath}/booking">Đặt xe</a>
        </c:when>
        <c:otherwise>
          <a class="nav-link ${param.activePage == 'booking' ? 'active' : ''}"
             href="${pageContext.request.contextPath}/login">Đặt xe</a>
        </c:otherwise>
      </c:choose>

      <c:choose>
        <c:when test="${not empty sessionScope.account_id}">
          <a class="nav-link ${param.activePage == 'cart' ? 'active' : ''}"
             href="${pageContext.request.contextPath}/my-shopping-cart">Giỏ hàng</a>
        </c:when>
        <c:otherwise>
          <a class="nav-link ${param.activePage == 'cart' ? 'active' : ''}"
             href="${pageContext.request.contextPath}/login">Giỏ hàng</a>
        </c:otherwise>
      </c:choose>

      <c:if test="${sessionScope.role_id == 3}">
        <a class="nav-link admin-link"
           href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
      </c:if>
    </div>

    <div class="nav-actions">
      <c:choose>

        <%-- Chưa đăng nhập --%>
        <c:when test="${empty sessionScope.account_id}">
          <a href="${pageContext.request.contextPath}/login"    class="btn-login">Đăng nhập</a>
          <a href="${pageContext.request.contextPath}/register" class="btn-register">Đăng ký</a>
        </c:when>

        <%-- Đã đăng nhập --%>
        <c:otherwise>
          <a class="notif-wrap" href="${pageContext.request.contextPath}/profile">
            🔔
            <c:if test="${unreadCount > 0}">
              <span class="notif-badge">${unreadCount}</span>
            </c:if>
          </a>

          <%-- Dropdown avatar --%>
          <div class="dropdown">
            <div class="dropdown-toggle" onclick="navToggleDropdown(event)">
              <div class="user-avatar">
                  ${fn:substring(sessionScope.full_name, 0, 1)}
              </div>
              <span class="user-name">${sessionScope.full_name}</span>
              <span class="dropdown-caret">▼</span>
            </div>

            <div class="dropdown-menu" id="navDropdownMenu">
              <div class="dropdown-header">
                <div class="dropdown-header-name">${sessionScope.full_name}</div>
                <div class="dropdown-header-role">
                  <c:choose>
                    <c:when test="${sessionScope.role_id == 3}">Quản trị viên</c:when>
                    <c:otherwise>Khách hàng</c:otherwise>
                  </c:choose>
                </div>
              </div>
              <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Hồ sơ cá nhân</a>
              <a class="dropdown-item" href="${pageContext.request.contextPath}/my-bookings">Đơn đặt xe</a>
              <a class="dropdown-item" href="${pageContext.request.contextPath}/my-shopping-cart">Giỏ hàng</a>
              <c:if test="${sessionScope.role_id == 3}">
                <a class="dropdown-item admin"
                   href="${pageContext.request.contextPath}/admin/dashboard">Dashboard Admin</a>
              </c:if>
              <a class="dropdown-item logout"
                 href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
            </div>
          </div>
        </c:otherwise>

      </c:choose>
    </div>

  </div>
</nav>
<script src="${pageContext.request.contextPath}/assets/js/header.js"></script>

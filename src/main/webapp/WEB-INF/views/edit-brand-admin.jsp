<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
  <title>Title</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/edit-brand-admin.css">
</head>
<body>

<div class="sidebar">
  <div class="sidebar-header">Auto Cars Admin</div>

  <div class="menu-title">TỔNG QUAN</div>
  <a href="#" class="menu-item">Dashboard</a>

  <div class="menu-title">VẬN HÀNH</div>
  <a href="booking-admin" class="menu-item">Quản lý đặt xe</a>
  <a href="#" class="menu-item">Quản lý thanh toán</a>

  <div class="menu-title">DANH MỤC</div>
  <a href="brand-admin" class="menu-item active">Hãng xe</a>
  <a href="cars-admin"  class="menu-item">Loại xe</a>
  <a href="#" class="menu-item">Mã giảm giá</a>

  <div class="menu-title">KHÁCH HÀNG</div>
  <a href="#" class="menu-item">Khách hàng</a>
  <a href="#" class="menu-item">Đánh giá</a>
  <a href="#" class="menu-item">Member</a>

  <div class="menu-title">CÀI ĐẶT</div>
  <a href="#" class="menu-item">Quản lý giá cước</a>
  <a href="#" class="menu-item">Cài đặt hệ thống</a>
</div>

<div class="main-content">
  <div class="page-header">
    <h1 class="page-title">Sửa hãng xe</h1>
  </div>

  <div class="form-card">
    <h2>&#x270E; Sửa thông tin hãng xe</h2>

    <%--load brand từ db lên tu brandId đẩy set dữ liệu vào request cho cái brand, nhưng cái dó được điền sẵn vào form nếu có sủa thì đỡ mất công viết lại --%>
    <%--khi cap nhat thi seo post truyen lai cho edit -> controller -> thay doi db -> update db thanh nhung cai da duoc nhap vao--%>
    <form method="post" action="${pageContext.request.contextPath}/edit-brand" enctype="multipart/form-data">

      <input type="hidden" name="brandId" value="${brand.brandId}">

      <input type="hidden" name="oldLogo" value="${brand.logo}">

      <div class="form-group">
        <label>Tên hãng xe <span style="color:red">*</span></label>
        <input type="text" name="brandName" value="${brand.brandName}" required>
      </div>
      <div class="form-group">
        <label>Ảnh logo hiện tại</label>
        <c:choose>
          <c:when test="${not empty brand.logo}">
            <c:choose>
              <c:when test="${fn:startsWith(brand.logo, 'http')}">
                <img src="${brand.logo}" alt="logo" class="brand-logo-preview">
              </c:when>
              <c:otherwise>
                <img src="${pageContext.request.contextPath}/${brand.logo}" alt="logo" class="brand-logo-preview">
              </c:otherwise>
            </c:choose>
          </c:when>
          <c:otherwise>
            <p class="no-logo-text">Chưa có ảnh logo</p>
          </c:otherwise>
        </c:choose>
        <input type="file" name="logoFile" accept="image/*">
        <small>Chọn ảnh mới nếu muốn thay đổi logo, để trống nếu giữ ảnh hiện tại.</small>
      </div>
      <div class="form-group">
        <label>Quốc gia</label>
        <input type="text" name="country" value="${brand.country}">
      </div>
      <div class="form-group">
        <label>Mô tả</label>
        <textarea name="descriptionBrand">${brand.descriptionBrand}</textarea>
      </div>
              <%-- huy thi quay lai trang brand-admin  --%>
      <div class="form-footer">
        <a href="${pageContext.request.contextPath}/brand-admin" class="btn-cancel">Hủy</a>
        <button type="submit" class="btn-save">Cập nhật</button>
      </div>
    </form>
  </div>
</div>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Title</title>
  <title>Thêm hãng xe - Auto Cars Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cars-brand-admin.css">
</head>
<body>

<%-- ===== SIDEBAR ===== --%>
<div class="sidebar">
  <div class="sidebar-header">Auto Cars Admin</div>

  <div class="menu-title">TỔNG QUAN</div>
  <a href="#" class="menu-item">Dashboard</a>

  <div class="menu-title">VẬN HÀNH</div>
  <a href="booking-admin" class="menu-item">Quản lý đặt xe</a>
  <a href="#" class="menu-item">Quản lý thanh toán</a>

  <div class="menu-title">DANH MỤC</div>
  <a href="${pageContext.request.contextPath}/brand-admin" class="menu-item active">Hãng xe</a>
  <a href="${pageContext.request.contextPath}/cars-admin"  class="menu-item">Loại xe</a>
  <a href="#" class="menu-item">Mã giảm giá</a>

  <div class="menu-title">KHÁCH HÀNG</div>
  <a href="#" class="menu-item">Khách hàng</a>
  <a href="#" class="menu-item">Đánh giá</a>
  <a href="#" class="menu-item">Member</a>

  <div class="menu-title">CÀI ĐẶT</div>
  <a href="#" class="menu-item">Quản lý giá cước</a>
  <a href="#" class="menu-item">Cài đặt hệ thống</a>
</div>

<%-- ===== NỘI DUNG CHÍNH ===== --%>
<div class="main-content">
  <div class="page-header">
    <h1 class="page-title">Thêm hãng xe mới</h1>
  </div>

  <div class="form-card">
    <h2>+ Thêm hãng xe mới</h2>

    <%--
        form POST về /add-brand.
        AddBrandController.doPost() sẽ nhận và insert vào DB.
    --%>
    <form method="post" action="${pageContext.request.contextPath}/add-brand" enctype="multipart/form-data">

      <div class="form-group">
        <label>Tên hãng xe <span style="color:red">*</span></label>
        <input type="text" name="brandName" placeholder="VD: Toyota" required>
      </div>
      <div class="form-group">
        <label>Ảnh logo</label>
        <input type="file" name="logoFile" accept="image/*">
        <small>Chọn ảnh logo (jpg, png, ...) cho hãng xe. Có thể bỏ trống.</small>
      </div>
      <div class="form-group">
        <label>Quốc gia</label>
        <input type="text" name="country" placeholder="VD: Nhật Bản">
      </div>
      <div class="form-group">
        <label>Mô tả</label>
        <textarea name="descriptionBrand" placeholder="Mô tả ngắn về hãng xe..."></textarea>
      </div>

      <div class="form-footer">
        <%-- Nút Hủy quay về danh sách --%>
        <a href="${pageContext.request.contextPath}/brand-admin" class="btn-cancel">Hủy</a>
        <button type="submit" class="btn-save">Lưu hãng</button>
      </div>
    </form>
  </div>
</div>


</body>
</html>

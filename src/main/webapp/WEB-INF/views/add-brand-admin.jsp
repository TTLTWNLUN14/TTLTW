<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
  <title>Thêm hãng xe - Auto Cars Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cars-brand-admin.css">
  <style>
    .form-card {
      max-width: 560px;
      margin: 40px auto;
      background: #fff;
      border-radius: 12px;
      padding: 32px 36px;
      box-shadow: 0 4px 24px rgba(0,0,0,0.10);
    }
    .form-card h2 {
      font-size: 1.2rem;
      font-weight: 700;
      color: #0b1a2e;
      margin-bottom: 24px;
      border-bottom: 2px solid #e2e8f0;
      padding-bottom: 12px;
    }
    .form-group { margin-bottom: 16px; }
    .form-group label {
      display: block;
      font-size: 0.82rem;
      font-weight: 600;
      color: #64748b;
      margin-bottom: 5px;
      text-transform: uppercase;
      letter-spacing: 0.4px;
    }
    .form-group input[type="text"],
    .form-group textarea {
      width: 100%;
      padding: 9px 12px;
      border: 1px solid #d1d5db;
      border-radius: 6px;
      font-size: 0.9rem;
      box-sizing: border-box;
      transition: border-color 0.2s;
    }
    .form-group input:focus,
    .form-group textarea:focus { outline: none; border-color: #1d549a; }
    .form-group textarea { height: 90px; resize: vertical; }
    .form-footer {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      margin-top: 24px;
      border-top: 1px solid #e2e8f0;
      padding-top: 18px;
    }
    .btn-cancel {
      padding: 9px 22px;
      border: 1px solid #d1d5db;
      background: #fff;
      border-radius: 6px;
      cursor: pointer;
      font-size: 0.9rem;
      color: #555;
      text-decoration: none;
    }
    .btn-cancel:hover { background: #f1f5f9; }
    .btn-save {
      padding: 9px 22px;
      background: #1d549a;
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 0.9rem;
      font-weight: 600;
    }
    .btn-save:hover { background: #15407a; }
  </style>
</head>
<body>

<%-- ===== SIDEBAR ===== --%>
<div class="sidebar">
  <div class="sidebar-header">Auto Cars Admin</div>

  <div class="menu-title">TỔNG QUAN</div>
  <a href="#" class="menu-item">Dashboard</a>

  <div class="menu-title">VẬN HÀNH</div>
  <a href="#" class="menu-item">Quản lý đặt xe</a>
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
    <form method="post" action="${pageContext.request.contextPath}/add-brand">

      <div class="form-group">
        <label>Tên hãng xe <span style="color:red">*</span></label>
        <input type="text" name="brandName" placeholder="VD: Toyota" required>
      </div>
      <div class="form-group">
        <label>URL Logo</label>
        <input type="text" name="logo" placeholder="https://example.com/logo.png">
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

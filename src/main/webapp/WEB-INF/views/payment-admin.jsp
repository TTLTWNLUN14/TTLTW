<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản lý thanh toán - Auto Cars Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/payment-admin.css">
</head>
<body>

<div class="sidebar">
  <div class="sidebar-header">Auto Cars Admin</div>

  <div class="menu-title">TỔNG QUAN</div>
  <a href="dashboard-admin.jsp" class="menu-item">Dashboard</a>

  <div class="menu-title">VẬN HÀNH</div>
  <a href="booking-admin.jsp" class="menu-item">Quản lý đặt xe</a>
  <a href="payment-admin.jsp" class="menu-item active">Quản lý thanh toán</a>

  <div class="menu-title">DANH MỤC</div>
  <a href="cars-brand-admin.jsp" class="menu-item">Hãng xe</a>
  <a href="cars-admin.jsp" class="menu-item">Loại xe</a>
  <a href="coupon-admin.jsp" class="menu-item">Mã giảm giá</a>

  <div class="menu-title">KHÁCH HÀNG</div>
  <a href="#" class="menu-item">Khách hàng</a>
  <a href="#" class="menu-item">Đánh giá</a>
</div>

<div class="main-content">
  <div class="page-header">
    <h2>Quản lý thanh toán</h2>
    <button class="btn-primary" onclick="openModal('add-modal')">+ Thêm thanh toán</button>
  </div>

  <div class="filter-section" style="margin-bottom: 20px; display: flex; gap: 10px;">
    <input type="text" class="form-control" placeholder="Tìm kiếm mã giao dịch, khách hàng..." style="width: 300px;">
    <select class="form-control" style="width: 200px;">
      <option value="">Tất cả trạng thái</option>
      <option value="paid">Đã thanh toán</option>
      <option value="pending">Chờ xử lý</option>
      <option value="failed">Thất bại</option>
    </select>
    <button class="btn-primary">Lọc</button>
  </div>

  <div class="table-responsive">
    <table class="table">
      <thead>
      <tr>
        <th>Mã GD</th>
        <th>Khách hàng</th>
        <th>Ngày giao dịch</th>
        <th>Số tiền</th>
        <th>Phương thức</th>
        <th>Trạng thái</th>
        <th>Thao tác</th>
      </tr>
      </thead>
      <tbody>
      <tr>
        <td>#PAY1023</td>
        <td>Trần Văn Bình</td>
        <td>15/05/2026 09:30</td>
        <td>2.000.000đ</td>
        <td>Chuyển khoản (QR)</td>
        <td><span class="badge badge-green">Đã thanh toán</span></td>
        <td>
          <button class="btn-action" style="color: blue;" onclick="openModal('add-modal')">Sửa</button>
          <button class="btn-action" style="color: orange;" onclick="openModal('refund-modal')">Hoàn tiền</button>
          <button class="btn-action" style="color: red;" onclick="openModal('delete-modal')">Xóa</button>
        </td>
      </tr>
      <tr>
        <td>#PAY1024</td>
        <td>Nguyễn Thị Mai</td>
        <td>16/05/2026 14:15</td>
        <td>1.500.000đ</td>
        <td>Tiền mặt</td>
        <td><span class="badge badge-yellow">Chờ xử lý</span></td>
        <td>
          <button class="btn-action" style="color: blue;" onclick="openModal('add-modal')">Sửa</button>
          <button class="btn-action" style="color: red;" onclick="openModal('delete-modal')">Xóa</button>
        </td>
      </tr>
      </tbody>
    </table>
  </div>
</div>

<div id="add-modal" class="modal">
  <div class="modal-content">
    <h2>Cập nhật thông tin thanh toán</h2>
    <div class="form-group" style="margin-top: 15px;">
      <label>Trạng thái giao dịch</label>
      <select class="form-control">
        <option>Đã thanh toán</option>
        <option>Chờ xử lý</option>
        <option>Thất bại</option>
      </select>
    </div>
    <div class="modal-actions">
      <button class="btn-cancel" onclick="closeModal('add-modal')">Hủy</button>
      <button class="btn-save" onclick="closeModal('add-modal')">Lưu thông tin</button>
    </div>
  </div>
</div>

<div id="delete-modal" class="modal">
  <div class="modal-content text-center">
    <h2 class="text-red">Xác nhận xóa</h2>
    <p>Bạn có chắc chắn muốn xóa giao dịch thanh toán này không?</p>
    <div class="modal-actions center">
      <button class="btn-cancel" onclick="closeModal('delete-modal')">Hủy</button>
      <button class="btn-delete-confirm" onclick="closeModal('delete-modal')">Xóa ngay</button>
    </div>
  </div>
</div>

<div id="refund-modal" class="modal">
  <div class="modal-content text-center">
    <h2>Xử lý hoàn tiền</h2>
    <p>Xác nhận hoàn <strong class="text-orange">2.000.000đ</strong> cho khách hàng <strong>Trần Văn Bình</strong>?</p>
    <div class="modal-actions center">
      <button class="btn-cancel" onclick="closeModal('refund-modal')">Hủy</button>
      <button class="btn-save" onclick="closeModal('refund-modal')">Xác nhận hoàn tiền</button>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/payment-admin.js"></script>

</body>
</html>
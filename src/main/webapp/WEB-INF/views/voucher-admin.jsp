<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lí mã giảm giá - Auto Cars Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/voucher-admin.css">
</head>
<body>
<div class="sidebar">
    <div class="sidebar-header">Auto Cars Admin</div>
    <div class="menu-title">TỔNG QUAN</div>
    <a href="dashboard-admin.jsp" class="menu-item">Dashboard</a>
    <div class="menu-title">VẬN HÀNH</div>
    <a href="booking-admin.jsp" class="menu-item">Quản lý đặt xe</a>
    <a href="payment-admin.jsp" class="menu-item">Quản lý thanh toán</a>
    <div class="menu-title">DANH MỤC</div>
    <a href="cars-brand-admin.jsp" class="menu-item">Hãng xe</a>
    <a href="cars-admin.jsp" class="menu-item">Loại xe</a>
    <a href="${pageContext.request.contextPath}/admin/voucher" class="menu-item active">Mã giảm giá</a>
    <div class="menu-title">KHÁCH HÀNG</div>
    <a href="#" class="menu-item">Khách hàng</a>
    <a href="#" class="menu-item">Đánh giá</a>
</div>

<main class="main-content">
    <div class="page-header">
        <h1 class="page-title">Quản lý mã giảm giá</h1>
        <button class="btn-add" id="openAddModalBtn">+ Thêm mã giảm giá</button>
    </div>

    <!-- Hiển thị thông báo -->
    <c:if test="${param.success != null}">
        <div class="alert alert-success">Thao tác thành công!</div>
    </c:if>
    <c:if test="${param.error != null}">
        <div class="alert alert-danger">Có lỗi xảy ra, vui lòng thử lại!</div>
    </c:if>

    <div class="table-container">
        <table class="custom-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Mã Code</th>
                <th>Tên Voucher</th>
                <th>Giảm giá (%)</th>
                <th>Giảm tối đa</th>
                <th>Đơn tối thiểu</th>
                <th>Hạng KH</th>
                <th>Lượt dùng</th>
                <th>Hết hạn</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="v" items="${listVouchers}">
                <tr>
                    <td>${v.voucherId}</td>
                    <td>${v.code}</td>
                    <td>${v.nameVoucher}</td>
                    <td>${v.discount}%</td>
                    <td>${v.priceMaxDiscount}</td>
                    <td>${v.minOrder}</td>
                    <td>${v.minTier}</td>
                    <td>${v.usesLeft}</td>
                    <td>${v.expiresAt}</td>
                    <td>${v.active ? "Kích hoạt" : "Vô hiệu"}</td>
                    <td>
                        <button class="btn-edit" data-id="${v.voucherId}"
                                data-code="${v.code}"
                                data-name="${v.nameVoucher}"
                                data-discount="${v.discount}"
                                data-maxdiscount="${v.priceMaxDiscount}"
                                data-minorder="${v.minOrder}"
                                data-mintier="${v.minTier}"
                                data-usesleft="${v.usesLeft}"
                                data-expires="${v.expiresAt}"
                                data-active="${v.active}">Sửa</button>
                        <form method="post" style="display:inline" onsubmit="return confirm('Xóa voucher này?')">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="voucherId" value="${v.voucherId}">
                            <button type="submit" class="btn-delete">Xóa</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty listVouchers}">
                <tr><td colspan="11" style="text-align:center">Chưa có mã giảm giá nào.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</main>

<!-- Modal Thêm voucher -->
<div id="addModal" class="modal">
    <div class="modal-content">
        <h3>Thêm mã giảm giá</h3>
        <form method="post" action="${pageContext.request.contextPath}/admin/voucher">
            <input type="hidden" name="action" value="create">
            <input type="text" name="code" placeholder="Mã code *" required>
            <input type="text" name="nameVoucher" placeholder="Tên voucher *" required>
            <input type="number" step="0.01" name="discount" placeholder="Giảm giá (%) *" required>
            <input type="number" name="priceMaxDiscount" placeholder="Giảm tối đa (VNĐ) *" required>
            <input type="number" step="0.01" name="minOrder" placeholder="Đơn hàng tối thiểu *" required>
            <input type="text" name="minTier" placeholder="Hạng khách hàng (VD: Silver, Gold)">
            <input type="number" name="usesLeft" placeholder="Số lượt còn *" required>
            <input type="datetime-local" name="expiresAt" required>
            <label><input type="checkbox" name="isActive" checked> Kích hoạt ngay</label>
            <div class="modal-buttons">
                <button type="button" class="close-btn" onclick="closeModal('addModal')">Đóng</button>
                <button type="submit" class="submit-btn">Thêm</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Sửa voucher -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <h3>Chỉnh sửa mã giảm giá</h3>
        <form method="post" action="${pageContext.request.contextPath}/admin/voucher">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="voucherId" id="editVoucherId">
            <input type="text" name="code" id="editCode" required>
            <input type="text" name="nameVoucher" id="editName" required>
            <input type="number" step="0.01" name="discount" id="editDiscount" required>
            <input type="number" name="priceMaxDiscount" id="editPriceMaxDiscount" required>
            <input type="number" step="0.01" name="minOrder" id="editMinOrder" required>
            <input type="text" name="minTier" id="editMinTier">
            <input type="number" name="usesLeft" id="editUsesLeft" required>
            <input type="datetime-local" name="expiresAt" id="editExpiresAt" required>
            <label><input type="checkbox" name="isActive" id="editIsActive"> Kích hoạt</label>
            <div class="modal-buttons">
                <button type="button" class="close-btn" onclick="closeModal('editModal')">Đóng</button>
                <button type="submit" class="submit-btn">Cập nhật</button>
            </div>
        </form>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/voucher-admin.js"></script>
</body>
</html>
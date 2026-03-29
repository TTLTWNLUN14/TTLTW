<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
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
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-item">Dashboard</a>

    <div class="menu-title">VẬN HÀNH</div>
    <a href="${pageContext.request.contextPath}/admin/bookings" class="menu-item">Quản lý đặt xe</a>
    <a href="${pageContext.request.contextPath}/admin/payments" class="menu-item active">Quản lý thanh toán</a>

    <div class="menu-title">DANH MỤC</div>
    <a href="${pageContext.request.contextPath}/admin/brands" class="menu-item">Hãng xe</a>
    <a href="${pageContext.request.contextPath}/admin/cars" class="menu-item">Loại xe</a>
    <a href="${pageContext.request.contextPath}/admin/vouchers" class="menu-item">Mã giảm giá</a>

    <div class="menu-title">KHÁCH HÀNG</div>
    <a href="${pageContext.request.contextPath}/admin/customers" class="menu-item">Khách hàng</a>
    <a href="${pageContext.request.contextPath}/admin/reviews" class="menu-item">Đánh giá</a>
    <a href="${pageContext.request.contextPath}/admin/members" class="menu-item">Member</a>

    <div class="menu-title">CÀI ĐẶT</div>
    <a href="${pageContext.request.contextPath}/admin/pricing" class="menu-item">Quản lý giá cước</a>
    <a href="${pageContext.request.contextPath}/logout" class="menu-item text-danger" style="margin-top: 20px; color: #dc3545;">Đăng xuất</a>
</div>

<div class="main-content">
    <div class="content-header">
        <h2 class="content-title">Quản lý thanh toán</h2>
        <button class="btn-primary" onclick="openCreateModal()">+ Tạo thanh toán mới</button>
    </div>

    <c:if test="${param.error == 'true'}">
        <div style="color: #dc3545; background-color: #f8d7da; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
            Đã xảy ra lỗi trong quá trình xử lý!
        </div>
    </c:if>

    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>Mã TT</th>
                <th>Mã Booking</th>
                <th>Mã KH</th>
                <th>Số tiền</th>
                <th>Phương thức</th>
                <th>Loại trả</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${listPayments}" var="p">
                <tr>
                    <td class="text-orange">#PAY-<fmt:formatNumber value="${p.paymentId}" minIntegerDigits="4" pattern="0000"/></td>
                    <td>#AC-<fmt:formatNumber value="${p.bookingId}" minIntegerDigits="4" pattern="0000"/></td>
                    <td>KH-${p.accountId}</td>
                    <td class="text-orange fw-bold"><fmt:formatNumber value="${p.price}" pattern="#,###"/> đ</td>
                    <td>${p.method == 'TRANSFER' ? 'Chuyển khoản' : 'Tiền mặt'}</td>
                    <td>${p.payType}</td>
                    <td>
                        <c:choose>
                            <c:when test="${p.status == 'SUCCESS'}"><span class="status-badge bg-success">Thành công</span></c:when>
                            <c:when test="${p.status == 'FAILED'}"><span class="status-badge bg-danger">Thất bại</span></c:when>
                            <c:otherwise><span class="status-badge bg-warning">Chờ duyệt</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td class="action-buttons">
                        <c:if test="${p.status == 'PENDING'}">
                            <form action="${pageContext.request.contextPath}/admin/payments" method="POST">
                                <input type="hidden" name="paymentId" value="${p.paymentId}">
                                <input type="hidden" name="action" value="approve">
                                <button type="submit" class="btn-approve" title="Duyệt">&#10003;</button>
                            </form>
                        </c:if>

                        <button type="button" class="btn-edit" title="Sửa"
                                onclick="openEditModal(${p.paymentId}, ${p.bookingId}, ${p.accountId}, ${p.price}, '${p.method}', '${p.payType}', '${p.status}')">
                            &#x270E;
                        </button>

                        <form action="${pageContext.request.contextPath}/admin/payments" method="POST" onsubmit="return confirm('Xác nhận xóa thanh toán này?');">
                            <input type="hidden" name="paymentId" value="${p.paymentId}">
                            <input type="hidden" name="action" value="delete">
                            <button type="submit" class="btn-reject" title="Xóa/Hủy">&#10005;</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<div id="createModal" class="modal">
    <div class="modal-content">
        <span class="close-modal" onclick="closeModal('createModal')">&times;</span>
        <h3>Tạo Thanh Toán Mới</h3>
        <form action="${pageContext.request.contextPath}/admin/payments" method="POST" style="margin-top: 15px;">
            <input type="hidden" name="action" value="create">
            <div class="form-group"><label>Mã Booking</label><input type="number" name="bookingId" required></div>
            <div class="form-group"><label>Mã Khách Hàng</label><input type="number" name="accountId" required></div>
            <div class="form-group"><label>Số Tiền</label><input type="number" name="price" required></div>
            <div class="form-group">
                <label>Phương thức</label>
                <select name="method" required><option value="CASH">Tiền mặt</option><option value="TRANSFER">Chuyển khoản</option></select>
            </div>
            <div class="form-group">
                <label>Loại thanh toán</label>
                <select name="payType" required><option value="FULL">Toàn bộ (100%)</option><option value="DEPOSIT">Đặt cọc</option></select>
            </div>
            <div class="form-group">
                <label>Trạng thái</label>
                <select name="status" required><option value="PENDING">Đang chờ (PENDING)</option><option value="SUCCESS">Thành công (SUCCESS)</option></select>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeModal('createModal')">Hủy</button>
                <button type="submit" class="btn-primary">Tạo mới</button>
            </div>
        </form>
    </div>
</div>

<div id="editModal" class="modal">
    <div class="modal-content">
        <span class="close-modal" onclick="closeModal('editModal')">&times;</span>
        <h3>Sửa Thông Tin Thanh Toán</h3>
        <form action="${pageContext.request.contextPath}/admin/payments" method="POST" style="margin-top: 15px;">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="paymentId" id="edit-paymentId">
            <div class="form-group"><label>Mã Booking</label><input type="number" name="bookingId" id="edit-bookingId" required></div>
            <div class="form-group"><label>Mã Khách Hàng</label><input type="number" name="accountId" id="edit-accountId" required></div>
            <div class="form-group"><label>Số Tiền</label><input type="number" name="price" id="edit-price" required></div>
            <div class="form-group">
                <label>Phương thức</label>
                <select name="method" id="edit-method" required><option value="CASH">Tiền mặt</option><option value="TRANSFER">Chuyển khoản</option></select>
            </div>
            <div class="form-group">
                <label>Loại thanh toán</label>
                <select name="payType" id="edit-payType" required><option value="FULL">Toàn bộ (100%)</option><option value="DEPOSIT">Đặt cọc</option></select>
            </div>
            <div class="form-group">
                <label>Trạng thái</label>
                <select name="status" id="edit-status" required><option value="PENDING">PENDING</option><option value="SUCCESS">SUCCESS</option><option value="FAILED">FAILED</option></select>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeModal('editModal')">Hủy</button>
                <button type="submit" class="btn-primary">Cập nhật</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openCreateModal() { document.getElementById('createModal').style.display = 'block'; }
    function openEditModal(pId, bId, aId, price, method, pType, status) {
        document.getElementById('edit-paymentId').value = pId;
        document.getElementById('edit-bookingId').value = bId;
        document.getElementById('edit-accountId').value = aId;
        document.getElementById('edit-price').value = price;
        document.getElementById('edit-method').value = method;
        document.getElementById('edit-payType').value = pType;
        document.getElementById('edit-status').value = status;
        document.getElementById('editModal').style.display = 'block';
    }
    function closeModal(modalId) { document.getElementById(modalId).style.display = 'none'; }
    window.onclick = function(e) {
        if (e.target == document.getElementById('createModal')) closeModal('createModal');
        if (e.target == document.getElementById('editModal')) closeModal('editModal');
    }
</script>

</body>
</html>
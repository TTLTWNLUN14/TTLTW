<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cài đặt hệ thống - Auto Cars Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cars-admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/settings-admin.css">
</head>
<body>

<div class="sidebar">
    <div class="sidebar-header">Auto Cars Admin</div>

    <div class="menu-title">TỔNG QUAN</div>
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-item">Dashboard</a>

    <div class="menu-title">VẬN HÀNH</div>
    <a href="${pageContext.request.contextPath}/admin/bookings" class="menu-item">Quản lý đặt xe</a>
    <a href="${pageContext.request.contextPath}/admin/payments" class="menu-item">Quản lý thanh toán</a>

    <div class="menu-title">DANH MỤC</div>
    <a href="${pageContext.request.contextPath}/brand-admin" class="menu-item">Hãng xe</a>
    <a href="${pageContext.request.contextPath}/cars-admin" class="menu-item">Loại xe</a>
    <a href="#" class="menu-item">Mã giảm giá</a>

    <div class="menu-title">KHÁCH HÀNG</div>
    <a href="#" class="menu-item">Khách hàng</a>
    <a href="#" class="menu-item">Đánh giá</a>
    <a href="${pageContext.request.contextPath}/admin/members" class="menu-item">Member</a>

    <div class="menu-title">CÀI ĐẶT</div>
    <a href="#" class="menu-item">Quản lý giá cước</a>
    <a href="${pageContext.request.contextPath}/admin/settings" class="menu-item active">Cài đặt hệ thống</a>
</div>

<div class="main-content">

    <c:if test="${flashType == 'success'}">
        <div class="toast-success" id="toastMsg">${flashMsg}</div>
    </c:if>
    <c:if test="${flashType == 'error'}">
        <div class="toast-error" id="toastMsg">${flashMsg}</div>
    </c:if>

    <div class="page-header">
        <h1 class="page-title">Quản lý tài khoản quản trị</h1>
        <button type="button" class="btn-add" onclick="openCreateModal()">+ Thêm tài khoản</button>
    </div>

    <p style="color:#64748b; font-size:0.9rem; margin-bottom:18px;">
        Chỉ <strong style="color:#0b1a2e;">Super Admin</strong> mới có quyền thêm / sửa / xóa tài khoản quản trị viên.
        Tổng cộng <strong style="color:#0b1a2e;">${totalAdmins}</strong> tài khoản quản trị
        (<strong style="color:#0b1a2e;">${totalSuperAdmins}</strong> Super Admin).
    </p>

    <div class="filter-bar">
        <label>Tìm:</label>
        <input type="text" id="searchInput" placeholder="Tên, email, username, SĐT…" oninput="filterTable()">

        <label>Vai trò:</label>
        <select id="roleFilter" onchange="filterTable()">
            <option value="">-- Tất cả --</option>
            <option value="0">Super Admin</option>
            <option value="1">Admin</option>
        </select>

        <label>Trạng thái:</label>
        <select id="statusFilter" onchange="filterTable()">
            <option value="">-- Tất cả --</option>
            <option value="active">Đang hoạt động</option>
            <option value="locked">Đã khóa</option>
        </select>
    </div>

    <div class="table-container">
        <table class="custom-table" id="adminTable">
            <thead>
            <tr>
                <th>ID</th>
                <th>Họ và tên</th>
                <th>Tên đăng nhập</th>
                <th>Email</th>
                <th>Số điện thoại</th>
                <th>Vai trò</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="a" items="${admins}">
                <tr data-role="${a.role_id}" data-status="${a.is_active ? 'active' : 'locked'}">
                    <td><strong>#${a.account_id}</strong></td>
                    <td>
                            ${a.full_name}
                        <c:if test="${a.account_id == sessionScope.account_id}">
                            <span class="badge-you">Bạn</span>
                        </c:if>
                    </td>
                    <td>${a.username}</td>
                    <td>${a.email}</td>
                    <td>${a.phone}</td>
                    <td>
                        <c:choose>
                            <c:when test="${a.role_id == 0}">
                                <span class="role-badge role-super">Super Admin</span>
                            </c:when>
                            <c:otherwise>
                                <span class="role-badge role-admin">Admin</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${a.is_active}"><span class="status-active">● Hoạt động</span></c:when>
                            <c:otherwise><span class="status-locked">● Đã khóa</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td class="action-buttons">
                        <button type="button" class="btn-edit"
                                onclick="openEditModal(
                                    ${a.account_id},
                                        '${a.full_name}',
                                        '${a.username}',
                                        '${a.email}',
                                        '${a.phone}',
                                    ${a.role_id},
                                    ${a.is_active}
                                        )">&#x270E; Sửa
                        </button>

                        <c:if test="${a.account_id != sessionScope.account_id}">
                            <c:choose>
                                <c:when test="${a.is_active}">
                                    <button type="button" class="btn-lock"
                                            onclick="openToggleStatusModal('${a.account_id}', '${a.full_name}', true)">
                                        Khóa
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" class="btn-unlock"
                                            onclick="openToggleStatusModal('${a.account_id}', '${a.full_name}', false)">
                                        Mở
                                    </button>
                                </c:otherwise>
                            </c:choose>

                            <button type="button" class="btn-delete"
                                    onclick="openDeleteModal('${a.account_id}', '${a.full_name}')">Xóa
                            </button>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty admins}">
                <tr>
                    <td colspan="8" style="text-align:center; padding:40px; color:#94a3b8;">
                        Chưa có tài khoản quản trị nào.
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

</div>

<div id="createModal" class="modal-wrapper">
    <div class="modal-box">
        <div class="modal-header">
            <h3>Thêm tài khoản quản trị</h3>
            <span class="modal-close" onclick="closeCreateModal()">&times;</span>
        </div>
        <div class="modal-body">
            <form method="POST" action="${pageContext.request.contextPath}/admin/settings">
                <input type="hidden" name="action" value="create">

                <div class="form-group">
                    <label>Họ và tên *</label>
                    <input type="text" name="fullName" required>
                </div>
                <div class="form-group">
                    <label>Tên đăng nhập *</label>
                    <input type="text" name="username" required>
                </div>
                <div class="form-group">
                    <label>Email *</label>
                    <input type="email" name="email" required>
                </div>
                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input type="text" name="phone">
                </div>
                <div class="form-group">
                    <label>Mật khẩu *</label>
                    <input type="password" name="password" minlength="6" required>
                </div>
                <input type="hidden" name="roleId" value="1">
                <p style="color:#94a3b8; font-size:0.8rem; margin:-6px 0 14px;">
                    Tài khoản mới sẽ được tạo với vai trò <strong>Admin</strong>.
                    Super Admin không thể tạo thêm tài khoản Super Admin khác.
                </p>

                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeCreateModal()">Hủy</button>
                    <button type="submit" class="btn-add">Tạo tài khoản</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div id="editModal" class="modal-wrapper">
    <div class="modal-box">
        <div class="modal-header">
            <h3>Chỉnh sửa tài khoản quản trị</h3>
            <span class="modal-close" onclick="closeEditModal()">&times;</span>
        </div>
        <div class="modal-body">
            <form method="POST" action="${pageContext.request.contextPath}/admin/settings">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="accountId" id="modalAccountId">

                <div class="form-group">
                    <label>Họ và tên *</label>
                    <input type="text" name="fullName" id="modalFullName" required>
                </div>
                <div class="form-group">
                    <label>Tên đăng nhập</label>
                    <input type="text" id="modalUsername" readonly>
                </div>
                <div class="form-group">
                    <label>Email *</label>
                    <input type="email" name="email" id="modalEmail" required>
                </div>
                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input type="text" name="phone" id="modalPhone">
                </div>
                <div class="form-group">
                    <label>Mật khẩu mới (để trống nếu không đổi)</label>
                    <input type="password" name="newPassword" id="modalNewPassword" minlength="6"
                           placeholder="••••••••">
                </div>
                <div class="form-group">
                    <label>Vai trò *</label>
                    <select name="roleId" id="modalRoleId" required>
                        <option value="1">Admin</option>
                        <option value="0" id="modalSuperAdminOption">Super Admin</option>
                    </select>
                    <small style="display:none; color:#94a3b8;" id="modalRoleHint">
                        Không thể nâng quyền tài khoản Admin lên Super Admin.
                    </small>
                </div>
                <div class="form-group">
                    <label>Trạng thái *</label>
                    <select name="isActive" id="modalIsActive" required>
                        <option value="true">Đang hoạt động</option>
                        <option value="false">Đã khóa</option>
                    </select>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeEditModal()">Hủy</button>
                    <button type="submit" class="btn-add">Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div id="deleteModal" class="modal-wrapper">
    <div class="modal-box">
        <div class="modal-header">
            <h3>Xác nhận xóa tài khoản</h3>
            <span class="modal-close" onclick="closeDeleteModal()">&times;</span>
        </div>
        <div class="modal-body">
            <p>Bạn có chắc chắn muốn xóa tài khoản <strong id="deleteTargetName">...</strong>?</p>
            <small class="text-danger">Hành động này không thể hoàn tác.</small>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn-cancel" onclick="closeDeleteModal()">Hủy bỏ</button>

            <form id="realDeleteForm" action="${pageContext.request.contextPath}/admin/settings" method="post"
                  style="display:inline; margin:0;">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="accountId" id="deleteAccountId">
                <button type="submit" class="btn-confirm-delete">Xác nhận xóa</button>
            </form>
        </div>
    </div>
</div>

<div id="toggleStatusModal" class="modal-wrapper">
    <div class="modal-box">
        <div class="modal-header">
            <h3 id="toggleStatusTitle">Xác nhận</h3>
            <span class="modal-close" onclick="closeToggleStatusModal()">&times;</span>
        </div>
        <div class="modal-body">
            <p id="toggleStatusMessage"></p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn-cancel" onclick="closeToggleStatusModal()">Hủy bỏ</button>

            <form action="${pageContext.request.contextPath}/admin/settings" method="post"
                  style="display:inline; margin:0;">
                <input type="hidden" name="action" value="toggleStatus">
                <input type="hidden" name="accountId" id="toggleAccountId">
                <input type="hidden" name="lock" id="toggleLockValue">
                <button type="submit" class="btn-add" id="toggleSubmitBtn">Xác nhận</button>
            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/settings-admin.js"></script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%

    Integer roleId = (Integer) session.getAttribute("role_id");
    if (roleId == null || roleId != 3) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String flashMsg  = (String) session.getAttribute("flashMsg");
    String flashType = (String) session.getAttribute("flashType");
    session.removeAttribute("flashMsg");
    session.removeAttribute("flashType");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Member – Auto Cars Admin</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/member-admin.css">
</head>
<body>


<div class="sidebar">
    <div class="sidebar-header">Auto Cars Admin</div>

    <div class="menu-title">Tổng quan</div>
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-item">Dashboard</a>

    <div class="menu-title">Vận hành</div>
    <a href="${pageContext.request.contextPath}/admin/bookings"  class="menu-item">Quản lý đặt xe</a>
    <a href="${pageContext.request.contextPath}/admin/payments"  class="menu-item">Quản lý thanh toán</a>

    <div class="menu-title">Danh mục</div>
    <a href="${pageContext.request.contextPath}/admin/brands"    class="menu-item">Hãng xe</a>
    <a href="${pageContext.request.contextPath}/admin/cars"      class="menu-item">Loại xe</a>
    <a href="${pageContext.request.contextPath}/admin/vouchers"  class="menu-item">Mã giảm giá</a>

    <div class="menu-title">Khách hàng</div>
    <a href="${pageContext.request.contextPath}/admin/customers" class="menu-item">Khách hàng</a>
    <a href="${pageContext.request.contextPath}/admin/reviews"   class="menu-item">Đánh giá</a>
    <a href="${pageContext.request.contextPath}/admin/members"   class="menu-item active">Member</a>

    <div class="menu-title">Cài đặt</div>
    <a href="${pageContext.request.contextPath}/admin/pricing"   class="menu-item">Quản lý giá cước</a>
    <a href="${pageContext.request.contextPath}/admin/settings"  class="menu-item">Cài đặt hệ thống</a>
</div>


<div class="main-content">


    <% if (flashMsg != null && !flashMsg.isBlank()) { %>
    <div class="flash <%= "success".equals(flashType) ? "success" : "error" %>">
        <%= flashMsg %>
    </div>
    <% } %>


    <div class="page-header">
        <div>
            <div class="page-title">Quản lý Member</div>
            <div class="page-sub">Tổng cộng <strong>${totalMembers}</strong> thành viên đã đăng ký</div>
        </div>
    </div>

    <div class="stat-row">
        <div class="stat-card">
            <div class="stat-label">Tổng thành viên</div>
            <div class="stat-value">${totalMembers}</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Diamond</div>
            <div class="stat-value" style="color:#8b5cf6;">
                <c:set var="diamondCount" value="0"/>
                <c:forEach var="m" items="${members}">
                    <c:if test="${m.memberTier eq 'Diamond'}"><c:set var="diamondCount" value="${diamondCount + 1}"/></c:if>
                </c:forEach>
                ${diamondCount}
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Platinum</div>
            <div class="stat-value" style="color:#0ea5e9;">
                <c:set var="platCount" value="0"/>
                <c:forEach var="m" items="${members}">
                    <c:if test="${m.memberTier eq 'Platinum'}"><c:set var="platCount" value="${platCount + 1}"/></c:if>
                </c:forEach>
                ${platCount}
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Gold</div>
            <div class="stat-value" style="color:#f5b82e;">
                <c:set var="goldCount" value="0"/>
                <c:forEach var="m" items="${members}">
                    <c:if test="${m.memberTier eq 'Gold'}"><c:set var="goldCount" value="${goldCount + 1}"/></c:if>
                </c:forEach>
                ${goldCount}
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Silver</div>
            <div class="stat-value" style="color:#9ca3af;">
                <c:set var="silverCount" value="0"/>
                <c:forEach var="m" items="${members}">
                    <c:if test="${m.memberTier eq 'Silver'}"><c:set var="silverCount" value="${silverCount + 1}"/></c:if>
                </c:forEach>
                ${silverCount}
            </div>
        </div>
    </div>


    <div class="filter-bar">
        <input type="text" id="searchInput" placeholder=" Tìm tên, email, SĐT…" oninput="filterTable()">
        <select id="tierFilter" onchange="filterTable()">
            <option value="">Tất cả hạng</option>
            <option value="Diamond">Diamond</option>
            <option value="Platinum">Platinum</option>
            <option value="Gold">Gold</option>
            <option value="Silver">Silver</option>
            <option value="Standard">Standard</option>
        </select>
        <select id="statusFilter" onchange="filterTable()">
            <option value="">Tất cả trạng thái</option>
            <option value="active">Đang hoạt động</option>
            <option value="locked">Đã khóa</option>
        </select>
    </div>

    <div class="table-container">
        <table class="custom-table" id="memberTable">
            <thead>
            <tr>
                <th>Mã TV</th>
                <th>Họ và tên</th>
                <th>Số điện thoại</th>
                <th>Email</th>
                <th>Hạng</th>
                <th>Điểm</th>
                <th>Số chuyến</th>
                <th>Tổng chi tiêu</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="m" items="${members}">
                <tr data-tier="${m.memberTier}" data-status="${m.active ? 'active' : 'locked'}">
                    <td><strong>${m.displayId}</strong></td>
                    <td>${m.fullName}</td>
                    <td>${m.phone}</td>
                    <td style="color:#64748b;">${m.email}</td>
                    <td>
                        <span class="tier-badge tier-${m.memberTier.toLowerCase()}">${m.memberTier}</span>
                    </td>
                    <td><span class="badge-pts">${m.points}</span></td>
                    <td>${m.totalTrips}</td>
                    <td class="text-money">
                        <fmt:formatNumber value="${m.totalSpent}" pattern="#,##0"/>đ
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${m.active}"><span class="status-active">● Hoạt động</span></c:when>
                            <c:otherwise><span class="status-locked">● Đã khóa</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div class="action-buttons">

                            <button class="btn-edit"
                                    onclick="openEditModal(
                                        ${m.customerId},
                                            '${m.fullName}',
                                            '${m.email}',
                                            '${m.memberTier}',
                                        ${m.points}
                                            )"> Sửa</button>

                            <c:choose>
                                <c:when test="${m.active}">
                                    <form method="POST" action="${pageContext.request.contextPath}/admin/members"
                                          style="display:inline;"
                                          onsubmit="return confirm('Bạn chắc chắn muốn khóa tài khoản này?')">
                                        <input type="hidden" name="action"     value="toggleStatus">
                                        <input type="hidden" name="customerId" value="${m.customerId}">
                                        <input type="hidden" name="lock"       value="true">
                                        <button type="submit" class="btn-lock"> Khóa</button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <form method="POST" action="${pageContext.request.contextPath}/admin/members"
                                          style="display:inline;">
                                        <input type="hidden" name="action"     value="toggleStatus">
                                        <input type="hidden" name="customerId" value="${m.customerId}">
                                        <input type="hidden" name="lock"       value="false">
                                        <button type="submit" class="btn-unlock"> Mở</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty members}">
                <tr><td colspan="10" style="text-align:center;padding:40px;color:#94a3b8;">
                    Chưa có thành viên nào.
                </td></tr>
            </c:if>
            </tbody>
        </table>
    </div>

</div>

<div class="modal-overlay" id="editModal">
    <div class="modal">
        <h2>✏ Chỉnh sửa thành viên</h2>
        <form method="POST" action="${pageContext.request.contextPath}/admin/members">
            <input type="hidden" name="action"     value="update">
            <input type="hidden" name="customerId" id="modalCustomerId">

            <div class="form-group">
                <label>Họ và tên</label>
                <input type="text" id="modalFullName" readonly>
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="text" id="modalEmail" readonly>
            </div>
            <div class="form-group">
                <label>Hạng thành viên</label>
                <select name="memberTier" id="modalTier">
                    <option value="Standard">Standard</option>
                    <option value="Silver">Silver</option>
                    <option value="Gold">Gold</option>
                    <option value="Platinum">Platinum</option>
                    <option value="Diamond">Diamond</option>
                </select>
            </div>
            <div class="form-group">
                <label>Điểm tích lũy</label>
                <input type="number" name="points" id="modalPoints" min="0" required>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn-cancel" onclick="closeModal()">Hủy</button>
                <button type="submit" class="btn-save">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</div>


<script src="${pageContext.request.contextPath}/assets/js/member-admin.js"></script>
</body>
</html>

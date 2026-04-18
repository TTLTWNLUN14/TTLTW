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
    <style>

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', sans-serif; background: #f1f5f9; display: flex; min-height: 100vh; color: #1e293b; }


        .sidebar {
            width: 240px; min-height: 100vh; background: #0d1b2e;
            padding: 24px 0; position: fixed; top: 0; left: 0; z-index: 50;
        }
        .sidebar-header {
            color: #f5b82e; font-weight: 700; font-size: 1.1rem;
            letter-spacing: .08em; padding: 0 24px 24px;
            border-bottom: 1px solid rgba(255,255,255,.07);
        }
        .menu-title {
            color: #64748b; font-size: .68rem; font-weight: 700;
            letter-spacing: .12em; padding: 20px 24px 6px; text-transform: uppercase;
        }
        .menu-item {
            display: block; color: #94a3b8; text-decoration: none;
            padding: 10px 24px; font-size: .88rem; transition: all .18s;
            border-left: 3px solid transparent;
        }
        .menu-item:hover { color: #fff; background: rgba(255,255,255,.06); }
        .menu-item.active { color: #f5b82e; border-left-color: #f5b82e; background: rgba(245,184,46,.08); }


        .main-content { margin-left: 240px; flex: 1; padding: 32px; }


        .page-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 24px;
        }
        .page-title { font-size: 1.5rem; font-weight: 700; color: #0f172a; }
        .page-sub   { font-size: .85rem; color: #64748b; margin-top: 2px; }


        .flash {
            padding: 12px 20px; border-radius: 8px; margin-bottom: 20px;
            font-size: .9rem; font-weight: 500;
        }
        .flash.success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
        .flash.error   { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }

        .stat-row { display: flex; gap: 16px; margin-bottom: 24px; flex-wrap: wrap; }
        .stat-card {
            background: #fff; border-radius: 12px; padding: 20px 24px;
            flex: 1; min-width: 140px; box-shadow: 0 1px 4px rgba(0,0,0,.06);
        }
        .stat-label { font-size: .78rem; color: #64748b; margin-bottom: 6px; }
        .stat-value { font-size: 1.6rem; font-weight: 700; color: #0f172a; }


        .filter-bar {
            background: #fff; border-radius: 12px; padding: 16px 20px;
            display: flex; gap: 12px; align-items: center; flex-wrap: wrap;
            margin-bottom: 20px; box-shadow: 0 1px 4px rgba(0,0,0,.06);
        }
        .filter-bar input, .filter-bar select {
            border: 1.5px solid #e2e8f0; border-radius: 8px; padding: 8px 14px;
            font-size: .88rem; color: #1e293b; outline: none; transition: border .18s;
        }
        .filter-bar input:focus, .filter-bar select:focus { border-color: #f5b82e; }
        .filter-bar input { flex: 1; min-width: 200px; }

        .table-container {
            background: #fff; border-radius: 14px; overflow: hidden;
            box-shadow: 0 1px 6px rgba(0,0,0,.07);
        }
        .custom-table { width: 100%; border-collapse: collapse; font-size: .88rem; }
        .custom-table thead { background: #0d1b2e; }
        .custom-table thead th {
            color: #94a3b8; font-weight: 600; font-size: .75rem; letter-spacing: .06em;
            text-transform: uppercase; padding: 14px 16px; text-align: left;
        }
        .custom-table tbody tr { border-bottom: 1px solid #f1f5f9; transition: background .15s; }
        .custom-table tbody tr:last-child { border-bottom: none; }
        .custom-table tbody tr:hover { background: #f8fafc; }
        .custom-table td { padding: 14px 16px; vertical-align: middle; }


        .tier-badge {
            display: inline-block; padding: 3px 10px; border-radius: 20px;
            font-size: .75rem; font-weight: 700; letter-spacing: .04em;
        }
        .tier-diamond  { background: #ede9fe; color: #6d28d9; }
        .tier-platinum { background: #e0f2fe; color: #0369a1; }
        .tier-gold     { background: #fef3c7; color: #b45309; }
        .tier-silver   { background: #f1f5f9; color: #475569; }
        .tier-standard { background: #f8fafc; color: #94a3b8; border: 1px solid #e2e8f0; }

        .status-active  { color: #16a34a; font-weight: 600; font-size: .8rem; }
        .status-locked  { color: #dc2626; font-weight: 600; font-size: .8rem; }


        .badge-pts {
            background: #dcfce7; color: #166534; padding: 2px 9px;
            border-radius: 12px; font-size: .78rem; font-weight: 700;
        }

        .text-money { color: #ea580c; font-weight: 600; }

        .action-buttons { display: flex; gap: 8px; }
        .btn-edit, .btn-lock, .btn-unlock {
            border: none; border-radius: 7px; padding: 6px 12px;
            font-size: .82rem; font-weight: 600; cursor: pointer; transition: all .18s;
        }
        .btn-edit   { background: #eff6ff; color: #1d4ed8; }
        .btn-edit:hover   { background: #dbeafe; }
        .btn-lock   { background: #fee2e2; color: #dc2626; }
        .btn-lock:hover   { background: #fecaca; }
        .btn-unlock { background: #dcfce7; color: #16a34a; }
        .btn-unlock:hover { background: #bbf7d0; }


        .pagination {
            display: flex; justify-content: flex-end; align-items: center;
            gap: 6px; padding: 16px 20px; background: #fff;
            border-top: 1px solid #f1f5f9;
        }
        .page-btn {
            border: 1.5px solid #e2e8f0; background: #fff; border-radius: 7px;
            padding: 5px 12px; font-size: .82rem; cursor: pointer; transition: all .18s; color: #475569;
        }
        .page-btn:hover, .page-btn.active { background: #0d1b2e; color: #fff; border-color: #0d1b2e; }

        .modal-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,.45); z-index: 200; align-items: center; justify-content: center;
        }
        .modal-overlay.open { display: flex; }
        .modal {
            background: #fff; border-radius: 16px; padding: 32px;
            width: 440px; max-width: 95vw; box-shadow: 0 20px 60px rgba(0,0,0,.2);
        }
        .modal h2 { font-size: 1.15rem; font-weight: 700; margin-bottom: 20px; color: #0f172a; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: .82rem; font-weight: 600; color: #475569; margin-bottom: 6px; }
        .form-group input, .form-group select {
            width: 100%; border: 1.5px solid #e2e8f0; border-radius: 8px;
            padding: 9px 14px; font-size: .9rem; color: #1e293b; outline: none; transition: border .18s;
        }
        .form-group input:focus, .form-group select:focus { border-color: #f5b82e; }
        .form-group input[readonly] { background: #f8fafc; color: #64748b; }
        .modal-actions { display: flex; gap: 10px; justify-content: flex-end; margin-top: 24px; }
        .btn-cancel {
            background: #f1f5f9; color: #475569; border: none; border-radius: 8px;
            padding: 9px 20px; font-size: .9rem; font-weight: 600; cursor: pointer;
        }
        .btn-save {
            background: #0d1b2e; color: #fff; border: none; border-radius: 8px;
            padding: 9px 20px; font-size: .9rem; font-weight: 600; cursor: pointer;
        }
        .btn-save:hover   { background: #1a3a6b; }
        .btn-cancel:hover { background: #e2e8f0; }
    </style>
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

<script>

    function filterTable() {
        const search = document.getElementById('searchInput').value.toLowerCase();
        const tier   = document.getElementById('tierFilter').value.toLowerCase();
        const status = document.getElementById('statusFilter').value;

        document.querySelectorAll('#memberTable tbody tr').forEach(row => {
            const text      = row.innerText.toLowerCase();
            const rowTier   = (row.dataset.tier   || '').toLowerCase();
            const rowStatus =  row.dataset.status || '';

            const matchSearch = !search || text.includes(search);
            const matchTier   = !tier   || rowTier === tier;
            const matchStatus = !status || rowStatus === status;

            row.style.display = (matchSearch && matchTier && matchStatus) ? '' : 'none';
        });
    }


    function openEditModal(customerId, fullName, email, memberTier, points) {
        document.getElementById('modalCustomerId').value = customerId;
        document.getElementById('modalFullName').value   = fullName;
        document.getElementById('modalEmail').value      = email;
        document.getElementById('modalPoints').value     = points;

        const sel = document.getElementById('modalTier');
        for (let i = 0; i < sel.options.length; i++) {
            sel.options[i].selected = sel.options[i].value === memberTier;
        }

        document.getElementById('editModal').classList.add('open');
    }

    function closeModal() {
        document.getElementById('editModal').classList.remove('open');
    }

    document.getElementById('editModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });
</script>
</body>
</html>

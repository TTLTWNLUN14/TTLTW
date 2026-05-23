<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý hãng xe - Auto Cars Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cars-brand-admin.css">
</head>
<body>

<div class="sidebar">
    <div class="sidebar-header">Auto Cars Admin</div>

    <div class="menu-title">TỔNG QUAN</div>
    <a href="#" class="menu-item">Dashboard</a>

    <div class="menu-title">VẬN HÀNH</div>
    <a href="#" class="menu-item">Quản lý đặt xe</a>
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
        <h1 class="page-title">Quản lý hãng xe</h1>
        <a href="add-brand" class="btn-add">+ Thêm hãng</a>
    </div>

    <c:if test="${param.error == 'has_cars'}">
        <div class="alert-error">
            Không thể xóa hãng xe này vì còn loại xe bên trong. Hãy xóa hết loại xe trước.
        </div>
    </c:if>

    <div class="filter-bar">
        <form method="get" action="${pageContext.request.contextPath}/brand-admin" class="filter-form">
            <label class="filter-label" for="filterBrandId">Lọc nhanh hãng xe:</label>

            <select name="filterBrandId" id="filterBrandId" class="filter-select"
                    onchange="this.form.submit()">
                <option value="">-- Tất cả hãng xe --</option>
                <c:forEach var="b" items="${allBrands}">
                    <option value="${b.brandId}"
                            <c:if test="${b.brandId == filterBrandId}">selected</c:if>>
                            ${b.brandName}
                    </option>
                </c:forEach>
            </select>

            <c:if test="${not empty filterBrandId}">
                <a href="${pageContext.request.contextPath}/brand-admin"
                   class="btn-clear-filter">✕ Bỏ lọc</a>
            </c:if>
        </form>

        <span class="filter-count">
            Đang hiển thị <strong>${listBrand.size()}</strong> / ${allBrands.size()} hãng
        </span>
    </div>

    <div class="table-container">
        <table class="custom-table">
            <thead>
            <tr>
                <th>Logo</th>
                <th>Hãng xe</th>
                <th>Quốc gia</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="b" items="${listBrand}">
                <tr>
                    <td>
                        <c:choose>
                            <c:when test="${not empty b.logo}">
                                <img src="${b.logo}" alt="${b.brandName}" class="brand-logo-img">
                            </c:when>
                            <c:otherwise>
                                <span class="empty-logo-text">—</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td><strong>${b.brandName}</strong></td>
                    <td>${b.country}</td>

                    <td>
                        <c:choose>
                            <c:when test="${b.isActive}">
                                <span class="status-badge">Hoạt động</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-inactive">Ngừng hoạt động</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td class="action-buttons">
                        <a href="${pageContext.request.contextPath}/edit-brand?brandId=${b.brandId}"
                           class="btn-edit">&#x270E;</a>

                        <button class="btn-disable"
                                onclick="openConfirm(${b.brandId}, '${b.brandName}')">Xóa</button>

                            <%-- Nút thêm loại xe thuộc hãng này --%>
                        <a href="${pageContext.request.contextPath}/cars-admin?brandId=${b.brandId}"
                           class="btn-add-type" title="Thêm loại xe">+</a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty listBrand}">
                <tr>
                    <td colspan="5" class="empty-table-cell">
                        <c:choose>
                            <c:when test="${not empty filterBrandId}">
                                Không tìm thấy hãng xe phù hợp.
                                <a href="${pageContext.request.contextPath}/brand-admin">Xem tất cả</a>
                            </c:when>
                            <c:otherwise>
                                Chưa có hãng xe nào. Nhấn <strong>+ Thêm hãng</strong> để bắt đầu.
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>
<div class="confirm-overlay" id="confirmOverlay">
    <div class="confirm-box">
        <h3>Xác nhận xóa hãng xe</h3>
        <p>Bạn có chắc muốn xóa hãng xe<br>
            <strong id="confirmBrandName"></strong>?</p>

        <p class="warning-text"><strong>Lưu ý:</strong> Tất cả các loại xe thuộc hãng này có thể bị ảnh hưởng
            hoặc cần được xóa trước. Hành động này không thể hoàn tác.
        </p>

        <div class="confirm-actions">
            <button class="btn-confirm-cancel" onclick="closeConfirm()">Hủy bỏ</button>
            <button type="button" class="btn-confirm-delete" onclick="submitDelete()">Xóa hãng</button>
        </div>
    </div>
</div>

<form id="deleteForm" method="post"
      action="${pageContext.request.contextPath}/brand-admin"
      style="display:none;">
    <input type="hidden" name="action"  value="delete">
    <input type="hidden" name="brandId" id="deleteBrandId">
</form>
<script>
    function openConfirm(brandId, brandName) {
        document.getElementById('confirmBrandName').textContent = brandName;
        document.getElementById('deleteBrandId').value = brandId;
        document.getElementById('confirmOverlay').classList.add('open');
    }

    function closeConfirm() {
        document.getElementById('confirmOverlay').classList.remove('open');
    }

    document.getElementById('confirmOverlay').addEventListener('click', function(e) {
        if (e.target === this) closeConfirm();
    });

    function submitDelete() {
        document.getElementById('deleteForm').submit();
    }
</script>
</body>
</html>

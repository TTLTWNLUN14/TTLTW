<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý loại xe - Auto Cars Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cars-admin.css">
    <style>

    </style>
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
    <a href="${pageContext.request.contextPath}/brand-admin" class="menu-item">Hãng xe</a>
    <a href="${pageContext.request.contextPath}/cars-admin"  class="menu-item active">Loại xe</a>
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
        <h1 class="page-title">Quản lý loại xe</h1>
        <%-- thêm xe -> add-car-admin --%>
        <a href="${pageContext.request.contextPath}/cars-admin/add
               <c:if test='${selectedBrandId != null}'>?brandId=${selectedBrandId}</c:if>"
           class="btn-add">+ Thêm xe</a>
    </div>

    <div class="table-container">
        <table class="custom-table">
            <thead>
            <tr>
                <th>Ảnh</th>
                <th>Tên xe</th>
                <th>Hãng</th>
                <th>Loại</th>
                <th>Chỗ</th>
                <th>Nhiên liệu</th>
                <th>Giá/km</th>
                <th>Giá/ngày</th>
                <th>Xe có sẵn</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="ct" items="${listCarType}">
                <tr>
                    <td>
                        <c:choose>
                            <c:when test="${not empty ct.img}">
                                <img src="${ct.img}" alt="${ct.typeName}"
                                     style="width:60px; height:42px; object-fit:cover; border-radius:4px;">
                            </c:when>
                            <c:otherwise>
                                <span style="color:#aaa; font-size:0.8rem;">—</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td><strong>${ct.typeName}</strong></td>
                    <td>
                        <c:forEach var="b" items="${listBrand}">
                            <c:if test="${b.brandId == ct.brandId}">${b.brandName}</c:if>
                        </c:forEach>
                    </td>
                    <td>${ct.category}</td>
                    <td>${ct.seatingPlan} chỗ</td>
                    <td>${ct.fuel}</td>
                    <td class="text-orange">${ct.priceKm}đ</td>
                    <td class="text-orange">${ct.priceDay}đ</td>
                    <td><span class="badge-count">${ct.count}</span></td>
                    <td>
                        <c:choose>
                            <c:when test="${ct.active}">
                                <span class="status-badge">Hoạt động</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge"
                                      style="background:#fee2e2; color:#dc2626;">Ngừng</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="action-buttons">
                            <%-- sửa -> edit-car-admin --%>
                        <a href="${pageContext.request.contextPath}/cars-admin/edit?typeId=${ct.typeId}"
                           class="btn-edit">&#x270E; Sửa</a>

                        <button class="btn-delete"
                                onclick="openConfirm(${ct.typeId}, '${ct.typeName}')">Xóa</button>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty listCarType}">
                <tr>
                    <td colspan="11" style="text-align:center; padding:40px; color:#94a3b8;">
                        Không có loại xe nào.
                        <c:if test="${selectedBrandId != null}">
                            Nhấn <strong>+ Thêm xe</strong> để thêm xe cho hãng này.
                        </c:if>
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<div class="confirm-overlay" id="confirmOverlay">
    <div class="confirm-box">
        <h3>Xác nhận xóa xe</h3>
        <p>Bạn có chắc muốn xóa xe<br><strong id="confirmCarName"></strong>?<br>
            Hành động này không thể hoàn tác.</p>
        <div class="confirm-actions">
            <button class="btn-confirm-cancel" onclick="closeConfirm()">Hủy bỏ</button>
            <button class="btn-confirm-delete" onclick="submitDelete()">Xóa xe</button>
        </div>
    </div>
</div>
    <%--add submit khi bam vao xac nhan xoa xe --%>
<form id="deleteForm" method="post"
      action="${pageContext.request.contextPath}/cars-admin"
      style="display:none;">
    <input type="hidden" name="action" value="delete">
    <input type="hidden" name="typeId" id="deleteTypeId">
</form>
<script>
   // Mở confirm dialog: ghi tên xe + typeId vào dialog rồi hiện lên
    function openConfirm(typeId, carName) {
        document.getElementById('confirmCarName').textContent = carName;
        document.getElementById('deleteTypeId').value = typeId;
        document.getElementById('confirmOverlay').classList.add('open');
    }

    // Khi bam vao huy bo hay bam ra ngoai thi se thoat k xoa nua
    function closeConfirm() {
        document.getElementById('confirmOverlay').classList.remove('open');
    }
    document.getElementById('confirmOverlay').addEventListener('click', function(e) {
        if (e.target === this) closeConfirm();
    })

    // Người dùng bấm xoa xe add submit
    function submitDelete() {
        document.getElementById('deleteForm').submit();
    }
</script>
</body>
</html>

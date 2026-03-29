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
                                <img src="${b.logo}" alt="${b.brandName}"
                                     style="width:48px; height:36px; object-fit:contain;">
                            </c:when>
                            <c:otherwise>
                                <span style="color:#aaa; font-size:0.8rem;">—</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td><strong>${b.brandName}</strong></td>
                    <td>${b.country}</td>

                        <%--  check isActive=1 -> hd, =0 -> ngung  --%>
                    <td>
                        <c:choose>
                            <c:when test="${b.isActive}">Hoạt động ${b.isActive}</c:when>
                            <c:otherwise>
                                <span class="status-badge"
                                      style="background:#fee2e2; color:#dc2626;">Ngừng hoạt động  ${b.isActive}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="action-buttons">
                            <%-- bam vao nut edit thi nhay qua trang edit vs brandId --%>
                        <a href="${pageContext.request.contextPath}/edit-brand?brandId=${b.brandId}"
                           class="btn-edit">&#x270E;</a>

<%--========================================== chua lam duoc ==========================================--%>
                        <form method="post">
                            <button type="submit" class="btn-disable">Xóa</button>
                        </form>
<%--===================================================================================================--%>
                            <%--truyen brandId vao url chuyen sang trang them loai xe thuoc hang xe nay   --%>
                        <a href="${pageContext.request.contextPath}/cars-admin?brandId=${b.brandId}" class="btn-add-type">+</a>

                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty listBrand}">
                <tr>
                    <td colspan="6" style="text-align:center; padding:40px; color:#94a3b8;">
                        Chưa có hãng xe nào. Nhấn <strong>+ Thêm hãng</strong> để bắt đầu.
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>

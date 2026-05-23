<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý loại xe - Auto Cars Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cars-admin.css">
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
        <a href="${pageContext.request.contextPath}/cars-admin/add<c:if test='${selectedBrandId != null}'>?brandId=${selectedBrandId}</c:if>"
           class="btn-add">+ Thêm xe</a>
    </div>

    <div class="filter-bar">
        <form method="get" action="${pageContext.request.contextPath}/cars-admin"
              style="display:flex; gap:8px; align-items:center; flex-wrap:wrap;">

            <label>Hãng:</label>
            <select name="brandId">
                <option value="">-- Tất cả hãng --</option>
                <c:forEach var="b" items="${listBrand}">
                    <option value="${b.brandId}"
                            <c:if test="${b.brandId == selectedBrandId}">selected</c:if>>
                            ${b.brandName}
                    </option>
                </c:forEach>
            </select>

            <label>Loại xe:</label>
            <select name="category">
                <option value="">-- Tất cả loại --</option>
                <option value="SUV"       <c:if test="${selectedCategory == 'SUV'}">selected</c:if>>SUV</option>
                <option value="Sedan"     <c:if test="${selectedCategory == 'Sedan'}">selected</c:if>>Sedan</option>
                <option value="MPV"       <c:if test="${selectedCategory == 'MPV'}">selected</c:if>>MPV</option>
                <option value="Pickup"    <c:if test="${selectedCategory == 'Pickup'}">selected</c:if>>Pickup</option>
                <option value="Hatchback" <c:if test="${selectedCategory == 'Hatchback'}">selected</c:if>>Hatchback</option>
            </select>

            <label>Số chỗ:</label>
            <select name="seatingPlan">
                <option value="">-- Tất cả --</option>
                <option value="4"  <c:if test="${selectedSeat == 4}">selected</c:if>>4 chỗ</option>
                <option value="5"  <c:if test="${selectedSeat == 5}">selected</c:if>>5 chỗ</option>
                <option value="7"  <c:if test="${selectedSeat == 7}">selected</c:if>>7 chỗ</option>
                <option value="9"  <c:if test="${selectedSeat == 9}">selected</c:if>>9 chỗ</option>
                <option value="16" <c:if test="${selectedSeat == 16}">selected</c:if>>16 chỗ</option>
            </select>

            <button type="submit" class="btn-filter">Lọc</button>
        </form>
        <a href="${pageContext.request.contextPath}/cars-admin" class="btn-reset-filter">✕ Xóa lọc</a>
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
                            <c:when test="${ct.isActive}">
                                <span class="status-badge">Hoạt động</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge"
                                      style="background:#fee2e2; color:#dc2626;">Ngừng</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="action-buttons">
                        <a href="${pageContext.request.contextPath}/cars-admin/edit?typeId=${ct.typeId}"
                           class="btn-edit">&#x270E; Sửa</a>
                        <button type="button" class="btn-delete"
                                onclick="openDeleteModal('${ct.typeId}', '${ct.typeName}')">Xóa</button>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty listCarType}">
                <tr>
                    <td colspan="11" style="text-align:center; padding:40px; color:#94a3b8;">
                        Không có loại xe nào phù hợp với bộ lọc.
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <c:if test="${totalPages > 1}">
        <div class="pagination" style="
            display:flex; justify-content:center; align-items:center;
            gap:6px; margin-top:32px; flex-wrap:wrap;">

            <c:choose>
                <c:when test="${currentPage > 1}">
                    <a href="${pageContext.request.contextPath}/cars-admin?page=${currentPage - 1}
                        <c:if test='${not empty selectedBrandId}'>&brandId=${selectedBrandId}</c:if>
                        <c:if test='${not empty selectedCategory}'>&category=${selectedCategory}</c:if>
                        <c:if test='${not empty selectedSeat}'>&seatingPlan=${selectedSeat}</c:if>"
                       class="page-btn">‹ Trước</a>
                </c:when>
                <c:otherwise>
                    <span class="page-btn disabled">‹ Trước</span>
                </c:otherwise>
            </c:choose>

            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <span class="page-btn active">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/cars-admin?page=${i}
                            <c:if test='${not empty selectedBrandId}'>&brandId=${selectedBrandId}</c:if>
                            <c:if test='${not empty selectedCategory}'>&category=${selectedCategory}</c:if>
                            <c:if test='${not empty selectedSeat}'>&seatingPlan=${selectedSeat}</c:if>"
                           class="page-btn">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:choose>
                <c:when test="${currentPage < totalPages}">
                    <a href="${pageContext.request.contextPath}/cars-admin?page=${currentPage + 1}
                        <c:if test='${not empty selectedBrandId}'>&brandId=${selectedBrandId}</c:if>
                        <c:if test='${not empty selectedCategory}'>&category=${selectedCategory}</c:if>
                        <c:if test='${not empty selectedSeat}'>&seatingPlan=${selectedSeat}</c:if>"
                       class="page-btn">Sau ›</a>
                </c:when>
                <c:otherwise>
                    <span class="page-btn disabled">Sau ›</span>
                </c:otherwise>
            </c:choose>

        </div>

        <p style="text-align:center; color:#94a3b8; font-size:0.85rem; margin-top:8px;">
            Trang ${currentPage}/${totalPages} — ${totalItems} loại xe
        </p>
    </c:if>

</div>

<div id="deleteModal" class="modal-wrapper">
    <div class="modal-box">
        <div class="modal-header">
            <h3>Xác nhận xóa xe</h3>
            <span class="modal-close" onclick="closeDeleteModal()">&times;</span>
        </div>
        <div class="modal-body">
            <p>Bạn có chắc chắn muốn xóa xe <strong id="deleteTargetName">...</strong>?</p>
            <small class="text-danger">Hành động này không thể hoàn tác và có thể ảnh hưởng đến các dữ liệu liên quan.</small>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn-cancel" onclick="closeDeleteModal()">Hủy bỏ</button>

            <form id="realDeleteForm" action="${pageContext.request.contextPath}/cars-admin" method="post" style="display:inline; margin:0;">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="typeId" id="deleteTypeId">
                <button type="submit" class="btn-confirm-delete">Xác nhận xóa</button>
            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/cars-admin.js"></script>
</body>
</html>
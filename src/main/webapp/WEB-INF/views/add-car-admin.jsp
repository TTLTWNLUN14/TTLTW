<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm loại xe - Auto Cars Admin</title>
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
        <h1 class="page-title">Thêm loại xe mới</h1>
    </div>

    <div class="form-card">
        <h2>+ Thêm loại xe mới</h2>

        <form method="post" action="${pageContext.request.contextPath}/cars-admin/add">

            <div class="form-group">
                <label>Hãng xe <span style="color:red">*</span></label>
                <select name="brandId" required>
                    <option value="">-- Chọn hãng --</option>
                    <c:forEach var="b" items="${listBrand}">
                        <option value="${b.brandId}"
                                <c:if test="${b.brandId == selectedBrandId}">selected</c:if>>
                                ${b.brandName}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>Tên xe <span style="color:red">*</span></label>
                <input type="text" name="typeName" placeholder="VD: Toyota Innova Cross" required>
            </div>

            <div class="form-row-2">
                <div class="form-group">
                    <label>Loại xe</label>
                    <select name="category">
                        <option value="">-- Chọn loại --</option>
                        <option>Sedan</option>
                        <option>SUV</option>
                        <option>MPV</option>
                        <option>Pickup</option>
                        <option>Hatchback</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Số chỗ ngồi</label>
                    <input type="number" name="seatingPlan" placeholder="5" min="1" max="20">
                </div>
            </div>

            <div class="form-group">
                <label>Nhiên liệu</label>
                <select name="fuel">
                    <option value="">-- Chọn --</option>
                    <option>Xăng</option>
                    <option>Điện</option>
                    <option>Hybrid</option>
                    <option>Diesel</option>
                </select>
            </div>

            <div class="form-row-3">
                <div class="form-group">
                    <label>Giá có tài (đ)</label>
                    <input type="number" name="priceDirver" placeholder="0" min="0">
                </div>
                <div class="form-group">
                    <label>Giá/km (đ)</label>
                    <input type="number" name="priceKm" placeholder="4500" min="0">
                </div>
                <div class="form-group">
                    <label>Giá/ngày (đ)</label>
                    <input type="number" name="priceDay" placeholder="1800000" min="0">
                </div>
            </div>

            <div class="form-row-2">
                <div class="form-group">
                    <label>URL Ảnh xe</label>
                    <input type="text" name="img" placeholder="https://...">
                </div>
                <div class="form-group">
                    <label>Số xe có sẵn</label>
                    <input type="number" name="count" placeholder="0" min="0">
                </div>
            </div>

            <div class="form-group">
                <label>Mô tả xe</label>
                <textarea name="descriptionType" placeholder="Mô tả ngắn về loại xe này..."></textarea>
            </div>

            <div class="form-footer">
                <a href="${pageContext.request.contextPath}/cars-admin" class="btn-cancel">Hủy</a>
                <button type="submit" class="btn-save">Lưu xe</button>
            </div>
        </form>
    </div>
</div>

</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa loại xe - Auto Cars Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/edit-brand-admin.css">
</head>
<body>
<div class="sidebar">
    <div class="sidebar-header">Auto Cars Admin</div>

    <div class="menu-title">TỔNG QUAN</div>
    <a href="#" class="menu-item">Dashboard</a>

    <div class="menu-title">VẬN HÀNH</div>
    <a href="booking-admin" class="menu-item">Quản lý đặt xe</a>
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
        <h1 class="page-title">Sửa thông tin loại xe</h1>
    </div>

    <div class="form-card">
        <h2>&#x270E; Sửa thông tin loại xe</h2>

        <%-- EditCarAdminController -> id và set vào request --%>
        <form method="post" action="${pageContext.request.contextPath}/cars-admin/edit" enctype="multipart/form-data">
            <input type="hidden" name="typeId" value="${carType.typeId}">

            <input type="hidden" name="oldImg" value="${carType.img}">

            <div class="form-group">
                <label>Hãng xe <span style="color:red">*</span></label>
                <select name="brandId" required>
                    <c:forEach var="b" items="${listBrand}">
                        <option value="${b.brandId}"
                                <c:if test="${b.brandId == carType.brandId}">selected</c:if>>
                                ${b.brandName}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>Tên xe <span style="color:red">*</span></label>
                <input type="text" name="typeName" value="${carType.typeName}" required>
            </div>

            <div class="form-row-2">
                <div class="form-group">
                    <label>Loại xe</label>
                    <select name="category">
                        <option value="">-- Chọn --</option>
                        <c:forEach var="cat" items="${['Sedan','SUV','MPV','Pickup','Hatchback']}">
                            <option value="${cat}"
                                    <c:if test="${cat == carType.category}">selected</c:if>>${cat}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label>Số chỗ ngồi</label>
                    <input type="number" name="seatingPlan"
                           value="${carType.seatingPlan}" min="1" max="20">
                </div>
            </div>

            <div class="form-group">
                <label>Nhiên liệu</label>
                <select name="fuel">
                    <option value="">-- Chọn --</option>
                    <c:forEach var="f" items="${['Xăng','Điện','Hybrid','Diesel']}">
                        <option value="${f}"
                                <c:if test="${f == carType.fuel}">selected</c:if>>${f}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-row-2">
                <div class="form-group">
                    <label>Giá/km (đ)</label>
                    <input type="number" name="priceKm"
                           value="${carType.priceKm}" min="0">
                </div>
                <div class="form-group">
                    <label>Giá/ngày (đ)</label>
                    <input type="number" name="priceDay"
                           value="${carType.priceDay}" min="0">
                </div>
            </div>

            <div class="form-row-2">
                <div class="form-group">
                    <label>Ảnh xe hiện tại</label>
                    <%-- hiển thị ảnh hiện tại (nếu có) --%>
                    <c:choose>
                        <c:when test="${not empty carType.img}">
                            <c:choose>
                                <%-- Ảnh cũ là link URL (http...) thì hiển thị trực tiếp --%>
                                <c:when test="${fn:startsWith(carType.img, 'http')}">
                                    <img src="${carType.img}" alt="${carType.typeName}" class="car-img-preview">
                                </c:when>
                                <%-- ảnh là file đã upload (đường dẫn tương đối) thì thêm contextpath --%>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/${carType.img}" alt="${carType.typeName}" class="car-img-preview">
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <p>Chưa có ảnh</p>
                        </c:otherwise>
                    </c:choose>

                    <input type="file" name="imgFile" accept="image/*">
                    <small>Chọn ảnh mới nếu muốn thay đổi, để trống nếu giữ ảnh hiện tại.</small>
                </div>
                <div class="form-group">
                    <label>Số xe có sẵn</label>
                    <input type="number" name="count" value="${carType.count}" min="0">
                </div>
            </div>

            <div class="form-group">
                <label>Mô tả xe</label>
                <textarea name="descriptionType">${carType.descriptionType}</textarea>
            </div>

            <div class="form-footer">
                <a href="${pageContext.request.contextPath}/cars-admin" class="btn-cancel">Hủy</a>
                <button type="submit" class="btn-save">Cập nhật</button>
            </div>
        </form>
    </div>
</div>

</body>
</html>

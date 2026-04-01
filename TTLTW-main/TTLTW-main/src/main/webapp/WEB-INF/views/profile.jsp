<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
</head>
<body>

<nav class="global-nav">
    <div class="nav-inner">
        <a class="nav-logo" href="${pageContext.request.contextPath}/index.jsp">AUTO CARS</a>
        <div class="nav-links">
            <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/list-product">Đặt xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/my-bookings">Đơn của tôi</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/profile">Hộ sơ</a>
        </div>
        <div class="nav-actions">
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng xuất</a>
        </div>
    </div>
</nav>

<div class="page-container">
    <div class="sidebar">

        <div class="profile-card">
            <div class="avatar-container">
                <div class="avatar">${member.fullName.charAt(0)}</div>
            </div>
            <h3 class="profile-name">${member.fullName}</h3>
            <p class="profile-email">${member.email}</p>
            <div class="member-badge tier-${member.memberTier}">
                <span class="badge-icon"></span> ${member.memberTier}
            </div>
            <button class="btn-edit-profile"> Chỉnh sửa</button>
        </div>

        <div class="sidebar-menu">
            <a href="#" class="menu-item active" onclick="switchTab('info')"> Thông tin cá nhân</a>
            <a href="#" class="menu-item" onclick="switchTab('bookings')"> Lịch sử đơn hàng</a>
            <a href="#" class="menu-item" onclick="switchTab('member')"> Thông tin Member</a>
        </div>
    </div>

    <div class="main-content">
      
        <div id="tab-info" class="tab-pane active">
            <div class="tab-header">
                <h2> Thông tin cá nhân</h2>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">${errorMessage}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/profile" class="form-profile">
                <input type="hidden" name="action" value="updateProfile">

                <div class="form-row">
                    <div class="form-group">
                        <label>Họ và tên</label>
                        <input type="text" name="fullName" value="${member.fullName}" required>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" value="${member.email}" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <input type="tel" name="phone" value="${member.phone}" required>
                    </div>
                    <div class="form-group">
                        <label>Giới tính</label>
                        <select name="gender" required>
                            <option value="Nam" ${member.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                            <option value="Nữ" ${member.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                            <option value="Khác" ${member.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>CCCD</label>
                        <input type="text" name="cccd" value="${member.cccd}" required>
                    </div>
                    <div class="form-group">
                        <label>Địa chỉ</label>
                        <input type="text" name="address" value="${member.address}" required>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-save"> Lưu thay đổi</button>
                    <button type="reset" class="btn-cancel">Hủy</button>
                </div>
            </form>
        </div>

        <div id="tab-bookings" class="tab-pane">
            <div class="tab-header">
                <h2> Các item đi với phần đơn của tôi</h2>
                <p class="tab-subtitle">Quản lý tất cả các đơn đặt xe của bạn</p>
            </div>

            <c:if test="${empty bookingHistory}">
                <div class="empty-state">
                    <p> Bạn chưa có đơn đặt xe nào</p>
                    <a href="${pageContext.request.contextPath}/list-product" class="btn-primary">
                        Đặt xe ngay
                    </a>
                </div>
            </c:if>

            <c:if test="${not empty bookingHistory}">
                <div class="bookings-list">
                    <c:forEach var="booking" items="${bookingHistory}">
                        <div class="booking-card">
                            <div class="booking-header">
                                <span class="booking-id">#${booking.bookingId}</span>
                                <span class="booking-date">
                                        <fmt:formatDate value="${booking.bookingDate}"
                                                        pattern="dd/MM/yyyy"/>
                                    </span>
                            </div>

                            <div class="booking-details">
                                <div class="detail-item">
                                    <span class="label">Xe:</span>
                                    <span class="value">${booking.carName}</span>
                                </div>
                                <div class="detail-item">
                                    <span class="label">Tuyến:</span>
                                    <span class="value">${booking.route}</span>
                                </div>
                                <div class="detail-item">
                                    <span class="label">Trạng thái:</span>
                                    <span class="status ${booking.status}">${booking.status}</span>
                                </div>
                            </div>

                            <div class="booking-footer">
                                    <span class="booking-price">
                                        <fmt:formatNumber value="${booking.totalPrice}"
                                                          pattern="#,##0"/>đ
                                    </span>
                                <a href="${pageContext.request.contextPath}/booking-detail?id=${booking.bookingId}"
                                   class="btn-view">Chi tiết</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>

       
        <div id="tab-member" class="tab-pane">
            <div class="tab-header">
                <h2> Thông tin Member</h2>
            </div>

            <div class="member-info">
                <div class="member-tier-section">
                    <h3>Hạng thành viên: <span class="tier-name">${member.memberTier}</span></h3>
                    <p class="member-benefits">
                        Nhận ưu đãi độc quyền, tích điểm mỗi chuyến đi
                    </p>
                </div>

                <div class="member-stats">
                    <div class="stat">
                        <span class="stat-value">${member.totalTrips}</span>
                        <span class="stat-label">Chuyến đi</span>
                    </div>
                    <div class="stat">
                        <span class="stat-value">${member.points}</span>
                        <span class="stat-label">Điểm</span>
                    </div>
                    <div class="stat">
                            <span class="stat-value">
                                <fmt:formatNumber value="${member.totalSpent}"
                                                  pattern="#,##0"/>đ
                            </span>
                        <span class="stat-label">Tổng chi tiêu</span>
                    </div>
                </div>

                <div class="member-join">
                    <p>Ngày tham gia: <strong>
                        <fmt:formatDate value="${member.joinDate}"
                                        pattern="dd/MM/yyyy"/>
                    </strong></p>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/profile.js"></script>
</body>
</html>
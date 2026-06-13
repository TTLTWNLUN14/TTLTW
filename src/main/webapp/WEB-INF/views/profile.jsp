<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Cá Nhân</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nav.css">
    
</head>
<body>

<jsp:include page="/WEB-INF/views/includes/header.jsp">
  <jsp:param name="activePage" value="profile"/>
</jsp:include>

<!-- MAIN CONTENT -->
<div class="main-wrapper">
    <div class="profile-container">
        <!-- Messages -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-custom" role="alert">
                <i class="fas fa-check-circle"></i> ${successMessage}
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-custom" role="alert">
                <i class="fas fa-exclamation-circle"></i> ${errorMessage}
            </div>
        </c:if>

        <!-- Profile Header -->
        <div class="profile-header">
            <div class="header-content">
                <div class="user-info">
                    <div class="user-avatar-large">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="user-details">
                        <h2>${member.fullName}</h2>
                        <p><i class="fas fa-envelope"></i> ${member.email}</p>
                        <p><i class="fas fa-phone"></i> ${member.phone}</p>
                    </div>
                </div>

                <div class="member-stats">
                    <div class="stat-item">
                        <div class="stat-value">${member.totalTrips}</div>
                        <div class="stat-label">Chuyến Xe</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">${member.points}</div>
                        <div class="stat-label">Điểm Thưởng</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">${member.memberTier}</div>
                        <div class="stat-label">Hạng Thành Viên</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Navigation Tabs -->
        <ul class="nav nav-tabs" role="tablist">
            <li class="nav-item">
                <a class="nav-link active" id="info-tab" data-bs-toggle="tab" href="#info">
                    <i class="fas fa-user-circle"></i> Thông Tin Cá Nhân
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="bookings-tab" data-bs-toggle="tab" href="#bookings">
                    <i class="fas fa-calendar-check"></i> Lịch Sử Đặt Xe
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="notifications-tab" data-bs-toggle="tab" href="#notifications">
                    <i class="fas fa-bell"></i> Thông Báo
                    <c:if test="${unreadCount > 0}">
                        <span class="badge bg-danger ms-2">${unreadCount}</span>
                    </c:if>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="settings-tab" data-bs-toggle="tab" href="#settings">
                    <i class="fas fa-sliders-h"></i> Cài Đặt
                </a>
            </li>
        </ul>

        <div class="tab-content">
            <!-- Personal Information Tab -->
            <div class="tab-pane fade show active" id="info">
                <div class="form-section">
                    <h3 class="form-section-title">
                        <i class="fas fa-edit"></i> Cập Nhật Thông Tin Cá Nhân
                    </h3>
                    <form method="POST" action="${pageContext.request.contextPath}/profile">
                        <input type="hidden" name="action" value="updateProfile">

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Họ và Tên</label>
                                    <input type="text" class="form-control" name="fullName"
                                           value="${member.fullName}" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Email</label>
                                    <input type="email" class="form-control" name="email"
                                           value="${member.email}" required>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Số Điện Thoại</label>
                                    <input type="tel" class="form-control" name="phone"
                                           value="${member.phone}" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Giới Tính</label>
                                    <select class="form-control" name="gender">
                                        <option value="Nam" ${member.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                        <option value="Nữ" ${member.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                        <option value="Khác" ${member.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Địa Chỉ</label>
                            <input type="text" class="form-control" name="address"
                                   value="${member.address}">
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">CCCD/CMND</label>
                                    <input type="text" class="form-control" name="cccd"
                                           value="${member.cccd}">
                                </div>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary-custom">
                            <i class="fas fa-save"></i> Lưu Thay Đổi
                        </button>
                    </form>
                </div>

                <!-- Change Password Section -->
                <div class="form-section">
                    <h3 class="form-section-title">
                        <i class="fas fa-lock"></i> Đổi Mật Khẩu
                    </h3>
                    <form method="POST" action="${pageContext.request.contextPath}/profile">
                        <input type="hidden" name="action" value="changePassword">

                        <div class="form-group">
                            <label class="form-label">Mật Khẩu Hiện Tại</label>
                            <input type="password" class="form-control" name="oldPassword" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Mật Khẩu Mới</label>
                            <input type="password" class="form-control" name="newPassword"
                                   minlength="6" required>
                            <small class="text-muted">Ít nhất 6 ký tự</small>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Xác Nhận Mật Khẩu</label>
                            <input type="password" class="form-control" name="confirmPassword" required>
                        </div>

                        <button type="submit" class="btn btn-primary-custom">
                            <i class="fas fa-key"></i> Đổi Mật Khẩu
                        </button>
                    </form>
                </div>
            </div>

            <!-- Booking History Tab -->
            <div class="tab-pane fade" id="bookings">
                <div class="form-section">
                    <h3 class="form-section-title">
                        <i class="fas fa-history"></i> Lịch Sử Đặt Xe
                    </h3>

                    <c:choose>
                        <c:when test="${not empty bookingHistory && bookingHistory.size() > 0}">
                            <c:forEach var="booking" items="${bookingHistory}">
                                <div class="booking-card">
                                    <div class="booking-header">
                                        <div>
                                            <div class="booking-code">Mã: ${booking.bookingCode}</div>
                                            <p class="mb-0" style="color: #6b7280; font-size: 0.9rem;">
                                                <fmt:formatDate value="${booking.bookingDate}"
                                                                pattern="dd/MM/yyyy HH:mm"/>
                                            </p>
                                        </div>
                                        <span class="booking-status completed">
                                                <i class="fas fa-check-circle"></i> ${booking.status}
                                            </span>
                                    </div>
                                    <div style="color: #4b5563; font-size: 0.9rem;">
                                        <p><strong>Xe:</strong> ${booking.carInfo}</p>
                                        <p><strong>Điểm đón:</strong> ${booking.pickupLocation}</p>
                                        <p><strong>Điểm trả:</strong> ${booking.dropoffLocation}</p>
                                        <p><strong>Giá tiền:</strong> <span style="color: var(--primary-color); font-weight: 600;">
                                                <fmt:formatNumber value="${booking.totalPrice}" type="currency"
                                                                  currencySymbol=""/>VND</span></p>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="notification-empty">
                                <i class="fas fa-inbox" style="font-size: 2.5rem; color: #d1d5db;"></i>
                                <p style="margin-top: 15px;">Bạn chưa có chuyến xe nào</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Notifications Tab -->
            <div class="tab-pane fade" id="notifications">
                <div class="form-section">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <h3 class="form-section-title mb-0">
                            <i class="fas fa-bell"></i> Thông Báo của Bạn
                        </h3>
                        <c:if test="${unreadCount > 0}">
                            <form method="POST" action="${pageContext.request.contextPath}/profile" style="display: inline;">
                                <input type="hidden" name="action" value="markAllAsRead">
                                <button type="submit" class="btn btn-outline-custom">
                                    <i class="fas fa-check-double"></i> Đánh dấu tất cả đã đọc
                                </button>
                            </form>
                        </c:if>
                    </div>

                    <c:choose>
                        <c:when test="${not empty notifications && notifications.size() > 0}">
                            <c:forEach var="notif" items="${notifications}">
                                <div class="notification-item ${!notif.read ? 'unread' : ''}">
                                    <div class="notification-icon">
                                        <i class="${notif.icon}"></i>
                                    </div>
                                    <div class="notification-content" style="flex: 1;">
                                        <h5>${notif.title}</h5>
                                        <p>${notif.content}</p>
                                    </div>
                                    <div class="notification-time">
                                        <fmt:formatDate value="${notif.createdAt}"
                                                        pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="notification-empty">
                                <i class="fas fa-bell-slash" style="font-size: 2.5rem; color: #d1d5db;"></i>
                                <p style="margin-top: 15px;">Bạn chưa có thông báo nào</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Settings Tab -->
            <div class="tab-pane fade" id="settings">
                <div class="form-section">
                    <h3 class="form-section-title">
                        <i class="fas fa-cog"></i> Tùy Chỉnh Thông Báo
                    </h3>
                    <form method="POST" action="${pageContext.request.contextPath}/profile">
                        <input type="hidden" name="action" value="updateSettings">

                        <div class="form-switch">
                            <div>
                                <h5 style="margin: 0; color: #1f2937;">Thông báo đặt xe</h5>
                                <p style="margin: 5px 0 0 0; color: #6b7280; font-size: 0.85rem;">
                                    Nhận thông báo khi có cập nhật về đơn đặt xe của bạn
                                </p>
                            </div>
                            <input class="form-check-input" type="checkbox" name="notificationBooking"
                                   value="on" ${preference.notificationBooking ? 'checked' : ''}>
                        </div>

                        <div class="form-switch">
                            <div>
                                <h5 style="margin: 0; color: #1f2937;">Thông báo khuyến mãi</h5>
                                <p style="margin: 5px 0 0 0; color: #6b7280; font-size: 0.85rem;">
                                    Nhận thông báo về các ưu đãi và giảm giá mới
                                </p>
                            </div>
                            <input class="form-check-input" type="checkbox" name="notificationPromotion"
                                   value="on" ${preference.notificationPromotion ? 'checked' : ''}>
                        </div>

                        <div class="form-switch">
                            <div>
                                <h5 style="margin: 0; color: #1f2937;">Email hàng tuần</h5>
                                <p style="margin: 5px 0 0 0; color: #6b7280; font-size: 0.85rem;">
                                    Nhận email tóm tắt hoạt động hàng tuần
                                </p>
                            </div>
                            <input class="form-check-input" type="checkbox" name="emailWeekly"
                                   value="on" ${preference.emailWeekly ? 'checked' : ''}>
                        </div>

                        <button type="submit" class="btn btn-primary-custom mt-3">
                            <i class="fas fa-save"></i> Lưu Cài Đặt
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- FOOTER -->

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
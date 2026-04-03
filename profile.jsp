<%@ page import="vn.edu.nlu.fit.datxedulich.model.Member" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
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
            <a href="#" class="menu-item active" onclick="switchTab('info'); return false;"> Thông tin cá nhân</a>
            <a href="#" class="menu-item" onclick="switchTab('bookings'); return false;"> Lịch sử đơn hàng</a>
            <a href="#" class="menu-item" onclick="switchTab('member'); return false;"> Thông tin Member</a>
            <a href="#" class="menu-item" onclick="switchTab('reviews'); return false;"> Lịch sử đánh giá</a>
            <a href="#" class="menu-item" onclick="switchTab('notifications'); return false;"> Thông báo<span class="badge-dot">${unreadCount}</span></a>
            <a href="#" class="menu-item" onclick="switchTab('settings'); return false;"> Cài đặt</a>
            <a href="#" class="menu-item" onclick="switchTab('security'); return false;"> Bảo mật</a>
        </div>
    </div>

    <div class="main-content">

        <div id="tab-info" class="tab-pane active">
            <div class="tab-header">
                <div class="tab-header-left">
                    <h2>Thông tin cá nhân</h2>
                </div>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success" style="margin: 20px 30px 0;">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error" style="margin: 20px 30px 0;">${errorMessage}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/profile" class="form-profile"  novalidate>
                <input type="hidden" name="action" value="updateProfile">

                <div class="form-row"  novalidate>
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
                <div class="tab-header-left">
                    <h2>Lịch sử đơn hàng</h2>
                    <p class="tab-subtitle">Quản lý tất cả các đơn đặt xe của bạn</p>
                </div>
            </div>

            <c:if test="${empty bookingHistory}">
                <div class="empty-state">
                    <p>Bạn chưa có đơn đặt xe nào</p>
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
                                    <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy"/>
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
                                    <span class="status">${booking.status}</span>
                                </div>
                            </div>

                            <div class="booking-footer">
                                <span class="booking-price">
                                    <fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0"/>đ
                                </span>
                                <a href="${pageContext.request.contextPath}/booking-detail?id=${booking.bookingId}" class="btn-view">Chi tiết</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
        
        <div id="tab-member" class="tab-pane">
            <div class="tab-header">
                <div class="tab-header-left">
                    <h2>Thông tin Member</h2>
                </div>
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
                            <fmt:formatNumber value="${member.totalSpent}" pattern="#,##0"/>đ
                        </span>
                        <span class="stat-label">Tổng chi tiêu</span>
                    </div>
                </div>

                <div class="member-join">
                    <p>Ngày tham gia: <strong>
                        <%
                            Member member = (Member) request.getAttribute("member");
                            if (member != null && member.getJoinDate() != null) {
                                java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
                                System.out.print(member.getJoinDate().format(formatter));
                            }
                        %>
                    </strong></p>
                </div>
            </div>
        </div>

       
        <div id="tab-reviews" class="tab-pane">
            <div class="tab-header">
                <div class="tab-header-left">
                    <h2>Lịch sử đánh giá</h2>
                </div>
            </div>

            <c:if test="${empty reviews}">
                <div class="empty-state">
                    <p>Bạn chưa có đánh giá nào</p>
                    <a href="${pageContext.request.contextPath}/list-product" class="btn-primary">
                         Đặt xe để đánh giá
                    </a>
                </div>
            </c:if>

            <c:if test="${not empty reviews}">
                <div style="padding: 30px;">
                    <c:forEach var="review" items="${reviews}">
                        <div class="review-card">
                            <div class="review-header">
                                <div class="review-avatar">${review.bookingCode.substring(0, 1)}</div>
                                <div class="review-info">
                                    <h4>${review.carName}</h4>
                                    <div class="review-meta">
                                        Đơn <strong>${review.bookingCode}</strong> •
                                        <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy"/>
                                    </div>
                                </div>
                                <div class="review-rating">
                                    <c:forEach var="i" begin="1" end="${review.rating}"></c:forEach>
                                </div>
                            </div>
                            <div class="review-comment">
                                "${review.comment}"
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>

        <div id="tab-notifications" class="tab-pane">
            <div class="tab-header">
                <div class="tab-header-left">
                    <h2>Thông báo</h2>
                </div>
                <c:if test="${unreadCount > 0}">
                    <form method="post" action="${pageContext.request.contextPath}/profile" style="display: inline;">
                        <input type="hidden" name="action" value="markAllAsRead">
                        <button type="submit" class="btn-mark-read">Đánh dấu tất cả đã đọc</button>
                    </form>
                </c:if>
            </div>

            <c:if test="${empty notifications}">
                <div class="empty-state">
                    <p>Bạn không có thông báo nào</p>
                </div>
            </c:if>

            <c:if test="${not empty notifications}">
                <div style="padding: 30px;">
                    <c:forEach var="notif" items="${notifications}">
                        <div class="notification-card ${!notif.read ? 'unread' : ''}">
                            <div class="notification-icon">
                                <c:choose>
                                    <c:when test="${notif.type == 'booking'}"></c:when>
                                    <c:when test="${notif.type == 'promotion'}"></c:when>
                                    <c:otherwise></c:otherwise>
                                </c:choose>
                            </div>
                            <div class="notification-content">
                                <div class="notification-title">${notif.title}</div>
                                <div class="notification-text">${notif.content}</div>
                                <div class="notification-time">
                                    <fmt:formatDate value="${notif.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
        
        <div id="tab-settings" class="tab-pane">
            <div class="tab-header">
                <div class="tab-header-left">
                    <h2>Cài đặt</h2>
                </div>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success" style="margin: 20px 30px 0;">${successMessage}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/profile" class="form-profile"  novalidate>
                <input type="hidden" name="action" value="updateSettings">

                <div class="settings-section">
                    <div class="setting-item">
                        <div class="setting-label">
                            <h3> Thông báo đặt xe</h3>
                            <p>Nhận thông báo khi trạng thái đơn thay đổi</p>
                        </div>
                        <label class="toggle-switch">
                            <input type="checkbox" name="notificationBooking" ${preference.notificationBooking ? 'checked' : ''}>
                            <span class="slider"></span>
                        </label>
                    </div>

                    <div class="setting-item">
                        <div class="setting-label">
                            <h3> Thông báo khuyến mãi</h3>
                            <p>Nhận email về các ưu đãi và khuyến mãi mới</p>
                        </div>
                        <label class="toggle-switch">
                            <input type="checkbox" name="notificationPromotion" ${preference.notificationPromotion ? 'checked' : ''}>
                            <span class="slider"></span>
                        </label>
                    </div>

                    <div class="setting-item">
                        <div class="setting-label">
                            <h3> Email tổng hợp hằng tuần</h3>
                            <p>Nhận email tóm tắt các đơn đặt xe và khuyến mãi mỗi tuần</p>
                        </div>
                        <label class="toggle-switch">
                            <input type="checkbox" name="emailWeekly" ${preference.emailWeekly ? 'checked' : ''}>
                            <span class="slider"></span>
                        </label>
                    </div>

                    <div class="setting-item">
                        <div class="setting-label">
                            <h3> Chế độ tối</h3>
                            <p>Bật chế độ tối cho giao diện</p>
                        </div>
                        <label class="toggle-switch">
                            <input type="checkbox" name="preferenceLanguage" ${preference.preferenceLanguage ? 'checked' : ''}>
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>

                <div style="padding: 0 30px 30px;">
                    <button type="submit" class="btn-save"> Lưu cài đặt</button>
                </div>
            </form>
        </div>

        <div id="tab-security" class="tab-pane">
            <div class="tab-header">
                <div class="tab-header-left">
                    <h2>Bảo mật tài khoản</h2>
                </div>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success" style="margin: 20px 30px 0;">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error" style="margin: 20px 30px 0;">${errorMessage}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/profile" class="form-profile"  novalidate>
                <input type="hidden" name="action" value="changePassword">

                <div style="margin-bottom: 24px;">
                    <h3 style="font-size: 1.05rem; font-weight: 600; color: var(--text-main); margin-bottom: 20px;">Đổi mật khẩu</h3>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Mật khẩu hiện tại</label>
                        <input type="password" name="oldPassword" required placeholder="Nhập mật khẩu hiện tại">
                    </div>
                    <div style="width: 100%;"></div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Mật khẩu mới</label>
                        <input type="password" name="newPassword" required placeholder="Tối thiểu 6 ký tự">
                    </div>
                    <div class="form-group">
                        <label>Xác nhận mật khẩu</label>
                        <input type="password" name="confirmPassword" required placeholder="Nhập lại mật khẩu mới">
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-save"> Cập nhật mật khẩu</button>
                    <button type="reset" class="btn-cancel">Hủy</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function switchTab(tabName) {
        event.preventDefault();
        const tabs = document.querySelectorAll('.tab-pane');
        tabs.forEach(tab => tab.classList.remove('active'));
        const menuItems = document.querySelectorAll('.menu-item');
        menuItems.forEach(item => item.classList.remove('active'));
        document.getElementById('tab-' + tabName).classList.add('active');
        event.target.closest('.menu-item').classList.add('active');
    }

    document.querySelectorAll('.toggle-switch input').forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            console.log(this.name + ': ' + this.checked);
        });
    });
</script>

</body>
</html>
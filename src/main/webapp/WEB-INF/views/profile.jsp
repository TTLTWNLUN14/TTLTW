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
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #1e40af;
            --success-color: #16a34a;
            --warning-color: #ea580c;
            --danger-color: #dc2626;
            --light-bg: #f8fafc;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* NAVBAR STYLES */
        .global-nav {
            background: #0d1b2e;
            height: 70px;
            display: flex;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 2px 8px rgba(0,0,0,.1);
        }

        .nav-inner {
            width: 100%;
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 40px;
        }

        .nav-logo {
            color: #ffa500;
            font-weight: bold;
            font-size: 1.3rem;
            letter-spacing: 0.05em;
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
        }

        .nav-logo:hover {
            color: #fff;
        }

        .nav-links {
            display: flex;
            gap: 40px;
            flex: 1;
            margin-left: 40px;
            align-items: center;
        }

        .nav-link {
            color: #cbd5e1;
            font-size: 0.95rem;
            padding: 6px 0;
            transition: color 0.2s;
            text-decoration: none;
        }

        .nav-link:hover {
            color: #fff;
        }

        .nav-link.active {
            color: #ffa500;
        }

        .nav-link.admin-link {
            color: #f5b82e;
            font-weight: 700;
            border: 1.5px solid rgba(245,184,46,.4);
            border-radius: 6px;
            padding: 4px 14px;
            font-size: 0.82rem;
        }

        .nav-link.admin-link:hover {
            background: rgba(245,184,46,.12);
        }

        .nav-actions {
            display: flex;
            gap: 16px;
            align-items: center;
        }

        .btn-login, .btn-register {
            padding: 8px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-login {
            color: #fff;
            background: transparent;
            border: 1.5px solid rgba(255,255,255,.4);
        }

        .btn-login:hover {
            background: rgba(255,255,255,.1);
        }

        .btn-register {
            background: #ffa500;
            color: #0d1b2e;
            border: none;
        }

        .btn-register:hover {
            background: #e69500;
        }

        .notif-wrap {
            position: relative;
            cursor: pointer;
            color: #94a3b8;
            font-size: 1.15rem;
        }

        .notif-wrap:hover {
            color: #fff;
        }

        .notif-badge {
            position: absolute;
            top: -5px;
            right: -6px;
            background: #ef4444;
            color: #fff;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            font-size: 0.68rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .user-avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: #ffa500;
            color: #0d1b2e;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 1rem;
            flex-shrink: 0;
        }

        .user-name {
            color: #fff;
            font-size: 0.9rem;
            font-weight: 500;
            max-width: 130px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .dropdown {
            position: relative;
            display: flex;
            align-items: center;
        }

        .dropdown-toggle {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
        }

        .dropdown-toggle:hover .user-name {
            color: #ffa500;
        }

        .dropdown-caret {
            color: #ffa500;
            font-size: 0.7rem;
        }

        .dropdown-menu {
            display: none;
            position: absolute;
            top: calc(100% + 12px);
            right: 0;
            background: #fff;
            border-radius: 10px;
            min-width: 220px;
            box-shadow: 0 8px 24px rgba(0,0,0,.15);
            overflow: hidden;
            z-index: 200;
        }

        .dropdown-menu.open {
            display: block;
        }

        .dropdown-header {
            padding: 14px 16px 10px;
            border-bottom: 1px solid #f1f5f9;
        }

        .dropdown-header-name {
            font-weight: 700;
            font-size: 0.9rem;
            color: #0f172a;
        }

        .dropdown-header-role {
            font-size: 0.75rem;
            color: #64748b;
            margin-top: 2px;
        }

        .dropdown-item {
            padding: 11px 16px;
            color: #334155;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.88rem;
            transition: background 0.15s;
        }

        .dropdown-item:hover {
            background: #f8fafc;
        }

        .dropdown-item.admin {
            color: #92400e;
            font-weight: 600;
            background: #fffbeb;
        }

        .dropdown-item.admin:hover {
            background: #fef3c7;
        }

        .dropdown-item.logout {
            color: #dc2626;
            border-top: 1px solid #f1f5f9;
        }

        .dropdown-item.logout:hover {
            background: #fef2f2;
        }

        /* MAIN CONTENT */
        .main-wrapper {
            flex: 1;
            padding: 30px 15px;
        }

        .profile-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Profile Header */
        .profile-header {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07);
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
            flex: 1;
        }

        .user-avatar-large {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }

        .user-details h2 {
            color: #1f2937;
            margin-bottom: 5px;
            font-weight: 600;
        }

        .user-details p {
            color: #6b7280;
            margin: 0;
            font-size: 0.95rem;
        }

        .member-stats {
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
        }

        .stat-item {
            text-align: center;
        }

        .stat-value {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary-color);
        }

        .stat-label {
            font-size: 0.85rem;
            color: #6b7280;
            margin-top: 5px;
        }

        /* Navigation Tabs */
        .nav-tabs {
            border-bottom: 2px solid #e5e7eb;
            margin-bottom: 30px;
            gap: 0;
        }

        .nav-tabs .nav-link {
            color: #6b7280;
            border: none;
            border-bottom: 3px solid transparent;
            border-radius: 0;
            font-weight: 500;
            padding: 15px 20px;
            transition: all 0.3s ease;
        }

        .nav-tabs .nav-link:hover {
            color: var(--primary-color);
            border-bottom-color: var(--primary-color);
        }

        .nav-tabs .nav-link.active {
            color: var(--primary-color);
            border-bottom-color: var(--primary-color);
            background: none;
        }

        /* Alert Messages */
        .alert-custom {
            border: none;
            border-left: 4px solid;
            border-radius: 8px;
            margin-bottom: 20px;
            animation: slideIn 0.3s ease;
        }

        .alert-success {
            background-color: #f0fdf4;
            border-left-color: var(--success-color);
            color: #15803d;
        }

        .alert-danger {
            background-color: #fef2f2;
            border-left-color: var(--danger-color);
            color: #7f1d1d;
        }

        @keyframes slideIn {
            from { transform: translateX(-10px); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        /* Form Sections */
        .form-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07);
        }

        .form-section-title {
            color: #1f2937;
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--primary-color);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
            display: block;
        }

        .form-control {
            border: 1.5px solid #e5e7eb;
            border-radius: 8px;
            padding: 10px 15px;
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
            color: white;
        }

        .btn-outline-custom {
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
            background: transparent;
            padding: 10px 25px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .btn-outline-custom:hover {
            background: var(--primary-color);
            color: white;
        }

        /* Notification Section */
        .notification-item {
            background: #f9fafb;
            border-left: 4px solid var(--primary-color);
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            display: flex;
            gap: 15px;
            align-items: flex-start;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .notification-item:hover {
            background: #f3f4f6;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .notification-item.unread {
            background: #eff6ff;
            border-left-color: #3b82f6;
        }

        .notification-icon {
            font-size: 1.3rem;
            color: var(--primary-color);
            min-width: 25px;
            text-align: center;
        }

        .notification-content h5 {
            margin: 0;
            color: #1f2937;
            font-weight: 600;
            font-size: 0.95rem;
        }

        .notification-content p {
            margin: 5px 0 0 0;
            color: #6b7280;
            font-size: 0.85rem;
            line-height: 1.4;
        }

        .notification-time {
            color: #9ca3af;
            font-size: 0.8rem;
            white-space: nowrap;
        }

        .notification-empty {
            text-align: center;
            color: #9ca3af;
            padding: 40px 20px;
        }

        /* Settings Toggle */
        .form-switch {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px;
            background: #f9fafb;
            border-radius: 8px;
            margin-bottom: 12px;
        }

        .form-check-input {
            width: 45px;
            height: 25px;
            cursor: pointer;
        }

        .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        /* Booking History */
        .booking-card {
            background: white;
            border: 1.5px solid #e5e7eb;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .booking-card:hover {
            border-color: var(--primary-color);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.1);
        }

        .booking-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .booking-code {
            font-weight: 700;
            color: var(--primary-color);
            font-family: monospace;
        }

        .booking-status {
            padding: 5px 12px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.85rem;
        }

        .booking-status.completed {
            background: #d1fae5;
            color: #065f46;
        }

        .booking-status.pending {
            background: #fef3c7;
            color: #92400e;
        }

        .booking-status.cancelled {
            background: #fee2e2;
            color: #991b1b;
        }

        /* FOOTER STYLES */
        .footer {
            background: #0d1b2e;
            padding: 60px 0 30px;
            color: #fff;
            border-top: 1px solid rgba(255,255,255,0.05);
            margin-top: auto;
        }

        .footer-grid {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 40px;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 30px;
        }

        .footer-grid > div {
            flex: 1;
            min-width: 200px;
        }

        .footer-grid > div:first-child {
            flex: 1.5;
        }

        .footer-title {
            color: #fff;
            font-weight: 700;
            font-size: 1rem;
            margin-bottom: 20px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .footer-link {
            display: block;
            color: #94a3b8;
            text-decoration: none;
            font-size: 0.85rem;
            margin-bottom: 12px;
            transition: color 0.2s;
        }

        .footer-link:hover {
            color: #ffa500;
        }

        .footer-bottom {
            text-align: center;
            margin-top: 50px;
            padding-top: 25px;
            border-top: 1px solid rgba(255,255,255,0.05);
            color: #64748b;
            font-size: 0.8rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .profile-header {
                padding: 20px;
            }

            .header-content {
                flex-direction: column;
                text-align: center;
            }

            .user-info {
                flex-direction: column;
                justify-content: center;
            }

            .member-stats {
                width: 100%;
                justify-content: space-around;
            }

            .form-section {
                padding: 20px;
            }

            .nav-tabs .nav-link {
                padding: 12px 15px;
                font-size: 0.9rem;
            }

            .nav-inner {
                padding: 0 20px;
            }

            .nav-links {
                gap: 20px;
                margin-left: 20px;
            }
        }
    </style>
</head>
<body>
<!-- NAVBAR HEADER -->
<nav class="global-nav">
    <div class="nav-inner">
        <a class="nav-logo" href="${pageContext.request.contextPath}/index">AUTO CARS</a>

        <div class="nav-links">
            <a class="nav-link" href="${pageContext.request.contextPath}/index">Trang chủ</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/list-product">Xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/brand">Hãng xe</a>

            <c:choose>
                <c:when test="${not empty sessionScope.account_id}">
                    <a class="nav-link" href="${pageContext.request.contextPath}/booking">Đặt xe</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/cart">Member</a>
                </c:when>
                <c:otherwise>
                    <a class="nav-link" href="${pageContext.request.contextPath}/login">Đặt xe</a>
                </c:otherwise>
            </c:choose>

            <c:if test="${sessionScope.role_id == 3}">
                <a class="nav-link admin-link" href="${pageContext.request.contextPath}/admin/dashboard">
                    Dashboard
                </a>
            </c:if>
        </div>

        <div class="nav-actions">
            <c:choose>
                <c:when test="${empty sessionScope.account_id}">
                    <a href="${pageContext.request.contextPath}/login" class="btn-login">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn-register">Đăng ký</a>
                </c:when>

                <c:otherwise>
                    <a class="notif-wrap" href="${pageContext.request.contextPath}/profile">
                        🔔
                        <c:if test="${unreadCount > 0}">
                            <span class="notif-badge">${unreadCount}</span>
                        </c:if>
                    </a>

                    <div class="dropdown">
                        <div class="dropdown-toggle" onclick="toggleDropdown(event)">
                            <div class="user-avatar">
                                    ${fn:substring(sessionScope.full_name, 0, 1)}
                            </div>
                            <span class="user-name">${sessionScope.full_name}</span>
                            <span class="dropdown-caret">▼</span>
                        </div>

                        <div class="dropdown-menu" id="dropdownMenu">
                            <div class="dropdown-header">
                                <div class="dropdown-header-name">${sessionScope.full_name}</div>
                                <div class="dropdown-header-role">
                                    <c:choose>
                                        <c:when test="${sessionScope.role_id == 3}">Quản trị viên</c:when>
                                        <c:otherwise>Khách hàng</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                <i class="fas fa-user"></i> Hồ sơ cá nhân
                            </a>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/my-bookings">
                                <i class="fas fa-calendar"></i> Đơn đặt xe
                            </a>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/cart">
                                <i class="fas fa-crown"></i> Member
                            </a>

                            <c:if test="${sessionScope.role_id == 3}">
                                <a class="dropdown-item admin" href="${pageContext.request.contextPath}/admin/dashboard">
                                    <i class="fas fa-shield-alt"></i> Dashboard Admin
                                </a>
                            </c:if>

                            <a class="dropdown-item logout" href="${pageContext.request.contextPath}/logout">
                                <i class="fas fa-sign-out-alt"></i> Đăng xuất
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

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
<footer class="footer">
    <div class="footer-grid">
        <div>
            <div class="nav-logo" style="margin-bottom:14px">AUTO CARS</div>
            <p style="font-size:.82rem;line-height:1.7;color:#94a3b8;max-width:280px">
                Nền tảng đặt xe du lịch cao cấp hàng đầu Việt Nam.
            </p>
        </div>
        <div>
            <div class="footer-title">Dịch vụ</div>
            <a class="footer-link" href="${pageContext.request.contextPath}/list-product">Danh sách xe</a>
            <a class="footer-link" href="${pageContext.request.contextPath}/brand">Hãng xe</a>
        </div>
        <div>
            <div class="footer-title">Tài khoản</div>
            <c:choose>
                <c:when test="${empty sessionScope.account_id}">
                    <a class="footer-link" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                    <a class="footer-link" href="${pageContext.request.contextPath}/register">Đăng ký</a>
                </c:when>
                <c:otherwise>
                    <a class="footer-link" href="${pageContext.request.contextPath}/profile">Hồ sơ cá nhân</a>
                    <a class="footer-link" href="${pageContext.request.contextPath}/my-bookings">Đơn đặt xe</a>
                    <c:if test="${sessionScope.role_id == 3}">
                        <a class="footer-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard Admin</a>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>
        <div>
            <div class="footer-title">Liên hệ</div>
            <p style="font-size:.83rem;color:#94a3b8;line-height:2.1">
                1800-AUTO-CAR<br>support@autocars.vn<br>
                123 Nguyễn Huệ, Q1, HCM<br>24/7 hỗ trợ
            </p>
        </div>
    </div>
    <div class="footer-bottom">© 2025 AUTO CARS. All rights reserved.</div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleDropdown(event) {
        event.stopPropagation();
        document.getElementById('dropdownMenu').classList.toggle('open');
    }

    document.addEventListener('click', function () {
        const m = document.getElementById('dropdownMenu');
        if (m) m.classList.remove('open');
    });

    // Auto-hide alerts after 5 seconds
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.alert-custom');
        alerts.forEach(alert => {
            setTimeout(() => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }, 5000);
        });
    });
</script>
</body>
</html>
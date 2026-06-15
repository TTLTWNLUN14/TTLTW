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

        .dropdown-menu {
            min-width: 200px;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,.1);
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.2s;
            position: absolute;
            right: 0;
            top: 100%;
            margin-top: 8px;
            z-index: 1000;
            background: white;
        }

        .dropdown-menu.open {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
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

        .main-wrapper {
            flex: 1;
            padding: 30px 15px;
        }

        .profile-container {
            max-width: 1200px;
            margin: 0 auto;
        }

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
            font-size: 1.1rem;
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

        .nav-tabs {
            border-bottom: 2px solid #e5e7eb;
            margin-bottom: 30px;
            gap: 0;
            position: relative;
            z-index: 10;
        }

        .nav-tabs .nav-link {
            color: #6b7280;
            border: none;
            border-bottom: 3px solid transparent;
            border-radius: 0;
            font-weight: 500;
            padding: 15px 20px;
            transition: all 0.3s ease;
            background-color: transparent;
            cursor: pointer;
            position: relative;
            z-index: 11;
            pointer-events: auto !important;
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
        }

        .notification-item:hover {
            background: #f3f4f6;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .notification-item.unread {
            background: #eff6ff;
            border-left-color: #3b82f6;
        }

        .notification-content {
            flex: 1;
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
            flex-shrink: 0;
        }

        .notification-empty {
            text-align: center;
            color: #9ca3af;
            padding: 40px 20px;
        }

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
            }

            .member-stats {
                justify-content: center;
                width: 100%;
            }

            .nav-inner {
                padding: 0 20px;
            }

            .nav-links {
                margin-left: 20px;
                gap: 20px;
            }

            .nav-tabs .nav-link {
                padding: 12px 15px;
                font-size: 0.85rem;
            }
        }
    </style>
</head>
<body>
<nav class="global-nav">
    <div class="nav-inner">
        <a class="nav-logo" href="${pageContext.request.contextPath}/">AUTO CARS</a>
        <div class="nav-links">
            <a class="nav-link active" href="${pageContext.request.contextPath}/">Trang Chủ</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/list-product">Danh Sách Xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/brand">Hãng Xe</a>
        </div>
        <div class="nav-actions">
            <c:choose>
                <c:when test="${empty sessionScope.account_id}">
                    <a href="${pageContext.request.contextPath}/login" class="btn-login">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn-register">Đăng ký</a>
                </c:when>
                <c:otherwise>
                    <div style="position: relative;">
                        <div style="display: flex; align-items: center; gap: 10px; cursor: pointer;"
                             onclick="toggleDropdown(event)">
                            <div class="user-avatar">${fn:substring(sessionScope.fullName, 0, 1)}</div>
                            <div class="user-name">${sessionScope.fullName}</div>
                        </div>
                        <div id="dropdownMenu" class="dropdown-menu">
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Hồ Sơ Cá Nhân</a>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/my-bookings">Đơn Đặt Xe</a>

                            <c:if test="${sessionScope.role_id == 3}">
                                <a class="dropdown-item admin" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard Admin</a>
                            </c:if>

                            <a class="dropdown-item logout" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<div class="main-wrapper">
    <div class="profile-container">
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-custom" role="alert">
                    ${successMessage}
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-custom" role="alert">
                    ${errorMessage}
            </div>
        </c:if>

        <div class="card mb-4 border-0 shadow-sm bg-white rounded-3">
            <div class="card-body d-flex align-items-center justify-content-between p-4 flex-wrap gap-4">

                <div class="d-flex align-items-center flex-wrap gap-4">
                    <div class="position-relative" style="width: 110px; height: 110px; flex-shrink: 0;">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.avatar}">
                                <img src="${pageContext.request.contextPath}/${sessionScope.user.avatar}"
                                     alt="Avatar"
                                     class="rounded-circle img-thumbnail w-100 h-100 object-fit-cover"
                                     id="avatarPreview">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/images/default-avatar.png"
                                     alt="Avatar Mặc Định"
                                     class="rounded-circle img-thumbnail w-100 h-100 object-fit-cover"
                                     id="avatarPreview">
                            </c:otherwise>
                        </c:choose>

                        <form action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data" id="avatarForm">
                            <input type="hidden" name="action" value="updateAvatar">

                            <input type="file" name="avatarFile" id="avatarInput" accept="image/*" class="d-none" onchange="document.getElementById('avatarForm').submit();">

                            <label for="avatarInput" class="position-absolute bottom-0 end-0 bg-primary text-white rounded-circle d-flex align-items-center justify-content-center"
                                   style="width: 30px; height: 30px; cursor: pointer; border: 2px solid #fff; box-shadow: 0 2px 5px rgba(0,0,0,0.2);"
                                   title="Nhấp để đổi ảnh đại diện">
                                <span style="font-size: 18px; font-weight: bold; line-height: 1; margin-top: -2px;">+</span>
                            </label>
                        </form>
                    </div>

                    <div>
                        <div class="d-flex align-items-center mb-2 flex-wrap gap-2">
                            <span class="badge border border-primary text-primary px-3 py-1.5 bg-transparent fw-bold"
                                  style="border-radius: 6px; font-size: 14px; letter-spacing: 0.5px;">
                                Hồ sơ
                            </span>
                            <h4 class="m-0 fw-bold text-dark">${sessionScope.user.full_name}</h4>
                        </div>

                        <div class="text-muted" style="font-size: 14px;">
                            <p class="mb-1"><i class="bi bi-telephone-fill me-2 text-secondary"></i>Số điện thoại: <strong>${sessionScope.user.phone}</strong></p>
                            <p class="mb-0"><i class="bi bi-envelope-fill me-2 text-secondary"></i>Email: <strong>${sessionScope.user.email}</strong></p>
                        </div>
                    </div>
                </div>

                <div class="member-stats my-2">
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
        <ul class="nav nav-tabs" id="profileTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="info-tab" data-bs-toggle="tab" data-bs-target="#info" type="button" role="tab" aria-controls="info" aria-selected="true">
                    Thông Tin Cá Nhân
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="bookings-tab" data-bs-toggle="tab" data-bs-target="#bookings" type="button" role="tab" aria-controls="bookings" aria-selected="false">
                    Lịch Sử Đặt Xe
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="notifications-tab" data-bs-toggle="tab" data-bs-target="#notifications" type="button" role="tab" aria-controls="notifications" aria-selected="false">
                    Thông Báo
                    <c:if test="${unreadCount > 0}">
                        <span class="badge bg-danger ms-2">${unreadCount}</span>
                    </c:if>
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="settings-tab" data-bs-toggle="tab" data-bs-target="#settings" type="button" role="tab" aria-controls="settings" aria-selected="false">
                    Cài Đặt
                </button>
            </li>
        </ul>

        <div class="tab-content">
            <div class="tab-pane fade show active" id="info" role="tabpanel" aria-labelledby="info-tab">

                <div class="form-section">
                    <h3 class="form-section-title">Cập Nhật Thông Tin Cá Nhân</h3>
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

                        <button type="submit" class="btn btn-primary-custom">Lưu Thay Đổi</button>
                    </form>
                </div>

                <div class="form-section">
                    <h3 class="form-section-title">Đổi Mật Khẩu</h3>
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

                        <button type="submit" class="btn btn-primary-custom">Đổi Mật Khẩu</button>
                    </form>
                </div>
            </div>
            <div class="tab-pane fade" id="bookings" role="tabpanel" aria-labelledby="bookings-tab">
                <div class="form-section">
                    <h3 class="form-section-title">Lịch Sử Đặt Xe</h3>

                    <c:choose>
                        <c:when test="${not empty bookingHistory && bookingHistory.size() > 0}">
                            <c:forEach var="booking" items="${bookingHistory}">
                                <div class="booking-card">
                                    <div class="booking-header">
                                        <div>
                                            <div class="booking-code">Mã: ${booking.bookingId}</div>
                                            <p class="mb-0" style="color: #6b7280; font-size: 0.9rem;">
                                                Ngày: <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy"/>
                                            </p>
                                        </div>
                                        <c:choose>
                                            <c:when test="${booking.status == 'Hoàn thành'}">
                                                <span class="booking-status completed">${booking.status}</span>
                                            </c:when>
                                            <c:when test="${booking.status == 'Đã hủy'}">
                                                <span class="booking-status cancelled">${booking.status}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="booking-status pending">${booking.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div style="color: #4b5563; font-size: 0.9rem; line-height: 1.8;">
                                        <p style="margin: 8px 0;">
                                            <strong>Xe:</strong> ${booking.carName}
                                        </p>
                                        <p style="margin: 8px 0;">
                                            <strong>Tuyến đường:</strong> ${booking.route}
                                        </p>
                                        <p style="margin: 8px 0;">
                                            <strong>Thời gian đón:</strong> ${booking.pickupTime}
                                        </p>
                                        <p style="margin: 8px 0;">
                                            <strong>Thời gian trả:</strong> ${booking.returnTime}
                                        </p>
                                        <p style="margin: 8px 0;">
                                            <strong>Khoảng cách:</strong> ${booking.km} km
                                        </p>
                                        <p style="margin: 8px 0; color: var(--primary-color); font-weight: 600;">
                                            <strong>Tổng tiền:</strong> <fmt:formatNumber value="${booking.totalPrice}" type="number"/>₫
                                        </p>
                                        <c:if test="${not empty booking.note}">
                                            <p style="margin: 8px 0; font-style: italic; color: #6b7280;">
                                                <strong>Ghi chú:</strong> ${booking.note}
                                            </p>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="notification-empty">
                                <p style="margin-top: 15px;">Bạn chưa có chuyến xe nào</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="tab-pane fade" id="notifications" role="tabpanel" aria-labelledby="notifications-tab">
                <div class="form-section">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <h3 class="form-section-title mb-0">Thông Báo của Bạn</h3>
                        <c:if test="${unreadCount > 0}">
                            <form method="POST" action="${pageContext.request.contextPath}/profile" style="display: inline;">
                                <input type="hidden" name="action" value="markAllAsRead">
                                <button type="submit" class="btn btn-outline-custom">Đánh dấu tất cả đã đọc</button>
                            </form>
                        </c:if>
                    </div>

                    <c:choose>
                        <c:when test="${not empty notifications && notifications.size() > 0}">
                            <c:forEach var="notif" items="${notifications}">
                                <div style="background: #f9fafb; border-left: 4px solid #2563eb; border-radius: 8px; padding: 15px; margin-bottom: 15px; display: flex; gap: 15px; align-items: flex-start;">
                                    <div style="flex: 1;">
                                        <h5 style="margin: 0; color: #1f2937; font-weight: 600; font-size: 0.95rem;">
                                                ${notif.title}
                                        </h5>
                                        <p style="margin: 5px 0 0 0; color: #6b7280; font-size: 0.85rem; line-height: 1.4;">
                                                ${notif.content}
                                        </p>
                                    </div>
                                    <div style="color: #9ca3af; font-size: 0.8rem; white-space: nowrap;">
                                            ${notif.createdAt}
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align: center; color: #9ca3af; padding: 40px 20px;">
                                <p style="margin-top: 15px;">Bạn chưa có thông báo nào</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="tab-pane fade" id="settings" role="tabpanel" aria-labelledby="settings-tab">
                <div class="form-section">
                    <h3 class="form-section-title">Tùy Chỉnh Thông Báo</h3>
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

                        <button type="submit" class="btn btn-primary-custom mt-3">Lưu Cài Đặt</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

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

    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.alert-custom');
        alerts.forEach(alert => {
            setTimeout(() => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }, 5000);
        });

        const activeTabId = sessionStorage.getItem('activeTab');
        if (activeTabId) {
            const tabBtn = document.getElementById(activeTabId);
            if (tabBtn) {
                const tab = new bootstrap.Tab(tabBtn);
                tab.show();
            }
        }
        const tabButtons = document.querySelectorAll('#profileTabs button');
        tabButtons.forEach(button => {
            button.addEventListener('shown.bs.tab', function (e) {
                sessionStorage.setItem('activeTab', e.target.id);
            });
        });
    });
</script>
</body>
</html>
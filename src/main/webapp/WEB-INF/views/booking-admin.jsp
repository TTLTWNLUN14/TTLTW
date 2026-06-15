<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đặt xe - Auto Cars Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/booking-admin.css">
</head>
<body>

<div class="sidebar">
    <div class="sidebar-header">Auto Cars Admin</div>

    <div class="menu-title">TỔNG QUAN</div>
    <a href="#" class="menu-item">Dashboard</a>

    <div class="menu-title">VẬN HÀNH</div>
    <a href="booking-admin" class="menu-item active">Quản lý đặt xe</a>
    <a href="admin-payment" class="menu-item">Quản lý thanh toán</a>

    <div class="menu-title">DANH MỤC</div>
    <a href="${pageContext.request.contextPath}/brand-admin" class="menu-item">Hãng xe</a>
    <a href="${pageContext.request.contextPath}/cars-admin" class="menu-item">Loại xe</a>
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

    <c:if test="${param.msg == 'deleted'}">
        <div class="toast toast-success" id="toastMsg">Đã xóa đơn đặt xe thành công.</div>
    </c:if>
    <c:if test="${param.msg == 'edit_ok'}">
        <div class="toast toast-success" id="toastMsg">Cập nhật đơn thành công.</div>
    </c:if>
    <c:if test="${param.msg == 'replace_ok'}">
        <div class="toast toast-success" id="toastMsg">Đã tạo đơn bù với giá giảm 20% thành công.</div>
    </c:if>
    <c:if test="${param.msg == 'replace_err'}">
        <div class="toast toast-error" id="toastMsg">Không thể tạo đơn bù. Đơn chưa ở trạng thái Đã hủy hoặc đã tạo
            trước đó.
        </div>
    </c:if>
    <c:if test="${param.msg == 'error'}">
        <div class="toast toast-error" id="toastMsg">Có lỗi xảy ra. Vui lòng thử lại.</div>
    </c:if>

    <div class="page-header">
        <h1 class="page-title">Quản lý đặt xe</h1>
        <span class="record-count">Tổng <strong>${totalItems}</strong> đơn đặt xe</span>
    </div>

    <div class="filter-bar">
        <form method="get" action="${pageContext.request.contextPath}/booking-admin"
              style="display:flex; gap:10px; align-items:center; flex-wrap:wrap; flex:1;">

            <div class="search-wrap">
                <span class="search-icon">🔍</span>
                <input type="text" name="keyword" class="search-input"
                       placeholder="Tên khách, SĐT, mã đơn, loại xe…"
                       value="${filterKeyword}">
            </div>

            <select name="status" class="filter-select">
                <option value="">-- Tất cả trạng thái --</option>
                <option value="Chờ xác nhận" <c:if test="${filterStatus == 'Chờ xác nhận'}">selected</c:if>>Chờ xác
                    nhận
                </option>
                <option value="Đã xác nhận" <c:if test="${filterStatus == 'Đã xác nhận'}">selected</c:if>>Đã xác nhận
                </option>
                <option value="Đang chạy" <c:if test="${filterStatus == 'Đang chạy'}">selected</c:if>>Đang chạy</option>
                <option value="Hoàn thành" <c:if test="${filterStatus == 'Hoàn thành'}">selected</c:if>>Hoàn thành
                </option>
                <option value="Đã hủy" <c:if test="${filterStatus == 'Đã hủy'}">selected</c:if>>Đã hủy</option>
            </select>
            <button type="submit" class="btn-filter">Tìm kiếm</button>
        </form>

        <a href="${pageContext.request.contextPath}/booking-admin" class="btn-reset-filter">✕ Xóa lọc</a>
    </div>

    <div class="table-container">
        <table class="custom-table">
            <thead>
            <tr>
                <th>#</th>
                <th>Khách hàng</th>
                <th>Loại xe</th>
                <th>Hành trình</th>
                <th>Tổng tiền</th>
                <th>Trạng thái</th>
                <th>Thanh toán</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="b" items="${listBookings}">
                <tr>
                    <td><strong>#${b.bookingId}</strong></td>
                    <td>
                        <div class="booker-name">${b.bookerName}</div>
                        <div class="booker-phone">${b.bookerPhone}</div>
                    </td>
                    <td>${b.carName}</td>
                    <td>
                        <span class="route-text">${b.pickupProvince}</span>
                        <span class="route-arrow">→</span>
                        <span class="route-text">${b.dropoffProvince}</span>
                        <div class="route-meta">${b.km} km · ${b.days} ngày</div>
                    </td>
                    <td>
                        <span class="price-text">
                            <fmt:formatNumber value="${b.totalPrice}" pattern="#,###"/> đ
                        </span>
                    </td>

                    <td>
                        <c:choose>
                            <c:when test="${b.status == 'Chờ xác nhận'}">
                                <span class="status-badge bg-pending">Chờ xác nhận</span>
                            </c:when>
                            <c:when test="${b.status == 'Đã xác nhận'}">
                                <span class="status-badge bg-confirmed">Đã xác nhận</span>
                            </c:when>
                            <c:when test="${b.status == 'Đang chạy'}">
                                <span class="status-badge bg-ongoing">Đang chạy</span>
                            </c:when>
                            <c:when test="${b.status == 'Hoàn thành'}">
                                <span class="status-badge bg-completed">Hoàn thành</span>
                            </c:when>
                            <c:when test="${b.status == 'Đã hủy'}">
                                <span class="status-badge bg-cancelled">Đã hủy</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge">${b.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>
                        <c:choose>
                            <c:when test="${b.paymentStatus == 'SUCCESS'}">
                                <span class="pay-badge pay-success">Đã thanh toán</span>
                            </c:when>
                            <c:when test="${b.paymentStatus == 'PENDING'}">
                                <span class="pay-badge pay-pending">Chờ thanh toán</span>
                            </c:when>
                            <c:otherwise>
                                <span class="pay-badge pay-fail">Thất bại</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td class="action-buttons">
                        <button class="btn-edit"
                                onclick="openEditModal(
                                    ${b.bookingId},
                                        '${b.bookerName}',
                                        '${b.bookerPhone}',
                                        '${b.bookerAddress}',
                                        '${b.pickupProvince}',
                                        '${b.dropoffProvince}',
                                        '${b.pickupTime}',
                                        '${b.returnTime}',
                                        '${b.note}',
                                        '${b.status}',
                                    ${b.totalPrice}
                                        )">&#x270E; Sửa
                        </button>

                        <button class="btn-disable"
                                onclick="openDeleteConfirm(${b.bookingId}, '#${b.bookingId} - ${b.bookerName}')">Xóa
                        </button>

                        <button class="btn-replace ${b.status == 'Đã hủy' ? '' : 'disabled'}"
                                title="${b.status == 'Đã hủy' ? 'Tạo đơn bù cho khách (giảm 20%)' : 'Chỉ khả dụng khi đơn đã hủy'}"
                                <c:if test="${b.status == 'Đã hủy'}">
                                    onclick="openReplaceConfirm(${b.bookingId}, '${b.bookerName}', ${b.totalPrice})"
                                </c:if>
                            ${b.status != 'Đã hủy' ? 'disabled' : ''}>
                            Tạo đơn bù
                        </button>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty listBookings}">
                <tr>
                    <td colspan="8" class="empty-table-cell">
                        <c:choose>
                            <c:when test="${not empty filterKeyword or not empty filterStatus or not empty filterDateFrom}">
                                Không tìm thấy đơn đặt xe phù hợp.
                                <a href="${pageContext.request.contextPath}/booking-admin">Xem tất cả</a>
                            </c:when>
                            <c:otherwise>Chưa có đơn đặt xe nào trong hệ thống.</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <%-- phân trang--%>
    <c:if test="${totalPages > 1}">
        <div class="pagination" style="
            display:flex; justify-content:center; align-items:center;
            gap:6px; margin-top:32px; flex-wrap:wrap;">

            <c:choose>
                <c:when test="${currentPage > 1}">
                    <a href="${pageContext.request.contextPath}/booking-admin?page=${currentPage - 1}<c:if test='${not empty filterKeyword}'>&keyword=${filterKeyword}</c:if><c:if test='${not empty filterStatus}'>&status=${filterStatus}</c:if><c:if test='${not empty filterDateFrom}'>&dateFrom=${filterDateFrom}</c:if><c:if test='${not empty filterDateTo}'>&dateTo=${filterDateTo}</c:if>"
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
                        <a href="${pageContext.request.contextPath}/booking-admin?page=${i}<c:if test='${not empty filterKeyword}'>&keyword=${filterKeyword}</c:if><c:if test='${not empty filterStatus}'>&status=${filterStatus}</c:if><c:if test='${not empty filterDateFrom}'>&dateFrom=${filterDateFrom}</c:if><c:if test='${not empty filterDateTo}'>&dateTo=${filterDateTo}</c:if>"
                           class="page-btn">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:choose>
                <c:when test="${currentPage < totalPages}">
                    <a href="${pageContext.request.contextPath}/booking-admin?page=${currentPage + 1}<c:if test='${not empty filterKeyword}'>&keyword=${filterKeyword}</c:if><c:if test='${not empty filterStatus}'>&status=${filterStatus}</c:if><c:if test='${not empty filterDateFrom}'>&dateFrom=${filterDateFrom}</c:if><c:if test='${not empty filterDateTo}'>&dateTo=${filterDateTo}</c:if>"
                       class="page-btn">Sau ›</a>
                </c:when>
                <c:otherwise>
                    <span class="page-btn disabled">Sau ›</span>
                </c:otherwise>
            </c:choose>

        </div>

        <p style="text-align:center; color:#94a3b8; font-size:0.85rem; margin-top:8px;">
            Trang ${currentPage}/${totalPages} — ${totalItems} đơn đặt xe
        </p>
    </c:if>

</div>

<div class="modal-overlay" id="editOverlay">
    <div class="modal-box modal-wide">
        <h3>Sửa thông tin đơn <span id="editBookingLabel"></span></h3>
        <form id="editForm" method="post"
              action="${pageContext.request.contextPath}/booking-admin">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="bookingId" id="editBookingId">
            <input type="hidden" name="page" value="${currentPage}">
            <input type="hidden" name="keyword" value="${filterKeyword}">
            <input type="hidden" name="filterStatus" value="${filterStatus}">
            <input type="hidden" name="filterDateFrom" value="${filterDateFrom}">
            <input type="hidden" name="filterDateTo" value="${filterDateTo}">

            <div class="form-grid">
                <div class="form-group">
                    <label>Tên người đặt</label>
                    <input type="text" name="bookerName" id="editBookerName" class="modal-input">
                </div>
                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input type="text" name="bookerPhone" id="editBookerPhone" class="modal-input">
                </div>
                <div class="form-group">
                    <label>Địa chỉ</label>
                    <input type="text" name="bookerAddress" id="editBookerAddress" class="modal-input">
                </div>
                <div class="form-group">
                    <label>Trạng thái</label>
                    <select name="status" id="editStatus" class="modal-select">
                        <option value="Chờ xác nhận">Chờ xác nhận</option>
                        <option value="Đã xác nhận">Đã xác nhận</option>
                        <option value="Đang chạy">Đang chạy</option>
                        <option value="Hoàn thành">Hoàn thành</option>
                        <option value="Đã hủy">Đã hủy</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Tỉnh đón</label>
                    <input type="text" name="pickupProvince" id="editPickup" class="modal-input">
                </div>
                <div class="form-group">
                    <label>Tỉnh trả</label>
                    <input type="text" name="dropoffProvince" id="editDropoff" class="modal-input">
                </div>
                <div class="form-group">
                    <label>Ngày đón</label>
                    <input type="text" name="pickupTime" id="editPickupTime" class="modal-input">
                </div>
                <div class="form-group">
                    <label>Ngày trả</label>
                    <input type="text" name="returnTime" id="editReturnTime" class="modal-input">
                </div>
                <div class="form-group">
                    <label>Tổng tiền (đ)</label>
                    <input type="number" name="totalPrice" id="editTotalPrice" class="modal-input">
                </div>
                <div class="form-group form-full">
                    <label>Ghi chú</label>
                    <textarea name="note" id="editNote" class="modal-textarea" rows="2"></textarea>
                </div>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn-modal-cancel" onclick="closeModal('editOverlay')">Hủy bỏ</button>
                <button type="submit" class="btn-modal-confirm">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</div>

<div class="modal-overlay" id="deleteOverlay">
    <div class="modal-box">
        <h3>Xác nhận xóa đơn</h3>
        <p>Bạn có chắc muốn xóa đơn<br><strong id="deleteBookingLabel"></strong>?</p>
        <div class="modal-warning">⚠️ Hành động này không thể hoàn tác.</div>
        <div class="modal-actions">
            <button class="btn-modal-cancel" onclick="closeModal('deleteOverlay')">Hủy bỏ</button>
            <button class="btn-modal-delete" onclick="submitDelete()">Xóa đơn</button>
        </div>
    </div>
</div>
<form id="deleteForm" method="post"
      action="${pageContext.request.contextPath}/booking-admin" style="display:none;">
    <input type="hidden" name="action" value="delete">
    <input type="hidden" name="bookingId" id="deleteBookingId">
    <input type="hidden" name="page" value="${currentPage}">
    <input type="hidden" name="keyword" value="${filterKeyword}">
    <input type="hidden" name="filterStatus" value="${filterStatus}">
    <input type="hidden" name="filterDateFrom" value="${filterDateFrom}">
    <input type="hidden" name="filterDateTo" value="${filterDateTo}">
</form>

<!-- ══════════════ MODAL: TẠO ĐƠN BÙ ══════════════ -->
<div class="modal-overlay" id="replaceOverlay">
    <div class="modal-box">
        <h3>Tạo đơn bù cho khách</h3>
        <p>Đơn gốc: <strong id="replaceBookingLabel"></strong></p>

        <div class="replace-price-info">
            <div class="replace-row">
                <span>Giá đơn gốc</span>
                <span id="replaceOrigPrice" class="price-orig"></span>
            </div>
            <div class="replace-row discount-row">
                <span>Giảm 20% ưu đãi</span>
                <span id="replaceDiscountAmt" class="price-discount">−</span>
            </div>
            <div class="replace-row total-row">
                <span>Khách thanh toán</span>
                <span id="replaceNewPrice" class="price-new"></span>
            </div>
        </div>

        <p class="replace-note">
            Hệ thống sẽ tạo đơn mới giữ nguyên thông tin hành trình, khách hàng
            và áp dụng giá ưu đãi 20% thay thế đơn đã hủy.
        </p>

        <div class="modal-actions">
            <button class="btn-modal-cancel" onclick="closeModal('replaceOverlay')">Hủy bỏ</button>
            <button class="btn-modal-replace" onclick="submitReplace()">Xác nhận tạo đơn bù</button>
        </div>
    </div>
</div>
<form id="replaceForm" method="post"
      action="${pageContext.request.contextPath}/booking-admin" style="display:none;">
    <input type="hidden" name="action" value="createReplacement">
    <input type="hidden" name="originalBookingId" id="replaceOriginalId">
</form>

<script src="${pageContext.request.contextPath}/assets/js/booking-admin.js"></script>
</body>
</html>
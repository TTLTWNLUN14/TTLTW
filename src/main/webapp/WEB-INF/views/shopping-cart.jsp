<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<html>
<head>
    <title>Giỏ hàng - Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shopping-cart.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nav.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/includes/header.jsp">
    <jsp:param name="activePage" value="cart"/>
</jsp:include>

<c:if test="${param.error == 'no_item_selected'}">
    <div class="toast toast-error" id="errorToast">
        Vui lòng chọn ít nhất 1 đơn để tiến hành đặt xe.
    </div>
</c:if>

<div class="container">
    <div class="left-panel">
        <div class="tabs">
            <div class="tab active" id="tabCart" onclick="switchTab('cart')">Giỏ hàng</div>
            <div class="tab" id="tabHistory" onclick="switchTab('history')">Lịch sử đặt xe</div>
        </div>

        <div id="cartSection">
            <div class="select-all-bar">
                <label>
                    <input type="checkbox" id="selectAll" onchange="toggleSelectAll(this)">
                    Chọn tất cả
                </label>
            </div>

            <div class="order-list">
                <c:forEach items="${sessionScope.cart.items}" var="ci">
                    <c:set var="itemTypeIdStr">${ci.product.typeId}</c:set>
                    <c:set var="isOpen" value="${param.openDetailId == itemTypeIdStr}"/>

                    <div class="order-card">
                        <input type="checkbox"
                               class="item-checkbox"
                               value="${ci.product.typeId}"
                               data-total="${ci.price * ci.km * ci.quantity}"
                               onchange="updateSelectedTotal()">

                        <div class="order-info">
                            <h4>
                                <a href="${pageContext.request.contextPath}/list-product/product?typeId=${ci.product.typeId}"
                                   class="order-link">
                                        ${ci.product.typeName}
                                </a>
                            </h4>
                            <p>
                                <span class="highlight-text">Giá/KM:</span>
                                <strong><fmt:formatNumber value="${ci.price}" type="number"/></strong> VND/KM
                                &nbsp;|&nbsp;
                                <span class="highlight-text">Số KM:</span>
                                <strong>${ci.km}</strong> km
                            </p>

                            <div class="qty-wrapper">
                                <span class="highlight-text">Số lượng:</span>
                                <form action="${pageContext.request.contextPath}/update-cart" method="post"
                                      class="qty-form">
                                    <input type="hidden" name="productId" value="${ci.product.typeId}">
                                    <input type="hidden" name="quantity"
                                           value="${ci.quantity > 1 ? ci.quantity - 1 : 1}">
                                    <button type="submit" class="qty-btn" ${ci.quantity <= 1 ? 'disabled' : ''}>−
                                    </button>
                                </form>
                                <span class="qty-display">${ci.quantity}</span>
                                <form action="${pageContext.request.contextPath}/update-cart" method="post"
                                      class="qty-form">
                                    <input type="hidden" name="productId" value="${ci.product.typeId}">
                                    <input type="hidden" name="quantity" value="${ci.quantity + 1}">
                                    <button type="submit" class="qty-btn">+</button>
                                </form>
                            </div>

                            <p>Thành tiền:
                                <strong><fmt:formatNumber value="${ci.price * ci.km * ci.quantity}" type="number"/>
                                    VND</strong>
                            </p>

                            <div class="detail-panel <c:if test='${isOpen}'>open</c:if>"
                                 id="detail-${ci.product.typeId}">
                                <form action="${pageContext.request.contextPath}/update-cart-detail" method="post"
                                      accept-charset="UTF-8">
                                    <input type="hidden" name="productId" value="${ci.product.typeId}">
                                    <div class="detail-grid">
                                        <div class="detail-section-title">Thông tin xe</div>
                                        <div class="detail-field">
                                            <label>Hãng xe</label>
                                            <select name="brandId" onchange="this.form.submit()">
                                                <option value="">-- Chọn hãng xe --</option>
                                                <c:forEach items="${brands}" var="b">
                                                    <option value="${b.brandId}"
                                                            <c:if test="${b.brandId == ci.selectedBrandId}">selected</c:if>>
                                                            ${b.brandName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="detail-field">
                                            <label>Tên xe</label>
                                            <select name="selectedTypeId" onchange="this.form.submit()">
                                                <option value="">-- Chọn tên xe --</option>
                                                <c:if test="${ci.selectedBrandId > 0}">
                                                    <c:forEach items="${carsMap[ci.selectedBrandId]}" var="ct">
                                                        <option value="${ct.typeId}"
                                                                <c:if test="${ct.typeId == ci.selectedTypeId}">selected</c:if>>
                                                                ${ct.typeName}
                                                        </option>
                                                    </c:forEach>
                                                </c:if>
                                            </select>
                                        </div>
                                        <div class="detail-section-title">Tuyến đường</div>
                                        <div class="detail-field">
                                            <label>Tỉnh / Thành đón</label>
                                            <select name="fromProvinceId" onchange="this.form.submit()">
                                                <option value="">-- Điểm đón --</option>
                                                <c:forEach items="${provinces}" var="p">
                                                    <option value="${p.provinceId}" data-name="${p.provinceName}"
                                                            <c:if test="${p.provinceId == ci.fromProvinceId}">selected</c:if>>
                                                            ${p.provinceName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <input type="hidden" name="fromProvinceName" value="${ci.fromProvinceName}">
                                        </div>
                                        <div class="detail-field">
                                            <label>Tỉnh / Thành đến</label>
                                            <select name="toProvinceId" onchange="this.form.submit()">
                                                <option value="">-- Điểm đến --</option>
                                                <c:forEach items="${provinces}" var="p">
                                                    <option value="${p.provinceId}" data-name="${p.provinceName}"
                                                            <c:if test="${p.provinceId == ci.toProvinceId}">selected</c:if>>
                                                            ${p.provinceName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <input type="hidden" name="toProvinceName" value="${ci.toProvinceName}">
                                        </div>
                                        <c:if test="${ci.km > 0}">
                                            <div class="detail-field">
                                                <label>Khoảng cách ước tính</label>
                                                <span><strong>${ci.km} km</strong></span>
                                            </div>
                                        </c:if>
                                        <div class="detail-section-title">Thời gian</div>
                                        <div class="detail-field">
                                            <label>Ngày giờ đón</label>
                                            <input type="datetime-local" name="pickupTime" value="${ci.pickupTime}">
                                        </div>
                                        <div class="detail-field">
                                            <label>Ngày giờ trả xe</label>
                                            <input type="datetime-local" name="returnTime" value="${ci.returnTime}">
                                        </div>
                                    </div>
                                    <div class="detail-actions">
                                        <button type="submit" class="btn-save-detail">💾 Lưu thông tin</button>
                                    </div>
                                </form>
                            </div>

                            <div class="item-actions-wrapper">
                                <form action="${pageContext.request.contextPath}/del-item" method="post"
                                      class="form-inline">
                                    <input type="hidden" name="productId" value="${ci.product.typeId}">
                                    <button type="submit" class="btn-delete">Xóa</button>
                                </form>

                                <button type="button" class="btn-detail"
                                        onclick="toggleDetail(this, '${ci.product.typeId}')">
                                    <c:choose>
                                        <c:when test="${isOpen}">Ẩn chi tiết ▴</c:when>
                                        <c:otherwise>Xem chi tiết ▾</c:otherwise>
                                    </c:choose>
                                </button>
                            </div>

                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="booking-history-section" id="historySection">
            <div class="status-tabs">
                <a href="${pageContext.request.contextPath}/my-shopping-cart?statusFilter=all"
                   class="status-tab ${(statusFilter == null || statusFilter == 'all') ? 'active' : ''}">
                    Tất cả
                </a>
                <a href="${pageContext.request.contextPath}/my-shopping-cart?statusFilter=Chờ xác nhận"
                   class="status-tab ${statusFilter == 'Chờ xác nhận' ? 'active' : ''}">
                    Chờ xác nhận
                </a>
                <a href="${pageContext.request.contextPath}/my-shopping-cart?statusFilter=Đang diễn ra"
                   class="status-tab ${statusFilter == 'Đang diễn ra' ? 'active' : ''}">
                    Đang diễn ra
                </a>
                <a href="${pageContext.request.contextPath}/my-shopping-cart?statusFilter=Hoàn thành"
                   class="status-tab ${statusFilter == 'Hoàn thành' ? 'active' : ''}">
                    Hoàn thành
                </a>
                <a href="${pageContext.request.contextPath}/my-shopping-cart?statusFilter=Đã hủy"
                   class="status-tab ${statusFilter == 'Đã hủy' ? 'active' : ''}">
                    Đã hủy
                </a>
            </div>
            <c:choose>
                <c:when test="${not empty bookingHistory}">
                    <table class="history-table">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Tên xe</th>
                            <th>Lộ trình</th>
                            <th>Ngày đặt</th>
                            <th>Tổng tiền</th>
                            <th>Người đặt</th>
                            <th>Trạng thái</th>
                            <th></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${bookingHistory}" var="bk">
                            <tr>
                                <td>#${bk.bookingId}</td>
                                <td><strong>${bk.carName}</strong></td>
                                <td>${bk.route}</td>
                                <td>${bk.bookingDate}</td>
                                <td><fmt:formatNumber value="${bk.totalPrice}" type="number"/> VND</td>
                                <td>${bk.bookerName}<br><small>${bk.bookerPhone}</small></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${bk.status == 'Chờ xác nhận'}">
                                            <span class="status-badge-order badge-cho">${bk.status}</span>
                                        </c:when>
                                        <c:when test="${bk.status == 'Đang diễn ra'}">
                                            <span class="status-badge-order badge-dang">${bk.status}</span>
                                        </c:when>
                                        <c:when test="${bk.status == 'Hoàn thành'}">
                                            <span class="status-badge-order badge-hoan">${bk.status}</span>
                                        </c:when>
                                        <c:when test="${bk.status == 'Đã hủy'}">
                                            <span class="status-badge-order badge-huy">${bk.status}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge-order">${bk.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${bk.status == 'Chờ xác nhận'}">
                                        <button type="button" class="btn-cancel-order"
                                                onclick="openCancelModal(${bk.bookingId})">
                                            Hủy đơn
                                        </button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="history-empty">Không có đơn nào phù hợp.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="right-panel" id="rightPanel">
        <h3>Đơn đã chọn</h3>
        <hr>
        <div class="total-price">
            <span>Đã chọn: <strong id="selectedCount">0</strong> đơn</span>
        </div>
        <div class="total-price">
            <span>Tổng tiền:</span>
            <strong id="selectedTotal">0 VND</strong>
        </div>
        <c:forEach items="${sessionScope.cart.items}" var="ci">
            <div class="selected-item-text">
                    ${ci.product.typeName}:
                <fmt:formatNumber value="${ci.price}" type="number"/> × ${ci.km} km × ${ci.quantity} =
                <strong><fmt:formatNumber value="${ci.price * ci.km * ci.quantity}" type="number"/> VND</strong>
            </div>
        </c:forEach>
        <hr>

        <form id="bookingForm" action="${pageContext.request.contextPath}/booking" method="post">
            <input type="hidden" name="step" value="1">
        </form>
        <button id="btnBooking" class="btn-payment" onclick="submitBooking()" disabled>
            Tiến hành đặt xe →
        </button>
    </div>
</div>

<div id="cancelModal">
    <div class="modal-box">
        <h3>Xác nhận hủy đơn</h3>
        <p>Bạn có chắc muốn hủy đơn <strong id="cancelModalLabel"></strong> không? Hành động này không thể hoàn tác.</p>
        <form id="cancelForm" action="${pageContext.request.contextPath}/cancel-booking" method="post">
            <input type="hidden" name="bookingId" id="cancelBookingIdInput">
            <div class="modal-actions">
                <button type="button" class="btn-modal-cancel" id="cancelModalClose">Không, ở lại</button>
                <button type="submit" class="btn-modal-confirm">Có, hủy đơn</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/shopping-cart.js"></script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Danh sách xe - Auto Cars</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/list-cars.css">
    <script>
        const CONTEXT_PATH = '${pageContext.request.contextPath}';
    </script>
</head>
<body>

<nav class="global-nav">
    <div class="nav-inner">
        <a class="nav-logo" href="${pageContext.request.contextPath}/index.jsp">AUTO CARS</a>
        <div class="nav-links">
            <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a>
            <a class="nav-link active" href="${pageContext.request.contextPath}/list-product">Xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/cars-brand">Hãng xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/booking">Đặt xe</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/my-shopping-cart">
                Giỏ hàng (<span class="cart-count"><c:out
                    value="${sessionScope.cart.totalQuantity != null ? sessionScope.cart.totalQuantity : 0}"/></span>)
            </a>
        </div>
        <div class="nav-actions" id="navActions">
            <a href="#" class="btn-login">Đăng nhập</a>
            <a href="#" class="btn-login ml-20">Đăng ký</a>
        </div>
    </div>
</nav>

<div class="page-main">
    <div class="page-wrap-lg">

        <div class="cars-hero">
            <h1>Chọn xe phù hợp với bạn</h1>
            <p>Hơn 100+ mẫu xe cao cấp từ các thương hiệu uy tín – Giao/nhận tận nơi</p>
        </div>

        <div class="brands-filter-bar" id="brandFilterBar">
            <button class="brand-pill ${empty selectedBrandId ? 'active' : ''}"
                    onclick="filterBrand(0, this)">Tất cả
            </button>
            <c:forEach items="${brands}" var="b">
                <button class="brand-pill ${b.brandId == selectedBrandId ? 'active' : ''}"
                        onclick="filterBrand(${b.brandId}, this)">${b.brandName}</button>
            </c:forEach>
        </div>

        <div class="cars-layout">

            <div class="cars-sidebar">
                <form method="get" action="${pageContext.request.contextPath}/list-product" id="filterForm">

                    <div class="filter-section">
                        <div class="filter-title">Hãng xe</div>
                        <select name="brandId" class="filter-select">
                            <option value="">-- Tất cả hãng --</option>
                            <c:forEach var="b" items="${brands}">
                                <option value="${b.brandId}"
                                        <c:if test="${b.brandId == selectedBrandId}">selected</c:if>>
                                        ${b.brandName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="filter-section">
                        <div class="filter-title">Loại xe</div>
                        <select name="category" class="filter-select">
                            <option value="">-- Tất cả --</option>
                            <option value="SUV" <c:if test="${selectedCategory == 'SUV'}">selected</c:if>>SUV</option>
                            <option value="Sedan" <c:if test="${selectedCategory == 'Sedan'}">selected</c:if>>Sedan
                            </option>
                            <option value="MPV" <c:if test="${selectedCategory == 'MPV'}">selected</c:if>>MPV</option>
                            <option value="Pickup" <c:if test="${selectedCategory == 'Pickup'}">selected</c:if>>Pickup
                            </option>
                            <option value="Hatchback" <c:if test="${selectedCategory == 'Hatchback'}">selected</c:if>>
                                Hatchback
                            </option>
                        </select>
                    </div>

                    <div class="filter-section">
                        <div class="filter-title">Số chỗ ngồi</div>
                        <select name="seatingPlan" class="filter-select">
                            <option value="">-- Tất cả --</option>
                            <option value="4" <c:if test="${selectedSeat == 4}">selected</c:if>>4 chỗ</option>
                            <option value="5" <c:if test="${selectedSeat == 5}">selected</c:if>>5 chỗ</option>
                            <option value="7" <c:if test="${selectedSeat == 7}">selected</c:if>>7 chỗ</option>
                            <option value="9" <c:if test="${selectedSeat == 9}">selected</c:if>>9 chỗ</option>
                            <option value="16" <c:if test="${selectedSeat == 16}">selected</c:if>>16 chỗ</option>
                        </select>
                    </div>

                    <div class="filter-section">
                        <div class="filter-title">Nhiên liệu</div>
                        <select name="fuel" class="filter-select">
                            <option value="">-- Tất cả --</option>
                            <option value="Xăng" <c:if test="${selectedFuel == 'Xăng'}">selected</c:if>>Xăng</option>
                            <option value="Điện" <c:if test="${selectedFuel == 'Điện'}">selected</c:if>>Điện</option>
                            <option value="Hybrid" <c:if test="${selectedFuel == 'Hybrid'}">selected</c:if>>Hybrid
                            </option>
                            <option value="Diesel" <c:if test="${selectedFuel == 'Diesel'}">selected</c:if>>Diesel
                            </option>
                        </select>
                    </div>

                    <div class="filter-section">
                        <div class="filter-title">Giá tối đa / km</div>
                        <input type="range" name="maxPriceKm" id="maxPrice"
                               min="3000" max="15000" step="500"
                               value="${not empty selectedMaxPrice ? selectedMaxPrice : 15000}">
                        <div class="price-labels">
                            <span>3.000đ</span>
                            <span id="priceLabel">
                                <c:choose>
                                    <c:when test="${not empty selectedMaxPrice}">${selectedMaxPrice}đ</c:when>
                                    <c:otherwise>15.000đ</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>

                    <%-- Nút xóa tất cả bộ lọc --%>
                    <a href="${pageContext.request.contextPath}/list-product"
                       class="btn-ghost" style="display:block; margin-top:8px; text-align:center;">
                        ↺ Xóa bộ lọc
                    </a>

                </form>

            </div>

            <div class="cars-main">
                <div class="cars-header">
                    <span class="car-count"> loại xe</span>
                </div>

                <div class="cars-grid" id="carGrid">
                    <c:forEach var="p" items="${list}">
                        <div class="car-card"
                             data-brand="${p.brandId}"
                             data-category="${p.category}"
                             data-seat="${p.seatingPlan}"
                             data-fuel="${p.fuel}"
                             data-price="${p.priceKm}">
                            <div class="car-img-box">
                                <img class="car-img" src="${p.img}" alt="img-cars">
                                <span class="badge-stock">${p.count} xe có sẵn</span>
                            </div>
                            <div class="car-body">
                                <div class="car-brand">
                                    <c:forEach items="${brands}" var="b">
                                        <c:if test="${b.brandId == p.brandId}">${b.brandName}</c:if>
                                    </c:forEach>
                                </div>
                                <h3 class="car-title">
                                    <a href="${pageContext.request.contextPath}/list-product/product?typeId=${p.typeId}">${p.typeName}</a>
                                </h3>
                                <div class="car-tags">
                                    <span class="car-tag">${p.seatingPlan} chỗ</span>
                                    <span class="car-tag">${p.fuel}</span>
                                    <span class="car-tag">${p.category}</span>
                                </div>

                                <div class="car-prices">
                                    <div class="price-col">
                                        <div class="main-price">${p.priceKm}</div>
                                        <div>VNĐ/KM</div>
                                    </div>
                                    <div class="price-col right-align">
                                        <div class="main-price">${p.priceDay}</div>
                                        <div>VNĐ/Ngày</div>
                                    </div>
                                </div>

                                <div class="car-action-wrap">
                                    <a href="${pageContext.request.contextPath}/booking?typeId=${p.typeId}"
                                       class="btn-book-now">Đặt ngay</a>
                                    <button class="btn-add-cart"
                                            onclick="addToCart(${p.typeId}, 1, true, '${p.typeName}', this)">
                                        Thêm vào giỏ hàng
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <c:if test="${totalPages > 1}">
                    <div class="pagination-container">

                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}/list-product?page=${currentPage - 1}
                    <c:if test='${not empty selectedBrandId}'>&brandId=${selectedBrandId}</c:if>
                    <c:if test='${not empty selectedCategory}'>&category=${selectedCategory}</c:if>
                    <c:if test='${not empty selectedSeat}'>&seatingPlan=${selectedSeat}</c:if>
                    <c:if test='${not empty selectedFuel}'>&fuel=${selectedFuel}</c:if>
                    <c:if test='${not empty selectedMaxPrice}'>&maxPriceKm=${selectedMaxPrice}</c:if>"
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
                                    <a href="${pageContext.request.contextPath}/list-product?page=${i}
                        <c:if test='${not empty selectedBrandId}'>&brandId=${selectedBrandId}</c:if>
                        <c:if test='${not empty selectedCategory}'>&category=${selectedCategory}</c:if>
                        <c:if test='${not empty selectedSeat}'>&seatingPlan=${selectedSeat}</c:if>
                        <c:if test='${not empty selectedFuel}'>&fuel=${selectedFuel}</c:if>
                        <c:if test='${not empty selectedMaxPrice}'>&maxPriceKm=${selectedMaxPrice}</c:if>"
                                       class="page-btn">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}/list-product?page=${currentPage + 1}
                    <c:if test='${not empty selectedBrandId}'>&brandId=${selectedBrandId}</c:if>
                    <c:if test='${not empty selectedCategory}'>&category=${selectedCategory}</c:if>
                    <c:if test='${not empty selectedSeat}'>&seatingPlan=${selectedSeat}</c:if>
                    <c:if test='${not empty selectedFuel}'>&fuel=${selectedFuel}</c:if>
                    <c:if test='${not empty selectedMaxPrice}'>&maxPriceKm=${selectedMaxPrice}</c:if>"
                                   class="page-btn">Sau ›</a>
                            </c:when>
                            <c:otherwise>
                                <span class="page-btn disabled">Sau ›</span>
                            </c:otherwise>
                        </c:choose>

                    </div>

                    <p class="pagination-info">
                        Trang ${currentPage}/${totalPages} — ${totalItems} loại xe
                    </p>
                </c:if>

            </div>
        </div>
    </div>
</div>


<div id="cartModal" class="modal-overlay">
    <div class="modal-box">
        <span class="modal-close" onclick="closeModal('cartModal')">&times;</span>
        <div class="modal-icon">✓</div>
        <div class="modal-title">Thêm thành công!</div>
        <div class="modal-body">
            Đã thêm <strong id="modalProductName">Tên xe</strong> vào giỏ hàng.
        </div>
        <div class="modal-actions">
            <button class="modal-btn btn-continue" onclick="closeModal('cartModal')">Tiếp tục chọn xe</button>
            <a href="${pageContext.request.contextPath}/my-shopping-cart" class="modal-btn btn-go-cart">Xem giỏ hàng</a>
        </div>
    </div>
</div>

<div id="errorModal" class="modal-overlay">
    <div class="modal-box">
        <span class="modal-close" onclick="closeModal('errorModal')">&times;</span>
        <div class="modal-icon" style="color: #ef4444;">⚠</div>
        <div class="modal-title">Có lỗi xảy ra!</div>
        <div class="modal-body" id="modalErrorMessage">
            Có lỗi xảy ra trong quá trình thêm giỏ hàng. Vui lòng thử lại!
        </div>
        <div class="modal-actions">
            <button class="modal-btn btn-continue" style="width: 100%; flex: none;" onclick="closeModal('errorModal')">
                Đóng
            </button>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/list-cars.js"></script>
</body>
</html>
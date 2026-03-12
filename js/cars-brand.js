const params = new URLSearchParams(location.search);
const brandId = params.get('brand');
const brand = Store.getBrand(brandId);

if (!brand) {
  document.getElementById('carsGrid').innerHTML = `
    <div class="empty">
      <div class="empty__icon">🚫</div>
      <p>Thương hiệu không tồn tại.</p>
      <a href="car.html" class="btn btn-primary" style="margin-top:16px;">Quay lại</a>
    </div>`;
} else {
  document.title = brand.name + ' – Auto Cars';
  document.getElementById('brandLogo').textContent = brand.logo;
  document.getElementById('brandName').textContent = brand.name;
  document.getElementById('brandDesc').textContent = brand.desc;
  renderCars();
}

function renderCars() {
  if (!brand) return;
  const cars = Store.getCarsByBrand(brandId);
  const grid = document.getElementById('carsGrid');
  if (!cars.length) {
    grid.innerHTML = '<div class="empty" style="grid-column:1/-1"><div class="empty__icon">🚗</div><p>Chưa có xe nào cho thương hiệu này.</p></div>';
    return;
  }
  grid.innerHTML = cars.map(c => `
    <div class="car-card">
      <img class="car-card__img" src="${c.img}" alt="${c.name}" loading="lazy">
      <div class="car-card__body">
        <span class="car-card__type">${c.type}</span>
        <div class="car-card__name">${c.name}</div>
        <div class="car-card__desc">${c.desc}</div>
        <div class="car-card__meta">
          <span>💺 ${c.seats} chỗ</span>
          <span>⛽ Xăng</span>
        </div>
        <div class="car-card__price">${Store.fmtCurrency(c.pricePerKm)}/km</div>
        <div class="car-card__actions">
          <button class="btn btn-outline btn-sm" onclick="toggleDetail('det-${c.id}')">Chi tiết</button>
          <a href="booking.html?carId=${c.id}" class="btn btn-primary btn-sm">Đặt xe này</a>
        </div>
      </div>
      <div class="detail-panel" id="det-${c.id}">
        <div class="detail-row"><span>Số ghế</span><span>${c.seats} chỗ</span></div>
        <div class="detail-row"><span>Loại xe</span><span>${c.type}</span></div>
        <div class="detail-row"><span>Giá/km</span><span>${Store.fmtCurrency(c.pricePerKm)}</span></div>
        <div class="detail-row"><span>Thương hiệu</span><span>${brand.name}</span></div>
      </div>
    </div>
  `).join('');
}

function toggleDetail(id) {
  document.getElementById(id).classList.toggle('open');
}

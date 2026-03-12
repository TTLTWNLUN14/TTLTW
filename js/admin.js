// ── PAGE ROUTING ──────────────────────────────
const TITLES = { dashboard:'Dashboard', brands:'Hãng xe', cars:'Loại xe', drivers:'Tài xế', bookings:'Đặt xe', feedback:'Phản hồi', pricing:'Giá cước' };

function gotoPage(id) {
  document.querySelectorAll('.page-section').forEach(p => p.classList.remove('active'));
  document.querySelectorAll('.sidebar__item').forEach(i => i.classList.remove('active'));
  document.getElementById('page-' + id).classList.add('active');
  document.getElementById('topbarTitle').textContent = TITLES[id] || id;
  document.querySelectorAll('.sidebar__item').forEach(i => { if (i.textContent.trim().includes(TITLES[id])) i.classList.add('active'); });
  renders[id]?.();
}

const renders = {
  dashboard: renderDashboard,
  brands: renderBrands,
  cars: renderCars,
  drivers: renderDrivers,
  bookings: renderBookings,
  feedback: renderFeedback,
  pricing: renderPricing,
};

// ── MODAL HELPERS ─────────────────────────────
function openModal(id) { document.getElementById(id).classList.add('open'); }
function closeModal(id) { document.getElementById(id).classList.remove('open'); }

// ── DASHBOARD ─────────────────────────────────
function renderDashboard() {
  const bookings = Store.getBookings();
  const brands = Store.getBrands();
  const cars = Store.getCars();
  const drivers = Store.getDrivers();
  const revenue = bookings.filter(b=>b.status==='done').reduce((s,b)=>s+b.total,0);

  document.getElementById('dashGrid').innerHTML = `
    <div class="dash-card"><div class="dash-card__num">${bookings.length}</div><div class="dash-card__lbl">Tổng đặt xe</div></div>
    <div class="dash-card gold"><div class="dash-card__num">${Store.fmtCurrency(revenue)}</div><div class="dash-card__lbl">Doanh thu (done)</div></div>
    <div class="dash-card green"><div class="dash-card__num">${brands.length} hãng / ${cars.length} xe</div><div class="dash-card__lbl">Kho xe</div></div>
    <div class="dash-card red"><div class="dash-card__num">${drivers.length}</div><div class="dash-card__lbl">Tài xế</div></div>
  `;
  const STATUS = { pending:'Đang chờ', done:'Hoàn thành', cancel:'Đã huỷ' };
  document.getElementById('dashBookingTable').innerHTML = bookings.slice(0,8).map(b => {
    const car = Store.getCar(b.carId);
    return `<tr>
      <td><b>${b.id}</b></td>
      <td>${b.from} → ${b.to}</td>
      <td>${car?.name || '—'}</td>
      <td>${Store.fmtDate(b.dateFrom)}</td>
      <td>${Store.fmtCurrency(b.total)}</td>
      <td><span class="badge badge-${b.status}">${STATUS[b.status]}</span></td>
    </tr>`;
  }).join('');
}

// ── BRANDS ────────────────────────────────────
function renderBrands() {
  const brands = Store.getBrands();
  const allCars = Store.getCars();
  document.getElementById('brandsGrid').innerHTML = brands.map(b => {
    const bCars = allCars.filter(c => c.brandId === b.id);
    return `
      <div class="mgrid-item">
        <div class="mgrid-item__icon">${b.logo}</div>
        <div class="mgrid-item__body">
          <div class="mgrid-item__name">${b.name}</div>
          <div class="mgrid-item__sub">${b.desc}</div>
          <div class="mgrid-item__sub" style="margin-top:4px;color:var(--blue);">${bCars.length} xe</div>
          <div class="mgrid-item__actions">
            <button class="btn btn-outline btn-sm" onclick="editBrand('${b.id}')">✏️ Sửa</button>
            <button class="btn btn-sm" style="background:#fee2e2;color:#991b1b;" onclick="deleteBrand('${b.id}')">🗑️</button>
            <button class="btn btn-primary btn-sm" onclick="addCarForBrand('${b.id}')">+ Thêm xe</button>
          </div>
        </div>
      </div>`;
  }).join('');
}

function saveBrand() {
  const id = document.getElementById('mBrandId').value;
  const data = { name: document.getElementById('mBrandName').value.trim(), logo: document.getElementById('mBrandLogo').value.trim(), desc: document.getElementById('mBrandDesc').value.trim() };
  if (!data.name) { toast('Nhập tên hãng!','err'); return; }
  if (id) { Store.updateBrand(id, data); toast('Đã cập nhật hãng xe!'); }
  else { Store.addBrand(data); toast('Đã thêm hãng xe mới!'); }
  closeModal('mBrand'); renderBrands();
}

function editBrand(id) {
  const b = Store.getBrand(id);
  document.getElementById('mBrandId').value = b.id;
  document.getElementById('mBrandName').value = b.name;
  document.getElementById('mBrandLogo').value = b.logo;
  document.getElementById('mBrandDesc').value = b.desc;
  document.getElementById('mBrandTitle').textContent = 'Sửa hãng xe';
  openModal('mBrand');
}

function deleteBrand(id) {
  if (!confirm('Xoá hãng xe này và TẤT CẢ xe của hãng?')) return;
  Store.deleteBrand(id); toast('Đã xoá!'); renderBrands();
}

function addCarForBrand(brandId) {
  gotoPage('cars');
  setTimeout(() => {
    clearCarModal();
    document.getElementById('mCarBrand').value = brandId;
    document.getElementById('mCarTitle').textContent = 'Thêm xe cho hãng';
    openModal('mCar');
  }, 50);
}

// ── CARS ──────────────────────────────────────
function fillBrandSelects() {
  const brands = Store.getBrands();
  ['mCarBrand','carBrandFilter','calcCarBrandFilt'].forEach(id => {
    const el = document.getElementById(id);
    if (!el) return;
    const oldVal = el.value;
    el.innerHTML = (id === 'carBrandFilter' ? '<option value="">Tất cả</option>' : '');
    brands.forEach(b => el.appendChild(new Option(b.name, b.id)));
    el.value = oldVal;
  });
  const calcCar = document.getElementById('calcCar');
  if (calcCar) {
    calcCar.innerHTML = '<option value="">-- Giá mặc định --</option>';
    Store.getCars().forEach(c => calcCar.appendChild(new Option(`${c.name} (${Store.fmtCurrency(c.pricePerKm)}/km)`, c.id)));
  }
}

function renderCars() {
  fillBrandSelects();
  const filter = document.getElementById('carBrandFilter')?.value;
  const cars = filter ? Store.getCarsByBrand(filter) : Store.getCars();
  const grid = document.getElementById('carsGrid');
  if (!cars.length) { grid.innerHTML = '<p style="color:var(--gray);grid-column:1/-1;padding:20px;">Chưa có xe nào.</p>'; return; }
  grid.innerHTML = cars.map(c => {
    const brand = Store.getBrand(c.brandId);
    return `
      <div class="mgrid-item">
        <div style="font-size:2rem;">${brand?.logo||'🚗'}</div>
        <div class="mgrid-item__body">
          <div class="mgrid-item__name">${c.name}</div>
          <div class="mgrid-item__sub">${brand?.name||''} · ${c.type} · ${c.seats} chỗ</div>
          <div class="mgrid-item__sub" style="color:var(--blue);font-weight:700;">${Store.fmtCurrency(c.pricePerKm)}/km</div>
          <div class="mgrid-item__actions">
            <button class="btn btn-outline btn-sm" onclick="editCar('${c.id}')">✏️ Sửa</button>
            <button class="btn btn-sm" style="background:#fee2e2;color:#991b1b;" onclick="deleteCar('${c.id}')">🗑️</button>
          </div>
        </div>
      </div>`;
  }).join('');
}

function clearCarModal() {
  ['mCarId','mCarName','mCarImg','mCarDesc'].forEach(id => document.getElementById(id).value = '');
  document.getElementById('mCarSeats').value = '5';
  document.getElementById('mCarPrice').value = '';
  document.getElementById('mCarTitle').textContent = 'Thêm loại xe';
}

function saveCar() {
  const id = document.getElementById('mCarId').value;
  const data = {
    brandId: document.getElementById('mCarBrand').value,
    name:    document.getElementById('mCarName').value.trim(),
    type:    document.getElementById('mCarType').value,
    seats:   +document.getElementById('mCarSeats').value,
    pricePerKm: +document.getElementById('mCarPrice').value,
    img:     document.getElementById('mCarImg').value.trim() || 'https://via.placeholder.com/400x200?text=No+Image',
    desc:    document.getElementById('mCarDesc').value.trim(),
  };
  if (!data.name || !data.brandId || !data.pricePerKm) { toast('Điền đủ tên, hãng và giá!','err'); return; }
  if (id) { Store.updateCar(id, data); toast('Đã cập nhật xe!'); }
  else { Store.addCar(data); toast('Đã thêm xe mới!'); }
  closeModal('mCar'); renderCars();
}

function editCar(id) {
  fillBrandSelects();
  const c = Store.getCar(id);
  document.getElementById('mCarId').value = c.id;
  document.getElementById('mCarBrand').value = c.brandId;
  document.getElementById('mCarName').value = c.name;
  document.getElementById('mCarType').value = c.type;
  document.getElementById('mCarSeats').value = c.seats;
  document.getElementById('mCarPrice').value = c.pricePerKm;
  document.getElementById('mCarImg').value = c.img;
  document.getElementById('mCarDesc').value = c.desc;
  document.getElementById('mCarTitle').textContent = 'Sửa xe';
  openModal('mCar');
}

function deleteCar(id) {
  if (!confirm('Xoá xe này?')) return;
  Store.deleteCar(id); toast('Đã xoá xe!'); renderCars();
}

// ── DRIVERS ───────────────────────────────────
function renderDrivers() {
  const drivers = Store.getDrivers();
  document.getElementById('driversTable').innerHTML = drivers.map(d => `
    <tr>
      <td><b>${d.name}</b></td>
      <td>${d.phone}</td>
      <td>⭐ ${d.rating}</td>
      <td>${d.trips}</td>
      <td><span class="badge" style="background:${d.avail?'#ecfdf5':'#fef2f2'};color:${d.avail?'#065f46':'#991b1b'}">${d.avail?'Sẵn sàng':'Bận'}</span></td>
      <td style="display:flex;gap:6px;flex-wrap:wrap;">
        <button class="btn btn-outline btn-sm" onclick="editDriver('${d.id}')">✏️</button>
        <button class="btn btn-sm" style="background:#fee2e2;color:#991b1b;" onclick="deleteDriver('${d.id}')">🗑️</button>
      </td>
    </tr>`).join('');
}

function saveDriver() {
  const id = document.getElementById('mDriverId').value;
  const data = {
    name:   document.getElementById('mDriverName').value.trim(),
    phone:  document.getElementById('mDriverPhone').value.trim(),
    rating: +document.getElementById('mDriverRating').value,
    avail:  document.getElementById('mDriverAvail').value === '1',
    trips:  0,
  };
  if (!data.name || !data.phone) { toast('Điền đủ thông tin!','err'); return; }
  if (id) { Store.updateDriver(id, data); toast('Đã cập nhật tài xế!'); }
  else { Store.addDriver(data); toast('Đã thêm tài xế!'); }
  closeModal('mDriver'); renderDrivers();
}

function editDriver(id) {
  const d = Store.getDriver(id);
  document.getElementById('mDriverId').value = d.id;
  document.getElementById('mDriverName').value = d.name;
  document.getElementById('mDriverPhone').value = d.phone;
  document.getElementById('mDriverRating').value = d.rating;
  document.getElementById('mDriverAvail').value = d.avail ? '1' : '0';
  document.getElementById('mDriverTitle').textContent = 'Sửa tài xế';
  openModal('mDriver');
}

function deleteDriver(id) {
  if (!confirm('Xoá tài xế này?')) return;
  Store.deleteDriver(id); toast('Đã xoá!'); renderDrivers();
}

// ── BOOKINGS ──────────────────────────────────
function renderBookings() {
  const filter = document.getElementById('bkStatusFilter').value;
  let bks = Store.getBookings();
  if (filter) bks = bks.filter(b => b.status === filter);
  const STATUS_OPTS = ['pending','done','cancel'];
  const STATUS_LBL = { pending:'Đang chờ', done:'Hoàn thành', cancel:'Đã huỷ' };
  document.getElementById('bookingsTable').innerHTML = bks.map(b => {
    const car = Store.getCar(b.carId);
    const driver = b.driverId ? Store.getDriver(b.driverId) : null;
    const opts = STATUS_OPTS.map(s => `<option value="${s}" ${b.status===s?'selected':''}>${STATUS_LBL[s]}</option>`).join('');
    return `<tr>
      <td><b>${b.id}</b></td>
      <td>${b.from} → ${b.to}</td>
      <td>${car?.name||'—'}</td>
      <td>${driver?.name||'Tự lái'}</td>
      <td>${Store.fmtDate(b.dateFrom)}</td>
      <td>${Store.fmtCurrency(b.total)}</td>
      <td>
        <select class="form-control" style="font-size:.78rem;padding:4px 8px;" onchange="changeStatus('${b.id}',this.value)">${opts}</select>
      </td>
      <td><button class="btn btn-sm" style="background:#fee2e2;color:#991b1b;" onclick="deleteBooking('${b.id}')">🗑️</button></td>
    </tr>`;
  }).join('');
}

function changeStatus(id, status) {
  Store.updateBooking(id, { status });
  toast('Đã cập nhật trạng thái!');
}
function deleteBooking(id) {
  if (!confirm('Xoá đặt xe này?')) return;
  Store.deleteBooking(id); toast('Đã xoá!'); renderBookings();
}

// ── FEEDBACK ──────────────────────────────────
function renderFeedback() {
  document.getElementById('feedbackTable').innerHTML = Store.getFeedbacks().map(f => `
    <tr>
      <td><b>${f.user}</b></td>
      <td>${'★'.repeat(f.stars)}${'☆'.repeat(5-f.stars)}</td>
      <td>${f.text}</td>
      <td>${Store.fmtDate(f.date)}</td>
    </tr>`).join('');
}

// ── PRICING ───────────────────────────────────
function renderPricing() {
  fillBrandSelects();
  const p = Store.getPricing();
  const fields = [
    { key:'baseFee',    label:'Phí mở cửa (VND)', placeholder:'VD: 30000' },
    { key:'perKm',      label:'Giá/km mặc định (VND)', placeholder:'VD: 4000' },
    { key:'driverDay',  label:'Phí tài xế/ngày (VND)', placeholder:'VD: 300000' },
    { key:'fuelFactor', label:'Hệ số nhiên liệu', placeholder:'VD: 1.0' },
  ];
  document.getElementById('pricingGrid').innerHTML = fields.map(f => `
    <div class="pricing-item">
      <label>${f.label}</label>
      <input id="p_${f.key}" class="form-control" type="number" step="any" value="${p[f.key]}" placeholder="${f.placeholder}" onchange="savePricing()">
    </div>`).join('');
}

function savePricing() {
  Store.updatePricing({
    baseFee:    +document.getElementById('p_baseFee').value,
    perKm:      +document.getElementById('p_perKm').value,
    driverDay:  +document.getElementById('p_driverDay').value,
    fuelFactor: +document.getElementById('p_fuelFactor').value,
  });
  toast('Đã lưu giá cước!');
}

function runCalc() {
  const km = +document.getElementById('calcKm').value;
  const days = +document.getElementById('calcDays').value || 1;
  const driver = document.getElementById('calcDriver').value === '1';
  const carId = document.getElementById('calcCar').value;
  const car = carId ? Store.getCar(carId) : null;
  if (!km) { toast('Nhập khoảng cách!','err'); return; }
  const total = Store.calcCost(km, driver, days, car?.pricePerKm);
  const p = Store.getPricing();
  document.getElementById('calcResult').innerHTML = `
    <div style="background:var(--light);border-radius:10px;padding:16px;display:flex;gap:32px;flex-wrap:wrap;">
      <div><div style="font-size:.78rem;color:var(--gray);">Phí mở cửa</div><div>${Store.fmtCurrency(p.baseFee)}</div></div>
      <div><div style="font-size:.78rem;color:var(--gray);">Km × giá</div><div>${km} × ${Store.fmtCurrency(car?.pricePerKm||p.perKm)} = ${Store.fmtCurrency(km*(car?.pricePerKm||p.perKm))}</div></div>
      ${driver ? `<div><div style="font-size:.78rem;color:var(--gray);">Tài xế × ngày</div><div>${Store.fmtCurrency(p.driverDay)} × ${days} = ${Store.fmtCurrency(p.driverDay*days)}</div></div>` : ''}
      <div><div style="font-size:.78rem;color:var(--gray);font-weight:600;">TỔNG</div><div style="font-size:1.4rem;font-weight:800;color:var(--blue);">${Store.fmtCurrency(total)}</div></div>
    </div>`;
}

// ── INIT ──────────────────────────────────────
document.querySelectorAll('#mBrand, #mCar, #mDriver').forEach(m => {
  m.addEventListener('click', e => { if (e.target === m) m.classList.remove('open'); });
});
renderDashboard();
fillBrandSelects();
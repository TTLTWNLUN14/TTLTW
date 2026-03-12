// ── STATE ──────────────────────────────────────
let withDriver = false;
let reviewStars = 0;
let reviewBookingId = null;

// ── INIT ──────────────────────────────────────
(function init() {
  const today = new Date().toISOString().slice(0,10);
  document.getElementById('bDateFrom').min = today;
  document.getElementById('bDateTo').min = today;

  // Fill car options grouped by brand
  const carSel = document.getElementById('bCar');
  Store.getBrands().forEach(brand => {
    const grp = document.createElement('optgroup');
    grp.label = brand.name;
    Store.getCarsByBrand(brand.id).forEach(c => {
      grp.appendChild(new Option(`${c.name} (${c.seats} chỗ – ${Store.fmtCurrency(c.pricePerKm)}/km)`, c.id));
    });
    carSel.appendChild(grp);
  });

  // Fill driver options
  const drvSel = document.getElementById('bDriver');
  Store.getAvailDrivers().forEach(d => {
    drvSel.appendChild(new Option(`${d.name} – ⭐${d.rating} (${d.trips} chuyến)`, d.id));
  });

  // Pre-fill from query params
  const p = new URLSearchParams(location.search);
  if (p.get('from')) document.getElementById('bFrom').value = decodeURIComponent(p.get('from'));
  if (p.get('to'))   document.getElementById('bTo').value   = decodeURIComponent(p.get('to'));
  if (p.get('carId')) { document.getElementById('bCar').value = p.get('carId'); calcPrice(); }

  // Star rating for review modal
  document.querySelectorAll('#reviewStars .star').forEach(s => {
    s.addEventListener('click', () => {
      reviewStars = +s.dataset.v;
      document.querySelectorAll('#reviewStars .star').forEach((x,i) => x.classList.toggle('lit', i < reviewStars));
    });
  });

  // Open history tab if requested
  if (new URLSearchParams(location.search).get('tab') === 'history') switchTab('history');
})();

// ── DRIVER TOGGLE ─────────────────────────────
function selectDriver(val) {
  withDriver = val;
  document.getElementById('dOpt0').classList.toggle('selected', !val);
  document.getElementById('dOpt1').classList.toggle('selected',  val);
  document.getElementById('driverPanel').style.display = val ? 'block' : 'none';
  calcPrice();
}

// ── PRICE CALC ────────────────────────────────
function calcPrice() {
  const km = parseFloat(document.getElementById('bKm').value) || 0;
  const carId = document.getElementById('bCar').value;
  const dateFrom = document.getElementById('bDateFrom').value;
  const dateTo   = document.getElementById('bDateTo').value;
  const days = (dateFrom && dateTo) ? Store.daysBetween(dateFrom, dateTo) : 1;
  const car = carId ? Store.getCar(carId) : null;
  const total = km > 0 ? Store.calcCost(km, withDriver, days, car?.pricePerKm) : 0;
  document.getElementById('priceDisplay').textContent = total > 0 ? Store.fmtCurrency(total) : '—';
}

// ── SUBMIT BOOKING ────────────────────────────
function submitBooking() {
  const name     = document.getElementById('bName').value.trim();
  const phone    = document.getElementById('bPhone').value.trim();
  const from     = document.getElementById('bFrom').value.trim();
  const to       = document.getElementById('bTo').value.trim();
  const dateFrom = document.getElementById('bDateFrom').value;
  const dateTo   = document.getElementById('bDateTo').value || dateFrom;
  const km       = parseFloat(document.getElementById('bKm').value);
  const carId    = document.getElementById('bCar').value;
  const driverId = withDriver ? (document.getElementById('bDriver').value || null) : null;

  if (!name || !phone || !from || !to || !dateFrom || !km || !carId) {
    toast('Vui lòng điền đầy đủ thông tin!', 'err'); return;
  }
  const days  = Store.daysBetween(dateFrom, dateTo);
  const car   = Store.getCar(carId);
  const total = Store.calcCost(km, withDriver, days, car?.pricePerKm);

  const bk = Store.addBooking({ userId:'u01', carId, driverId, from, to, dateFrom, dateTo, km, withDriver, status:'pending', total, review:null });
  toast(`Đặt xe thành công! Mã: ${bk.id}`);
  switchTab('history');
  renderHistory();
}

// ── HISTORY ───────────────────────────────────
function renderHistory() {
  const status = document.getElementById('hStatus').value;
  let bookings = Store.getBookings().filter(b => b.userId === 'u01');
  if (status) bookings = bookings.filter(b => b.status === status);
  bookings = bookings.sort((a,b) => new Date(b.dateFrom) - new Date(a.dateFrom));

  const STATUS = { pending:'Đang chờ', done:'Hoàn thành', cancel:'Đã huỷ' };
  const list = document.getElementById('historyList');
  if (!bookings.length) {
    list.innerHTML = '<p style="text-align:center;color:var(--gray);padding:40px;">Không có lịch sử đặt xe.</p>';
    return;
  }
  list.innerHTML = bookings.map(b => {
    const car    = Store.getCar(b.carId);
    const driver = b.driverId ? Store.getDriver(b.driverId) : null;
    const reviewBtn = b.status === 'done' && !b.review
      ? `<button class="btn btn-gold btn-sm" onclick="openReview('${b.id}','${b.from} → ${b.to}')">✍️ Đánh giá</button>`
      : b.review ? `<span class="reviewed-badge">⭐ ${'★'.repeat(b.review.stars)} Đã đánh giá</span>` : '';
    return `
      <div class="booking-item">
        <div style="font-size:2rem;">${car ? (Store.getBrand(car.brandId)?.logo || '🚗') : '🚗'}</div>
        <div class="booking-item__route">
          <div class="booking-item__route-main">${b.from} → ${b.to}</div>
          <div class="booking-item__route-sub">${car ? car.name : ''} · ${b.km}km · ${b.withDriver ? '👨‍✈️ Có tài xế' : '🙋 Tự lái'}</div>
          ${driver ? `<div class="booking-item__route-sub">Tài xế: ${driver.name}</div>` : ''}
        </div>
        <div class="booking-item__date">${Store.fmtDate(b.dateFrom)}</div>
        <span class="badge badge-${b.status}">${STATUS[b.status]}</span>
        <div class="booking-item__price">${Store.fmtCurrency(b.total)}</div>
        <div class="booking-item__actions">${reviewBtn}</div>
      </div>`;
  }).join('');
}

// ── REVIEW ────────────────────────────────────
function openReview(bookingId, info) {
  reviewBookingId = bookingId;
  reviewStars = 0;
  document.getElementById('reviewBookingInfo').textContent = info;
  document.getElementById('reviewText').value = '';
  document.querySelectorAll('#reviewStars .star').forEach(s => s.classList.remove('lit'));
  document.getElementById('reviewModal').classList.add('open');
}

function submitReview() {
  if (!reviewStars) { toast('Vui lòng chọn số sao!', 'err'); return; }
  const text = document.getElementById('reviewText').value.trim();
  Store.addReview(reviewBookingId, reviewStars, text || 'Chuyến đi tốt!');
  closeModal('reviewModal');
  renderHistory();
  toast('Cảm ơn bạn đã đánh giá!');
}

function closeModal(id) { document.getElementById(id).classList.remove('open'); }

// ── TABS ──────────────────────────────────────
function switchTab(tab) {
  document.getElementById('panelBook').style.display    = tab === 'book'    ? 'block' : 'none';
  document.getElementById('panelHistory').style.display = tab === 'history' ? 'block' : 'none';
  document.getElementById('tabBook').classList.toggle('active',    tab === 'book');
  document.getElementById('tabHistory').classList.toggle('active', tab === 'history');
  if (tab === 'history') renderHistory();
}

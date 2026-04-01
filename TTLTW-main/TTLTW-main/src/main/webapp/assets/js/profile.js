const sess = Session.ensure('user');
const customer = DB.customers.find(c => c.customer_id === sess.customer_id) || DB.customers[0];
const acc = DB.accounts.find(a => a.account_id === sess.account_id) || DB.accounts[2];
const tier = customer.member_tier;

const myDriver = DB.drivers.find(d => d.account_id === acc.account_id);

document.getElementById('psAvatarText').textContent = avatarInitials(customer.full_name);
if (customer.avatar_url || acc.avatar) {
    const img = document.getElementById('psAvatarImg');
    img.src = customer.avatar_url || acc.avatar;
    img.style.display = 'block';
    document.getElementById('psAvatarText').style.display = 'none';
}
document.getElementById('psName').textContent = customer.full_name;
document.getElementById('psEmail').textContent = acc.email;
const tierEl = document.getElementById('psTier');
tierEl.textContent = ' ' + DB.tierName(tier);
tierEl.className = 'badge badge-' + ({ standard: 'gray', silver: 'gray', gold: 'gold', platinum: 'blue', diamond: 'purple' }[tier] || 'gray');

document.getElementById('statsMini').innerHTML = `
      <div class="sm-card"><div class="sm-val">${customer.total_trips}</div><div class="sm-lbl">Chuyến đi</div></div>
      <div class="sm-card"><div class="sm-val">${customer.points}</div><div class="sm-lbl">Điểm tích lũy</div></div>
      <div class="sm-card"><div class="sm-val">${fmtMoney(customer.total_spent)}</div><div class="sm-lbl">Tổng chi tiêu</div></div>`;

document.getElementById('infoRows').innerHTML = [
    ['Họ và tên', customer.full_name], ['Email', acc.email], ['Điện thoại', customer.phone],
    ['Ngày sinh', fmtDate(customer.dob)], ['Giới tính', { male: 'Nam', female: 'Nữ', other: 'Khác' }[customer.gender] || '—'],
    ['CCCD', customer.cccd || 'Chưa cập nhật'], ['Địa chỉ', customer.address || 'Chưa cập nhật'],
    ['Hạng Member', DB.tierName(tier)], ['Ngày tham gia', fmtDate(customer.joined)],
    ['Ưu đãi', `${DB.member_tiers.find(t => t.tier === tier)?.discount || 0}% mọi chuyến`],
].map(([k, v]) => `<div style="display:flex;justify-content:space-between;padding:9px 0;border-bottom:1px solid var(--border);font-size:.85rem"><span style="color:var(--text-muted)">${k}</span><span style="font-weight:600;text-align:right">${v}</span></div>`).join('');

document.getElementById('editName').value = customer.full_name;
document.getElementById('editPhone').value = customer.phone;
document.getElementById('editEmail').value = acc.email;
document.getElementById('editDob').value = customer.dob || '';
document.getElementById('editGender').value = customer.gender || 'male';
document.getElementById('editAddress').value = customer.address || '';
document.getElementById('editCccd').value = customer.cccd || '';

function switchTab(tab) {
    document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.ps-nav-item').forEach(n => n.classList.remove('active'));
    const t = document.getElementById('tab-' + tab);
    if (t) t.classList.add('active');
    const n = document.getElementById('nav-' + tab);
    if (n) n.classList.add('active');
    if (tab === 'notif') loadNotifs();
    if (tab === 'history') loadHistory();
    if (tab === 'reviews') loadReviews();
    if (tab === 'settings') loadSettings();
    if (tab === 'driver-register') loadDriverRegister();
}

function loadNotifs() {
    const ns = DB.notifications.filter(n => n.account_id === sess.account_id);
    const unread = ns.filter(n => !n.is_read).length;
    const badge = document.getElementById('unreadBadge');
    badge.textContent = unread; badge.style.display = unread ? '' : 'none';
    const icons = { booking: ' ', promo: ' ', payment: ' ', member: ' ', system: ' ' };
    document.getElementById('notifList').innerHTML = ns.length ? ns.map(n => `
        <div class="notif-item2" onclick="markRead(${n.notif_id})" style="cursor:pointer${n.is_read ? '' : ';background:#fffbeb;'}">
          <div class="ni-icon" style="${n.is_read ? '' : 'background:#fef3c7'}">${icons[n.type] || ' '}</div>
          <div class="ni-body">
            <div class="ni-title" style="font-weight:${n.is_read ? 600 : 700}">${n.title}</div>
            <div class="ni-msg">${n.body}</div>
            <div class="ni-time">${timeAgo(n.created_at)}</div>
          </div>
          ${!n.is_read ? '<div class="ni-dot"></div>' : ''}
        </div>`).join('') : `<div class="empty-state"><div class="empty-icon"> </div><div class="empty-title">Không có thông báo</div></div>`;
}

function markRead(id) { const n = DB.notifications.find(x => x.notif_id === id); if (n) n.is_read = 1; loadNotifs(); }
function markAllRead() { DB.notifications.filter(n => n.account_id === sess.account_id).forEach(n => n.is_read = 1); loadNotifs(); showToast('Đã đọc tất cả', '', 'success'); }

function loadHistory() {
    const bks = DB.bookings.filter(b => b.customer_id === customer.customer_id).sort((a, b) => b.booking_id - a.booking_id);
    if (!bks.length) { document.getElementById('historyBody').innerHTML = '<div class="empty-state"><div class="empty-icon"> </div><div class="empty-title">Chưa có đơn nào</div></div>'; return; }
    document.getElementById('historyBody').innerHTML = bks.map(b => {
        const type = DB.car_types.find(t => t.type_id === b.type_id);
        const driver = b.driver_id ? DB.drivers.find(d => d.driver_id === b.driver_id) : null;
        const sc = DB.statusColor(b.status);
        return `<div style="display:flex;justify-content:space-between;align-items:center;padding:12px 0;border-bottom:1px solid var(--border);flex-wrap:wrap;gap:8px">
          <div>
            <div style="font-family:var(--font-m);font-size:.78rem;color:var(--gold);font-weight:800">#AC-${String(b.booking_id).padStart(4, '0')}</div>
            <div style="font-weight:700;font-size:.88rem;margin:3px 0">${b.pickup} → ${b.dropoff}</div>
            <div style="font-size:.75rem;color:var(--text-muted)">${type?.type_name || '—'} · ${fmtDate(b.pickup_date)}${driver ? ' ·   ' + driver.full_name : ''}</div>
          </div>
          <div style="text-align:right">
            <span class="badge badge-${sc}">${DB.statusLabel(b.status)}</span>
            <div style="font-family:var(--font-d);color:var(--gold);font-weight:700;margin-top:4px">${fmtMoney(b.total_price)}</div>
          </div>
        </div>`;
    }).join('');
}

function loadReviews() {
    const rvs = DB.reviews.filter(r => r.customer_id === customer.customer_id);
    if (!rvs.length) { document.getElementById('reviewsBody').innerHTML = '<div class="empty-state"><div class="empty-icon"> </div><div class="empty-title">Chưa có đánh giá nào</div></div>'; return; }
    document.getElementById('reviewsBody').innerHTML = rvs.map(r => {
        const driver = r.driver_id ? DB.drivers.find(d => d.driver_id === r.driver_id) : null;
        return `<div class="review-item" style="padding:15px 0; border-bottom:1px solid var(--border); display:flex; gap:12px;">
          <div class="nav-avatar" style="width:42px;height:42px;font-size:.88rem;flex-shrink:0;background:var(--gold);border-radius:50%;display:flex;align-items:center;justify-content:center;">${driver ? driver.avatar_text || driver.full_name.slice(0, 2) : 'TX'}</div>
          <div style="flex:1">
            <div class="ri-stars" style="color:var(--gold);font-size:1.1rem;">${'★'.repeat(r.rating)}${'☆'.repeat(5 - r.rating)}</div>
            <div class="ri-meta" style="font-size:0.8rem;color:var(--text-muted);margin:4px 0;">Đơn #AC-${String(r.booking_id).padStart(4, '0')} · ${driver ? driver.full_name : 'Thuê tự lái'} · ${fmtDate(r.created_at)}</div>
            <div class="ri-comment" style="font-size:0.9rem;">"${r.comment}"</div>
            ${r.replied ? `<div style="margin-top:8px;padding:8px;background:#f8fafc;border-radius:8px;font-size:.8rem;color:var(--text-muted)"><strong>Phản hồi:</strong> ${r.replied}</div>` : ''}
          </div>
        </div>`;
    }).join('');
}

function loadSettings() {
    const items = [
        ['Thông báo đặt xe', 'Nhận thông báo khi trạng thái thay đổi', 'notif_booking', true],
        ['Thông báo khuyến mãi', 'Mã giảm giá và ưu đãi mới', 'notif_promo', true],
        ['Email tóm tắt tuần', 'Nhận email tổng hợp hàng tuần', 'notif_email', false],
        ['Chế độ tối', 'Giao diện tối', 'dark_mode', false],
    ];
    document.getElementById('settingsList').innerHTML = items.map(([t, d, k, v]) => `
        <div style="display:flex;align-items:center;gap:12px;padding:14px 0;border-bottom:1px solid var(--border)">
          <div style="flex:1"><div style="font-size:.9rem;font-weight:600">${t}</div><div style="font-size:.8rem;color:var(--text-muted);margin-top:2px">${d}</div></div>
          <label style="position:relative;display:inline-block;width:40px;height:22px;">
            <input type="checkbox" ${v ? 'checked' : ''} onchange="saveSetting('${k}',this.checked)" style="opacity:0;width:0;height:0;">
            <span style="position:absolute;cursor:pointer;top:0;left:0;right:0;bottom:0;background-color:${v ? 'var(--primary)' : '#cbd5e1'};transition:.4s;border-radius:34px;"></span>
          </label>
        </div>`).join('');
}

function saveProfile() {
    customer.full_name = document.getElementById('editName').value;
    customer.phone = document.getElementById('editPhone').value;
    customer.address = document.getElementById('editAddress').value;
    customer.dob = document.getElementById('editDob').value;
    customer.gender = document.getElementById('editGender').value;
    customer.cccd = document.getElementById('editCccd').value;
    acc.email = document.getElementById('editEmail').value;
    Session.set({ ...sess, full_name: customer.full_name });
    showToast('Đã lưu', 'Thông tin hồ sơ đã cập nhật', 'success');
    switchTab('info');
    document.getElementById('psName').textContent = customer.full_name;
    document.getElementById('psAvatarText').textContent = avatarInitials(customer.full_name);
}

function uploadAvatar(input) {
    const file = input.files[0]; if (!file) return;
    const reader = new FileReader();
    reader.onload = e => {
        acc.avatar = e.target.result;
        const img = document.getElementById('psAvatarImg');
        img.src = e.target.result; img.style.display = 'block';
        document.getElementById('psAvatarText').style.display = 'none';
        showToast('Đã cập nhật', 'Ảnh đại diện đã thay đổi', 'success');
    };
    reader.readAsDataURL(file);
}

function uploadFace(input) {
    const file = input.files[0]; if (!file) return;
    const reader = new FileReader();
    reader.onload = e => {
        customer.face_img = e.target.result;
        const img = document.getElementById('facePreviewImg');
        img.src = e.target.result; img.style.display = 'block';
        document.getElementById('facePreviewWrap').style.display = 'none';
        document.getElementById('faceStatus').innerHTML = '<span style="color:#10b981">Ảnh đã tải lên thành công. Đang chờ xác thực...</span>';
        showToast('Tải ảnh thành công', 'Khuôn mặt đang chờ xác thực', 'success');
        DB.notifications.push({ notif_id: DB.newId('notif'), account_id: 2, type: 'system', title: 'Xác thực khuôn mặt', body: customer.full_name + ' vừa tải ảnh xác thực', is_read: 0, created_at: new Date().toISOString(), booking_id: null });
    };
    reader.readAsDataURL(file);
}

let pwStep = 1;
function changePassword() {
    if (pwStep === 1) {
        const cur = document.getElementById('curPass').value;
        const np = document.getElementById('newPassS').value;
        const nc = document.getElementById('confirmPass').value;
        if (!cur || !np || !nc) { showToast('Thiếu thông tin', 'Điền đủ các ô', 'error'); return; }
        if (acc.password !== cur) { showToast('Lỗi', 'Mật khẩu hiện tại không đúng', 'error'); return; }
        if (np !== nc) { showToast('Lỗi', 'Mật khẩu không khớp', 'error'); return; }
        document.getElementById('pwOtpSection').style.display = '';
        showToast('Gửi OTP', 'Mã OTP đã gửi đến email/SĐT (Demo: 123456)', 'info');
        pwStep = 2;
    } else {
        const otp = document.getElementById('pwOtp').value;
        if (otp !== '123456') { showToast('Sai OTP', 'Demo: 123456', 'error'); return; }
        acc.password = document.getElementById('newPassS').value;
        showToast('Thành công', 'Mật khẩu đã thay đổi', 'success');
        ['curPass', 'newPassS', 'confirmPass', 'pwOtp'].forEach(id => document.getElementById(id).value = '');
        document.getElementById('pwOtpSection').style.display = 'none';
        pwStep = 1;
    }
}

function confirmHideAccount() {
    if (confirm('Ẩn tài khoản? Bạn sẽ không thể đặt xe cho đến khi liên hệ hỗ trợ.')) {
        acc.is_active = 0;
        Session.clear();
        showToast('Tài khoản đã ẩn', 'Liên hệ 1800-AUTO-CAR để khôi phục', 'warning');
        setTimeout(() => location.href = 'login.jsp', 1500);
    }
}

function saveSetting(key, val) { showToast('Đã lưu', `Cài đặt "${key}" đã cập nhật`, 'success'); }

function logout() {
    if (typeof Session !== 'undefined') {
        Session.clear();
    }
    showToast('Đã đăng xuất', 'Đang chuyển hướng về trang đăng nhập...', 'success');
    setTimeout(() => {
        location.href = 'login.jsp';
    }, 800);
}

function loadDriverRegister() {
    const body = document.getElementById('driverRegBody');
    const existingDriver = DB.drivers.find(d => d.account_id === sess.account_id);
    if (existingDriver) {
        const statusMap = {
            approved: { bg: '#dcfce7', color: '#166534', label: 'Đã được duyệt' },
            pending: { bg: '#ffedd5', color: '#9a3412', label: 'Đang chờ duyệt' },
            rejected: { bg: '#fee2e2', color: '#991b1b', label: 'Bị từ chối' },
        };
        const st = statusMap[existingDriver.approval_status] || statusMap.pending;
        body.innerHTML = `
          <div style="text-align:center;padding:24px 0">
            <div style="background:${st.bg};color:${st.color};display:inline-block;padding:8px 22px;border-radius:99px;font-weight:700;font-size:.9rem;margin-bottom:20px">${st.label}</div>
            <h3 style="font-family:var(--font-d);margin-bottom:8px">Đơn đăng ký tài xế</h3>
            <p style="color:var(--text-muted);font-size:.85rem;margin-bottom:20px">Mã tài xế: <strong style="color:var(--primary)">#DRV-${String(existingDriver.driver_id).padStart(4, '0')}</strong></p>
            <div style="background:#f8fafc;border-radius:12px;padding:20px;text-align:left;margin-bottom:20px">
              ${[
                ['Họ và tên', existingDriver.full_name],
                ['Số điện thoại', existingDriver.phone],
                ['Số GPLX', existingDriver.license],
                ['GPLX hết hạn', fmtDate(existingDriver.license_exp)],
                ['Số CCCD', existingDriver.cccd || '—'],
                ['Khu vực', existingDriver.city],
                ['Trạng thái', st.label],
                ['Ngày nộp đơn', fmtDate(existingDriver.joined)],
            ].map(([k, v]) => `<div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid var(--border);font-size:.85rem"><span style="color:var(--text-muted)">${k}</span><span style="font-weight:600">${v}</span></div>`).join('')}
            </div>
            ${existingDriver.approval_status === 'approved' ? `
              <a href="driver.html" class="btn btn-primary">Vào trang Tài xế</a>
              <p style="font-size:.8rem;color:var(--text-muted);margin-top:12px">Bạn có thể đăng nhập bằng tài khoản hiện tại vào trang tài xế</p>
            ` : `
              <p style="color:var(--text-muted);font-size:.85rem">Vui lòng đến trực tiếp cơ sở để xác minh giấy tờ và nhận xe. Thời gian xét duyệt 1–3 ngày làm việc.</p>
            `}
          </div>`;
        return;
    }

    body.innerHTML = `
        <div style="background:#eff6ff;border:1px solid #bfdbfe;border-radius:8px;padding:14px;margin-bottom:20px;font-size:.85rem;color:#1e40af">
            Điền thông tin bên dưới để nộp đơn đăng ký tài xế. Sau khi gửi, bạn cần <strong>đến trực tiếp cơ sở</strong> để xác minh giấy tờ và nhận xe. Đơn sẽ được admin xét duyệt trong 1–3 ngày làm việc.
        </div>
        <div class="form-row">
          <div class="form-group"><label class="form-label">Số CCCD/CMND *</label><input class="form-control" id="drCccd" placeholder="12 chữ số" value="${customer.cccd || ''}"></div>
          <div class="form-group"><label class="form-label">Khu vực hoạt động</label>
            <select class="form-control" id="drCity">
              <option value="HCM"${customer.city === 'HCM' ? ' selected' : ''}>TP. Hồ Chí Minh</option>
              <option value="HN"${customer.city === 'HN' ? ' selected' : ''}>Hà Nội</option>
              <option value="DN">Đà Nẵng</option>
              <option value="CT">Cần Thơ</option>
              <option value="HP">Hải Phòng</option>
            </select>
          </div>
        </div>
        <div class="form-row">
          <div class="form-group"><label class="form-label">Số GPLX *</label><input class="form-control" id="drLicense" placeholder="VD: B2-123456"></div>
          <div class="form-group"><label class="form-label">GPLX hết hạn</label><input class="form-control" id="drLicenseExp" type="date"></div>
        </div>
        <div class="form-group">
          <label class="form-label">Kinh nghiệm lái xe</label>
          <select class="form-control" id="drExp">
            <option value="1">Dưới 1 năm</option>
            <option value="2">1–3 năm</option>
            <option value="5" selected>3–5 năm</option>
            <option value="10">Trên 5 năm</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Ghi chú thêm (không bắt buộc)</label>
          <textarea class="form-control" id="drNote" rows="3" placeholder="Kinh nghiệm, khu vực quen thuộc, thời gian có thể làm việc..."></textarea>
        </div>
        <div style="display:flex;gap:10px">
          <button class="btn btn-primary" onclick="submitDriverReg()">Nộp đơn đăng ký</button>
          <button class="btn btn-ghost" onclick="switchTab('info')">Hủy</button>
        </div>`;
}

function submitDriverReg() {
    const cccd = document.getElementById('drCccd')?.value?.trim();
    const license = document.getElementById('drLicense')?.value?.trim();
    if (!cccd || !license) { showToast('Thiếu thông tin', 'Vui lòng điền CCCD và số GPLX', 'error'); return; }
    const city = document.getElementById('drCity').value;
    const licExp = document.getElementById('drLicenseExp').value;
    const did = DB.newId('driver');

    if (cccd) customer.cccd = cccd;
    DB.drivers.push({
        driver_id: did, account_id: acc.account_id,
        full_name: customer.full_name, phone: customer.phone,
        license, license_exp: licExp, city,
        rating: 0, total_trips: 0, income_today: 0, income_month: 0,
        is_available: 0, is_online: 0, approval_status: 'pending', status: 'pending',
        joined: new Date().toISOString().slice(0, 10),
        cccd, face_img: null,
        avatar_text: avatarInitials(customer.full_name),
    });

    DB.notifications.push({ notif_id: DB.newId('notif'), account_id: 1, type: 'system', title: 'Tài xế mới chờ duyệt', body: customer.full_name + ' · ' + customer.phone + ' · ' + city, is_read: 0, created_at: new Date().toISOString(), booking_id: null });
    DB.notifications.push({ notif_id: DB.newId('notif'), account_id: 2, type: 'system', title: 'Tài xế mới chờ duyệt', body: customer.full_name + ' · ' + customer.phone + ' · ' + city, is_read: 0, created_at: new Date().toISOString(), booking_id: null });

    Session.set({ ...sess, driver_id: did });
    showToast('Đơn đã gửi', 'Chờ admin duyệt trong 1–3 ngày. Vui lòng đến cơ sở xác minh.', 'success');
    setTimeout(() => loadDriverRegister(), 1200);
}

const unread = DB.notifications.filter(n => n.account_id === sess.account_id && !n.is_read).length;
if (unread) { document.getElementById('unreadBadge').textContent = unread; document.getElementById('unreadBadge').style.display = ''; }
loadSettings();

if (myDriver) {
    const navDrv = document.getElementById('nav-driver-register');
    if (navDrv) {
        if (myDriver.approval_status === 'approved') {
            navDrv.innerHTML = 'Trang tài xế';
            navDrv.onclick = () => location.href = 'driver.html';
        } else {
            navDrv.innerHTML = `Đăng ký tài xế <span style="background:var(--gold);border-radius:10px;padding:1px 7px;font-size:.7rem;color:#000;margin-left:4px">Chờ duyệt</span>`;
        }
    }
}
function setTab(tab) {
  ['login','register','forgot','reset'].forEach(t => {
    document.getElementById('p' + t.charAt(0).toUpperCase() + t.slice(1)).classList.remove('show');
  });
  document.getElementById('p' + tab.charAt(0).toUpperCase() + tab.slice(1)).classList.add('show');
  document.getElementById('tLogin')?.classList.toggle('active', tab === 'login');
  document.getElementById('tRegister')?.classList.toggle('active', tab === 'register');
}

function doLogin() {
  const u = document.getElementById('lUser').value.trim();
  if (!u) { toast('Nhập tên đăng nhập!', 'err'); return; }
  toast('Đăng nhập thành công! Xin chào ' + u);
  setTimeout(() => location.href = 'index.html', 1200);
}

function doRegister() {
  const pass  = document.getElementById('rPass').value;
  const pass2 = document.getElementById('rPass2').value;
  if (!document.getElementById('rUser').value.trim()) { toast('Nhập tên đăng nhập!', 'err'); return; }
  if (pass !== pass2) { toast('Mật khẩu không khớp!', 'err'); return; }
  toast('Đăng kí thành công! Bạn có thể đăng nhập.');
  setTab('login');
}

function doForgot() {
  if (!document.getElementById('fEmail').value.trim()) { toast('Nhập email!', 'err'); return; }
  toast('Mã khôi phục đã gửi vào email của bạn.');
  setTab('reset');
}

function doReset() {
  toast('Mật khẩu đã được cập nhật!');
  setTimeout(() => setTab('login'), 1200);
}

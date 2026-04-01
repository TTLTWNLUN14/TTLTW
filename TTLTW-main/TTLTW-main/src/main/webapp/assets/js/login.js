function setTab(tab) {

  ['pLogin', 'pRegister', 'pForgot', 'pReset'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.classList.remove('show');
  });

  const target = document.getElementById('p' + tab.charAt(0).toUpperCase() + tab.slice(1));
  if (target) target.classList.add('show');

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
  const email = document.getElementById('fEmail');
  if (!email || !email.value.trim()) {
    toast('Nhập email!', 'err');
    return;
  }
  toast('Mã khôi phục đã gửi vào email của bạn.');
  setTimeout(() => setTab('reset'), 800);
}

function doReset() {
  toast('Mật khẩu đã được cập nhật!');
  setTimeout(() => setTab('login'), 1000);
}

function toast(msg,type='ok'){
  const t=document.getElementById('toast');
  if(!t)return;
  t.textContent=msg;
  t.style.background=type==='err'?'#ef4444':'#0b1e3d';
  t.classList.add('show');
  clearTimeout(t._timer);
  t._timer=setTimeout(()=>t.classList.remove('show'),3000);
}

document.addEventListener('DOMContentLoaded',()=>{
  const page=location.pathname.split('/').pop()||'index.html';
  document.querySelectorAll('.nav-links a').forEach(a=>{
    if(a.getAttribute('href')===page) a.classList.add('active');
  });
});

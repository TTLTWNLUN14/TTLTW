
function setTab(tabName) {

  const panels = document.querySelectorAll('.form-panel');
  panels.forEach(panel => panel.classList.remove('show'));


  const tabs = document.querySelectorAll('.tab-btn');
  tabs.forEach(tab => tab.classList.remove('active'));


  const selectedPanel = document.getElementById('p' + tabName.charAt(0).toUpperCase() + tabName.slice(1));
  if (selectedPanel) {
    selectedPanel.classList.add('show');
  }


  if (tabName === 'login' || tabName === 'register') {
    const btn = document.getElementById('t' + tabName.charAt(0).toUpperCase() + tabName.slice(1));
    if (btn) btn.classList.add('active');
  }


  if (tabName !== 'forgot') {
    resetForgotForm();
  }
}


function sendForgotEmail() {
  const emailInput = document.getElementById('forgotEmail').value.trim();

  if (!emailInput) {
    showAlert('Vui lòng nhập email hoặc tên đăng nhập', 'error');
    return;
  }

  fetch('${pageContext.request.contextPath}/forgot-password', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: 'action=sendOtp&emailOrUsername=' + encodeURIComponent(emailInput)
  })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          showAlert('Mã xác nhận đã gửi đến email của bạn', 'success');
          document.getElementById('forgotStep1').style.display = 'none';
          document.getElementById('forgotStep2').style.display = 'block';
        } else {
          showAlert(data.message || 'Không tìm thấy tài khoản', 'error');
        }
      })
      .catch(error => {
        console.error('Error:', error);
        showAlert('Có lỗi xảy ra, vui lòng thử lại', 'error');
      });
}


function verifyOtp() {
  const otp = document.getElementById('forgotOtp').value.trim();

  if (!otp || otp.length !== 6) {
    showAlert('Vui lòng nhập mã xác nhận 6 ký tự', 'error');
    return;
  }

  fetch('${pageContext.request.contextPath}/forgot-password', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: 'action=verifyOtp&otp=' + encodeURIComponent(otp)
  })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          showAlert('Mã xác nhận chính xác', 'success');
          document.getElementById('forgotStep2').style.display = 'none';
          document.getElementById('forgotStep3').style.display = 'block';
        } else {
          showAlert(data.message || 'Mã xác nhận không đúng', 'error');
        }
      })
      .catch(error => {
        console.error('Error:', error);
        showAlert('Có lỗi xảy ra, vui lòng thử lại', 'error');
      });
}


function resetPassword() {
  const newPass = document.getElementById('forgotNewPass').value;
  const confirmPass = document.getElementById('forgotNewPassConfirm').value;

  if (!newPass || !confirmPass) {
    showAlert('Vui lòng nhập mật khẩu mới', 'error');
    return;
  }

  if (newPass !== confirmPass) {
    showAlert('Mật khẩu xác nhận không khớp', 'error');
    return;
  }

  if (newPass.length < 6) {
    showAlert('Mật khẩu phải ít nhất 6 ký tự', 'error');
    return;
  }

  fetch('${pageContext.request.contextPath}/forgot-password', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: 'action=resetPassword&newPassword=' + encodeURIComponent(newPass)
  })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          showAlert('Mật khẩu đã được cập nhật thành công', 'success');
          setTimeout(() => {
            resetForgotForm();
            setTab('login');
          }, 1500);
        } else {
          showAlert(data.message || 'Cập nhật mật khẩu thất bại', 'error');
        }
      })
      .catch(error => {
        console.error('Error:', error);
        showAlert('Có lỗi xảy ra, vui lòng thử lại', 'error');
      });
}

function resetForgotForm() {
  document.getElementById('forgotEmail').value = '';
  document.getElementById('forgotOtp').value = '';
  document.getElementById('forgotNewPass').value = '';
  document.getElementById('forgotNewPassConfirm').value = '';
  document.getElementById('forgotStep1').style.display = 'block';
  document.getElementById('forgotStep2').style.display = 'none';
  document.getElementById('forgotStep3').style.display = 'none';
}


function showAlert(message, type) {
  const alertDiv = document.createElement('div');
  alertDiv.className = 'alert alert-' + (type === 'error' ? 'error' : type === 'success' ? 'success' : 'info');
  alertDiv.innerHTML = '<strong>' + (type === 'error' ? 'Lỗi!' : type === 'success' ? 'Thành công!' : 'Thông báo') + '</strong> ' + message;
  alertDiv.style.marginBottom = '16px';

  const currentPanel = document.querySelector('.form-panel.show');
  if (currentPanel) {
    currentPanel.insertBefore(alertDiv, currentPanel.firstChild);
    setTimeout(() => alertDiv.remove(), 4000);
  }
}


document.addEventListener('keypress', function(event) {
  if (event.key === 'Enter') {
    const loginPanel = document.getElementById('pLogin');
    const registerPanel = document.getElementById('pRegister');

    if (loginPanel && loginPanel.classList.contains('show')) {
      loginPanel.querySelector('form').submit();
    } else if (registerPanel && registerPanel.classList.contains('show')) {
      registerPanel.querySelector('form').submit();
    }
  }
});
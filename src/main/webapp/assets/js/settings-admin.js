function filterTable() {
    const search = document.getElementById('searchInput').value.toLowerCase();
    const role = document.getElementById('roleFilter').value;
    const status = document.getElementById('statusFilter').value;

    document.querySelectorAll('#adminTable tbody tr').forEach(row => {
        const text = row.innerText.toLowerCase();
        const rowRole = row.dataset.role || '';
        const rowStatus = row.dataset.status || '';

        const matchSearch = !search || text.includes(search);
        const matchRole = !role || rowRole === role;
        const matchStatus = !status || rowStatus === status;

        row.style.display = (matchSearch && matchRole && matchStatus) ? '' : 'none';
    });
}

function openCreateModal() {
    document.getElementById('createModal').style.display = 'flex';
}

function closeCreateModal() {
    document.getElementById('createModal').style.display = 'none';
}

function openEditModal(accountId, fullName, username, email, phone, roleId, isActive) {
    document.getElementById('modalAccountId').value = accountId;
    document.getElementById('modalFullName').value = fullName;
    document.getElementById('modalUsername').value = username;
    document.getElementById('modalEmail').value = email;
    document.getElementById('modalPhone').value = phone;
    document.getElementById('modalNewPassword').value = '';

    const roleSel = document.getElementById('modalRoleId');
    const superOpt = document.getElementById('modalSuperAdminOption');
    const roleHint = document.getElementById('modalRoleHint');
    const isSuperAdmin = parseInt(roleId, 10) === 0;

    superOpt.disabled = !isSuperAdmin;
    superOpt.style.display = isSuperAdmin ? '' : 'none';
    roleHint.style.display = isSuperAdmin ? 'none' : 'block';

    for (let i = 0; i < roleSel.options.length; i++) {
        roleSel.options[i].selected = (parseInt(roleSel.options[i].value, 10) === parseInt(roleId, 10));
    }

    const statusSel = document.getElementById('modalIsActive');
    const activeStr = isActive ? 'true' : 'false';
    for (let i = 0; i < statusSel.options.length; i++) {
        statusSel.options[i].selected = (statusSel.options[i].value === activeStr);
    }

    document.getElementById('editModal').style.display = 'flex';
}

function closeEditModal() {
    document.getElementById('editModal').style.display = 'none';
}

function openDeleteModal(accountId, fullName) {
    document.getElementById('deleteAccountId').value = accountId;
    document.getElementById('deleteTargetName').innerText = fullName;
    document.getElementById('deleteModal').style.display = 'flex';
}

function closeDeleteModal() {
    document.getElementById('deleteModal').style.display = 'none';
}

function openToggleStatusModal(accountId, fullName, isLocking) {
    // Truyền dữ liệu vào form ẩn
    document.getElementById('toggleAccountId').value = accountId;
    document.getElementById('toggleLockValue').value = isLocking;

    const title = document.getElementById('toggleStatusTitle');
    const msg = document.getElementById('toggleStatusMessage');
    const submitBtn = document.getElementById('toggleSubmitBtn');

    if (isLocking) {
        title.innerText = "Xác nhận khóa tài khoản";
        msg.innerHTML = `Bạn có chắc chắn muốn khóa tài khoản <strong>${fullName}</strong>?`;
        submitBtn.innerText = "Khóa tài khoản";
        submitBtn.style.backgroundColor = "#dc2626"; // Đỏ
    } else {
        title.innerText = "Xác nhận mở khóa";
        msg.innerHTML = `Bạn có chắc chắn muốn mở khóa tài khoản <strong>${fullName}</strong>?`;
        submitBtn.innerText = "Mở khóa";
        submitBtn.style.backgroundColor = "#16a34a"; // Xanh lá
    }

    document.getElementById('toggleStatusModal').style.display = 'flex';
}

function closeToggleStatusModal() {
    document.getElementById('toggleStatusModal').style.display = 'none';
}

window.addEventListener('click', function (event) {
    // Thêm 'toggleStatusModal' vào danh sách
    ['createModal', 'editModal', 'deleteModal', 'toggleStatusModal'].forEach(function (id) {
        const modal = document.getElementById(id);
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    });
});

const toast = document.getElementById('toastMsg');
if (toast) {
    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transform = 'translateY(-16px)';
        setTimeout(() => toast.remove(), 100);
    }, 2000);
}
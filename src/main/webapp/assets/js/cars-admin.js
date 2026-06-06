function openDeleteModal(typeId, typeName) {
    document.getElementById('deleteTypeId').value = typeId;
    document.getElementById('deleteTargetName').innerText = typeName;
    document.getElementById('deleteModal').style.display = 'flex';
}

function closeDeleteModal() {
    document.getElementById('deleteModal').style.display = 'none';
}

window.onclick = function(event) {
    var modal = document.getElementById('deleteModal');
    if (event.target == modal) {
        modal.style.display = 'none';
    }
}

const toast = document.getElementById('toastMsg');
if (toast) {
    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transform = 'translateY(-16px)';
        setTimeout(() => toast.remove(), 100);
    }, 1000);
}
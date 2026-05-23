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
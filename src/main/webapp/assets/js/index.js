function goBook() {
    const pickup  = document.getElementById('inPickup').value.trim();
    const dropoff = document.getElementById('inDropoff').value.trim();
    const date    = document.getElementById('inDate').value;
    if (!pickup || !dropoff || !date) {
        alert('Vui lòng điền đầy đủ thông tin');
        return;
    }
    window.location.href =
        CONTEXT_PATH + '/booking' +
        '?pickup='  + encodeURIComponent(pickup) +
        '&dropoff=' + encodeURIComponent(dropoff) +
        '&date='    + date;
}

function quickBook(pickup, dropoff) {
    document.getElementById('inPickup').value  = pickup;
    document.getElementById('inDropoff').value = dropoff;
    document.getElementById('inDate').focus();
}

document.addEventListener('DOMContentLoaded', function () {
    console.log('Trang chủ Auto Cars đã được tải thành công!');
});

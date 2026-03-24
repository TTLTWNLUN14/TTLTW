document.addEventListener("DOMContentLoaded", function() {
    console.log("Trang chủ Auto Cars đã được tải thành công!");
});

function goBook() {
    const pickup = document.getElementById("inPickup").value.trim();
    const dropoff = document.getElementById("inDropoff").value.trim();
    const date = document.getElementById("inDate").value;

    if(!pickup || !dropoff || !date) {
        alert("Vui lòng nhập đầy đủ Điểm đón, Điểm đến và Ngày đi!");
        return;
    }

    window.location.href = `booking.html?pickup=${encodeURIComponent(pickup)}&dropoff=${encodeURIComponent(dropoff)}&date=${date}`;
}

function quickBook(pickup, dropoff) {
    document.getElementById("inPickup").value = pickup;
    document.getElementById("inDropoff").value = dropoff;

    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    document.getElementById("inDate").valueAsDate = tomorrow;

    alert(`Đã điền nhanh tuyến đường: ${pickup} đi ${dropoff}`);
}
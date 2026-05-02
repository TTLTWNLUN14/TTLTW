document.addEventListener("DOMContentLoaded", function () {

    let activeCategory = "Tất cả";
    let activeSeat     = "Tất cả";
    let activeFuel     = "Tất cả";
    let maxPrice       = 15000;

    const seatMap = {
        "Tất cả": "Tất cả",
        "4 chỗ": "4",
        "5 chỗ": "5",
        "7 chỗ": "7",
        "8+ chỗ": "8+"
    };

    function applyFilters() {
        const cards = document.querySelectorAll(".car-card");
        let visible = 0;

        cards.forEach(function (card) {
            const cat   = card.dataset.category  || "";
            const seat  = card.dataset.seat       || "";
            const fuel  = card.dataset.fuel       || "";
            const price = parseInt(card.dataset.price) || 0;

            const matchCat   = activeCategory === "Tất cả" || cat === activeCategory;
            const matchFuel  = activeFuel     === "Tất cả" || fuel === activeFuel;
            const matchPrice = price <= maxPrice;

            let matchSeat = true;
            if (activeSeat !== "Tất cả") {
                if (activeSeat === "8+") {
                    matchSeat = parseInt(seat) >= 8;
                } else {
                    matchSeat = seat === activeSeat;
                }
            }

            if (matchCat && matchSeat && matchFuel && matchPrice) {
                card.style.display = "";
                visible++;
            } else {
                card.style.display = "none";
            }
        });

        const countEl = document.querySelector(".car-count");
        if (countEl) countEl.textContent = visible + " loại xe";
    }

    // --- Gắn sự kiện cho từng nhóm chip ---
    const filterGroups = document.querySelectorAll(".filter-chips");
    filterGroups.forEach(function (group, index) {
        const chips = group.querySelectorAll(".chip");
        chips.forEach(function (chip) {
            chip.addEventListener("click", function () {
                chips.forEach(function (c) { c.classList.remove("active"); });
                this.classList.add("active");

                const val = this.textContent.trim();
                if (index === 0) activeCategory = val;
                if (index === 1) {
                    activeSeat = seatMap[val] || "Tất cả";
                }
                if (index === 2) activeFuel = val;

                applyFilters();
            });
        });
    });

    // --- Slider giá ---
    const maxPriceInput = document.getElementById("maxPrice");
    const priceLabel    = document.getElementById("priceLabel");

    if (maxPriceInput && priceLabel) {
        maxPriceInput.addEventListener("input", function () {
            maxPrice = parseInt(this.value);
            priceLabel.textContent = Number(this.value).toLocaleString("vi-VN") + "đ";
            applyFilters();
        });
    }

    // --- Nút reset ---
    const resetBtn = document.getElementById("resetFiltersBtn");
    if (resetBtn) {
        resetBtn.addEventListener("click", function () {
            activeCategory = "Tất cả";
            activeSeat     = "Tất cả";
            activeFuel     = "Tất cả";
            maxPrice       = 15000;

            filterGroups.forEach(function (group) {
                const chips = group.querySelectorAll(".chip");
                chips.forEach(function (c) { c.classList.remove("active"); });
                if (chips.length > 0) chips[0].classList.add("active");
            });

            if (maxPriceInput) {
                maxPriceInput.value = 15000;
                priceLabel.textContent = "15.000đ";
            }

            applyFilters();
        });
    }

    applyFilters();
});
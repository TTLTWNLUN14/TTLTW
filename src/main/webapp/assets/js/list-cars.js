
document.addEventListener("DOMContentLoaded", function() {
    const filterGroups = document.querySelectorAll(".filter-chips");

    filterGroups.forEach(group => {
        const chips = group.querySelectorAll(".chip");
        chips.forEach(chip => {
            chip.addEventListener("click", function() {
                chips.forEach(c => c.classList.remove("active"));
                this.classList.add("active");
            });
        });
    });

    const brandPills = document.querySelectorAll(".brand-pill");
    brandPills.forEach(pill => {
        pill.addEventListener("click", function() {
            brandPills.forEach(p => p.classList.remove("active"));
            this.classList.add("active");
        });
    });

    const maxPriceInput = document.getElementById("maxPrice");
    const priceLabel = document.getElementById("priceLabel");

    if (maxPriceInput && priceLabel) {
        maxPriceInput.addEventListener("input", function() {
            let formattedPrice = Number(this.value).toLocaleString("vi-VN");
            priceLabel.textContent = formattedPrice + "đ";
        });
    }

    const resetBtn = document.getElementById("resetFiltersBtn");
    if (resetBtn) {
        resetBtn.addEventListener("click", function() {
            filterGroups.forEach(group => {
                const chips = group.querySelectorAll(".chip");
                chips.forEach(c => c.classList.remove("active"));
                if (chips.length > 0) chips[0].classList.add("active");
            });

            brandPills.forEach(p => p.classList.remove("active"));
            if (brandPills.length > 0) brandPills[0].classList.add("active");

            if (maxPriceInput) {
                maxPriceInput.value = 15000;
                priceLabel.textContent = "15.000đ";
            }
        });
    }
});
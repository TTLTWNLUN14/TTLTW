function renderBrands() {
  const brands = Store.getBrands();
  const allCars = Store.getCars();
  const grid = document.getElementById('brandsGrid');
  grid.innerHTML = brands.map(b => {
    const count = allCars.filter(c => c.brandId === b.id).length;
    return `
      <div class="brand-card" onclick="location.href='cars-brand.html?brand=${b.id}'">
        <div class="brand-card__icon">${b.logo}</div>
        <div class="brand-card__name">${b.name}</div>
        <div class="brand-card__desc">${b.desc}</div>
        <span class="brand-card__count">${count} dòng xe</span>
        <span class="brand-card__arrow">Xem xe →</span>
      </div>`;
  }).join('');
}

renderBrands();

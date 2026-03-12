// ── Shared Data Store ──────────────────────────
// All data is in-memory (no server required)

const Store = (() => {
  // ── Brands & Cars ───────────────────────────
  let brands = [
    { id: 'toyota', name: 'Toyota', logo: '🚗', desc: 'Xe Nhật Bản đáng tin cậy' },
    { id: 'honda',  name: 'Honda',  logo: '🏎️', desc: 'Công nghệ tiên tiến' },
    { id: 'vinfast',name: 'VinFast',logo: '🇻🇳', desc: 'Thương hiệu Việt tự hào' },
    { id: 'hyundai',name: 'Hyundai',logo: '🚙', desc: 'Thiết kế hiện đại' },
    { id: 'mercedes',name:'Mercedes',logo:'💎',desc:'Đẳng cấp sang trọng'},
    { id: 'ford',   name: 'Ford',   logo: '🛻', desc: 'Mạnh mẽ và bền bỉ' },
  ];

  let cars = [
    { id:'c01', brandId:'toyota', name:'Innova Cross', seats:7,  type:'MPV',    img:'https://www.libertyinsurance.com.vn/sites/libertyvn/files/inline-images/K%C3%ADch%20th%C6%B0%E1%BB%9Bc%20xe%20%C3%B4%20t%C3%B4%207%20ch%E1%BB%97_toyota%20innova_0.png', pricePerKm:4500, desc:'Không gian rộng, phù hợp gia đình.' },
    { id:'c02', brandId:'toyota', name:'Veloz Cross',  seats:7,  type:'MPV',    img:'https://i1-vnexpress.vnecdn.net/2022/03/23/DSCF15692JPG-1648011323.jpg?w=750&h=450&q=100', pricePerKm:4200, desc:'Tiện nghi, tiết kiệm nhiên liệu.' },
    { id:'c03', brandId:'toyota', name:'Raize',        seats:5,  type:'SUV',    img:'https://toyotahcm.vn/wp-content/uploads/2024/01/Xe-Toyota-Raize-Slide-2.jpg', pricePerKm:3800, desc:'SUV đô thị nhỏ gọn.' },
    { id:'c04', brandId:'toyota', name:'Fortuner',     seats:7,  type:'SUV',    img:'https://media-cdn-v2.laodong.vn/Storage/NewsPortal/2020/11/16/854951/7C1.png', pricePerKm:5500, desc:'SUV địa hình cứng cáp.' },
    { id:'c05', brandId:'honda',  name:'CR-V',         seats:5,  type:'SUV',    img:'https://cdn.dailyxe.com.vn/image/ngoai-that-honda-crv-rs-04-323818j.jpg', pricePerKm:4800, desc:'SUV sang trọng thực dụng.' },
    { id:'c06', brandId:'honda',  name:'BR-V',         seats:7,  type:'MPV',    img:'https://otohonda.com.vn/wp-content/uploads/Honda-BR-V-Lua-Chon-Xe-7-Cho-Dang-Tien-Trong-Phan-Khuc.jpg', pricePerKm:3900, desc:'Xe 7 chỗ giá tốt.' },
    { id:'c07', brandId:'vinfast',name:'VF 8',         seats:5,  type:'SUV',    img:'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxnSkfveLpjz_IkCTAutp-yqSxrhdhXIaQiA&s', pricePerKm:4000, desc:'SUV điện hiện đại.' },
    { id:'c08', brandId:'vinfast',name:'VF 9',         seats:7,  type:'SUV',    img:'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxnSkfveLpjz_IkCTAutp-yqSxrhdhXIaQiA&s', pricePerKm:5200, desc:'SUV điện 7 chỗ sang trọng.' },
    { id:'c09', brandId:'hyundai',name:'Grand i10',    seats:4,  type:'Sedan',  img:'https://hyundaibinhthuan.vn/wp-content/uploads/Ngoai-that-Grand-i10-Hatchback-5-1.jpg', pricePerKm:3000, desc:'Xe đô thị nhỏ gọn, tiết kiệm.' },
    { id:'c10', brandId:'hyundai',name:'Tucson',       seats:5,  type:'SUV',    img:'https://static-images.vnncdn.net/vps_images_publish/000001/000003/2024/8/11/nhung-mau-xe-7-cho-sieu-luot-trong-tam-gia-600-trieu-phu-hop-voi-gia-dinh-886.jpeg?width=0&s=t8sCUKqSHtMQLJB1rRNEgw', pricePerKm:4400, desc:'SUV tầm trung phổ biến.' },
    { id:'c11', brandId:'mercedes',name:'S500',        seats:4,  type:'Sedan',  img:'https://mercedesphumyhung.com.vn/wp-content/uploads/2025/01/thong-so-mercedes-s500-1.jpg.webp', pricePerKm:12000, desc:'Sedan cao cấp đẳng cấp nhất.' },
    { id:'c12', brandId:'mercedes',name:'GLC 300',     seats:5,  type:'SUV',    img:'https://mercedesphumyhung.com.vn/wp-content/uploads/2025/01/thong-so-mercedes-s500-1.jpg.webp', pricePerKm:9500, desc:'SUV sang trọng thế hệ mới.' },
    { id:'c13', brandId:'ford',   name:'Everest',      seats:7,  type:'SUV',    img:'https://i1-vnexpress.vnecdn.net/2023/11/20/MitsubishiPajeroSportVNEjpg-1700453733.jpg?w=500&h=300&q=100', pricePerKm:5000, desc:'SUV 7 chỗ mạnh mẽ.' },
    { id:'c14', brandId:'ford',   name:'Ranger',       seats:5,  type:'Pickup', img:'https://i1-vnexpress.vnecdn.net/2023/11/20/MitsubishiPajeroSportVNEjpg-1700453733.jpg?w=500&h=300&q=100', pricePerKm:4600, desc:'Bán tải đa địa hình.' },
  ];

  // ── Drivers ─────────────────────────────────
  let drivers = [
    { id:'d01', name:'Nguyễn Văn Sáng', phone:'0901234567', rating:4.8, trips:120, avail:true },
    { id:'d02', name:'Phạm Quang Ngọc', phone:'0912345678', rating:4.9, trips:95,  avail:true },
    { id:'d03', name:'Vũ Văn Tường',    phone:'0923456789', rating:4.6, trips:80,  avail:false},
    { id:'d04', name:'Trần Thanh Sơn',  phone:'0934567890', rating:4.7, trips:150, avail:true },
    { id:'d05', name:'Hoàng Văn Tiến',  phone:'0945678901', rating:4.5, trips:60,  avail:true },
  ];

  // ── Pricing ──────────────────────────────────
  let pricing = {
    baseFee:    30000,   // phí mở cửa (VND)
    perKm:      4000,    // VND/km mặc định
    driverDay:  300000,  // phí thuê tài xế / ngày
    fuelFactor: 1.0,     // nhân hệ số nhiên liệu
  };

  // ── Bookings ─────────────────────────────────
  let bookings = [
    { id:'BK001', userId:'u01', carId:'c01', driverId:'d01', from:'Hà Nội', to:'Hải Phòng', dateFrom:'2025-03-10', dateTo:'2025-03-10', km:120, withDriver:true,  status:'done',    total:768000,  review:null },
    { id:'BK002', userId:'u01', carId:'c05', driverId:'d02', from:'HCM',    to:'Đà Lạt',   dateFrom:'2025-03-15', dateTo:'2025-03-16', km:300, withDriver:true,  status:'done',    total:1740000, review:{ stars:5, text:'Dịch vụ tuyệt vời, tài xế thân thiện!' } },
    { id:'BK003', userId:'u01', carId:'c04', driverId:null,  from:'HCM',    to:'Nha Trang', dateFrom:'2025-04-01', dateTo:'2025-04-03', km:450, withDriver:false, status:'pending', total:2505000, review:null },
    { id:'BK004', userId:'u01', carId:'c09', driverId:'d04', from:'Hà Nội', to:'Quảng Ninh',dateFrom:'2025-04-05', dateTo:'2025-04-05', km:160, withDriver:true,  status:'pending', total:810000,  review:null },
    { id:'BK005', userId:'u01', carId:'c02', driverId:null,  from:'HCM',    to:'Vũng Tàu', dateFrom:'2025-02-20', dateTo:'2025-02-20', km:125, withDriver:false, status:'cancel',  total:555000,  review:null },
    { id:'BK006', userId:'u01', carId:'c11', driverId:'d02', from:'Hà Nội', to:'Huế',       dateFrom:'2025-02-25', dateTo:'2025-02-27', km:700, withDriver:true,  status:'done',    total:9300000, review:{ stars:5, text:'Xe sang, tài xế chuyên nghiệp. Sẽ đặt lại!' } },
  ];

  // ── Feedbacks (global) ───────────────────────
  let feedbacks = [
    { id:'f01', user:'Minh Tuấn',  stars:5, text:'Dịch vụ tuyệt vời, xe sạch và tài xế đúng giờ!', date:'2025-03-12' },
    { id:'f02', user:'Thị Lan',    stars:4, text:'Trải nghiệm rất tốt, giá hợp lý.', date:'2025-03-14' },
    { id:'f03', user:'Văn Hùng',   stars:5, text:'Tuyến HCM - Đà Lạt rất tiện lợi.', date:'2025-03-18' },
    { id:'f04', user:'Thu Hà',     stars:3, text:'Xe ổn nhưng đặt hơi lâu xác nhận.', date:'2025-03-20' },
  ];

  let _nextId = { booking: 7, feedback: 5, car: 15, brand: 7, driver: 6 };
  function newId(type) { return `${type}${String(_nextId[type]++).padStart(2,'0')}`; }

  return {
    // Brands
    getBrands: ()   => [...brands],
    getBrand:  (id) => brands.find(b => b.id === id),
    addBrand:  (b)  => { b.id = 'br' + newId('brand'); brands.push(b); return b; },
    updateBrand:(id,d) => { const i = brands.findIndex(b=>b.id===id); if(i>-1) brands[i]={...brands[i],...d}; },
    deleteBrand:(id) => { brands = brands.filter(b => b.id !== id); cars = cars.filter(c=>c.brandId!==id); },

    // Cars
    getCars:        ()     => [...cars],
    getCarsByBrand: (bid)  => cars.filter(c => c.brandId === bid),
    getCar:         (id)   => cars.find(c => c.id === id),
    addCar:         (c)    => { c.id = newId('car'); cars.push(c); return c; },
    updateCar:      (id,d) => { const i = cars.findIndex(c=>c.id===id); if(i>-1) cars[i]={...cars[i],...d}; },
    deleteCar:      (id)   => { cars = cars.filter(c => c.id !== id); },

    // Drivers
    getDrivers:      ()     => [...drivers],
    getDriver:       (id)   => drivers.find(d => d.id === id),
    getAvailDrivers: ()     => drivers.filter(d => d.avail),
    addDriver:       (d)    => { d.id = newId('driver'); drivers.push(d); return d; },
    updateDriver:    (id,d2)=> { const i = drivers.findIndex(d=>d.id===id); if(i>-1) drivers[i]={...drivers[i],...d2}; },
    deleteDriver:    (id)   => { drivers = drivers.filter(d => d.id !== id); },

    // Pricing
    getPricing:    ()  => ({...pricing}),
    updatePricing: (p) => { pricing = {...pricing,...p}; },
    calcCost: (km, withDriver, days, carPricePerKm) => {
      const ppm = carPricePerKm || pricing.perKm;
      let total = pricing.baseFee + km * ppm * pricing.fuelFactor;
      if (withDriver) total += pricing.driverDay * (days || 1);
      return Math.round(total);
    },

    // Bookings
    getBookings:     ()     => [...bookings],
    getBooking:      (id)   => bookings.find(b => b.id === id),
    addBooking:      (b)    => { b.id = 'BK' + String(_nextId.booking++).padStart(3,'0'); bookings.push(b); return b; },
    updateBooking:   (id,d) => { const i = bookings.findIndex(b=>b.id===id); if(i>-1) bookings[i]={...bookings[i],...d}; },
    deleteBooking:   (id)   => { bookings = bookings.filter(b => b.id !== id); },
    addReview: (bookingId, stars, text) => {
      const b = bookings.find(x=>x.id===bookingId);
      if (b) {
        b.review = { stars, text, date: new Date().toISOString().slice(0,10) };
        // also add to global feedbacks
        feedbacks.unshift({ id: newId('feedback'), user:'Khách hàng', stars, text, date: b.review.date });
      }
    },

    // Feedbacks
    getFeedbacks:  ()    => [...feedbacks],
    addFeedback:   (f)   => { f.id = newId('feedback'); feedbacks.unshift(f); return f; },

    // Helpers
    fmtCurrency: (n) => Number(n).toLocaleString('vi-VN') + ' ₫',
    fmtDate:     (d) => new Date(d).toLocaleDateString('vi-VN'),
    daysBetween: (a,b) => Math.max(1, Math.round((new Date(b)-new Date(a))/(1000*60*60*24))+1),
  };
})();

// Toast utility
function toast(msg, type='ok') {
  const t = document.getElementById('toast');
  if (!t) return;
  t.textContent = msg;
  t.style.background = type === 'err' ? '#ef4444' : '#0b1e3d';
  t.classList.add('show');
  clearTimeout(t._timer);
  t._timer = setTimeout(() => t.classList.remove('show'), 3000);
}

// Render nav active state
document.addEventListener('DOMContentLoaded', () => {
  const page = location.pathname.split('/').pop() || 'index.html';
  document.querySelectorAll('.nav-links a').forEach(a => {
    if (a.getAttribute('href') === page) a.classList.add('active');
  });
});

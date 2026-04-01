

let _id = { booking:10, payment:10, notif:20, event:20, review:10, account:10, customer:4, driver:3 };

function fmtMoney(n){ if(!n&&n!==0)return'—'; return Number(n).toLocaleString('vi-VN')+'đ'; }
function fmtDate(d){ if(!d)return'—'; return new Date(d).toLocaleDateString('vi-VN',{day:'2-digit',month:'2-digit',year:'numeric'}); }
function fmtDateTime(d){ if(!d)return'—'; return new Date(d).toLocaleString('vi-VN',{day:'2-digit',month:'2-digit',year:'numeric',hour:'2-digit',minute:'2-digit'}); }
function timeAgo(d){ if(!d)return''; const s=Math.floor((Date.now()-new Date(d))/1000); if(s<60)return s+'s trước'; if(s<3600)return Math.floor(s/60)+'p trước'; if(s<86400)return Math.floor(s/3600)+'h trước'; return Math.floor(s/86400)+'ng trước'; }


const Session = {
  _k:'ac_sess',
  get(){ try{return JSON.parse(sessionStorage.getItem(this._k))||null;}catch{return null;} },
  set(d){ sessionStorage.setItem(this._k,JSON.stringify(d)); },
  clear(){ sessionStorage.removeItem(this._k); },
  ensure(role){
    const s=this.get();
    const inH=location.pathname.includes('/html/');
    const auth=inH?'auth.html':'html/auth.html';
    if(!s){location.href=auth;return null;}
  
    if(role==='driver'&&s.role_id!==3&&!s.driver_id){location.href=auth;return null;}
    if(role==='admin'&&s.role_id!==1&&s.role_id!==0){location.href=auth;return null;}
    if(role==='user'&&s.role_id!==2&&s.role_id!==3){location.href=auth;return null;}
    return s;
  }
};

function showToast(title,msg='',type='info'){
  const icons={success:'',error:'',warning:'',warn:'',info:'️'};
  const c=document.getElementById('toastC'); if(!c)return;
  const el=document.createElement('div');
  el.className=`toast ${type==='warning'?'warn':type}`;
  el.innerHTML=`<div class="toast-icon">${icons[type]||'️'}</div><div class="toast-body"><div class="toast-title">${title}</div>${msg?`<div class="toast-msg">${msg}</div>`:''}</div>`;
  c.appendChild(el); setTimeout(()=>el.remove(),3500);
}

const DB = (()=>{
  const roles=[{role_id:0,role_name:'Super Admin'},{role_id:1,role_name:'Admin'},{role_id:2,role_name:'Khách hàng'},{role_id:3,role_name:'Tài xế'}];

  const accounts=[
    {account_id:1, email:'super@autocars.vn', password:'123456', role_id:0, full_name:'Super Admin',      username:'superadmin', phone:'0900000000', avatar:null, is_active:1, created_at:'2024-01-01', last_login:'2025-03-19T10:00:00'},
    {account_id:2, email:'admin@autocars.vn',  password:'123456', role_id:1, full_name:'Nguyễn Admin',     username:'admin',       phone:'0900000001', avatar:null, is_active:1, created_at:'2024-01-02', last_login:'2025-03-19T09:00:00'},
    {account_id:3, email:'user@autocars.vn',   password:'123456', role_id:2, full_name:'Trần Minh Tú',     username:'tranminhtú',  phone:'0901234567', avatar:null, is_active:1, created_at:'2024-02-01', last_login:'2025-03-18T14:30:00'},
    {account_id:4, email:'driver@autocars.vn', password:'123456', role_id:3, full_name:'Nguyễn Văn An',    username:'nguyenvanan', phone:'0901111111', avatar:null, is_active:1, created_at:'2024-02-15', last_login:'2025-03-19T07:00:00'},
    {account_id:5, email:'mai@gmail.com',       password:'123456', role_id:2, full_name:'Lê Thị Mai',       username:'lethimai',    phone:'0912345678', avatar:null, is_active:1, created_at:'2024-03-01', last_login:'2025-03-17T10:00:00'},
    {account_id:6, email:'khoa@gmail.com',      password:'123456', role_id:2, full_name:'Phạm Minh Khoa',  username:'pmkhoa',      phone:'0923456789', avatar:null, is_active:1, created_at:'2024-03-10', last_login:'2025-03-15T08:00:00'},
    {account_id:7, email:'driver2@autocars.vn',password:'123456', role_id:3, full_name:'Trần Văn Bình',    username:'tranvanbinh', phone:'0902222222', avatar:null, is_active:1, created_at:'2024-02-20', last_login:'2025-03-18T18:00:00'},
    {account_id:8, email:'driver3@autocars.vn',password:'123456', role_id:3, full_name:'Lê Hoàng Cường',  username:'lhcuong',     phone:'0903333333', avatar:null, is_active:1, created_at:'2024-03-05', last_login:'2025-03-10T09:00:00'},
    {account_id:9, email:'admin2@autocars.vn', password:'123456', role_id:1, full_name:'Vũ Thị Hoa',       username:'vthihoa',     phone:'0944444444', avatar:null, is_active:1, created_at:'2024-04-01', last_login:'2025-03-16T11:00:00'},
    {account_id:10,email:'tuan@gmail.com',      password:'123456', role_id:2, full_name:'Nguyễn Tuấn Kiệt',username:'ntkiet',     phone:'0934567890', avatar:null, is_active:1, created_at:'2024-04-15', last_login:'2025-03-19T06:00:00'},
  ];

  const member_tiers=[
    {tier:'standard',label:'Standard',discount:0, fee:0,      max_coupon_pct:5,  color:'#6b7280',points_rate:1},
    {tier:'silver',  label:'Silver',  discount:5, fee:199000, max_coupon_pct:10, color:'#9ca3af',points_rate:1.5},
    {tier:'gold',    label:'Gold',    discount:10,fee:499000, max_coupon_pct:20, color:'#f59e0b',points_rate:2},
    {tier:'platinum',label:'Platinum',discount:15,fee:999000, max_coupon_pct:30, color:'#38bdf8',points_rate:3},
    {tier:'diamond', label:'Diamond', discount:20,fee:1999000,max_coupon_pct:50, color:'#a78bfa',points_rate:4},
  ];
  const tierOrder=['standard','silver','gold','platinum','diamond'];

  const customers=[
    {customer_id:1, account_id:3, full_name:'Trần Minh Tú',     phone:'0901234567', member_tier:'gold',    points:2800, total_trips:28, total_spent:14500000, dob:'1995-05-12', gender:'male',   city:'HCM', cccd:'012345678901', address:'123 Nguyễn Trãi Q5', face_img:null, joined:'2024-02-01'},
    {customer_id:2, account_id:5, full_name:'Lê Thị Mai',        phone:'0912345678', member_tier:'silver',  points:420,  total_trips:8,  total_spent:3200000,  dob:'1998-09-22', gender:'female', city:'HCM', cccd:'098765432100', address:'45 Lê Lợi Q1',       face_img:null, joined:'2024-03-01'},
    {customer_id:3, account_id:6, full_name:'Phạm Minh Khoa',   phone:'0923456789', member_tier:'standard',points:80,   total_trips:3,  total_spent:850000,   dob:'2000-01-08', gender:'male',   city:'HN',  cccd:'001122334455', address:'67 Hoàng Diệu HN',   face_img:null, joined:'2024-03-10'},
    {customer_id:4, account_id:10,full_name:'Nguyễn Tuấn Kiệt', phone:'0934567890', member_tier:'platinum', points:7200, total_trips:56, total_spent:42000000, dob:'1990-11-30', gender:'male',   city:'HCM', cccd:'556677889900', address:'789 Đinh Tiên Hoàng', face_img:null, joined:'2024-04-15'},
  ];

  const drivers=[
    {driver_id:1, account_id:4, full_name:'Nguyễn Văn An',   phone:'0901111111', license:'B2-123456', license_exp:'2027-01-01', city:'HCM', rating:4.9, total_trips:1247, income_today:850000, income_month:24500000, is_available:1, is_online:1, approval_status:'approved', status:'available', joined:'2024-02-15', cccd:'111222333444', face_img:null, avatar_text:'AN'},
    {driver_id:2, account_id:7, full_name:'Trần Văn Bình',   phone:'0902222222', license:'B2-234567', license_exp:'2026-06-15', city:'HCM', rating:4.7, total_trips:832,  income_today:620000, income_month:18000000, is_available:1, is_online:1, approval_status:'approved', status:'available', joined:'2024-02-20', cccd:'222333444555', face_img:null, avatar_text:'TB'},
    {driver_id:3, account_id:8, full_name:'Lê Hoàng Cường', phone:'0903333333', license:'B2-345678', license_exp:'2028-03-10', city:'HN',  rating:4.8, total_trips:567,  income_today:0,      income_month:12000000, is_available:0, is_online:0, approval_status:'approved', status:'offline',   joined:'2024-03-05', cccd:'333444555666', face_img:null, avatar_text:'LC'},
    {driver_id:4, account_id:null, full_name:'Vũ Thành Long', phone:'0911223344', license:'B2-456789', license_exp:'2026-12-01', city:'HCM', rating:0,   total_trips:0,    income_today:0,      income_month:0,        is_available:0, is_online:0, approval_status:'pending',  status:'pending',   joined:'2025-03-15', cccd:'444555666777', face_img:null, avatar_text:'VL'},
  ];

  const car_brands=[
    {brand_id:1, brand_name:'Toyota',    logo:'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Toyota_carlogo.svg/100px-Toyota_carlogo.svg.png', country:'Nhật Bản', is_active:1, desc:'Xe Nhật Bản đáng tin cậy, bền bỉ'},
    {brand_id:2, brand_name:'Honda',     logo:'https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/Honda.svg/100px-Honda.svg.png',  country:'Nhật Bản', is_active:1, desc:'Công nghệ tiên tiến, tiết kiệm nhiên liệu'},
    {brand_id:3, brand_name:'VinFast',   logo:'https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/VinFast_logo.svg/100px-VinFast_logo.svg.png', country:'Việt Nam', is_active:1, desc:'Thương hiệu Việt tự hào, xe điện hiện đại'},
    {brand_id:4, brand_name:'Hyundai',   logo:'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Hyundai_Motor_Company_logo.svg/100px-Hyundai_Motor_Company_logo.svg.png', country:'Hàn Quốc', is_active:1, desc:'Thiết kế hiện đại, giá cả cạnh tranh'},
    {brand_id:5, brand_name:'Mercedes',  logo:'https://upload.wikimedia.org/wikipedia/commons/thumb/9/90/Mercedes-Logo.svg/100px-Mercedes-Logo.svg.png', country:'Đức', is_active:1, desc:'Đẳng cấp sang trọng, trải nghiệm thượng hạng'},
    {brand_id:6, brand_name:'Ford',      logo:'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3e/Ford_logo_flat.svg/100px-Ford_logo_flat.svg.png', country:'Mỹ', is_active:1, desc:'Mạnh mẽ, bền bỉ, phù hợp địa hình VN'},
    {brand_id:7, brand_name:'Kia',       logo:'https://upload.wikimedia.org/wikipedia/commons/thumb/1/13/Kia-logo.svg/100px-Kia-logo.svg.png', country:'Hàn Quốc', is_active:1, desc:'Thiết kế trẻ trung, công nghệ hiện đại'},
    {brand_id:8, brand_name:'Mazda',     logo:'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Mazda_2023_logo.svg/100px-Mazda_2023_logo.svg.png', country:'Nhật Bản', is_active:1, desc:'Thẩm mỹ Nhật Bản, lái hứng khởi'},
    {brand_id:9, brand_name:'Mitsubishi',logo:'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Mitsubishi_logo.svg/100px-Mitsubishi_logo.svg.png', country:'Nhật Bản', is_active:1, desc:'SUV địa hình số 1, mạnh mẽ và đáng tin'},
  ];

  const car_types=[
    {type_id:1, brand_id:1, type_name:'Toyota Innova Cross', seats:7, fuel:'Hybrid',  category:'MPV',   price_per_day:1800000, price_per_km:4500, available:3, img:'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/2023_Toyota_Innova_Cross_%28Thailand%29.jpg/320px-2023_Toyota_Innova_Cross_%28Thailand%29.jpg', desc:'Không gian rộng rãi, phù hợp gia đình đông người.'},
    {type_id:2, brand_id:1, type_name:'Toyota Fortuner',     seats:7, fuel:'Diesel',  category:'SUV',   price_per_day:2500000, price_per_km:5500, available:2, img:'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/2020_Toyota_Fortuner_%28facelift%2C_brown%29%2C_front_8.16.19.jpg/320px-2020_Toyota_Fortuner_%28facelift%2C_brown%29%2C_front_8.16.19.jpg', desc:'SUV địa hình cứng cáp, mạnh mẽ mọi cung đường.'},
    {type_id:3, brand_id:1, type_name:'Toyota Camry',        seats:5, fuel:'Hybrid',  category:'Sedan', price_per_day:2200000, price_per_km:6200, available:2, img:'https://upload.wikimedia.org/wikipedia/commons/thumb/6/63/2021_Toyota_Camry_%28XV70%2C_facelift%29%2C_front_8.8.21.jpg/320px-2021_Toyota_Camry_%28XV70%2C_facelift%29%2C_front_8.8.21.jpg', desc:'Sedan hạng sang, êm ái và sang trọng.'},
    {type_id:4, brand_id:1, type_name:'Toyota Raize',        seats:5, fuel:'Xăng',    category:'SUV',   price_per_day:1200000, price_per_km:3800, available:4, img:'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/2021_Toyota_Raize_Z_1.0T%2C_front_9.25.21.jpg/320px-2021_Toyota_Raize_Z_1.0T%2C_front_9.25.21.jpg', desc:'SUV đô thị nhỏ gọn, linh hoạt trong phố.'},
    {type_id:5, brand_id:2, type_name:'Honda CR-V',          seats:5, fuel:'Xăng',    category:'SUV',   price_per_day:1600000, price_per_km:4800, available:3, img:'https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/2023_Honda_CR-V_e%3AHEV_Advance%2C_front_10.28.22.jpg/320px-2023_Honda_CR-V_e%3AHEV_Advance%2C_front_10.28.22.jpg', desc:'SUV sang trọng, thực dụng cho mọi chuyến đi.'},
    {type_id:6, brand_id:2, type_name:'Honda BR-V',          seats:7, fuel:'Xăng',    category:'MPV',   price_per_day:1400000, price_per_km:3900, available:3, img:'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/2022_Honda_BR-V_1.5_E_CVT%2C_front_11.16.22.jpg/320px-2022_Honda_BR-V_1.5_E_CVT%2C_front_11.16.22.jpg', desc:'Xe 7 chỗ giá tốt, tiết kiệm nhiên liệu.'},
    {type_id:7, brand_id:3, type_name:'VinFast VF 8',        seats:5, fuel:'Điện',    category:'SUV',   price_per_day:1500000, price_per_km:4000, available:4, img:'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/VinFast_VF_8_at_CES_2022.jpg/320px-VinFast_VF_8_at_CES_2022.jpg', desc:'SUV điện hiện đại, công nghệ cao.'},
    {type_id:8, brand_id:3, type_name:'VinFast VF 9',        seats:7, fuel:'Điện',    category:'SUV',   price_per_day:2000000, price_per_km:5200, available:2, img:'https://upload.wikimedia.org/wikipedia/commons/thumb/6/61/VinFast_VF9_%28front%29.jpg/320px-VinFast_VF9_%28front%29.jpg', desc:'SUV điện 7 chỗ sang trọng, rộng rãi.'},
    {type_id:9, brand_id:4, type_name:'Hyundai Grand i10',   seats:4, fuel:'Xăng',    category:'Sedan', price_per_day:900000,  price_per_km:3000, available:5, img:'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Hyundai_Grand_i10_hatchback_%28India%2C_facelift%29.jpg/320px-Hyundai_Grand_i10_hatchback_%28India%2C_facelift%29.jpg', desc:'Xe đô thị nhỏ gọn, tiết kiệm tuyệt vời.'},
    {type_id:10,brand_id:4, type_name:'Hyundai Tucson',       seats:5, fuel:'Xăng',    category:'SUV',   price_per_day:1500000, price_per_km:4400, available:3, img:'https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/2022_Hyundai_Tucson_1.6_T-GDi_MHEV_Premium_%28UK%29%2C_front_8.28.21.jpg/320px-2022_Hyundai_Tucson_1.6_T-GDi_MHEV_Premium_%28UK%29%2C_front_8.28.21.jpg', desc:'SUV tầm trung phổ biến, ổn định.'},
    {type_id:11,brand_id:5, type_name:'Mercedes S500',        seats:5, fuel:'Xăng',    category:'Sedan', price_per_day:5000000, price_per_km:12000,available:1, img:'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/2022_Mercedes-Benz_S500_4Matic_%28W223%29%2C_front_8.14.21.jpg/320px-2022_Mercedes-Benz_S500_4Matic_%28W223%29%2C_front_8.14.21.jpg', desc:'Sedan cao cấp đẳng cấp nhất thế giới.'},
    {type_id:12,brand_id:6, type_name:'Ford Ranger',          seats:5, fuel:'Diesel',  category:'Pickup',price_per_day:1600000, price_per_km:4200, available:3, img:'https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/2023_Ford_Ranger_Sport_%28Australia%29%2C_front_11.13.22.jpg/320px-2023_Ford_Ranger_Sport_%28Australia%29%2C_front_11.13.22.jpg', desc:'Bán tải mạnh mẽ, vượt địa hình tốt.'},
    {type_id:13,brand_id:7, type_name:'Kia Carnival',         seats:8, fuel:'Xăng',    category:'MPV',   price_per_day:2200000, price_per_km:5000, available:2, img:'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/2022_Kia_Carnival_EX%2C_front_10.21.21.jpg/320px-2022_Kia_Carnival_EX%2C_front_10.21.21.jpg', desc:'MPV cao cấp, tiện nghi bậc nhất phân khúc.'},
    {type_id:14,brand_id:8, type_name:'Mazda CX-5',           seats:5, fuel:'Xăng',    category:'SUV',   price_per_day:1500000, price_per_km:4300, available:3, img:'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/2021_Mazda_CX-5_Sport_%28US%29%2C_front_12.15.20.jpg/320px-2021_Mazda_CX-5_Sport_%28US%29%2C_front_12.15.20.jpg', desc:'SUV sang trọng, đường nét thiết kế cuốn hút.'},
    {type_id:15,brand_id:9, type_name:'Mitsubishi Xpander',   seats:7, fuel:'Xăng',    category:'MPV',   price_per_day:1350000, price_per_km:3700, available:4, img:'https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/Mitsubishi_Xpander_Cross_Facelift_2022_%28Indonesia%29.jpg/320px-Mitsubishi_Xpander_Cross_Facelift_2022_%28Indonesia%29.jpg', desc:'MPV đa dụng, vận chuyển gia đình lý tưởng.'},
  ];

  const coupons=[
    {coupon_id:1, code:'WELCOME10', desc:'Chào mừng thành viên mới',      discount_pct:10, min_order:500000,  max_discount:200000,  min_tier:'standard', expires:'2025-12-31', uses_left:99, is_active:1},
    {coupon_id:2, code:'SILVER15',  desc:'Ưu đãi thành viên Silver',       discount_pct:15, min_order:1000000, max_discount:500000,  min_tier:'silver',   expires:'2025-12-31', uses_left:50, is_active:1},
    {coupon_id:3, code:'GOLD20',    desc:'Ưu đãi đặc quyền Gold',          discount_pct:20, min_order:1500000, max_discount:1000000, min_tier:'gold',     expires:'2025-12-31', uses_left:30, is_active:1},
    {coupon_id:4, code:'PLAT30',    desc:'Platinum Member – Giảm đậm',     discount_pct:30, min_order:2000000, max_discount:2000000, min_tier:'platinum', expires:'2025-12-31', uses_left:20, is_active:1},
    {coupon_id:5, code:'DIAMOND50', desc:'Diamond VIP – Ưu đãi tối thượng',discount_pct:50, min_order:3000000, max_discount:5000000, min_tier:'diamond',  expires:'2025-12-31', uses_left:10, is_active:1},
    {coupon_id:6, code:'DALAT2025', desc:'Tuyến HCM–Đà Lạt',              discount_pct:12, min_order:800000,  max_discount:300000,  min_tier:'standard', expires:'2025-06-30', uses_left:40, is_active:1},
  ];

  const bookings=[
    {booking_id:1, customer_id:1, driver_id:1, type_id:1,  rent_type:'with_driver', pickup:'Q1, HCM',          dropoff:'Đà Lạt',         date:'2025-03-10', pickup_date:'2025-03-10', return_date:'2025-03-10', km_est:310, days:null, total_price:1395000,  discount_amount:0,       coupon_code:null,   status:'completed',      note:'Cần ghế trẻ em'},
    {booking_id:2, customer_id:2, driver_id:2, type_id:4,  rent_type:'with_driver', pickup:'Q7, HCM',          dropoff:'Vũng Tàu',       date:'2025-03-18', pickup_date:'2025-03-18', return_date:'2025-03-18', km_est:120, days:null, total_price:456000,   discount_amount:0,       coupon_code:null,   status:'completed',      note:''},
    {booking_id:3, customer_id:1, driver_id:null,type_id:7, rent_type:'self_drive',  pickup:'Q3, HCM',         dropoff:'Q3, HCM',        date:'2025-03-20', pickup_date:'2025-03-20', return_date:'2025-03-23', km_est:null,days:3,    total_price:4500000,  discount_amount:900000,  coupon_code:'GOLD20', status:'completed',      note:'Có bằng lái B1'},
    {booking_id:4, customer_id:3, driver_id:null,type_id:9, rent_type:'self_drive',  pickup:'Hoàn Kiếm, HN',  dropoff:'Hoàn Kiếm, HN', date:'2025-03-22', pickup_date:'2025-03-22', return_date:'2025-03-24', km_est:null,days:2,    total_price:1800000,  discount_amount:0,       coupon_code:null,   status:'confirmed',      note:''},
    {booking_id:5, customer_id:1, driver_id:1, type_id:3,  rent_type:'with_driver', pickup:'Q1, HCM',          dropoff:'Đà Nẵng',        date:'2025-03-25', pickup_date:'2025-03-25', return_date:'2025-03-25', km_est:940, days:null, total_price:5828000,  discount_amount:1165600, coupon_code:'GOLD20', status:'in_progress',    note:'Gia đình 4 người'},
    {booking_id:6, customer_id:4, driver_id:2, type_id:11, rent_type:'with_driver', pickup:'Bình Thạnh, HCM', dropoff:'Vũng Tàu',       date:'2025-03-26', pickup_date:'2025-03-26', return_date:'2025-03-26', km_est:125, days:null, total_price:1500000,  discount_amount:0,       coupon_code:null,   status:'driver_accepted',note:'Xe cao cấp, cần nước'},
    {booking_id:7, customer_id:2, driver_id:null,type_id:5, rent_type:'self_drive',  pickup:'Thủ Đức, HCM',   dropoff:'Thủ Đức, HCM',  date:'2025-03-27', pickup_date:'2025-03-27', return_date:'2025-03-28', km_est:null,days:1,    total_price:1600000,  discount_amount:0,       coupon_code:null,   status:'pending',        note:''},
    {booking_id:8, customer_id:1, driver_id:null,type_id:2, rent_type:'with_driver', pickup:'Q1, HCM',         dropoff:'Phan Thiết',     date:'2025-03-28', pickup_date:'2025-03-28', return_date:'2025-03-28', km_est:200, days:null, total_price:1100000,  discount_amount:0,       coupon_code:null,   status:'pending',        note:''},
    {booking_id:9, customer_id:4, driver_id:null,type_id:13,rent_type:'self_drive',  pickup:'Q10, HCM',        dropoff:'Q10, HCM',      date:'2025-03-29', pickup_date:'2025-03-29', return_date:'2025-04-02', km_est:null,days:4,    total_price:8800000,  discount_amount:2640000, coupon_code:'PLAT30', status:'pending',        note:''},
    {booking_id:10,customer_id:3, driver_id:3,  type_id:4,  rent_type:'with_driver', pickup:'Cầu Giấy, HN',   dropoff:'Hạ Long',       date:'2025-03-30', pickup_date:'2025-03-30', return_date:'2025-03-30', km_est:165, days:null, total_price:627000,   discount_amount:0,       coupon_code:null,   status:'pending',        note:''},
  ];

  const payments=[
    {payment_id:1, booking_id:1, amount:1395000, method:'momo',   status:'paid',    paid_at:'2025-03-10T08:30:00', tx_id:'MM20250310001'},
    {payment_id:2, booking_id:2, amount:456000,  method:'cash',   status:'paid',    paid_at:'2025-03-18T14:00:00', tx_id:null},
    {payment_id:3, booking_id:3, amount:4500000, method:'vnpay',  status:'paid',    paid_at:'2025-03-20T09:00:00', tx_id:'VN20250320003'},
    {payment_id:4, booking_id:4, amount:1800000, method:'momo',   status:'pending', paid_at:null, tx_id:null},
    {payment_id:5, booking_id:5, amount:5828000, method:'zalopay',status:'paid',    paid_at:'2025-03-25T07:00:00', tx_id:'ZP20250325005'},
    {payment_id:6, booking_id:6, amount:1500000, method:'vnpay',  status:'pending', paid_at:null, tx_id:null},
    {payment_id:7, booking_id:7, amount:1600000, method:'momo',   status:'pending', paid_at:null, tx_id:null},
    {payment_id:8, booking_id:8, amount:1100000, method:'cash',   status:'pending', paid_at:null, tx_id:null},
    {payment_id:9, booking_id:9, amount:8800000, method:'bank',   status:'pending', paid_at:null, tx_id:null},
    {payment_id:10,booking_id:10,amount:627000,  method:'momo',   status:'pending', paid_at:null, tx_id:null},
  ];

  const booking_events=[
    {event_id:1, booking_id:1, actor:'system', event:'confirmed',       note:'Đã xác nhận',       timestamp:'2025-03-09T10:00:00'},
    {event_id:2, booking_id:1, actor:'driver', event:'driver_accepted', note:'Tài xế nhận đơn',   timestamp:'2025-03-10T07:00:00'},
    {event_id:3, booking_id:1, actor:'driver', event:'departing',       note:'Xuất phát đến đón', timestamp:'2025-03-10T07:30:00'},
    {event_id:4, booking_id:1, actor:'driver', event:'picked_up',       note:'Đã đón khách',      timestamp:'2025-03-10T08:00:00'},
    {event_id:5, booking_id:1, actor:'driver', event:'in_progress',     note:'Đang di chuyển',    timestamp:'2025-03-10T08:05:00'},
    {event_id:6, booking_id:1, actor:'driver', event:'completed',       note:'Hoàn thành',        timestamp:'2025-03-10T13:45:00'},
    {event_id:7, booking_id:5, actor:'driver', event:'driver_accepted', note:'Tài xế nhận đơn',   timestamp:'2025-03-25T06:30:00'},
    {event_id:8, booking_id:5, actor:'driver', event:'departing',       note:'Xuất phát',         timestamp:'2025-03-25T07:00:00'},
    {event_id:9, booking_id:5, actor:'driver', event:'picked_up',       note:'Đã đón khách',      timestamp:'2025-03-25T07:45:00'},
    {event_id:10,booking_id:5, actor:'driver', event:'in_progress',     note:'Đang trên đường',   timestamp:'2025-03-25T08:00:00'},
    {event_id:11,booking_id:6, actor:'driver', event:'driver_accepted', note:'Tài xế nhận đơn',   timestamp:'2025-03-26T07:00:00'},
  ];

  const reviews=[
    {review_id:1, booking_id:1, customer_id:1, driver_id:1, rating:5, comment:'Tài xế rất chuyên nghiệp, lịch sự. Xe sạch sẽ, điều hòa mát. Sẽ đặt lại!', is_visible:1, created_at:'2025-03-10', replied:'Cảm ơn bạn rất nhiều!'},
    {review_id:2, booking_id:2, customer_id:2, driver_id:2, rating:4, comment:'Chuyến đi tốt, tài xế biết đường và thân thiện.', is_visible:1, created_at:'2025-03-18', replied:null},
    {review_id:3, booking_id:3, customer_id:1, driver_id:null, rating:5, comment:'Xe VinFast VF8 rất thú vị, êm, điện 100%. Giao nhận nhanh gọn.', is_visible:1, created_at:'2025-03-23', replied:null},
  ];

  const notifications=[
    {notif_id:1,  account_id:3, type:'booking', title:'Đơn đặt xe thành công',       body:'Đơn #AC-0005 · HCM→Đà Nẵng đã được xác nhận',              is_read:0, created_at:new Date(Date.now()-3600000).toISOString(),   booking_id:5},
    {notif_id:2,  account_id:3, type:'booking', title:'Tài xế đã nhận đơn',           body:'Nguyễn Văn An đang trên đường đến đón bạn',                 is_read:0, created_at:new Date(Date.now()-7200000).toISOString(),   booking_id:5},
    {notif_id:3,  account_id:3, type:'promo',   title:'Ưu đãi mới cho Gold Member',   body:'Mã GOLD20 – Giảm 20% tất cả chuyến đi trong tháng 3',      is_read:1, created_at:new Date(Date.now()-86400000).toISOString(),  booking_id:null},
    {notif_id:4,  account_id:4, type:'booking', title:'Đơn mới đang chờ bạn',         body:'Q1 HCM → Đà Nẵng · 940km · 5.828.000đ',                    is_read:0, created_at:new Date(Date.now()-1800000).toISOString(),   booking_id:5},
    {notif_id:5,  account_id:4, type:'payment', title:'Thanh toán hoàn tất',           body:'Đơn #AC-0001 – Thu nhập: 977.000đ',                         is_read:1, created_at:new Date(Date.now()-172800000).toISOString(), booking_id:1},
    {notif_id:6,  account_id:3, type:'member',  title:'Chúc mừng! Hạng Gold',         body:'Bạn đã nâng lên hạng Gold Member. Hưởng giảm 10% ngay!',   is_read:1, created_at:new Date(Date.now()-604800000).toISOString(), booking_id:null},
    {notif_id:7,  account_id:5, type:'booking', title:'Đơn của bạn đã hoàn thành',    body:'Đơn #AC-0002 · HCM→Vũng Tàu đã hoàn thành',                is_read:0, created_at:new Date(Date.now()-5400000).toISOString(),   booking_id:2},
    {notif_id:8,  account_id:7, type:'booking', title:'Đơn mới gần khu vực bạn',      body:'Q7 HCM → Vũng Tàu · 120km · 456.000đ',                     is_read:0, created_at:new Date(Date.now()-900000).toISOString(),    booking_id:7},
    {notif_id:9,  account_id:1, type:'system',  title:'Tài xế mới chờ duyệt',         body:'Vũ Thành Long đã nộp đơn đăng ký tài xế',                   is_read:0, created_at:new Date(Date.now()-3000000).toISOString(),   booking_id:null},
    {notif_id:10, account_id:2, type:'system',  title:'Đơn đặt xe mới #AC-0007',      body:'Khách Lê Thị Mai đặt Honda CR-V · Thủ Đức HCM',             is_read:0, created_at:new Date(Date.now()-600000).toISOString(),    booking_id:7},
  ];

  const report_stats={
    revenue_month:148500000, bookings_month:87, customers_month:34,
    active_drivers:2, drivers_active:2, revenue_today:4200000, bookings_today:6,
    cancel_rate:3.2, avg_rating:4.8, total_revenue:1240000000, total_bookings:342,
    completed_trips:298, cancelled_trips:12, total_customers:186, total_drivers:3,
    rent_type_split:{with_driver:68,self_drive:32},
    top_routes:[
      {route:'HCM → Đà Lạt',    count:24, revenue:42000000},
      {route:'HCM → Vũng Tàu',  count:19, revenue:18000000},
      {route:'HCM → Đà Nẵng',   count:12, revenue:38000000},
      {route:'HN → Hạ Long',     count:9,  revenue:22000000},
      {route:'HCM → Phan Thiết', count:8,  revenue:12000000},
    ],
    monthly:[
      {month:'T10',revenue:82000000, bookings:48},
      {month:'T11',revenue:96000000, bookings:55},
      {month:'T12',revenue:124000000,bookings:71},
      {month:'T1', revenue:110000000,bookings:62},
      {month:'T2', revenue:118000000,bookings:68},
      {month:'T3', revenue:148500000,bookings:87},
    ],
  };


  function workflowSteps(rent_type){
    return rent_type==='with_driver'
      ?['pending','confirmed','driver_accepted','departing','picked_up','in_progress','completed']
      :['pending','confirmed','car_dispatched','car_delivered','in_progress','car_returned','completed'];
  }
  function workflowLabels(rent_type){
    return rent_type==='with_driver'
      ?{pending:'Chờ xác nhận',confirmed:'Đã xác nhận',driver_accepted:'Tài xế nhận',departing:'Xuất phát',picked_up:'Đón khách',in_progress:'Đang đi',completed:'Hoàn thành',cancelled:'Đã hủy'}
      :{pending:'Chờ xác nhận',confirmed:'Đã xác nhận',car_dispatched:'Đang giao xe',car_delivered:'Đã giao xe',in_progress:'Đang dùng',car_returned:'Đã trả xe',completed:'Hoàn thành',cancelled:'Đã hủy'};
  }
  function nextStatus(s,rt){const steps=workflowSteps(rt);const i=steps.indexOf(s);return(i===-1||i>=steps.length-1)?null:steps[i+1];}
  function statusLabel(s){
    const m={pending:' Chờ xác nhận',confirmed:' Đã xác nhận',driver_accepted:' Tài xế nhận',departing:' Xuất phát',picked_up:' Đón khách',in_progress:' Đang đi',car_dispatched:' Đang giao',car_delivered:' Đã giao xe',car_returned:' Đã trả',completed:' Hoàn thành',cancelled:' Đã hủy'};
    return m[s]||s;
  }
  function statusColor(s){
    const m={pending:'orange',confirmed:'blue',driver_accepted:'blue',departing:'orange',picked_up:'purple',in_progress:'green',car_dispatched:'orange',car_delivered:'blue',car_returned:'purple',completed:'green',cancelled:'red'};
    return m[s]||'gray';
  }


  function tierName(t){return{standard:'Standard',silver:'Silver',gold:'Gold',platinum:'Platinum',diamond:'Diamond'}[t]||t;}
  function tierColor(t){return member_tiers.find(x=>x.tier===t)?.color||'#6b7280';}
  function roleName(r){return roles.find(x=>x.role_id===r)?.role_name||'—';}
  function newId(t){_id[t]=(_id[t]||0)+1;return _id[t];}

  return {
    roles,accounts,member_tiers,tierOrder,
    customers,drivers,car_brands,car_types,
    coupons,bookings,payments,booking_events,reviews,notifications,
    report_stats,
    workflowSteps,workflowLabels,nextStatus,statusLabel,statusColor,
    tierName,tierColor,roleName,newId,
  };
})();


function doLoginHelper(email,password){
  const acc=DB.accounts.find(a=>(a.email===email.trim()||a.username===email.trim())&&a.password===password);
  if(!acc)return{ok:false,msg:'Email hoặc mật khẩu không đúng'};
  if(!acc.is_active)return{ok:false,msg:'Tài khoản đã bị khóa'};
  const cust=DB.customers.find(c=>c.account_id===acc.account_id);
  const drv=DB.drivers.find(d=>d.account_id===acc.account_id);
  const sess={account_id:acc.account_id,full_name:acc.full_name,email:acc.email,role_id:acc.role_id,username:acc.username,customer_id:cust?.customer_id||null,driver_id:drv?.driver_id||null,member_tier:cust?.member_tier||null};
  Session.set(sess);
  return{ok:true,sess};
}

function avatarInitials(name){return(name||'?').split(' ').map(w=>w[0]).join('').slice(0,2).toUpperCase();}
function renderAvatar(name,size=36,bg='var(--navy)',color='var(--gold)'){
  return`<div style="width:${size}px;height:${size}px;border-radius:50%;background:${bg};color:${color};font-size:${size*.32}px;font-weight:800;display:flex;align-items:center;justify-content:center;flex-shrink:0">${avatarInitials(name)}</div>`;
}


 const sess=Session.ensure('user');
    const customer=DB.customers.find(c=>c.customer_id===sess.customer_id)||DB.customers[0];
    const tier=customer.member_tier;
    const tierIdx=DB.tierOrder.indexOf(tier);
    const tierInfo=DB.member_tiers.find(t=>t.tier===tier);

    document.getElementById('navActions').innerHTML=`
      <button class="nav-notif-btn" onclick="location.href='profile.html'"></button>
      <button class="nav-user-btn" onclick="location.href='profile.html'">
        <div class="nav-avatar">${avatarInitials(sess.full_name)}</div>
        <span class="nav-user-name">${sess.full_name.split(' ').pop()}</span>
        <span class="nav-user-tier tier-${tier}">${DB.tierName(tier)}</span>
      </button>`;

    // ── Current tier banner ──
    const nextTierInfo=tierIdx<DB.member_tiers.length-1?DB.member_tiers[tierIdx+1]:null;
    document.getElementById('currentTierBanner').innerHTML=`
      <div class="ctb-card">
        <div class="ctb-tier" style="color:${tierInfo?.color||'#6b6456'}">${DB.tierName(tier)}</div>
        <div class="ctb-name">${customer.full_name}</div>
        <div class="ctb-stats">
          <span> ${customer.total_trips} chuyến</span>
          <span> ${customer.points} điểm</span>
          <span> ${fmtMoney(customer.total_spent)}</span>
        </div>
        ${nextTierInfo?`<div class="ctb-next">Nâng cấp ${DB.tierName(nextTierInfo.tier)} chỉ với ${fmtMoney(nextTierInfo.fee)}</div>`:'<div class="ctb-next">🎉 Bạn đã đạt hạng cao nhất!</div>'}
      </div>`;


    const tierEmojis={standard:'',silver:'',gold:'',platinum:'',diamond:''};
    document.getElementById('memberCardPreview').innerHTML=`
      <div class="mc-card mc-${tier}">
        <div class="mc-bg-glow"></div>
        <div class="mc-header">
          <div class="mc-tier-label">${tierEmojis[tier]||' '} ${DB.tierName(tier).toUpperCase()} MEMBER</div>
          <div class="mc-logo"> AUTO CARS</div>
        </div>
        <div class="mc-name">${customer.full_name}</div>
        <div class="mc-id">AC · ${DB.tierName(tier).toUpperCase()} · ${String(customer.customer_id).padStart(6,'0')}</div>
        <div class="mc-stats">
          <div><div class="mc-sv">${customer.total_trips}</div><div class="mc-sl">Chuyến đi</div></div>
          <div><div class="mc-sv">${customer.points}</div><div class="mc-sl">Điểm</div></div>
          <div><div class="mc-sv">${tierInfo?.discount||0}%</div><div class="mc-sl">Ưu đãi</div></div>
        </div>
        <div class="mc-stripe"></div>
      </div>`;


    const tierBenefits={
      standard:['Đặt xe 24/7','Theo dõi hành trình','Hỗ trợ cơ bản'],
      silver:  ['Tất cả Standard','Giảm 5% mọi chuyến','Mã giảm tối đa 10%','Ưu tiên hỗ trợ'],
      gold:    ['Tất cả Silver','Giảm 10% mọi chuyến','Mã giảm tối đa 20%','Xe hạng sang ưu tiên','Điểm x2'],
      platinum:['Tất cả Gold','Giảm 15% mọi chuyến','Mã giảm tối đa 30%','Tài xế riêng VIP','Điểm x3','Hủy miễn phí'],
      diamond: ['Tất cả Platinum','Giảm 20% mọi chuyến','Mã giảm tối đa 50%','Concierge 24/7','Điểm x4','Xe cao cấp ưu tiên'],
    };
    document.getElementById('tierGrid').innerHTML=DB.member_tiers.map(t=>{
      const isCurrent=t.tier===tier;
      const isLower=DB.tierOrder.indexOf(t.tier)<=tierIdx;
      const isNext=DB.tierOrder.indexOf(t.tier)===tierIdx+1;
      const emojis={standard:'',silver:'',gold:'',platinum:'',diamond:''};
      return`<div class="tier-card${isCurrent?' tier-card-current':''}" style="--tier-color:${t.color}">
        ${isCurrent?'<div class="tc-current-badge">Hạng hiện tại</div>':''}
        <div class="tc-icon">${emojis[t.tier]||''}</div>
        <div class="tc-name" style="color:${t.color}">${t.label}</div>
        <div class="tc-disc">${t.discount>0?`Giảm ${t.discount}%`:'Không giảm'}</div>
        <div class="tc-fee">${t.fee>0?fmtMoney(t.fee)+'/năm':'Miễn phí'}</div>
        <ul class="tc-benefits">
          ${(tierBenefits[t.tier]||[]).map(b=>`<li>✓ ${b}</li>`).join('')}
        </ul>
        <div class="tc-coupon">Mã giảm tối đa: <strong>${t.max_coupon_pct}%</strong></div>
        ${!isLower&&!isCurrent?`<button class="btn btn-primary btn-full tc-btn" onclick="showUpgrade('${t.tier}')">Nâng cấp ngay</button>`:
          isCurrent?`<button class="btn btn-ghost btn-full tc-btn" disabled>✓ Hạng hiện tại</button>`:
          `<button class="btn btn-ghost btn-full tc-btn" disabled style="opacity:.4">✓ Đã đạt</button>`}
      </div>`;
    }).join('');


    const tierIdxV=DB.tierOrder.indexOf(tier);
    const available=DB.coupons.filter(c=>c.is_active&&DB.tierOrder.indexOf(c.min_tier)<=tierIdxV);
    const locked=DB.coupons.filter(c=>c.is_active&&DB.tierOrder.indexOf(c.min_tier)>tierIdxV);
    document.getElementById('couponsGrid').innerHTML=`
      ${available.length?available.map(c=>`
        <div class="coupon-card" onclick="copyCoupon('${c.code}')">
          <div class="coupon-badge">🎟️/div>
          <div class="coupon-info">
            <div class="coupon-code">${c.code}</div>
            <div class="coupon-desc">${c.desc} · Đơn tối thiểu ${fmtMoney(c.min_order)}</div>
            <div style="font-size:.7rem;color:var(--text3);margin-top:2px">Hết hạn: ${fmtDate(c.expires)} · Còn ${c.uses_left} lượt</div>
          </div>
          <div class="coupon-value">-${c.discount_pct}%</div>
        </div>`).join(''):''}
      ${locked.map(c=>`
        <div class="coupon-card" style="opacity:.5;cursor:not-allowed">
          <div class="coupon-badge" style="background:var(--dark4);color:var(--text3)"></div>
          <div class="coupon-info">
            <div class="coupon-code" style="color:var(--text3)">••••••••</div>
            <div class="coupon-desc">Yêu cầu hạng <strong style="color:${DB.tierColor(c.min_tier)}">${DB.tierName(c.min_tier)}</strong></div>
          </div>
          <div class="coupon-value" style="color:var(--text3)">-${c.discount_pct}%</div>
        </div>`).join('')}`;

    // ── Points panel ──
    const pointsData=[
      {label:'Chuyến HCM→Đà Nẵng (Booking #5)',pts:+814,date:'2025-03-25',type:'earn'},
      {label:'Đổi điểm lấy mã GOLD10',pts:-200,date:'2025-03-15',type:'use'},
      {label:'Chuyến HCM→Vũng Tàu (Booking #3)',pts:+68,date:'2025-03-18',type:'earn'},
      {label:'Nâng cấp hạng Gold',pts:+500,date:'2025-03-01',type:'bonus'},
      {label:'Chuyến HCM→Đà Lạt (Booking #1)',pts:+235,date:'2025-03-10',type:'earn'},
    ];
    document.getElementById('pointsPanel').innerHTML=`
      <div class="pp-header">
        <div class="pp-total"><div class="pp-pts">${customer.points}</div><div class="pp-lbl">Điểm hiện có</div></div>
        <button class="btn btn-outline btn-sm" onclick="redeemPoints()">Đổi điểm</button>
      </div>
      <div class="pp-list">
        ${pointsData.map(p=>`<div class="pp-row">
          <div class="pp-icon ${p.type==='earn'?'earn':p.type==='bonus'?'bonus':'use'}">${p.type==='earn'?'↑':p.type==='bonus'?'':'↓'}</div>
          <div class="pp-info"><div class="pp-label">${p.label}</div><div class="pp-date">${p.date}</div></div>
          <div class="pp-pts-change ${p.pts>0?'pos':'neg'}">${p.pts>0?'+':''}${p.pts}</div>
        </div>`).join('')}
      </div>`;

    // ── Upgrade modal ──
    function showUpgrade(toTier){
      const info=DB.member_tiers.find(t=>t.tier===toTier);
      document.getElementById('upgradeTitle').textContent=`  Nâng cấp lên ${DB.tierName(toTier)}`;
      document.getElementById('upgradeBody').innerHTML=`
        <div style="background:var(--dark3);border-radius:var(--radius);padding:16px;margin-bottom:20px">
          <div style="display:flex;align-items:center;gap:12px;margin-bottom:12px">
            <div style="font-size:2.5rem">${{standard:' ',silver:' ',gold:'',platinum:'',diamond:''}[toTier]}</div>
            <div>
              <div style="font-family:var(--font-d);font-size:1.1rem;color:${info.color}">${DB.tierName(toTier)} Member</div>
              <div style="font-size:.82rem;color:var(--text2);margin-top:4px">Giảm ${info.discount}% · Mã tối đa ${info.max_coupon_pct}%</div>
            </div>
          </div>
          <div style="font-family:var(--font-d);font-size:1.5rem;color:var(--gold);text-align:center;margin:12px 0">${fmtMoney(info.fee)}<span style="font-family:var(--font-b);font-size:.8rem;color:var(--text3)">/năm</span></div>
        </div>
        <div class="form-group">
          <label class="form-label">Phương thức thanh toán</label>
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:8px">
            ${['momo','vnpay','zalopay','bank'].map((m,i)=>`
              <div class="pm-opt${i===0?' selected':''}" onclick="selectUpgradePay(this,'${m}')" style="padding:10px;display:flex;align-items:center;gap:8px;border:2px solid var(--border2);border-radius:var(--radius);cursor:pointer;font-size:.82rem">
                <span>${{momo:'',vnpay:'',zalopay:'',bank:''}[m]}</span>
                <span>${{momo:'MoMo',vnpay:'VNPay',zalopay:'ZaloPay',bank:'Ngân hàng'}[m]}</span>
              </div>`).join('')}
          </div>
        </div>
        <p style="font-size:.78rem;color:var(--text3);margin-bottom:16px">⚠ Phí thành viên không hoàn trả. Hạng thành viên có hiệu lực trong 12 tháng.</p>
        <div class="modal-footer">
          <button class="btn btn-ghost" onclick="closeModal()">Hủy</button>
          <button class="btn btn-primary" onclick="confirmUpgrade('${toTier}',${info.fee})">Thanh toán ${fmtMoney(info.fee)}</button>
        </div>`;
      document.getElementById('upgradeModal').classList.add('open');
    }

    function selectUpgradePay(el,m){document.querySelectorAll('#upgradeBody .pm-opt').forEach(e=>{e.classList.remove('selected');e.style.borderColor='var(--border2)'});el.classList.add('selected');el.style.borderColor='var(--gold)';}

    function confirmUpgrade(toTier,fee){
      customer.member_tier=toTier;
      DB.notifications.push({notif_id:DB.newId('notif'),account_id:sess.account_id,type:'member',title:'Nâng cấp thành viên thành công',body:'Chào mừng bạn lên hạng '+DB.tierName(toTier)+'! Hưởng ưu đãi ngay.',is_read:0,created_at:new Date().toISOString(),booking_id:null});
      closeModal();
      showToast('Nâng cấp thành công','Chúc mừng! Bạn đã lên hạng '+DB.tierName(toTier),'success');
      setTimeout(()=>location.reload(),1500);
    }

    function copyCoupon(code){navigator.clipboard?.writeText(code);showToast('Đã sao chép',`Mã ${code} đã được sao chép`,'success');}
    function redeemPoints(){showToast('Đổi điểm','Tính năng đổi điểm sẽ sớm ra mắt','info');}
    function closeModal(){document.getElementById('upgradeModal').classList.remove('open');}









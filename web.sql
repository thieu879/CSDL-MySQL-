create database Web;
use Web;

create table Categories (
	categories_id int auto_increment primary key,
    categories_name varchar(100) not null unique,
    categories_priority int,
    categories_description text,
    categories_status bit default(1)
);

create table Product(
	product_id char(5) primary key,
    categories_id int not null,
    product_name varchar(100) not null unique,
    product_price float not null check(product_price>0),
    product_title varchar(200) not null,
    product_description text not null,
    product_image text,
    product_status bit default(1),
    foreign key(categories_id) references Categories(categories_id)
);

create table User_status(
	status_id int auto_increment primary key,
    status_name varchar(100),
    status_description text
);

create table Web_user(
	user_id int auto_increment primary key,
    user_name varchar(100) not null unique,
    user_password varchar(100) not null,
    user_avatar text,
    user_email varchar(100) not null unique,
    user_phone varchar(15) not null unique,
    user_address text,
    user_status int not null unique,
    foreign key(user_status) references User_status(status_id)
);

create table Order_(
	order_id int auto_increment primary key,
    user_id int not null,
    user_email varchar(100) not null unique,
    user_phone varchar(15) not null unique,
    user_address text,
    user_created date,
    order_status int not null unique,
    foreign key(user_id) references Web_user(user_id),
    foreign key(order_status) references User_status(status_id)
);

create table Order_Detail(
	product_id char(5) not null,
    order_id int not null,
    Order_price float not null,
    Order_quality float,
    foreign key(product_id) references Product(product_id),
    foreign key(order_id) references Order_(order_id)
);

INSERT INTO Categories (categories_name, categories_priority, categories_description) VALUES
('Điện tử', 1, 'Các sản phẩm điện tử như TV, điện thoại, máy tính'),
('Thời trang', 2, 'Quần áo, phụ kiện thời trang'),
('Sách', 3, 'Sách giáo khoa, sách kỹ năng, tiểu thuyết'),
('Đồ gia dụng', 4, 'Các vật dụng sử dụng trong gia đình'),
('Thực phẩm', 5, 'Đồ ăn, thức uống'),
('Đồ chơi', 6, 'Đồ chơi trẻ em, đồ chơi giáo dục'),
('Thể thao', 7, 'Dụng cụ thể thao, đồ thể thao'),
('Mỹ phẩm', 8, 'Sản phẩm chăm sóc sắc đẹp, trang điểm'),
('Ô tô - Xe máy', 9, 'Phụ tùng xe, xe máy, ô tô'),
('Văn phòng phẩm', 10, 'Bút, sổ, giấy và các sản phẩm văn phòng khác');

INSERT INTO Product (product_id, categories_id, product_name, product_price, product_title, product_description) VALUES
('P0001', 1, 'iPhone 15', 29999.99, 'Điện thoại Apple iPhone 15', 'Điện thoại thông minh cao cấp từ Apple'),
('P0002', 1, 'Samsung TV', 15999.99, 'Smart TV Samsung 55 inch', 'TV thông minh màn hình lớn, độ phân giải 4K'),
('P0003', 2, 'Áo Thun', 199.99, 'Áo thun cotton nam', 'Áo thun chất liệu cotton, thoáng mát'),
('P0004', 2, 'Quần Jean', 399.99, 'Quần jean nữ', 'Quần jean dáng skinny thời trang'),
('P0005', 3, 'Sách Toán', 99.99, 'Sách giáo khoa Toán lớp 10', 'Sách giáo khoa theo chương trình mới'),
('P0006', 4, 'Nồi Cơm Điện', 499.99, 'Nồi cơm điện tử', 'Nồi cơm điện tử đa năng, dễ sử dụng'),
('P0007', 5, 'Bánh Quy', 49.99, 'Bánh quy bơ', 'Bánh quy thơm ngon, giòn rụm'),
('P0008', 6, 'Lego City', 999.99, 'Bộ lắp ráp Lego City', 'Giúp bé phát triển tư duy và sáng tạo'),
('P0009', 7, 'Vợt Cầu Lông', 299.99, 'Vợt cầu lông cao cấp', 'Vợt cầu lông chất liệu siêu nhẹ, bền'),
('P0010', 8, 'Son Môi', 199.99, 'Son môi dưỡng ẩm', 'Son môi màu đỏ tươi, dưỡng ẩm môi cả ngày');

INSERT INTO User_status (status_name, status_description) VALUES
('Active', 'Tài khoản đang hoạt động'),
('Inactive', 'Tài khoản không hoạt động'),
('Pending', 'Tài khoản đang chờ xác nhận'),
('Banned', 'Tài khoản bị cấm'),
('Deleted', 'Tài khoản đã bị xóa'),
('Guest', 'Tài khoản khách chưa đăng ký'),
('Admin', 'Quản trị viên'),
('Moderator', 'Người điều hành'),
('Support', 'Nhân viên hỗ trợ'),
('VIP', 'Khách hàng VIP');

INSERT INTO Web_user (user_name, user_password, user_avatar, user_email, user_phone, user_address, user_status) VALUES
('nguyenvana', '123456', NULL, 'nguyenvana@gmail.com', '0912345678', 'Hà Nội', 1),
('tranthib', '123456', NULL, 'tranthib@gmail.com', '0987654321', 'Hồ Chí Minh', 2),
('phamvanh', '123456', NULL, 'phamvanh@gmail.com', '0923456789', 'Đà Nẵng', 3),
('lediemc', '123456', NULL, 'lediemc@gmail.com', '0934567890', 'Cần Thơ', 1),
('dinhquand', '123456', NULL, 'dinhquand@gmail.com', '0945678901', 'Hải Phòng', 4),
('lethiepe', '123456', NULL, 'lethiepe@gmail.com', '0956789012', 'Nha Trang', 5),
('nguyenthif', '123456', NULL, 'nguyenthif@gmail.com', '0967890123', 'Huế', 6),
('nguyenminhg', '123456', NULL, 'nguyenminhg@gmail.com', '0978901234', 'Bình Dương', 7),
('vothih', '123456', NULL, 'vothih@gmail.com', '0989012345', 'Quảng Nam', 8),
('dangthih', '123456', NULL, 'dangthih@gmail.com', '0990123456', 'Bắc Ninh', 9);

INSERT INTO Order_ (user_id, user_email, user_phone, user_address, user_created, order_status) VALUES
(1, 'nguyenvana@gmail.com', '0912345678', 'Hà Nội', '2024-02-01', 1),
(2, 'tranthib@gmail.com', '0987654321', 'Hồ Chí Minh', '2024-02-02', 2),
(3, 'phamvanh@gmail.com', '0923456789', 'Đà Nẵng', '2024-02-03', 3),
(4, 'lediemc@gmail.com', '0934567890', 'Cần Thơ', '2024-02-04', 1),
(5, 'dinhquand@gmail.com', '0945678901', 'Hải Phòng', '2024-02-05', 4),
(6, 'lethiepe@gmail.com', '0956789012', 'Nha Trang', '2024-02-06', 5),
(7, 'nguyenthif@gmail.com', '0967890123', 'Huế', '2024-02-07', 6),
(8, 'nguyenminhg@gmail.com', '0978901234', 'Bình Dương', '2024-02-08', 7),
(9, 'vothih@gmail.com', '0989012345', 'Quảng Nam', '2024-02-09', 8),
(10, 'dangthih@gmail.com', '0990123456', 'Bắc Ninh', '2024-02-10', 9);

INSERT INTO Order_Detail (product_id, order_id, Order_price) VALUES
('P0001', 1, 29999.99),
('P0002', 2, 15999.99),
('P0003', 3, 199.99),
('P0004', 4, 399.99),
('P0005', 5, 99.99),
('P0006', 6, 499.99),
('P0007', 7, 49.99),
('P0008', 8, 999.99),
('P0009', 9, 299.99),
('P0010', 10, 199.99);



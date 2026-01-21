create database final_test;
use final_test;

-- Tạo bằng 
create table Students(
	student_id int auto_increment primary key,
    student_name varchar(255), 
    email varchar(255) unique not null,
    phone varchar(255) unique not null,
    balanced decimal(10,2) default(0) check(balanced > 0)
);

create table Student_Profiles(
	profile_id int primary key,
    student_id int not null,
    address varchar(255) not null,
    education_level varchar(255) not null,
    bio varchar(255),
    foreign key(student_id) references
    Students(student_id)
);

create table Courses(
	course_id int auto_increment primary key,
    course_name varchar(255) not null,
    price decimal(10,2) check(price >= 0) not null,
    duration int not null,
    course_status enum('Active', 'Inactive')
);

create table Enrollments(
	enroll_id int primary key,
    student_id int not null,
    course_id int not null,
    enroll_day date default(date(now())),
    status enum('Active', 'Pending', 'Cancelled'),
    foreign key(student_id) references
    Students(student_id),
    foreign key(course_id) references
    Courses(course_id)
);

create table Payments(
	payment_id int primary key,
    enroll_id int not null,
    amount decimal(10,2) check(amount >= 0),
    payment_date date default(date(now())),
    payment_method varchar(255)
);

insert into Students(student_name, email, phone, balanced) values
('Nguyen Van A', 'anv@gmail.com', '901111111', 5000000),
('Tran Thi B', 'btt@yahoo.com', '902222222', 1000000),
('Le Van C', 'cle@gmail.com', '903333333', 1200000),
('Pham Minh D', 'dpham@hotmail.com', '904444444', 200000),
('Hoang Anh E', 'ehoang@gmail.com', '905555555', 10000000);

insert into Student_Profiles(profile_id,student_id, address, education_level, bio) values
(101, 1, 'Ha Noi', 'University', 'Yeu thich lap trinh'),
(102, 2, 'Da Nang', 'High School', 'Muon hoc thiet ke'),
(103, 3, 'HCM', 'Master', 'Chuyen gia du lieu'),
(104, 4, 'Can Tho', 'College', 'Nguoi moi bat dau'),
(105, 5, 'Hai Phong', 'PhD', 'Nghien cuu sinh');

insert into Courses(course_name, price, duration, course_status) values
('Fullstack Java', 2000000, 40, 'Active'),
('Python for Data Science', 1500000, 30, 'Active'),
('ReactJS Advanced', 1200000, 20, 'Inactive'),
('Graphic Design Basic', 800000, 15, 'Active'),
('MySQL Database Master', 500000, 10, 'Active');

insert into Enrollments(enroll_id, student_id, course_id, enroll_day, status) values
(1001, 1, 1, '2023-10-15', 'Active'),
(1002, 2, 4, '2023-11-20', 'Active'),
(1003, 1, 2, '2024-1-5', 'Pending'),
(1004, 3, 5, '2023-12-12', 'Cancelled'),
(1005, 4, 1, '2024-1-18', 'Active');

insert into Payments(payment_id, enroll_id, amount, payment_date, payment_method)values
(501, 1001, 2000000, '2023-10-15', 'Banking'),
(502, 1002, 800000, '2023-11-20', 'Credit Card'),
(503, 1005, 2000000, '2024-1-18', 'Wallet'),
(504, 1004, 500000, '2023-12-12', 'Banking'),
(505, 1001, 0, '2023-10-16', 'Voucher');

--   - Viết câu lệnh UPDATE để giảm giá 10% cho tất cả các khóa học (Courses) đang có trạng thái là 'Inactive' (để khuyến khích đăng ký lại).
update courses set price = price - price * 10 / 100 where course_status =  'Inactive';
--   - Viết câu lệnh DELETE để xóa các bản ghi trong bảng Đăng ký (Enrollments) có trạng thái là 'Cancelled' và được tạo trước ngày 01/01/2024 .
delete from Enrollments where status = 'Cancelled' and datediff(enroll_day, '2024-01-01') < 0;

-- PHẦN 2: TRUY VẤN DỮ LIỆU CƠ BẢN 

-- - Câu 1 (5đ): Lấy danh sách các khóa học (course_name, price, duration) có giá lớn hơn 1.000.000 VNĐ và thời lượng trên 30 giờ.
select course_name, price, duration from Courses where price > 1000000 and duration > 30;

-- - Câu 2 (5đ): Tìm thông tin học viên (full_name, email) có email thuộc tên miền '@gmail.com' và số dư tài khoản (balance) lớn hơn 500.000 VNĐ.
select student_name, email from Students where email like '%@gmail.com%' and balanced > 500000;

-- - Câu 3 (5đ): Hiển thị Top 3 khóa học có giá cao nhất, sắp xếp giảm dần. Sử dụng LIMIT và OFFSET để bỏ qua khóa học đắt nhất (lấy từ khóa thứ 2 đến thứ 4).
select * from Courses order by price desc limit 3 offset 1;

-- PHẦN 3: TRUY VẤN DỮ LIỆU NÂNG CAO

-- - Câu 1 (6đ): Viết câu lệnh truy vấn để hiển thị các thông tin gồm: Tên học viên, Tên khóa học, Ngày đăng ký và Trạng thái đăng ký. Chỉ lấy các bản ghi có trạng thái là 'Active'.
select s.student_name, c.course_name, enroll_day, status
from Enrollments e 
join Students s on s.student_id = e.student_id
join Courses c on c.course_id = e.course_id
where status = 'Active';

-- - Câu 2 (7đ): Tính tổng doanh thu (amount) của từng phương thức thanh toán (payment_method). Chỉ hiển thị phương thức nào có tổng doanh thu trên 2.000.000 VNĐ.
select sum(amount), payment_method from Payments
group by payment_method
having sum(amount) > 2000000;

-- - Câu 3 (7đ): Tìm ra thông tin khóa học (course_name) chưa từng có học viên nào đăng ký (không tồn tại course_id trong bảng Enrollments).
select course_name 
from Courses 
where course_id not in (select course_id from Enrollments);

-- PHẦN 4: INDEX VÀ VIEW

-- - Câu 1 (5đ): Tạo một Index tên là idx_student_email trên cột email của bảng Students để tối ưu hóa việc tìm kiếm học viên theo địa chỉ thư điện tử.
create index idx_student_email on Students(email);

-- - Câu 2 (5đ): Tạo một View tên là vw_student_enrollments hiển thị: Mã học viên, Tên học viên, Tổng số khóa học đã đăng ký (chỉ tính trạng thái 'Active') và Tổng số tiền đã thanh toán.
create or replace view vw_student_enrollments as
select e.student_id, s.student_name, count(e.student_id), sum(p.amount)
from Enrollments e
join Students s on s.student_id = e.student_id
join Payments p on p.enroll_id = e.enroll_id
where e.status = 'Active'
group by e.student_id;


-- PHẦN 5: TRIGGER

-- - Câu 1 (5đ): Viết Trigger trg_after_payment_insert. Khi một bản ghi mới được thêm vào bảng Payments, hãy tự động cập nhật trạng thái (status) của bản ghi tương ứng trong bảng Enrollments thành 'Active'.
delimiter $$
create trigger trg_after_payment_insert 
after insert on Payments
for each row
begin
	update Enrollments set status = 'Active'
    where enroll_id = new.enroll_id
end ;


-- - Câu 2 (5đ): Viết Trigger trg_prevent_duplicate_enrollment. Trước khi INSERT vào bảng Enrollments, kiểm tra xem học viên đó đã đăng ký khóa học này chưa (kể cả trạng thái 'Pending' hay 'Active'). Nếu đã có, hãy hủy thao tác và báo lỗi: "Học viên đã đăng ký khóa học này rồi!".
create trigger trg_prevent_duplicate_enrollment
before insert on Enrollments
for each row
begin
	if(new.student_id = old.student_id) then
    signal sqlstate '45000'
    set message_text = 'Học viên đã đăng ký khóa học này rồi!'
    end if;
end;

-- PHẦN 6: STORED PROCEDURE

-- - Câu 1 (10đ): Viết Procedure sp_get_course_revenue nhận vào Mã khóa học (p_course_id). Procedure trả về tham số OUT p_total_revenue là tổng số tiền thu được từ khóa học đó (dựa trên bảng Payments và Enrollments). Nếu khóa học không tồn tại, trả về 0.

delimiter $$
	create procedure sp_get_course_revenue (p_course_id int, out p_total_revenue decimal(10,2))
    begin
    if(p_course_id not in (select course_id from enrollments)) then set p_total_revenue = 0; end if;
		select sum(p.amount)
        from Enrollments e
        join Payments p on p.enroll_id = e.enroll_id
        where e.course_id = p_course_id;
        set p_total_revenue = sum(p.amount);
    end;
call sp_get_course_revenue(1, @kq);


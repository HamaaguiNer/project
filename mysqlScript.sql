-- 1. Database үүсгэх
CREATE DATABASE gym_db;
USE gym_db;

-- 2. Гишүүдийн хүснэгт
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    join_date DATE NOT NULL
);

-- 3. Дасгалжуулагчдын хүснэгт
CREATE TABLE trainers (
    trainer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- 4. Захиалга/бүртгэлийн хүснэгт
CREATE TABLE subscriptions (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    trainer_id INT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    type VARCHAR(50) NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id)
);

-- 5. Ирцийн хүснэгт
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    checkin_date DATE NOT NULL,
    checkin_time TIME NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- 6. Members хүснэгтэд жишээ өгөгдөл
INSERT INTO members (first_name, last_name, phone, email, join_date)
VALUES
('Bat', 'Erdene', '99112233', 'bat@example.com', '2026-01-10'),
('Anu', 'Suren', '88112233', 'anu@example.com', '2026-02-01'),
('Bold', 'Gan', '77112233', 'bold@example.com', '2026-03-05');

-- 7. Trainers хүснэгтэд жишээ өгөгдөл
INSERT INTO trainers (first_name, last_name, specialization, phone, email)
VALUES
('Tuvshin', 'Bayar', 'Yoga', '99114455', 'tuvshin@example.com'),
('Naraa', 'Enkh', 'Weight Training', '88114455', 'naraa@example.com');

-- 8. Subscriptions хүснэгтэд жишээ өгөгдөл
INSERT INTO subscriptions (member_id, trainer_id, start_date, end_date, type)
VALUES
(1, 1, '2026-01-10', '2026-04-10', 'Monthly'),
(2, 2, '2026-02-01', '2026-05-01', 'Quarterly'),
(3, NULL, '2026-03-05', '2026-04-05', 'Trial');

-- 9. Attendance хүснэгтэд жишээ өгөгдөл
INSERT INTO attendance (member_id, checkin_date, checkin_time)
VALUES
(1, '2026-03-20', '08:30:00'),
(2, '2026-03-21', '09:00:00'),
(3, '2026-03-22', '18:15:00');

-- Query 1: Гишүүдийн болон дасгалжуулагчийн мэдээллийг JOIN ашиглан харуулах
SELECT 
    m.member_id,
    m.first_name AS member_first,
    m.last_name AS member_last,
    t.trainer_id,
    t.first_name AS trainer_first,
    t.last_name AS trainer_last,
    s.subscription_id,
    s.type,
    s.start_date,
    s.end_date
FROM subscriptions s
JOIN members m ON s.member_id = m.member_id
LEFT JOIN trainers t ON s.trainer_id = t.trainer_id;

-- Query 2: Дасгалжуулагч бүрийн гишүүдийн тоог GROUP BY ашиглан гаргах
SELECT 
    t.trainer_id,
    t.first_name,
    t.last_name,
    COUNT(s.member_id) AS member_count
FROM trainers t
LEFT JOIN subscriptions s ON t.trainer_id = s.trainer_id
GROUP BY t.trainer_id, t.first_name, t.last_name;

-- Query 3: Хамгийн олон гишүүнтэй дасгалжуулагчийг гаргах
SELECT 
    t.trainer_id,
    t.first_name,
    t.last_name,
    COUNT(s.member_id) AS member_count
FROM trainers t
JOIN subscriptions s ON t.trainer_id = s.trainer_id
GROUP BY t.trainer_id, t.first_name, t.last_name
ORDER BY member_count DESC
LIMIT 1;

-- Query 4: Ирц >= 2 удаа хийсэн гишүүдийг HAVING ашиглан гаргах
SELECT 
    m.member_id,
    m.first_name,
    m.last_name,
    COUNT(a.attendance_id) AS attendance_count
FROM members m
JOIN attendance a ON m.member_id = a.member_id
GROUP BY m.member_id, m.first_name, m.last_name
HAVING COUNT(a.attendance_id) >= 2;

-- Admin хэрэглэгч үүсгэх ба эрх олгох
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'AdminPass123!';
GRANT ALL PRIVILEGES ON gym_db.* TO 'admin_user'@'localhost';

-- Report хэрэглэгч үүсгэх ба зөвхөн SELECT эрх олгох
CREATE USER 'report_user'@'localhost' IDENTIFIED BY 'ReportPass123!';
GRANT SELECT ON gym_db.* TO 'report_user'@'localhost';

-- Эрхүүдийг шинэчлэх
FLUSH PRIVILEGES;

-- Хэрэглэгчдийн эрхийг шалгах
SHOW GRANTS FOR 'admin_user'@'localhost';
SHOW GRANTS FOR 'report_user'@'localhost';

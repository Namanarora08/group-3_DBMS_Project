-- =========================================
-- SCHEMA: TABLES + CONSTRAINTS + INDEXES
-- =========================================

-- DROP TABLES (order matters due to FK)
IF OBJECT_ID('users', 'U') IS NOT NULL DROP TABLE users;
IF OBJECT_ID('visitors', 'U') IS NOT NULL DROP TABLE visitors;
IF OBJECT_ID('complaints', 'U') IS NOT NULL DROP TABLE complaints;
IF OBJECT_ID('fees', 'U') IS NOT NULL DROP TABLE fees;
IF OBJECT_ID('students', 'U') IS NOT NULL DROP TABLE students;
IF OBJECT_ID('staff', 'U') IS NOT NULL DROP TABLE staff;
IF OBJECT_ID('rooms', 'U') IS NOT NULL DROP TABLE rooms;

-- ROOMS
CREATE TABLE rooms (
    room_no VARCHAR(10) PRIMARY KEY,
    capacity INT NOT NULL,
    status VARCHAR(20) DEFAULT 'Vacant' NOT NULL,
    floor INT NOT NULL,
    room_type VARCHAR(20) NOT NULL
);

-- STAFF
CREATE TABLE staff (
    staff_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL,
    contact_no VARCHAR(15) NOT NULL,
    salary DECIMAL(10,2),
    join_date DATE DEFAULT GETDATE() NOT NULL
);

-- STUDENTS
CREATE TABLE students (
    roll_no VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    room_no VARCHAR(10),
    year VARCHAR(10) NOT NULL,
    contact_no VARCHAR(15),
    email VARCHAR(100),
    date_joined DATE DEFAULT GETDATE() NOT NULL,
    status VARCHAR(20) DEFAULT 'Active' NOT NULL,
    FOREIGN KEY (room_no) REFERENCES rooms(room_no)
);

-- FEES
CREATE TABLE fees (
    fee_id INT IDENTITY(1,1) PRIMARY KEY,
    roll_no VARCHAR(20) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    due_date DATE NOT NULL,
    payment_date DATE,
    status VARCHAR(20) DEFAULT 'Unpaid',
    receipt_number VARCHAR(50),
    FOREIGN KEY (roll_no) REFERENCES students(roll_no)
);

-- COMPLAINTS
CREATE TABLE complaints (
    complaint_id INT IDENTITY(1,1) PRIMARY KEY,
    roll_no VARCHAR(20) NOT NULL,
    complaint VARCHAR(4000),
    type VARCHAR(30),
    severity VARCHAR(20) DEFAULT 'Medium',
    status VARCHAR(20) DEFAULT 'Pending',
    date_logged DATETIME DEFAULT GETDATE(),
    date_resolved DATETIME,
    resolution_notes VARCHAR(4000),
    FOREIGN KEY (roll_no) REFERENCES students(roll_no)
);

-- VISITORS
CREATE TABLE visitors (
    visitor_id INT IDENTITY(1,1) PRIMARY KEY,
    roll_no VARCHAR(20),
    visitor_name VARCHAR(100),
    visit_date DATE DEFAULT GETDATE(),
    purpose VARCHAR(4000),
    check_in_time DATETIME,
    check_out_time DATETIME,
    FOREIGN KEY (roll_no) REFERENCES students(roll_no)
);

-- USERS
CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    password_hash VARCHAR(100),
    role VARCHAR(20) DEFAULT 'Student',
    roll_no VARCHAR(20),
    staff_id INT,
    last_login DATETIME,
    account_status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (roll_no) REFERENCES students(roll_no),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- INDEXES
CREATE INDEX idx_students_room ON students(room_no);
CREATE INDEX idx_fees_roll_status ON fees(roll_no, status);
CREATE INDEX idx_complaints_status ON complaints(status);

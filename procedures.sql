-- =========================================
-- PROCEDURAL: DATA + QUERIES + LOGIC
-- =========================================

-- INSERT DATA
INSERT INTO rooms VALUES
('A102',2,'Vacant',1,'Double'),
('A118',1,'Vacant',1,'Single'),
('B201',4,'Vacant',2,'Quad'),
('C302',2,'Vacant',3,'Double'),
('C304',2,'Vacant',3,'Double');

INSERT INTO staff (name,position,contact_no,salary)
VALUES
('Harpreet Singh','Warden','09876543210',45000),
('Meena Devi','Caretaker','09765432109',28000);

INSERT INTO students (roll_no,name,department,room_no,year)
VALUES
('102303001','Arunima','ECE','A118','2nd'),
('102303002','Saurabh','EE','A102','2nd');

INSERT INTO fees (roll_no,amount,due_date,status)
VALUES
('102303001',50000,'2025-06-30','Paid'),
('102303002',50000,'2025-06-30','Unpaid');

-- =========================================
-- QUERIES
-- =========================================

SELECT * FROM students;

SELECT * FROM rooms WHERE status='Vacant';

SELECT f.*, s.name 
FROM fees f
JOIN students s ON f.roll_no=s.roll_no
WHERE f.status!='Paid';

-- =========================================
-- TRIGGERS
-- =========================================

GO
CREATE TRIGGER tr_check_room
ON students
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN rooms r ON i.room_no = r.room_no
        WHERE r.status != 'Vacant'
    )
    BEGIN
        RAISERROR('Room not vacant',16,1);
        ROLLBACK;
        RETURN;
    END

    INSERT INTO students
    SELECT * FROM inserted;
END;
GO

GO
CREATE TRIGGER tr_update_room
ON students
AFTER INSERT, DELETE
AS
BEGIN
    UPDATE rooms
    SET status = 'Occupied'
    WHERE room_no IN (SELECT room_no FROM inserted);

    UPDATE rooms
    SET status = 'Vacant'
    WHERE room_no IN (SELECT room_no FROM deleted);
END;
GO

-- =========================================
-- STORED PROCEDURES
-- =========================================

GO
CREATE PROCEDURE get_vacant_rooms
AS
BEGIN
    SELECT * FROM rooms WHERE status='Vacant';
END;
GO

GO
CREATE PROCEDURE get_pending_fees
AS
BEGIN
    SELECT f.*, s.name
    FROM fees f
    JOIN students s ON f.roll_no=s.roll_no
    WHERE f.status!='Paid';
END;
GO

GO
CREATE PROCEDURE complaint_summary
AS
BEGIN
    SELECT status, COUNT(*) total
    FROM complaints
    GROUP BY status;
END;
GO

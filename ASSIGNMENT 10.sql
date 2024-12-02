USE entri_d42;
CREATE TABLE Teachers (
		Id INT AUTO_INCREMENT PRIMARY KEY,
        Name VARCHAR(50) NOT NULL,
        Subject VARCHAR(50) NOT NULL,
        Experience INT NOT NULL,
        Salary DECIMAL(10,2) NOT NULL
        );
INSERT INTO Teachers(Name,Subject,Experience,Salary) VALUES 
       ('John vargese','Mathematics',5,60000),
       ('Mary curie','Physics',7,62000),
       ('Lion smith','Chemistry',3,45000),
       ('Emily davis','Biology',10,68000),
       ('Elizabeth deyn','English',2,40000),
       ('Laura white','History',4,50000),
       ('Christopher luis','Geography',12,75000),
       ('William johns','Computer science',8,65000);
       
-- creating the before_insert_teacher_trigger
DELIMITER //
CREATE TRIGGER before_insert_teacher
BEFORE INSERT ON Teachers
FOR EACH ROW
BEGIN
IF NEW.Salary <0 THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Salary can not be negative.';
END IF;
END //
DELIMITER ;

INSERT INTO Teachers VALUES (9,'Adam john','Mathematics',4,-10000);

-- create teacher_log table and after_insert_teacher trigger

CREATE TABLE Teacher_log(
            log_id INT AUTO_INCREMENT PRIMARY KEY,
            Teacher_id INT NOT NULL,
            Action VARCHAR(50) NOT NULL,
            Action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
DELIMITER //
CREATE TRIGGER after_insert_teacher
AFTER INSERT ON Teachers
FOR EACH ROW
BEGIN
INSERT INTO Teacher_log(Teacher_id,Action) VALUES (NEW.id,'Inserted');
END //
DELIMITER ;

-- create the before_delete_teacher trigger
DELIMITER //
CREATE TRIGGER before_delete_teacher
BEFORE DELETE ON Teachers
FOR EACH ROW
BEGIN
IF OLD.Experience >10 THEN 
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Can not delete a teacher with more than 10 years of experience';
END IF;
END //
DELIMITER ;

set sql_safe_updates = 0;
DELETE FROM Teachers WHERE name='Christopher luis';

-- create after_delete_teacher trigger
DELIMITER //
CREATE TRIGGER after_delete_teacher
AFTER DELETE ON Teachers
FOR EACH ROW
BEGIN
INSERT INTO Teacher_log(teacher.id,action) VALUES (OLD.id,'Deleted');
END //
DELIMITER ;








   
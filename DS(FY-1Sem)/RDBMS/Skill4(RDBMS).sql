use  prepartion;
# 1)

create table student1(PRN int primary key, name varchar(30), class varchar(10), s1 int, s2 int, s3 int);
# 2) 

INSERT INTO student1 (PRN, name, class, s1, s2, s3) VALUES
(101, 'Alice', '10A', 85, 78, 92),
(102, 'Bob', '10A', 88, 76, 81),
(103, 'Charlie', '10B', 90, 85, 87),
(104, 'Diana', '10B', 75, 80, 69),
(105, 'Eve', '10A', 82, 91, 88);

SELECT * FROM student1;

# 3)

DELIMITER &&
CREATE PROCEDURE GetTotalMarksByPRN(IN studentPRN INT)
BEGIN
    DECLARE TotalMarks INT;
    SELECT (s1 + s2 + s3) INTO TotalMarks FROM student1
    WHERE PRN = studentPRN;
    SELECT TotalMarks AS TotalMarks;
END &&
DELIMITER ;

CALL GetTotalMarksByPRN(101);

# 4)

DELIMITER &&
CREATE PROCEDURE GetStudentDetailsByName(IN studentName VARCHAR(50), OUT studentDetails VARCHAR(200))
BEGIN
    SELECT CONCAT('PRN:', PRN, ', Name:', name, ', Class:', class, ', Marks:', s1, ',', s2, ',', s3)
    INTO studentDetails
    FROM student1
    WHERE name = studentName;
END &&
DELIMITER ;

call company.GetStudentDetailsByName('Alice', @studentDetails);
select @studentDetails;

# 5)

DELIMITER &&
CREATE PROCEDURE GetStudentDetailsWithMsgSum(IN studentName VARCHAR(50), OUT studentDetails VARCHAR(200))
BEGIN
    -- Fetch student details with sum of marks and store in the output variable
    SELECT CONCAT('PRN:', PRN, ', Name:', name, ', Class:', class, ', Marks:', s1, ',', s2, ',', s3, ', Total Marks:', s1 + s2 + s3)
    INTO studentDetails
    FROM student1
    WHERE name = studentName;

    -- Confirmation message
    SELECT CONCAT('Details printed for student: ', studentName) AS message;
END &&
DELIMITER ;

CALL GetStudentDetailsWithMsgAndSum('Bob', @studentDetails);
SELECT @studentDetails;


# 6) 

DELIMITER $$

CREATE FUNCTION GetPercentageByPRN(studentPRN INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE totalMarks INT;
    DECLARE percentage DECIMAL(5,2);

    -- Calculate the total marks
    SELECT (s1 + s2 + s3) INTO totalMarks
    FROM student1
    WHERE PRN = studentPRN;

    -- Calculate the percentage (assuming maximum marks for each subject is 100)
    SET percentage = (totalMarks / 300) * 100;

    -- Return the calculated percentage
    RETURN percentage;
END $$

DELIMITER ;

SELECT GetPercentageByPRN(101);

# 7)

DELIMITER $$

CREATE FUNCTION GetClasswiseResult(ClassName VARCHAR(10))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255);
    
    -- Concatenate the results for all students in the given class
    SELECT GROUP_CONCAT(CONCAT('PRN:', PRN, ', Name:', Name, ', TotalMarks:', (s1 + s2 + s3)) SEPARATOR ': ') 
    INTO result
    FROM student1  -- Use the correct table name if it's student1
    WHERE Class = ClassName;
    
    -- Return the concatenated result
    RETURN result;
END $$

DELIMITER ;

-- Create Database
CREATE DATABASE LibraryDB;
USE LibraryDB;

-- Members Table
CREATE TABLE Members (
    memberID INT AUTO_INCREMENT PRIMARY KEY,
    fullName VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) UNIQUE,
    joinDate DATE NOT NULL
);

-- Books Table
CREATE TABLE Books (
    bookID INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    publishedYear YEAR,
    availableCopies INT NOT NULL
);

-- Borrowings Table
CREATE TABLE Borrowings (
    borrowID INT AUTO_INCREMENT PRIMARY KEY,
    memberID INT NOT NULL,
    bookID INT NOT NULL,
    borrowDate DATE NOT NULL,
    returnDate DATE,
    CONSTRAINT fk_borrow_member FOREIGN KEY (memberID) REFERENCES Members(memberID),
    CONSTRAINT fk_borrow_book FOREIGN KEY (bookID) REFERENCES Books(bookID)
);

-- Reservations Table
CREATE TABLE Reservations (
    reservationID INT AUTO_INCREMENT PRIMARY KEY,
    memberID INT NOT NULL,
    bookID INT NOT NULL,
    reservationDate DATE NOT NULL,
    status ENUM('Active','Completed','Cancelled') DEFAULT 'Active',
    CONSTRAINT fk_reserve_member FOREIGN KEY (memberID) REFERENCES Members(memberID),
    CONSTRAINT fk_reserve_book FOREIGN KEY (bookID) REFERENCES Books(bookID)
);

-- Librarians Table
CREATE TABLE Librarians (
    librarianID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hireDate DATE NOT NULL
);

-- BookAssignments Table
CREATE TABLE BookAssignments (
    assignmentID INT AUTO_INCREMENT PRIMARY KEY,
    librarianID INT NOT NULL,
    bookID INT NOT NULL,
    CONSTRAINT fk_assign_librarian FOREIGN KEY (librarianID) REFERENCES Librarians(librarianID),
    CONSTRAINT fk_assign_book FOREIGN KEY (bookID) REFERENCES Books(bookID)
);


-- INSERT SAMPLE DATA


-- Insert Members
INSERT INTO Members (fullName, email, phone, joinDate) VALUES
('John Doe', 'john.doe@email.com', '0712345678', '2023-01-15'),
('Jane Smith', 'jane.smith@email.com', '0723456789', '2023-02-10'),
('Emily Clark', 'emily.clark@email.com', '0734567890', '2023-03-05');

-- Insert Books
INSERT INTO Books (title, author, isbn, publishedYear, availableCopies) VALUES
('Database Systems', 'Elmasri Navathe', 'ISBN111', 2020, 5),
('Clean Code', 'Robert Martin', 'ISBN112', 2019, 3),
('Artificial Intelligence', 'Stuart Russell', 'ISBN113', 2021, 2),
('Web Development Basics', 'Jon Duckett', 'ISBN114', 2022, 4);

-- Insert Borrowings
INSERT INTO Borrowings (memberID, bookID, borrowDate, returnDate) VALUES
(1, 1, '2024-10-01', NULL),
(2, 2, '2024-09-15', '2024-09-30'),
(2, 3, '2024-10-05', NULL);

-- Insert Reservations
INSERT INTO Reservations (memberID, bookID, reservationDate, status) VALUES
(3, 4, '2024-10-02', 'Active'),
(1, 3, '2024-10-04', 'Cancelled');

-- Insert Librarians
INSERT INTO Librarians (name, email, hireDate) VALUES
('Alice Johnson', 'alice.j@email.com', '2022-06-01'),
('Bob Williams', 'bob.w@email.com', '2023-01-20');

-- Assign Books to Librarians
INSERT INTO BookAssignments (librarianID, bookID) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4);


-- SAMPLE QUERIES (Demonstrating Relationships)


-- 1. List all borrowed books with the member name and borrow date
SELECT m.fullName, b.title, br.borrowDate, br.returnDate
FROM Borrowings br
JOIN Members m ON br.memberID = m.memberID
JOIN Books b ON br.bookID = b.bookID;

-- 2. Show all reservations with member and book details
SELECT m.fullName, b.title, r.reservationDate, r.status
FROM Reservations r
JOIN Members m ON r.memberID = m.memberID
JOIN Books b ON r.bookID = b.bookID;

-- 3. Which librarian manages which books?
SELECT l.name AS Librarian, b.title AS Book
FROM BookAssignments ba
JOIN Librarians l ON ba.librarianID = l.librarianID
JOIN Books b ON ba.bookID = b.bookID;

-- 4. Find members who have not returned their borrowed books
SELECT m.fullName, b.title, br.borrowDate
FROM Borrowings br
JOIN Members m ON br.memberID = m.memberID
JOIN Books b ON br.bookID = b.bookID
WHERE br.returnDate IS NULL;

-- 5. Count how many books each member has borrowed
SELECT m.fullName, COUNT(br.bookID) AS TotalBorrowed
FROM Members m
LEFT JOIN Borrowings br ON m.memberID = br.memberID
GROUP BY m.fullName;

-- ERD (Entity Relationship Diagram)
-- Members (1) ------< Borrowings >------ (1) Books
 --       \                                /
  --       \--< Reservations >------------/

-- One-to-Many: One member can borrow many books.--
-- One-to-Many: One member can make many reservations.--
-- Many-to-Many: Books and Members through Borrowings/Reservations.--
-- One-to-One: Each book has one unique detail (like ISBN).--


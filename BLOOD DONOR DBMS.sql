-- ================================================================
-- Student Blood Bank Management System
-- Section A8 | Database Lab Project
-- Project 1 (Enhanced)
-- ================================================================

CREATE DATABASE IF NOT EXISTS BloodBank_Project1;
USE BloodBank_Project1;

-- ----------------------------------------------------------------
-- CREATE TABLES
-- ----------------------------------------------------------------

CREATE TABLE Donor (
    donor_id           INT          PRIMARY KEY AUTO_INCREMENT,
    full_name          VARCHAR(100) NOT NULL,
    blood_group        VARCHAR(5)   NOT NULL,
    contact_no         VARCHAR(15)  NOT NULL,
    last_donation_date DATE         NULL,
    city               VARCHAR(50)  NULL,
    -- Extra: ensure blood group is valid
    CONSTRAINT chk_donor_blood CHECK (blood_group IN ('A+','A-','B+','B-','O+','O-','AB+','AB-'))
);

CREATE TABLE Blood_Inventory (
    inventory_id    INT          PRIMARY KEY AUTO_INCREMENT,
    blood_group     VARCHAR(5)   NOT NULL,
    units_available INT          NOT NULL DEFAULT 0,
    last_updated    DATE         NOT NULL,
    CONSTRAINT chk_inv_blood   CHECK (blood_group IN ('A+','A-','B+','B-','O+','O-','AB+','AB-')),
    CONSTRAINT chk_units       CHECK (units_available >= 0),
    CONSTRAINT uq_blood_group  UNIQUE (blood_group)   -- one row per blood group
);

CREATE TABLE Recipient (
    recipient_id INT          PRIMARY KEY AUTO_INCREMENT,
    full_name    VARCHAR(100) NOT NULL,
    blood_group  VARCHAR(5)   NOT NULL,
    contact_no   VARCHAR(15)  NOT NULL,
    CONSTRAINT chk_rec_blood CHECK (blood_group IN ('A+','A-','B+','B-','O+','O-','AB+','AB-'))
);

CREATE TABLE Donation (
    donation_id   INT  PRIMARY KEY AUTO_INCREMENT,
    donor_id      INT  NOT NULL,
    donation_date DATE NOT NULL,
    units_donated INT  NOT NULL,
    CONSTRAINT chk_units_donated CHECK (units_donated > 0),
    FOREIGN KEY (donor_id) REFERENCES Donor(donor_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Blood_Request (
    request_id     INT         PRIMARY KEY AUTO_INCREMENT,
    recipient_id   INT         NOT NULL,
    blood_group    VARCHAR(5)  NOT NULL,
    units_required INT         NOT NULL,
    request_date   DATE        NOT NULL,
    status         VARCHAR(20) DEFAULT 'Pending',
    CONSTRAINT chk_req_blood   CHECK (blood_group IN ('A+','A-','B+','B-','O+','O-','AB+','AB-')),
    CONSTRAINT chk_units_req   CHECK (units_required > 0),
    CONSTRAINT chk_status      CHECK (status IN ('Pending','Fulfilled','Cancelled')),
    FOREIGN KEY (recipient_id) REFERENCES Recipient(recipient_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ----------------------------------------------------------------
-- INDEXES for faster query performance
-- ----------------------------------------------------------------
CREATE INDEX idx_donor_blood        ON Donor(blood_group);
CREATE INDEX idx_recipient_blood    ON Recipient(blood_group);
CREATE INDEX idx_donation_date      ON Donation(donation_date);
CREATE INDEX idx_request_status     ON Blood_Request(status);
CREATE INDEX idx_request_blood      ON Blood_Request(blood_group);

-- ----------------------------------------------------------------
-- INSERT DATA INTO Donor (8 records)
-- ----------------------------------------------------------------

INSERT INTO Donor (full_name, blood_group, contact_no, last_donation_date, city) VALUES
('Ahmed Raza',     'B+',  '0300-1234567', '2024-11-10', 'Lahore'),
('Sana Mahmood',   'A+',  '0311-2345678', '2024-09-22', 'Karachi'),
('Usman Tariq',    'O+',  '0321-3456789', '2025-01-05', 'Islamabad'),
('Fatima Noor',    'AB+', '0333-4567890', '2024-12-15', 'Lahore'),
('Bilal Hussain',  'B-',  '0345-5678901', '2024-08-30', 'Peshawar'),
('Zainab Iqbal',   'O-',  '0301-6789012', '2025-02-18', 'Faisalabad'),
('Hamza Sheikh',   'A-',  '0312-7890123', '2025-03-01', 'Multan'),
('Mariam Farooq',  'B+',  '0322-8901234', '2025-03-20', 'Lahore');

-- ----------------------------------------------------------------
-- INSERT DATA INTO Blood_Inventory (6 records)
-- ----------------------------------------------------------------

INSERT INTO Blood_Inventory (blood_group, units_available, last_updated) VALUES
('A+',  14, '2025-03-25'),
('A-',   5, '2025-03-25'),
('B+',  20, '2025-03-26'),
('B-',   3, '2025-03-26'),
('O+',  18, '2025-03-27'),
('O-',   7, '2025-03-27');

-- ----------------------------------------------------------------
-- INSERT DATA INTO Recipient (6 records)
-- ----------------------------------------------------------------

INSERT INTO Recipient (full_name, blood_group, contact_no) VALUES
('Imran Khan',     'B+',  '0341-1112233'),
('Nadia Saleem',   'O+',  '0302-2223344'),
('Tariq Mehmood',  'A+',  '0313-3334455'),
('Hira Baig',      'AB+', '0323-4445566'),
('Asad Ali',       'O-',  '0334-5556677'),
('Rabia Qadir',    'B-',  '0344-6667788');

-- ----------------------------------------------------------------
-- INSERT DATA INTO Donation (10 records)
-- ----------------------------------------------------------------

INSERT INTO Donation (donor_id, donation_date, units_donated) VALUES
(1, '2024-11-10', 1),
(2, '2024-09-22', 1),
(3, '2025-01-05', 2),
(4, '2024-12-15', 1),
(5, '2024-08-30', 1),
(6, '2025-02-18', 2),
(7, '2025-03-01', 1),
(8, '2025-03-20', 1),
(1, '2025-02-14', 1),
(3, '2025-03-10', 1);

-- ----------------------------------------------------------------
-- INSERT DATA INTO Blood_Request (8 records)
-- ----------------------------------------------------------------

INSERT INTO Blood_Request (recipient_id, blood_group, units_required, request_date, status) VALUES
(1, 'B+',  2, '2025-03-01', 'Pending'),
(2, 'O+',  1, '2025-03-05', 'Fulfilled'),
(3, 'A+',  3, '2025-03-08', 'Pending'),
(4, 'AB+', 1, '2025-03-10', 'Fulfilled'),
(5, 'O-',  2, '2025-03-12', 'Pending'),
(6, 'B-',  1, '2025-03-15', 'Pending'),
(1, 'B+',  1, '2025-03-18', 'Fulfilled'),
(2, 'O+',  2, '2025-03-22', 'Pending');

-- ================================================================
-- SET A: BASIC QUERIES
-- ================================================================

-- Query A1: All donors with blood group B+
SELECT donor_id, full_name, blood_group, contact_no, last_donation_date, city
FROM Donor
WHERE blood_group = 'B+'
ORDER BY full_name ASC;

-- Query A2: All blood requests with status Pending
SELECT request_id, recipient_id, blood_group, units_required, request_date, status
FROM Blood_Request
WHERE status = 'Pending'
ORDER BY request_date ASC;

-- Query A3: Donations made in the last 3 months
SELECT donation_id, donor_id, donation_date, units_donated
FROM Donation
WHERE donation_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
ORDER BY donation_date DESC;

-- Query A4: Recipients with blood group O+
SELECT recipient_id, full_name, blood_group, contact_no
FROM Recipient
WHERE blood_group = 'O+'
ORDER BY full_name ASC;

-- ================================================================
-- SET B: JOIN QUERIES
-- ================================================================

-- Query B1: Each donation with donor full name (INNER JOIN)
SELECT
    dn.donation_id,
    d.full_name       AS donor_name,
    d.blood_group,
    d.city,
    dn.donation_date,
    dn.units_donated
FROM Donation dn
INNER JOIN Donor d ON dn.donor_id = d.donor_id
ORDER BY dn.donation_date ASC;

-- Query B2: Each blood request with recipient name and blood group (JOIN)
SELECT
    br.request_id,
    r.full_name       AS recipient_name,
    br.blood_group,
    br.units_required,
    br.request_date,
    br.status
FROM Blood_Request br
INNER JOIN Recipient r ON br.recipient_id = r.recipient_id
ORDER BY br.request_date ASC;

-- Query B3: Donors who donated more than once (JOIN + GROUP BY + HAVING)
SELECT
    d.donor_id,
    d.full_name,
    d.blood_group,
    d.city,
    COUNT(dn.donation_id)  AS total_donations,
    SUM(dn.units_donated)  AS total_units_given
FROM Donor d
INNER JOIN Donation dn ON d.donor_id = dn.donor_id
GROUP BY d.donor_id, d.full_name, d.blood_group, d.city
HAVING COUNT(dn.donation_id) > 1
ORDER BY total_donations DESC;

-- ================================================================
-- SET C: AGGREGATE QUERIES
-- ================================================================

-- Query C1: Total units available per blood group
SELECT
    blood_group,
    SUM(units_available)  AS total_units_available,
    last_updated
FROM Blood_Inventory
GROUP BY blood_group, last_updated
ORDER BY blood_group ASC;

-- Query C2: Total requests per blood group
SELECT
    blood_group,
    COUNT(request_id)                                        AS total_requests,
    SUM(CASE WHEN status = 'Fulfilled' THEN 1 ELSE 0 END)   AS fulfilled,
    SUM(CASE WHEN status = 'Pending'   THEN 1 ELSE 0 END)   AS pending
FROM Blood_Request
GROUP BY blood_group
ORDER BY total_requests DESC;

-- Query C3: Donor with maximum total units donated
SELECT
    d.donor_id,
    d.full_name,
    d.blood_group,
    d.city,
    SUM(dn.units_donated) AS total_units_donated
FROM Donor d
INNER JOIN Donation dn ON d.donor_id = dn.donor_id
GROUP BY d.donor_id, d.full_name, d.blood_group, d.city
ORDER BY total_units_donated DESC
LIMIT 1;

-- ================================================================
-- BONUS QUERIES (Extra value — not required but impressive)
-- ================================================================

-- Bonus 1: Blood groups with LOW stock (less than 5 units) — urgent alert
SELECT blood_group, units_available, last_updated
FROM Blood_Inventory
WHERE units_available < 5
ORDER BY units_available ASC;

-- Bonus 2: Donors who have NEVER donated (registered but no donation record)
SELECT d.donor_id, d.full_name, d.blood_group, d.contact_no, d.city
FROM Donor d
LEFT JOIN Donation dn ON d.donor_id = dn.donor_id
WHERE dn.donation_id IS NULL;

-- Bonus 3: Fulfilled requests — shows recipient name + units received
SELECT
    r.full_name      AS recipient_name,
    br.blood_group,
    br.units_required,
    br.request_date,
    br.status
FROM Blood_Request br
INNER JOIN Recipient r ON br.recipient_id = r.recipient_id
WHERE br.status = 'Fulfilled'
ORDER BY br.request_date DESC;

-- ================================================================
-- END OF PROJECT 1 (Enhanced)
-- ================================================================

-- =====================================================
-- [Sáng tạo]
-- Xây dựng Module "Ví Điện Tử ShopeePay Mini"
-- =====================================================

-- =====================================================
-- PHÂN TÍCH RỦI RO
-- =====================================================

-- Rủi ro 1:
-- Một khách hàng tạo nhiều ví

-- Rủi ro 2:
-- Số dư ví bị âm

-- Rủi ro 3:
-- Giao dịch nhập số tiền âm hoặc bằng 0

-- Rủi ro 4:
-- Giao dịch không có trạng thái

-- Rủi ro 5:
-- Giao dịch tham chiếu tới ví không tồn tại

-- Rủi ro 6:
-- Người dùng bỏ trống thông tin quan trọng


-- =====================================================
-- TẠO BẢNG CUSTOMERS
-- =====================================================

CREATE TABLE Customers (

    CustomerID INT PRIMARY KEY AUTO_INCREMENT,

    FullName VARCHAR(100) NOT NULL,

    Email VARCHAR(100) NOT NULL UNIQUE

);


-- =====================================================
-- TẠO BẢNG WALLETS
-- =====================================================

CREATE TABLE Wallets (

    WalletID INT PRIMARY KEY AUTO_INCREMENT,

    CustomerID INT NOT NULL UNIQUE,

    Balance DECIMAL(15,2) NOT NULL DEFAULT 0,

    Status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,

    -- CHECK số dư không âm
    CONSTRAINT chk_wallet_balance
    CHECK (Balance >= 0),

    -- CHECK trạng thái hợp lệ
    CONSTRAINT chk_wallet_status
    CHECK (Status IN ('ACTIVE', 'BLOCKED')),

    -- FOREIGN KEY
    CONSTRAINT fk_wallet_customer
    FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID)

);


-- =====================================================
-- TẠO BẢNG TRANSACTIONS
-- =====================================================

CREATE TABLE Transactions (

    TransactionID INT PRIMARY KEY AUTO_INCREMENT,

    WalletID INT NOT NULL,

    TransactionType VARCHAR(20) NOT NULL,

    Amount DECIMAL(15,2) NOT NULL,

    TransactionStatus VARCHAR(20)
    NOT NULL DEFAULT 'PENDING',

    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,

    -- CHECK số tiền > 0
    CONSTRAINT chk_transaction_amount
    CHECK (Amount > 0),

    -- CHECK loại giao dịch
    CONSTRAINT chk_transaction_type
    CHECK (
        TransactionType IN (
            'DEPOSIT',
            'WITHDRAW',
            'PAYMENT'
        )
    ),

    -- CHECK trạng thái giao dịch
    CONSTRAINT chk_transaction_status
    CHECK (
        TransactionStatus IN (
            'PENDING',
            'SUCCESS',
            'FAILED'
        )
    ),

    -- FOREIGN KEY
    CONSTRAINT fk_transaction_wallet
    FOREIGN KEY (WalletID)
    REFERENCES Wallets(WalletID)

);


-- =====================================================
-- TEST DỮ LIỆU HỢP LỆ
-- =====================================================

INSERT INTO Customers (
    FullName,
    Email
)
VALUES (
    'Nguyen Van A',
    'a@gmail.com'
);


INSERT INTO Wallets (
    CustomerID,
    Balance
)
VALUES (
    1,
    500000
);


INSERT INTO Transactions (
    WalletID,
    TransactionType,
    Amount,
    TransactionStatus
)
VALUES (
    1,
    'DEPOSIT',
    200000,
    'SUCCESS'
);


-- =====================================================
-- TEST RỦI RO
-- =====================================================

-- =====================================================
-- TEST 1:
-- Tạo ví thứ 2 cho cùng khách hàng
-- -> bị chặn bởi UNIQUE
-- =====================================================

INSERT INTO Wallets (
    CustomerID,
    Balance
)
VALUES (
    1,
    100000
);


-- =====================================================
-- TEST 2:
-- Số dư âm
-- -> bị chặn bởi CHECK
-- =====================================================

INSERT INTO Wallets (
    CustomerID,
    Balance
)
VALUES (
    2,
    -50000
);


-- =====================================================
-- TEST 3:
-- Amount âm
-- -> bị chặn
-- =====================================================

INSERT INTO Transactions (
    WalletID,
    TransactionType,
    Amount
)
VALUES (
    1,
    'PAYMENT',
    -1000
);


-- =====================================================
-- TEST 4:
-- WalletID không tồn tại
-- -> bị chặn bởi FOREIGN KEY
-- =====================================================

INSERT INTO Transactions (
    WalletID,
    TransactionType,
    Amount
)
VALUES (
    999,
    'DEPOSIT',
    50000
);


-- =====================================================
-- KIỂM TRA DỮ LIỆU
-- =====================================================

SELECT *
FROM Customers;

SELECT *
FROM Wallets;

SELECT *
FROM Transactions;
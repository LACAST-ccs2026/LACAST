-- 创建 class_members 表
DROP TABLE IF EXISTS class_members;
CREATE TABLE IF NOT EXISTS class_members (
    id INTEGER PRIMARY KEY AUTOINCREMENT,  -- INTEGER
    name TEXT NOT NULL,                    -- TEXT
    age INTEGER,                           -- INTEGER
    gender TEXT,                           -- TEXT
    class_name TEXT NOT NULL,              -- TEXT
    score REAL,                            -- REAL
    salary NUMERIC,                        -- NUMERIC
    profile_picture BLOB                   -- BLOB
);

-- 创建 class_members1 表
DROP TABLE IF EXISTS class_members1;
CREATE TABLE IF NOT EXISTS class_members1 (
    id INTEGER PRIMARY KEY AUTOINCREMENT,  -- INTEGER
    name1 TEXT NOT NULL,                   -- TEXT
    age1 INTEGER,                          -- INTEGER
    gender1 TEXT,                          -- TEXT
    class_name1 TEXT NOT NULL,             -- TEXT
    grade REAL,                            -- REAL
    bonus NUMERIC,                         -- NUMERIC
    image BLOB                             -- BLOB
);

-- 创建 employees 表
DROP TABLE IF EXISTS employees;
CREATE TABLE IF NOT EXISTS employees (
    employee_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- INTEGER
    first_name TEXT NOT NULL,                        -- TEXT
    last_name TEXT NOT NULL,                         -- TEXT
    department TEXT,                                 -- TEXT
    salary NUMERIC,                                  -- NUMERIC
    bonus REAL,                                      -- REAL
    hire_date TEXT,                                  -- TEXT
    profile_picture BLOB                             -- BLOB
);

-- 创建 products 表
DROP TABLE IF EXISTS products;
CREATE TABLE IF NOT EXISTS products (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- INTEGER
    product_name TEXT NOT NULL,                     -- TEXT
    category TEXT,                                  -- TEXT
    price NUMERIC,                                  -- NUMERIC
    quantity INTEGER,                               -- INTEGER
    date_added TEXT,                                -- TEXT
    product_image BLOB                              -- BLOB
);

-- 创建 orders 表
DROP TABLE IF EXISTS orders;
CREATE TABLE IF NOT EXISTS orders (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- INTEGER
    customer_name TEXT NOT NULL,                  -- TEXT
    product_id INTEGER,                           -- INTEGER
    order_date TEXT,                              -- TEXT
    total_amount NUMERIC,                         -- NUMERIC
    shipping_address TEXT,                        -- TEXT
    invoice BLOB                                  -- BLOB
);

-- 创建 students 表
DROP TABLE IF EXISTS students;
CREATE TABLE IF NOT EXISTS students (
    student_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- INTEGER
    student_name TEXT NOT NULL,                    -- TEXT
    age INTEGER,                                  -- INTEGER
    gender TEXT,                                  -- TEXT
    grade REAL,                                   -- REAL
    scholarship NUMERIC,                           -- NUMERIC
    student_photo BLOB                            -- BLOB
);

-- 创建 courses 表
DROP TABLE IF EXISTS courses;
CREATE TABLE IF NOT EXISTS courses (
    course_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- INTEGER
    course_name TEXT NOT NULL,                     -- TEXT
    instructor_name TEXT,                          -- TEXT
    course_credit INTEGER,                         -- INTEGER
    course_fee NUMERIC,                            -- NUMERIC
    course_materials BLOB                          -- BLOB
);

-- 创建 sales 表
DROP TABLE IF EXISTS sales;
CREATE TABLE IF NOT EXISTS sales (
    sale_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- INTEGER
    product_id INTEGER,                         -- INTEGER
    sale_date TEXT,                             -- TEXT
    sale_amount NUMERIC,                        -- NUMERIC
    discount REAL,                              -- REAL
    receipt BLOB                                -- BLOB
);

-- 创建 transactions 表
DROP TABLE IF EXISTS transactions;
CREATE TABLE IF NOT EXISTS transactions (
    transaction_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- INTEGER
    transaction_date TEXT,                              -- TEXT
    amount NUMERIC,                                     -- NUMERIC
    transaction_type TEXT,                              -- TEXT
    transaction_receipt BLOB                           -- BLOB
);

-- 插入数据到 class_members 表
INSERT INTO class_members (name, age, gender, class_name, score, salary, profile_picture)
VALUES
('John Doe', 20, 'Male', 'Class A', 95.5, 5000.00, X'FFD8FFE000104A4649460001010100600060000100'),
('Alice Doe', 18, 'Female', 'Class C', 88.7, 4500.00, X'FFD8FFE000104A4649460001010100600060000200'),
('Bob Smith', 22, 'Male', 'Class B', 75.5, 4800.00, X'FFD8FFE000104A4649460001010100600060000300'),
('Charlie Brown', 19, 'Male', 'Class A', 82.4, 5000.00, X'FFD8FFE000104A4649460001010100600060000400'),
('Diana Green', 21, 'Female', 'Class D', 90.0, 4700.00, X'FFD8FFE000104A4649460001010100600060000500');

-- 插入数据到 class_members1 表
INSERT INTO class_members1 (name1, age1, gender1, class_name1, grade, bonus, image)
VALUES
('John Smith', 22, 'Male', 'Class B', 92.3, 1000.00, X'FFD8FFE000104A4649460001010100600060000600'),
('Eva White', 19, 'Female', 'Class D', 85.2, 800.00, X'FFD8FFE000104A4649460001010100600060000700'),
('Sam Green', 23, 'Male', 'Class A', 78.9, 500.00, X'FFD8FFE000104A4649460001010100600060000800'),
('Anna Blue', 20, 'Female', 'Class C', 88.5, 900.00, X'FFD8FFE000104A4649460001010100600060000900'),
('David Red', 21, 'Male', 'Class B', 91.0, 1100.00, X'FFD8FFE000104A4649460001010100600060000A00');

-- 插入数据到 employees 表
INSERT INTO employees (first_name, last_name, department, salary, bonus, hire_date, profile_picture)
VALUES
('Michael', 'Jordan', 'Sales', 8000.00, 1200.00, '2021-03-15', X'FFD8FFE000104A4649460001010100600060000B00'),
('Sarah', 'Connor', 'Engineering', 9500.00, 1500.00, '2020-07-21', X'FFD8FFE000104A4649460001010100600060000C00'),
('Alex', 'Reed', 'HR', 6500.00, 800.00, '2019-06-10', X'FFD8FFE000104A4649460001010100600060000D00'),
('Linda', 'Gray', 'Sales', 7500.00, 1100.00, '2018-09-05', X'FFD8FFE000104A4649460001010100600060000E00'),
('James', 'Bond', 'Marketing', 10500.00, 2000.00, '2021-11-01', X'FFD8FFE000104A4649460001010100600060000F00');

-- 插入数据到 products 表
INSERT INTO products (product_name, category, price, quantity, date_added, product_image)
VALUES
('Smartphone', 'Electronics', 699.99, 50, '2022-01-01', X'FFD8FFE000104A4649460001010100600060001000'),
('Laptop', 'Electronics', 1299.99, 30, '2022-02-15', X'FFD8FFE000104A4649460001010100600060001100'),
('Tablet', 'Electronics', 499.99, 70, '2022-03-20', X'FFD8FFE000104A4649460001010100600060001200'),
('Headphones', 'Electronics', 150.00, 200, '2022-05-01', X'FFD8FFE000104A4649460001010100600060001300'),
('Smartwatch', 'Electronics', 250.00, 100, '2022-06-15', X'FFD8FFE000104A4649460001010100600060001400');

-- 插入数据到 orders 表
INSERT INTO orders (customer_name, product_id, order_date, total_amount, shipping_address, invoice)
VALUES
('David Green', 1, '2022-03-10', 699.99, '123 Elm St, Springfield', X'FFD8FFE000104A4649460001010100600060001500'),
('Olivia Brown', 2, '2022-04-05', 1299.99, '456 Oak St, Springfield', X'FFD8FFE000104A4649460001010100600060001600'),
('Emma White', 3, '2022-04-20', 499.99, '789 Pine St, Springfield', X'FFD8FFE000104A4649460001010100600060001700'),
('Sophia Black', 4, '2022-05-15', 150.00, '321 Maple St, Springfield', X'FFD8FFE000104A4649460001010100600060001800'),
('Aiden Blue', 5, '2022-06-01', 250.00, '654 Cedar St, Springfield', X'FFD8FFE000104A4649460001010100600060001900');

-- 插入数据到 students 表
INSERT INTO students (student_name, age, gender, grade, scholarship, student_photo)
VALUES
('James Bond', 21, 'Male', 90.0, 2000.00, X'FFD8FFE000104A4649460001010100600060001A00'),
('Lara Croft', 20, 'Female', 92.5, 2500.00, X'FFD8FFE000104A4649460001010100600060001B00'),
('Peter Parker', 19, 'Male', 85.0, 1800.00, X'FFD8FFE000104A4649460001010100600060001C00'),
('Bruce Wayne', 22, 'Male', 93.0, 2200.00, X'FFD8FFE000104A4649460001010100600060001D00'),
('Diana Prince', 21, 'Female', 88.5, 2100.00, X'FFD8FFE000104A4649460001010100600060001E00');

-- 插入数据到 courses 表
INSERT INTO courses (course_name, instructor_name, course_credit, course_fee, course_materials)
VALUES
('Computer Science 101', 'Dr. Smith', 3, 500.00, X'FFD8FFE000104A4649460001010100600060001F00'),
('Mathematics 101', 'Prof. Johnson', 4, 400.00, X'FFD8FFE000104A4649460001010100600060002000'),
('Physics 101', 'Dr. Walker', 3, 450.00, X'FFD8FFE000104A4649460001010100600060002100'),
('Chemistry 101', 'Prof. Adams', 4, 300.00, X'FFD8FFE000104A4649460001010100600060002200'),
('Biology 101', 'Dr. Miller', 3, 350.00, X'FFD8FFE000104A4649460001010100600060002300');

-- 插入数据到 sales 表
INSERT INTO sales (product_id, sale_date, sale_amount, discount, receipt)
VALUES
(1, '2022-03-12', 699.99, 0.10, X'FFD8FFE000104A4649460001010100600060002400'),
(2, '2022-04-07', 1299.99, 0.15, X'FFD8FFE000104A4649460001010100600060002500'),
(3, '2022-04-21', 499.99, 0.05, X'FFD8FFE000104A4649460001010100600060002600'),
(4, '2022-05-10', 150.00, 0.20, X'FFD8FFE000104A4649460001010100600060002700'),
(5, '2022-06-05', 250.00, 0.10, X'FFD8FFE000104A4649460001010100600060002800');

-- 插入数据到 transactions 表
INSERT INTO transactions (transaction_date, amount, transaction_type, transaction_receipt)
VALUES
('2022-03-15', 699.99, 'Purchase', X'FFD8FFE000104A4649460001010100600060002900'),
('2022-04-10', 1299.99, 'Purchase', X'FFD8FFE000104A4649460001010100600060002A00'),
('2022-04-22', 499.99, 'Purchase', X'FFD8FFE000104A4649460001010100600060002B00'),
('2022-05-12', 150.00, 'Purchase', X'FFD8FFE000104A4649460001010100600060002C00'),
('2022-06-07', 250.00, 'Purchase', X'FFD8FFE000104A4649460001010100600060002D00');

-- 创建class_members表
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

-- 创建class_members1表
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

-- 插入测试数据
-- 插入测试数据
-- 插入测试数据
INSERT INTO class_members (name, age, gender, class_name, score, salary, profile_picture)
VALUES ('John Doe', 20, 'Male', 'Class A', 95.5, 5000.00, X'FFD8FFE000104A4649460001010100600060000000FFDB0043');
INSERT INTO class_members (name, age, gender, class_name, score, salary, profile_picture)
VALUES ('Alice Doe', 18, 'Female', 'Class C', 88.7, 4500.00, X'FFD8FFE000104A4649460001010100600060000000FFDB0043');
INSERT INTO class_members1 (name1, age1, gender1, class_name1, grade, bonus, image)
VALUES ('John Smith', 22, 'Male', 'Class B', 92.3, 1000.00, X'FFD8FFE000104A4649460001010100600060000000FFDB0043');
INSERT INTO class_members1 (name1, age1, gender1, class_name1, grade, bonus, image)
VALUES ('Eva White', 19, 'Female', 'Class D', 85.2, 800.00, X'FFD8FFE000104A4649460001010100600060000000FFDB0043');

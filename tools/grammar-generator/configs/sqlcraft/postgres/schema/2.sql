DROP TABLE IF EXISTS pg_table_a;
CREATE TABLE pg_table_a (
    id INTEGER PRIMARY KEY,
    col_bit BIT(6),
    col_bool BOOLEAN,
    col_bytea BYTEA,
    col_char CHARACTER(1),
    col_date DATE,
    col_double DOUBLE PRECISION,
    col_text TEXT,
    col_time TIME,
    col_timestamp TIMESTAMP,
    col_cidr CIDR,
    col_inet INET,
    col_macaddr MACADDR,
    col_macaddr8 MACADDR8,
    col_uuid UUID
);

DROP TABLE IF EXISTS pg_table_b;
CREATE TABLE pg_table_b (
    id INTEGER PRIMARY KEY,
    col_bit BIT(6),
    col_bool BOOLEAN,
    col_bytea BYTEA,
    col_char CHARACTER(1),
    col_date DATE,
    col_double DOUBLE PRECISION,
    col_text TEXT,
    col_time TIME,
    col_timestamp TIMESTAMP,
    col_cidr CIDR,
    col_inet INET,
    col_macaddr MACADDR,
    col_macaddr8 MACADDR8,
    col_uuid UUID
);

INSERT INTO pg_table_a VALUES
(1, B'101010', TRUE, E'\\xDEADBEEF', 'A', DATE '2025-01-01', 3.14, 'hello', TIME '12:00:00', TIMESTAMP '2025-01-01 12:00:00', '192.168.1.0/24', '192.168.1.1', '08:00:2b:01:02:03', '00:00:5e:00:53:af:12:34', '123e4567-e89b-12d3-a456-426614174000'),
(2, B'000001', FALSE, E'\\x00FF', 'B', DATE '2024-12-31', 2.71, 'postgresql', TIME '08:30:15', TIMESTAMP '2024-12-31 08:30:15', '10.0.0.0/8', '10.0.0.1', '00:15:5d:05:03:21', '00:0a:95:9d:68:16:5e:45', '123e4567-e89b-12d3-a456-426614174001'),
(3, B'111111', TRUE, E'\\xABCDEF', 'C', DATE '2023-06-15', 1.41, 'database', TIME '23:59:59', TIMESTAMP '2023-06-15 23:59:59', '172.16.0.0/16', '172.16.1.1', '00:22:33:44:55:66', '00:1a:2b:3c:4d:5e:6f:70', '123e4567-e89b-12d3-a456-426614174002'),
(4, B'010101', FALSE, E'\\x123456', 'D', DATE '2022-03-10', 0.99, 'testing', TIME '00:00:00', TIMESTAMP '2022-03-10 00:00:00', '192.168.0.0/16', '192.168.0.1', '01:02:03:04:05:06', '01:02:03:04:05:06:07:08', '123e4567-e89b-12d3-a456-426614174003'),
(5, B'100000', TRUE, E'\\xCAFEBABE', 'E', DATE '2021-07-07', 42.0, 'sql', TIME '16:45:30', TIMESTAMP '2021-07-07 16:45:30', '192.0.2.0/24', '192.0.2.1', '01:23:45:67:89:ab', '01:23:45:67:89:ab:cd:ef', '123e4567-e89b-12d3-a456-426614174004');

INSERT INTO pg_table_b VALUES
(1, B'001100', FALSE, E'\\x111111', 'X', DATE '2020-01-01', 10.5, 'alpha', TIME '01:01:01', TIMESTAMP '2020-01-01 01:01:01', '192.168.1.0/24', '192.168.1.2', '00:00:5e:00:53:af', '00:00:5e:00:53:af:12:34', '123e4567-e89b-12d3-a456-426614174005'),
(2, B'110011', TRUE, E'\\x222222', 'Y', DATE '2019-05-20', 20.5, 'beta', TIME '02:02:02', TIMESTAMP '2019-05-20 02:02:02', '10.0.0.0/8', '10.0.0.2', '00:15:5d:05:03:21', '00:0a:95:9d:68:16:5e:46', '123e4567-e89b-12d3-a456-426614174006'),
(3, B'101001', FALSE, E'\\x333333', 'Z', DATE '2018-09-09', 30.5, 'gamma', TIME '03:03:03', TIMESTAMP '2018-09-09 03:03:03', '172.16.0.0/16', '172.16.1.2', '00:22:33:44:55:67', '00:1a:2b:3c:4d:5e:6f:71', '123e4567-e89b-12d3-a456-426614174007'),
(4, B'011010', TRUE, E'\\x444444', 'M', DATE '2017-11-11', 40.5, 'delta', TIME '04:04:04', TIMESTAMP '2017-11-11 04:04:04', '192.168.0.0/16', '192.168.0.2', '01:02:03:04:05:07', '01:02:03:04:05:06:07:09', '123e4567-e89b-12d3-a456-426614174008'),
(5, B'000111', FALSE, E'\\x555555', 'N', DATE '2016-12-12', 50.5, 'epsilon', TIME '05:05:05', TIMESTAMP '2016-12-12 05:05:05', '192.0.2.0/24', '192.0.2.2', '01:23:45:67:89:bc', '01:23:45:67:89:ab:cd:ef', '123e4567-e89b-12d3-a456-426614174009');

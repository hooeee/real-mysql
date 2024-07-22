create database page_study;
use page_study;

create table product (
    id int primary key auto_increment,
    name varchar(50),
    price int
)

DELIMITER $$

CREATE PROCEDURE generate_product()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 1000000 DO
        INSERT INTO product (name , price)
        VALUES ( CONCAT('상품명 ' , i) , RAND() * 1000 + 1);
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;




create database tran_study;
use tran_study;

create table orders(
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    status VARCHAR(50) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL
);

DELIMITER $$

CREATE PROCEDURE generate_orders()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 1000 DO
        INSERT INTO orders (customer_id, order_date, status, total_amount)
        VALUES (FLOOR(RAND() * 4) + 1, NOW() - INTERVAL FLOOR(RAND() * 365) DAY, 'Completed', FLOOR(RAND() * 1000) + 1);
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;



create database drive_study;
use drive_study;

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    status VARCHAR(50) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    -- INDEX (customer_id),
    INDEX (order_date),
    INDEX (status)
);

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    INDEX (email)
);

ALTER TABLE orders ENGINE=MyISAM;
ALTER TABLE customers ENGINE=MyISAM;

insert into customers values ('1', 'Alice', 'alice@example.com');
insert into customers values ('2', 'Bob', 'bob@example.com');
insert into customers values ('3', 'Charlie', 'charlie@example.com');
insert into customers values ('4', 'David', 'david@example.com');


DELIMITER $$

CREATE PROCEDURE generate_orders()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100000 DO
        INSERT INTO orders (customer_id, order_date, status, total_amount)
        VALUES (FLOOR(RAND() * 4) + 1, NOW() - INTERVAL FLOOR(RAND() * 365) DAY, 'Completed', FLOOR(RAND() * 1000) + 1);
        SET i = i + 1;
    END WHILE;
END $$;

DELIMITER ;






create database real_mysql_query;
use real_mysql_query;

-- Customers 테이블 생성
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100)
);

-- Products 테이블 생성
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    unit_price DECIMAL(10, 2)
);
-- Orders 테이블 생성
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order_Details 테이블 생성
CREATE TABLE order_details (
    detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);




-- Customers 테이블에 대용량 데이터 삽입
DELIMITER $$

CREATE PROCEDURE insert_customers()
BEGIN
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= 1000000 DO
        INSERT INTO customers (customer_id, customer_name, customer_email)
        VALUES (i, CONCAT('Customer', i), CONCAT('customer', i, '@example.com'));
        
        SET i = i + 1;
    END WHILE;
    
END$$

DELIMITER ;



-- Orders 테이블에 대용량 데이터 삽입
DELIMITER $$

CREATE PROCEDURE insert_orders()
BEGIN
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= 3000000 DO
        INSERT INTO orders (order_id, order_date, customer_id)
        VALUES (i, DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND() * 365) DAY), FLOOR(1 + RAND() * 1000000));
        
        SET i = i + 1;
    END WHILE;
    
END$$

DELIMITER ;

-- Products 테이블에 대용량 데이터 삽입
DELIMITER $$

CREATE PROCEDURE insert_products()
BEGIN
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= 5000000 DO
        INSERT INTO products (product_id, product_name, unit_price)
        VALUES (i, CONCAT('Product', i), RAND() * 1000);
        
        SET i = i + 1;
    END WHILE;
    
END$$

DELIMITER ;




-- Order_Details 테이블에 대용량 데이터 삽입
DELIMITER $$

CREATE PROCEDURE insert_order_details()
BEGIN
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= 3000000 DO
        INSERT INTO order_details (detail_id, order_id, product_id, quantity)
        VALUES (i, FLOOR(1 + RAND() * 3000000), FLOOR(1 + RAND() * 5000000), FLOOR(1 + RAND() * 10));
        
        SET i = i + 1;
    END WHILE;
    
END$$

DELIMITER ;
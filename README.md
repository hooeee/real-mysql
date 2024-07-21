# real-mysql

real_mysql Study

https://2021-pick-git.github.io/service-performance-with-optimizer/

### Transaction이 속도에 미치는 영향

```
create table orders2(
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    status VARCHAR(50) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL
)

-- orders 테이블 생성
CREATE TABLE orders1 (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    status VARCHAR(50) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL
);


CREATE PROCEDURE generate_orders1()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 10000 DO
        INSERT INTO orders2 (customer_id, order_date, status, total_amount)
        VALUES (FLOOR(RAND() * 4) + 1, NOW() - INTERVAL FLOOR(RAND() * 365) DAY, 'Completed', FLOOR(RAND() * 1000) + 1);
        SET i = i + 1;
    END WHILE;
END $$;


CREATE PROCEDURE generate_orders2()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 10000 DO
        INSERT INTO orders2 (customer_id, order_date, status, total_amount)
        VALUES (FLOOR(RAND() * 4) + 1, NOW() - INTERVAL FLOOR(RAND() * 365) DAY, 'Completed', FLOOR(RAND() * 1000) + 1);
        SET i = i + 1;
    END WHILE;
END $$;


DROP PROCEDURE IF EXISTS generate_orders1;
DROP PROCEDURE IF EXISTS generate_orders2;

start transaction
call generate_orders1();
rollback;


call generate_orders2();

```

### Driving Table

1. ISAM

    - 트랜젝션 없음
    - Fk 없음
        - 따라서 논 클러스터링 인덱스 없음.
    - 버퍼 풀 없음
    - 테이블락 지원함

2. InnoDB
    - 트랜젝션 있음
    - MVCC 지원함 (row lock, 정확히는 Index Lock 임)

```sql

create database drive_table_study;
use drive_table_study;

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

insert into customers values ('1', 'Alice', 'alice@example.com');
insert into customers values ('2', 'Bob', 'bob@example.com');
insert into customers values ('3', 'Charlie', 'charlie@example.com');
insert into customers values ('4', 'David', 'david@example.com');



CREATE PROCEDURE generate_orders()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 10000 DO
        INSERT INTO orders (customer_id, order_date, status, total_amount)
        VALUES (FLOOR(RAND() * 4) + 1, NOW() - INTERVAL FLOOR(RAND() * 365) DAY, 'Completed', FLOOR(RAND() * 1000) + 1);
        SET i = i + 1;
    END WHILE;
END $$;


select count(*) from orders; --- 10만 +

start transaction
call generate_orders();
rollback;


ALTER TABLE orders ENGINE=MyISAM;
ALTER TABLE customers ENGINE=MyISAM;


explain select STRAIGHT_JOIN
    o.order_id, o.order_date, o.status, o.total_amount, c.name, c.email
	FROM orders o
	JOIN customers c ON o.customer_id = c.customer_id
	WHERE c.name = 'Alice';  --  // duration 30 , fetch 0.25



explain select
    o.order_id, o.order_date, o.status, o.total_amount, c.name, c.email
	FROM customers c
	JOIN orders o ON o.customer_id = c.customer_id
	WHERE c.name = 'Alice';  -- // duration 0.25 , fetch 30

```

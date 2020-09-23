-- Spencer Rosenvall

-- add or drop a column
USE sample;
ALTER TABLE employee
ADD telephone_no CHAR(12) NULL;
SELECT * FROM employee

-- remove a column
DROP COLUMN telephone_no;

-- modifying column properties */
ALTER COLUMN location CHAR(25) NOT NULL;
USE sample;
CREATE TABLE sales
(
	order_no INTEGER NOT NULL,
	order_date DATE NOT NULL,
	ship_date DATE NOT NULL
);

USE sample;
ALTER TABLE sales
ADD CONSTRAINT order_check CHECK( order_date <= ship_date);

-- alter table and add primary key constraint
USE sample;
ALTER TABLE sales
ADD CONSTRAINT pk_sales PRIMARY KEY (order_no);

-- alter table and remove constraints
USE sample;
ALTER TABLE sales
DROP CONSTRAINT pk_sales;

USE sample;
ALTER TABLE sales
DROP CONSTRAINT order_check;

-- enable and disable constraint
USE sample;
ALTER TABLE sales
NOCHECK CONSTRAINT order_check;

USE sample;
ALTER TABLE sales
NOCHECK CONSTRAINT pk_sales;

USE sample;
ALTER TABLE sales
CHECK CONSTRAINT order_check;

-- removing database objects, ex: keys, tables, constraints
DROP CONSTRAINT pk_sales;
DROP TABLE salesl
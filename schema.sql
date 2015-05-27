
DROP TABLE IF EXISTS sellers;
DROP TABLE IF EXISTS buyers;
DROP TABLE IF EXISTS invoice_freq;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS invoices;
-- DEFINE YOUR DATABASE SCHEMA HERE
CREATE TABLE sellers (
  id SERIAL PRIMARY KEY,
  employee VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE buyers (
  id SERIAL PRIMARY KEY,
  cust_acct VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE invoice_freq (
  id SERIAL PRIMARY KEY,
  frequency VARCHAR(50)  NOT NULL UNIQUE
);

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  product VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE invoices (
  inv_num INTEGER,
  seller_id INTEGER,
  cust_id INTEGER,
  sale_date varchar(100),
  product VARCHAR(100),
  units INTEGER,
  freq_id INTEGER,
  sale_amount VARCHAR(100)
);

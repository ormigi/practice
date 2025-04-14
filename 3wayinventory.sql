 
/* the following script creates a DataBase using MySQL Workbench, populates it with tables, then creates SQL queries to identify the mismatches in the records found in the 3 tables. This is part of a project that identifies using simulating data, the invoice and purchase order mismatches using SQL and Python (Pandas), 
identifying discrepancies across quantities, prices, and items, for actionable insights  —   mirroring real-world three-way matching and vendor alignment.*/

CREATE DATABASE inventory_management;
USE inventory_management;
CREATE TABLE purchase_orders (
    order_id INT PRIMARY KEY,
    item_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    order_date DATE
);

CREATE TABLE goods_received (
    receipt_id INT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT,
    receipt_date DATE,
    FOREIGN KEY (order_id) REFERENCES purchase_orders(order_id)
);

CREATE TABLE vendor_invoices (
    invoice_id INT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    invoice_date DATE,
    FOREIGN KEY (order_id) REFERENCES purchase_orders(order_id)
);
/*/insert some sample data into the tables./*/

INSERT INTO purchase_orders (order_id, item_id, quantity, price, order_date)
VALUES
(1, 101, 50, 10.00, '2025-01-01'),
(2, 102, 30, 15.00, '2025-01-05'),
(3, 103, 20, 25.00, '2025-01-07');

INSERT INTO goods_received (receipt_id, order_id, item_id, quantity, receipt_date)
VALUES
(1, 1, 101, 50, '2025-01-03'),
(2, 2, 102, 30, '2025-01-08'),
(3, 3, 103, 20, '2025-01-10');

INSERT INTO vendor_invoices (invoice_id, order_id, item_id, quantity, price, invoice_date)
VALUES
(1, 1, 101, 50, 10.00, '2025-01-04'),
(2, 2, 102, 30, 15.00, '2025-01-06'),
(3, 3, 103, 20, 25.00, '2025-01-09');

/*/run the query to perform the three-way matching between the purchase_orders, goods_received, and vendor_invoices tables.
 This query compares the quantities and prices from the three sources and returns whether they match.*/
 
 CREATE TABLE final_inventory_comparison AS
 SELECT
    po.order_id,
    po.item_id,
    po.quantity AS po_quantity,
    gr.quantity AS gr_quantity,
    vi.quantity AS vi_quantity,
    po.price AS po_price,
    vi.price AS vi_price,
    CASE
        WHEN po.quantity = gr.quantity AND po.quantity = vi.quantity THEN 'Match'
        ELSE 'Mismatch'
    END AS quantity_match,
    CASE
        WHEN po.price = vi.price THEN 'Match'
        ELSE 'Mismatch'
    END AS price_match,
    CASE
        WHEN po.item_id = gr.item_id AND po.item_id = vi.item_id THEN 'Match'
        ELSE 'Mismatch'
    END AS item_match
FROM
    purchase_orders po
JOIN
    goods_received gr ON po.order_id = gr.order_id
JOIN
    vendor_invoices vi ON po.order_id = vi.order_id
WHERE
    po.order_id IN (1, 2, 3);  -- we can specify which orders to match (or remove the filter to match all orders)
    
 /*   
CREATE TABLE vendor_invoices (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    invoice_date DATE
);
INSERT INTO vendor_invoices (order_id, item_id, quantity, price, invoice_date)
VALUES
(1, 101, 50, 10.00, '2025-01-04'),
(2, 102, 30, 15.00, '2025-01-06'),
(3, 103, 20, 25.00, '2025-01-09');
SELECT * FROM vendor_invoices;
SELECT * FROM purchase_orders;
SELECT * FROM goods_received;
SELECT USER();
SELECT DATABASE(); */

SELECT user, host, authentication_string, plugin FROM mysql.user WHERE user='root';

create table final_inventory_comparison as
SELECT 
    po.order_id,
    po.item_id,
    po.quantity AS po_qty,
    gr.quantity AS received_qty,
    vi.quantity AS invoiced_qty,
    po.price AS po_price,
    gr.price AS received_price,
    vi.price AS invoiced_price,
    CASE WHEN po.quantity = gr.quantity AND gr.quantity = vi.quantity THEN TRUE ELSE FALSE END AS qty_match,
    CASE WHEN po.price = gr.price AND gr.price = vi.price THEN TRUE ELSE FALSE END AS price_match,
    CASE WHEN po.item_id = gr.item_id AND gr.item_id = vi.item_id THEN TRUE ELSE FALSE END AS item_match
FROM purchase_orders po
JOIN goods_receipts gr ON po.order_id = gr.order_id AND po.item_id = gr.item_id
JOIN vendor_invoices vi ON gr.order_id = vi.order_id AND gr.item_id = vi.item_id;


CREATE TABLE final_inventory_comparison AS
SELECT 
    po.order_id,
    po.item_id,
    po.quantity AS po_qty,
    gr.quantity AS received_qty,
    vi.quantity AS invoiced_qty,
    po.price AS po_price,
    gr.price AS received_price,
    vi.price AS invoiced_price,
    CASE 
        WHEN po.quantity = gr.quantity AND gr.quantity = vi.quantity THEN TRUE 
        ELSE FALSE 
    END AS qty_match,
    CASE 
        WHEN po.price = gr.price AND gr.price = vi.price THEN TRUE 
        ELSE FALSE 
    END AS price_match,
    CASE 
        WHEN po.item_id = gr.item_id AND gr.item_id = vi.item_id THEN TRUE 
        ELSE FALSE 
    END AS item_match
FROM purchase_orders po
JOIN goods_receipts gr 
    ON po.order_id = gr.order_id AND po.item_id = gr.item_id
JOIN vendor_invoices vi 
    ON gr.order_id = vi.order_id AND gr.item_id = vi.item_id;


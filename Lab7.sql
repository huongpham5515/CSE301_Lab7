use salesmanagement;

-- 1. SQL statement returns the cities (only distinct values) from both the "Clients" and the "salesman" 
-- table
select city 
from clients union 
select city from salesman;

-- 2. SQL statement returns the cities (duplicate values also) both the "Clients" and the "salesman" table
select city 
from clients union all
select city from salesman;

-- 3. SQL statement returns the Ho Chi Minh cities (only distinct values) from the "Clients" and the 
-- "salesman" table.
select city 
from clients
where city = 'Ho Chi Minh' 
union 
select city from salesman
where city = 'Ho Chi Minh';

-- 4.SQL statement returns the Ho Chi Minh cities (duplicate values also) from the "Clients" and the 
-- "salesman" table
select city 
from clients
where city = 'Ho Chi Minh' 
union all
select city from salesman
where city = 'Ho Chi Minh';

-- 5. SQL statement lists all Clients and salesman
select client_name as Name, client_number as Number, 'Client' as Type
from clients
union
select salesman_name, salesman_number, 'Salesman'
from salesman;

-- 6. Write a SQL query to find all salesman and clients located in the city of Ha Noi on a table with 
-- information: ID, Name, City and Type.
-- from salesman;
select client_number as `Number`, client_name as `Name`, City, 'Client' as `Type`
from clients
where city = 'Hanoi'
union all
select salesman_number, salesman_name, City, 'Salesman'
from salesman
where city = 'Hanoi';

-- 7. Write a SQL query to find those salesman and clients who have placed more than one order. Return 
-- ID, name and order by ID.
select c.client_number as Number, c.client_name as Name, 'Client' as Type
from clients c
inner join salesorder so
on  c.Client_Number= so.Client_Number
group by c.Client_Number having count(so.Client_Number) > 1
union
select s.salesman_number, s.salesman_name, 'Salesman'
from salesman s
inner join salesorder so
on s.Salesman_Number = so.Salesman_Number
group by s.Salesman_Number having count(so.Salesman_Number) > 1
order by Number;

-- 8.Retrieve Name, Order Number (order by order number) and Type of client or salesman with the client 
-- names who placed orders and the salesman names who processed those order
select c.client_number as Number, c.client_name as Name, c.City, so.Order_Number, 'Client' as Type
from clients c
inner join salesorder so
on  c.Client_Number= so.Client_Number
union all
select s.salesman_number, s.salesman_name, s.City, so.Order_Number, 'Salesman'
from salesman s
inner join salesorder so
on s.Salesman_Number = so.Salesman_Number
order by Order_Number;

-- 9. Write a SQL query to create a union of two queries that shows the salesman, cities, and 
-- target_Achieved of all salesmen. Those with a target of 60 or greater will have the words 'High 
-- Achieved', while the others will have the words 'Low Achieved
select s.salesman_number, s.salesman_name, s.City, s.Target_Achieved, 'High Achieved' as 'Target'
from salesman s
where s.Target_Achieved >= 60 
union 
select s.salesman_number, s.salesman_name, s.City, s.Target_Achieved, 'Low Achieved' as 'Target'
from salesman s
where s.Target_Achieved < 60;

-- 10. Write query to creates lists all products (Product_Number AS ID, Product_Name AS Name, 
-- Quantity_On_Hand AS Quantity) and their stock status. Products with a positive quantity in stock are 
-- labeled as 'More 5 pieces in Stock'. Products with zero quantity are labeled as ‘Less 5 pieces in Stock'
select product_number as ID, product_name as Name, Quantity_On_Hand as Quantity, 'More 5 pieces in stock' as 'Labeled'
from product
where Quantity_On_Hand > 0
union 
select product_number as ID, product_name as Name, Quantity_On_Hand as Quantity, 'Less 5 pieces in stock' as 'Labeled'
from product
where Quantity_On_Hand <= 0;


-- 11. Create a procedure stores get_clients _by_city () saves the all Clients in table. Then Call procedure stores.
Delimiter $$
create procedure get_clients_by_city()
begin 
select * from clients;
end;
$$
call get_clients_by_city();

-- 12. Drop get_clients _by_city () procedure stores.
drop procedure get_clients_by_city;

-- 13. Create a stored procedure to update the delivery status for a given order number. Change value  
-- delivery status of order number “O20006” and “O20008” to “On Way”.
Delimiter $$
create procedure updateDeliveryStatus()
begin 
update salesorder
set delivery_status = 'On Way'
where order_number in ('O20006', 'O20008');
end;
$$
call updateDeliveryStatus();

-- 14. Create a stored procedure to retrieve the total quantity for each product.
Delimiter $$
create procedure totalQuantity()
begin
select product_name, total_quantity
from product;
end;
$$
call totalQuantity();

-- 15. Create a stored procedure to update the remarks for a specific salesman.
Delimiter $$
create procedure updateRemark(in salesNumber varchar(15), in remarkchange varchar(20))
begin
update salesman
set remark = remarkchange
where salesman_number = salesNumber;
end;
$$

-- 16. Create a procedure stores find_clients() saves all of clients and can call each client by client_number.
Delimiter $$
create procedure find_clients(in n_client_number varchar(10))
begin
select * from clients where Client_Number = n_client_number;
end;
$$

-- 17. Create a procedure stores salary_salesman() saves all of clients (salesman_number, salesman_name, 
-- salary) having salary >15000. Then execute the first 2 rows and the first 4 rows from the salesman 
-- table.
Delimiter $$
create procedure salary_salesman(in a int)
begin
select salesman_number, salesman_name, salary
from salesman where salary > 15000 limit a;
end;
$$
call salary_salesman(2);
call salary_salesman(4);

-- 18. Procedure MySQL MAX() function retrieves maximum salary from MAX_SALARY of salary table.
Delimiter $$
create procedure max_salary()
begin 
select max(salary) from salesman;
end;
$$
call max_salary();

-- 19. Create a procedure stores execute finding amount of order_status by values order status of salesorder 
-- table.
Delimiter $$
create procedure find_amount_orderstatus()
begin
select order_status, count(Order_Status) from salesorder
group by Order_Status;
end;
$$
call find_amount_orderstatus();

-- 20. Create a stored procedure to calculate and update the discount rate for orders.

-- 21. Count the number of salesman with following conditions : SALARY < 20000; SALARY > 20000; 
-- SALARY = 20000.
Delimiter $$
create procedure find_salary()
begin
select sum(case when salary < 20000 then 1 else 0 end) as less_20000,
		sum(case when salary > 20000 then 1 else 0 end) as more_20000,
		sum(case when salary = 20000 then 1 else 0 end)  equal_20000
from salesman;
end;
$$
call find_salary();

-- 22. Create a stored procedure to retrieve the total sales for a specific salesman.
Delimiter $$
create procedure totalsales(in salesNum varchar(15))
begin
select sum(sod.Order_Quantity * p.Sell_Price) as totalSales from salesorderdetails sod
inner join salesorder so 
on so.Order_Number = sod.Order_Number
inner join product p
on p.Product_Number = sod.Product_Number
where so.Salesman_Number = salesNum
group by salesNum;
end;
$$
call totalsales('S003');

-- 23. Create a stored procedure to add a new product: Input variables: Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, Sell_Price, 
-- Cost_Price.
Delimiter $$
create procedure addaNewProduct(n_p_num varchar(15), n_p_name varchar(25), n_qon int, n_qs int, 
n_sell decimal(15,4), n_cp decimal(15,4))
begin
insert into product(Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, Sell_Price,
Cost_Price)
values(n_p_num, n_p_name, n_qon , n_qs,  n_sell, n_cp);
end;
$$
call addaNewProduct('P1009', 'Glass', '10', '5', '150.000', '90.000');
-- delete from product
-- where product_number = 'P1009';

-- 24. Create a stored procedure for calculating the total order value and classification:
-- - This stored procedure receives the order code (p_Order_Number) và return the total value 
-- (p_TotalValue) and order classification (p_OrderStatus).
-- - Using the cursor (CURSOR) to browse all the products in the order (SalesOrderDetails ).
-- - LOOP/While: Browse each product and calculate the total order value.
-- - CASE WHEN: Classify orders based on total value:
-- Greater than or equal to 10000: "Large"
-- Greater than or equal to 5000: "Midium"
-- Less than 5000: "Small"

Delimiter $$
create procedure calculate_total_order_and_classification(in p_Order_Number varchar(15), out sum decimal(15, 4), out clarity char(15))
    begin
        
        DECLARE done INT DEFAULT FALSE;
        DECLARE temp_order_quantity int;
        DECLARE temp_sell_price decimal(15, 4);
        DECLARE cur_order cursor for 
                            select order_quantity, sell_price 
                            from salesorderdetails sod join product p on p.product_number = sod.product_number
                            where sod.order_number = p_Order_Number;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
         set sum = 0;
        open cur_order;
        read_loop: LOOP
            fetch cur_order into temp_order_quantity, temp_sell_price;
            set sum = sum + (temp_order_quantity * temp_sell_price);
            if done then
                leave read_loop;
            end if;
        end loop;
        CASE
            WHEN sum >= 10000 THEN SET clarity = 'Large';
            WHEN sum >= 5000 THEN SET clarity = 'Medium';
            ELSE SET clarity = 'Small';
        END CASE; 
    CLOSE cur_order;
end;
$$

select * from salesorderdetails;
select * from product;
set @sum = 0;
set @clarity = "";
call calculate_total_order_and_classification('O20001', @sum, @clarity);
select @sum;
select @clarity;

CREATE database ecommerce;
use ecommerce;
create table supplier(
supp_id int primary key, 
supp_name varchar(50) not null,
supp_city varchar(50) not null,
supp_phone varchar(50) not null
);
insert into supplier(supp_id, supp_name, supp_city, supp_phone)
values
(1, "Rajesh Retails","Delhi","1234567890"),
(2, "Appario Ltd.","Mumbai","2589631470"),
(3, "Knome products","Banglore","9785462315"),
(4, "Bansal Retails","Kochi","8975463285"),
(5, "Mittal Ltd.","Lucknow","7898456532");
drop table supplier;
create table customer(cus_id int primary key, cus_name varchar(20) not null,cus_phone varchar(10) not null,cus_city varchar(30) not null,cus_gender char);
insert into customer(cus_id, cus_name, cus_phone, cus_city, cus_gender)
values
(1, "AAKASH","9999999999","DELHI",'M'),
(2,"AMAN","9785463215","NOIDA",'M'),
(3,"NEHA","9999999999","MUMBAI",'F'),
(4,"MEGHA","9994562399","KOLKATA",'F'),
(5,"PULKIT","7895999999","LUCKNOW",'M');
create table category(cat_id int primary key, cat_name varchar(20) not null);
insert into category(cat_id, cat_name)
values
(1,"BOOKS"),
(2,"GAMES"),
(3,"GROCERIES"),
(4		,"ELECTRONICS"),
(5		,"CLOTHES");
create table product(
pro_id int primary key, 
pro_name varchar(20) not null default 'dummy',
pro_desc varchar(60), 
cat_id int ,
foreign key (cat_id) references category(cat_id)
);
insert into product(
pro_id, 
pro_name,
pro_desc, 
cat_id
)
values
(1,		"GTA V",			"Windows 7 and above with i5 processor and 8GB RAM",		2),
(2,		"TSHIRT",		"SIZE-L with Black, Blue and White variations",			5),
(3,		"ROG LAPTOP",		"Windows 10 with 15inch screen, i7 processor, 1TB SSD",		4),
(4,		"OATS",			"Highly Nutritious from Nestle",					3),
(5,		"HARRY POTTER", "Best Collection of all time by J.K Rowling",				1),
(6,		"MILK",			"1L Toned MIlk",								3),
(7,		"Boat Earphones",	"1.5Meter long Dolby Atmos",						4),
(8,		"Jeans",			"Stretchable Denim Jeans with various sizes and color",		5),
(9,		"Project IGI",		"compatible with windows 7 and above",				2),
(10,		"Hoodie",			"Black GUCCI for 13 yrs and above",					5),
(11,		"Rich Dad Poor Dad",	"Written by RObert Kiyosaki",						1),
(12,		"Train Your Brain",	"By Shireen Stephen",							1);

create table supplier_pricing(
pricing_id int primary key,
pro_id int,
supp_id int,
supp_price int default 0,
foreign key (pro_id) references product(pro_id),
foreign key (supp_id) references supplier(supp_id)
);
insert into supplier_pricing(
pricing_id,
pro_id,
supp_id,
supp_price)
values
(1,		1,			2,	1500),
(2,		3,			5,	30000),
(3,		5,			1,	3000),
(4,		2,			3,	2500),
(5,		4,			1,	1000);

create table `order`(
ord_id int primary key,
order_amount int not null,
ord_date date not null,
cus_id int,
pricing_id int,
foreign key (cus_id) references customer(cus_id),
foreign key (pricing_id) references supplier_pricing(pricing_id)
);
insert into `order`(
ord_id,
order_amount,
ord_date,
cus_id,
pricing_id
)
values
(101,			1500,		"2021-10-06",	2,		1),
(102,			1000,		"2021-10-12"	,3,		5),
(103,			30000,		"2021-09-16"	,5,		2),
(104,			1500,		"2021-10-05"	,1,		1),
(105,			3000,		"2021-08-16",	4,		3),
(106,			1450,		"2021-08-18",	1,		5),
(107,			789	,	"2021-09-01",	3		,3),
(108,			780	,	"2021-09-07",	5		,4),
(109,			3000,		"2021-09-10",	5,		3),
(110,			2500,		"2021-09-10",	2,		4),
(111,			1000,		"2021-09-15",	4,		5),
(112,			789	,	"2021-09-16",	4,		5),
(113,			31000,		"2021-09-16",	1,		5),
(114,			1000	,	"2021-09-16",	3,		5),
(115,			3000	,	"2021-09-16",	5,		3),
(116,			99		,"2021-09-17",	2,		4);

create table rating(
rat_id int primary key,
ord_id int,
rat_ratstars int not null,
foreign key (ord_id) references `order`(ord_id)
);
insert into rating(rat_id,
ord_id,
rat_ratstars
)
values
(1,		101	,	4),
(2	,	102	,	3),
(3	,	103	,	1),
(4	,	104	,	2),
(5	,	105	,	4),
(6	,	106	,	3),
(7	,	107	,	4),
(8	,	108	,	4),
(9	,	109	,	3),
(10	,	110	,	5),
(11	,	111	,	3),
(12	,	112	,	4),
(13	,	113	,	2),
(14	,	114	,	1),
(15	,	115	,	1),
(16	,	116,		0);

-- Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.

select COUNT(c.cus_id) as count, c.cus_gender from  `order` ord inner join customer c on c.cus_id = ord.cus_id where ord.order_amount>=3000 group by c.cus_gender;

-- Display all the orders along with product name ordered by a customer having Customer_Id=2

select ord.cus_id, cus.cus_name, prd.pro_name, prd.pro_desc from `order` ord inner join supplier_pricing sp on sp.pricing_id = ord.pricing_id inner join product prd on prd.pro_id = sp.pro_id inner join customer cus on cus.cus_id = ord.cus_id where ord.cus_id=2;

-- Display the Supplier details who can supply more than one product.

select * from supplier sp inner join 
( select supp_id, count(pro_id) as count from supplier_pricing group by supp_id )
as sup on sup.supp_id = sp.supp_id where sup.count>1;

-- Find the least expensive product from each category and print the table with category id, name, product name and price of the product

select c.cat_id,c.cat_name,t1.pro_name,min(t1.minPrice) from category c inner join
( select prd.cat_id,prd.pro_name, t2.pro_id,t2.minPrice from product prd inner join
	(select sp.pro_id, min(sp.supp_price) as minPrice from supplier_pricing sp group by sp.pro_id
    )as t2 on prd.pro_id = t2.pro_id
)as t1 on t1.cat_id = c.cat_id group by t1.cat_id, t1.pro_name;
    
-- Display the Id and Name of the Product ordered after “2021-10-05”.
select p.pro_id, p.pro_name from `order` ord inner join supplier_pricing sp on sp.pricing_id=ord.pricing_id inner join product p on p.pro_id=sp.pro_id where ord.ord_date>'2021-10-05';

-- Display customer name and gender whose names start or end with character 'A'.
select c.cus_name, c.cus_gender from customer c where c.cus_name like 'A%' or c.cus_name like '%A';

-- Create a stored procedure to display supplier id, name, rating and Type_of_Service. For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average Service” else print “Poor Service”.

DELIMITER //
create procedure review()
begin
	select report.supp_id, report.supp_name,report.rating,
    case
		when report.rating>4 then 'Genuine Supplier'
        when report.rating>2 then 'Average Supplier'
        else
        'Supplier should not be considered'
        end as supplier_review
	from (select s.supp_id,s.supp_name,v.average as rating from supplier s inner join
			(select sp.supp_id, avg(rt.rat_ratstars) as average from `order` ord inner join
				rating rt on rt.ord_id = ord.ord_id inner join
					supplier_pricing sp on sp.pricing_id=ord.pricing_id
                    group by sp.supp_id
			)as v on v.supp_id=s.supp_id
		 )as report;
end //
DELIMITER ;
call review();
create database analysis;
use analysis;
#---data exploration #
select * from zepto limit 10;
select count(*) from zepto;----#count of rows;
ALTER TABLE zepto
CHANGE COLUMN `ï»¿Category` Category VARCHAR(255);
select * from zepto
where Category is null
or name is null
or mrp is null
or discountPercent is null
or availableQuantity is null
or discountedSellingPrice is null
or weightInGms is null
or outOfStock is null
or quantity is null;---#to check nulls 

#different categories#
select distinct Category,count(*) from zepto
group by Category;

select outOfStock,count(*)###count of stock details ##
from zepto
group by outOfStock;

select name,count(name)
from zepto 
group by name
order by count(name) desc;###to get product details ##

select distinct name from zepto;

##data cleaning##
select name ,mrp from zepto where mrp=0 or discountedSellingPrice=0;
###convert paise to rupees
update zepto
set mrp=mrp/100,discountedSellingPrice=discountedSellingPrice/100
where mrp<>0 or discountedSellingPrice<>0;

###business requirements ###
##q1.Find the top 10 best-value products based on the discount percentage.
select name,mrp,discountPercent from zepto 
order by discountPercent desc
limit 10;

###q2.Q2.What are the Products with High MRP but Out of Stock
select distinct name,mrp from zepto
where outOfStock= 'TRUE'
order by mrp desc
LIMIT 15;
###q3.Calculate Estimated Revenue for each category
select Category,sum(discountedSellingPrice* availableQuantity) as estimated_revenue
from zepto 
group by Category
order by estimated_revenue desc;
####q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
select name,discountPercent,mrp from zepto 
where mrp>500 and discountPercent<10
group by name,discountPercent,mrp
order by discountPercent desc;
###q5.Identify the top 5 categories offering the highest average discount percentage.
SELECT Category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY Category
ORDER BY avg_discount DESC
LIMIT 5;
###q6.Find the price per gram for products above 100g and sort by best value.
select distinct name,round((discountedSellingPrice/weightInGms),2) as price_per_gram
from zepto where weightInGms>=100
order by price_per_gram desc;

##q7.Group the products into categories like Low, Medium, Bulk.
select distinct name,weightInGms,
case when weightInGms <= 1000 then 'low'
when weightInGms<5000 then 'medium'
else 'bulk'
end as categ
from zepto;
###q8.What is the Total Inventory Weight Per Category 
select distinct Category,sum(weightInGms*availableQuantity) as tot_invetory
from zepto
group by  Category
order by tot_invetory desc;
##########
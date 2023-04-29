
#Inspect the table schema
postgres=# \d+ retail;
                                     Table "public.retail"
    Column    |            Type             | Modifiers | Storage  | Stats target | Description
--------------+-----------------------------+-----------+----------+--------------+-------------
 invoice_no   | text                        |           | extended |              |
 stock_code   | text                        |           | extended |              |
 description  | text                        |           | extended |              |
 quantity     | integer                     |           | plain    |              |
 invoice_date | timestamp without time zone |           | plain    |              |
 unit_price   | real                        |           | plain    |              |
 customer_id  | real                        |           | plain    |              |
 country      | text                        |           | extended |              |
Has OIDs: no


#Q1: Show first 10 rows

postgres=# select * from retail limit 10;
 invoice_no | stock_code |             description             | quantity |    invoice_date     | unit_price | custom
er_id |    country
------------+------------+-------------------------------------+----------+---------------------+------------+-------
------+----------------
 489434     | 85048      | 15CM CHRISTMAS GLASS BALL 20 LIGHTS |       12 | 2009-12-01 07:45:00 |       6.95 |
13085 | United Kingdom
 489434     | 79323P     | PINK CHERRY LIGHTS                  |       12 | 2009-12-01 07:45:00 |       6.75 |
13085 | United Kingdom
 489434     | 79323W     |  WHITE CHERRY LIGHTS                |       12 | 2009-12-01 07:45:00 |       6.75 |
13085 | United Kingdom
 489434     | 22041      | RECORD FRAME 7" SINGLE SIZE         |       48 | 2009-12-01 07:45:00 |        2.1 |
13085 | United Kingdom
 489434     | 21232      | STRAWBERRY CERAMIC TRINKET BOX      |       24 | 2009-12-01 07:45:00 |       1.25 |
13085 | United Kingdom
 489434     | 22064      | PINK DOUGHNUT TRINKET POT           |       24 | 2009-12-01 07:45:00 |       1.65 |
13085 | United Kingdom
 489434     | 21871      | SAVE THE PLANET MUG                 |       24 | 2009-12-01 07:45:00 |       1.25 |
13085 | United Kingdom
 489434     | 21523      | FANCY FONT HOME SWEET HOME DOORMAT  |       10 | 2009-12-01 07:45:00 |       5.95 |
13085 | United Kingdom
 489435     | 22350      | CAT BOWL                            |       12 | 2009-12-01 07:46:00 |       2.55 |
13085 | United Kingdom
 489435     | 22349      | DOG BOWL , CHASING BALL DESIGN      |       12 | 2009-12-01 07:46:00 |       3.75 |
13085 | United Kingdom
(10 rows)


Q2: Check # of records

postgres=# select count(*) from retail;
  count
---------
 1067371
(1 row)

Q3: number of clients (e.g. unique client ID)

postgres=# select count(distinct customer_id) from retail;
 count
-------
  5942
(1 row)

Q4: invoice date range (e.g. max/min dates)

postgres=# select max(invoice_date) as max, min(invoice_date) as min from retail;
         max         |         min
---------------------+---------------------
 2011-12-09 12:50:00 | 2009-12-01 07:45:00
(1 row)

Q5: number of SKU/merchants (e.g. unique stock code)

postgres=# select count(distinct stock_code) from retail;
 count
-------
  5305
(1 row)

Q6: Calculate average invoice amount excluding invoices with a negative amount (e.g. canceled orders have negative amount)


postgres=# select avg(invoice) from (select sum(unit_price*quantity) as invoice from retail group by invoice_no having sum(unit_price*quantity)>0) as avg_invoice;
       avg
-----------------
 523.30375861254
(1 row)

Q7: Calculate total revenue (e.g. sum of unit_price * quantity)

postgres=# select sum(unit_price*quantity) as Tot_rev from retail;
     tot_rev
------------------
 19287250.4815679
(1 row)

Q8: Calculate total revenue by YYYYMM

postgres=# select concat(year,m) as yyyymm, sum(unit_price*quantity) as sum  from (select (cast(extract(YEAR FROM invoice_date) as text)) as year, (cast(extract(MONTH from invoice_date) as text) ) as m,unit_price, quantity  from retail) as yearmonth group by yyyymm order by yyyymm asc;

 yyyymm |       sum
--------+------------------
 200912 |  799847.10702483
 20101  |  624032.88899884
 201010 | 1045168.34560464
 201011 | 1422654.63578795
 201012 | 1126445.46600707
 20102  | 533091.423987399
 20103  | 765848.757352209
 20104  |  590580.42922299
 20105  | 615322.827583108
 20106  |  679786.60663899
 20107  | 575236.358301353
 20108  | 656776.337579533
 20109  | 853650.428091871
 20111  | 560000.257261246
 201110 | 1070704.66378935
 201111 | 1461756.24248293
 201112 |  433686.00760667
 20112  | 498062.648327291


# Introduction
- The project is based on the Gift store, London Gift Shop(LGS). The marketing team wants to upgrade on technology to develop sales and marketing technique
- As a Data Engineer, we takes the resposibility to help LGS by analysing customer shopping behaviour
- The LGS marketing team will use your analytics to develop targeted marking campaigns (e.g. email, events, target promotions, etc..) to attract new and existing customers.
- To solve all the business requirement, we used Python, Jupyter Notebook, Pandas Dataframe, Numpy, data warehouse and data analytics

# Implementaion
## Project Architecture
- The transaction data between 01/12/2009 and 09/12/2011 is dumped into sql file and shared with us
- Sql file is loaded to Datawarehouse and with the help of jupyter notebook data have been analysed

<img width="499" alt="image" src="https://user-images.githubusercontent.com/108684293/235561010-5adde3dd-40de-45dd-b275-ba831cc5ff04.png">

## Data Analytics and Wrangling

Jupyter Notebook link:
https://github.com/Jarvis-Consulting-Group/jarvis_data_eng-KalaivaniKG/blob/develop/python_data_analytics/psql/python_data_wrangling/retail_data_analytics_wrangling.ipynb
- Based on purchase history, customers are divided into 3 segments, "Can't Lose", "Hibernating" and "Champions".
- Number of customers for segments:
      Can't Lose = 71, Hibernating = 1522, Champions = 852
- Can't Lose Segment;
The last shopping date of the customers is on average 353 days before.
Customers have made an average of 16 purchases.
Customers spent an average of £ 8356.

- Hibernating Segment;
The last shopping date of the customers is 481 days before average.
Customers made an average of 1 purchases.
Customers spent an average of £ 438.

- Champions Segment;
The last shopping date of the customers is 30 days before average.
Customers made an average of 19 purchases.
Customers spent an average of £ 10796.

Can't Lose Segment;
Customers in this segment have not recently made a purchase. For this reason, we need to prepare a discount and gift campaign for this segment. These customers made a large number of purchases when they made purchases before. However, recency values are lower than they should be. The campaign to be implemented for these customers should include both items purchased and recommendations based on previous activities. New and popular products associated with the products that they were interested in can also be included in this campaign. Situations that will cause these customers to stop buying need to be investigated.

Hibernating Segment;
Customers in this segment have not made a purchase for a long time. However, by offering discounts, they may be attracted to another purchase.

Champions Segment;
Customers in this segment are responsible for most of the revenue. Campaigns should be implemented to ensure the continuity of the shopping of these customers.

# Improvements
- Customers could be divided based on their interest and promotions can be given
- check on revenues based on customers address

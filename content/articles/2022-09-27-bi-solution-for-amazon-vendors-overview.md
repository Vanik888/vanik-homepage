+++
date = 2022-07-04
isPopular = false
tags = ["data engineering", "dbt", "sqlfluff"]
thumbnailPath = "/self/img/thumbs/laptop-tech.jpg" #TODO find a good pic
title = "Overview of Business Intelligence solution for Amazon Vendors"
+++

# Intro
In this post I would like to talk about the Business Intelligence solution 
for Amazon Vendors we build in FACTOR-A/DEPT. I will shed some light on platforms 
Amazon provides for the Vendors, and the challenges it brings to the data teams. 

## Some terms before we start
**Vendors** are big enterprises that produce and sell their products on Amazon on
a large scale, they are key suppliers for Amazon.

**ASIN** - a unique identifier used insided of Amazon for every product, ie product ID
inside of Amazon.

# Platforms
## Advertising Platform
Advertising platform allows the vendors to set up ad campaigns that will be shown 
on the Amazon marketplace itself. The ads appear on various spots in 
the search result page and product detail page.
Amazon provides the following reports:
- campaigns 
- keywords
- search terms
- asin 

In most of the cases the Vendors are interested in campaign and asin reports. The 
first one provides a high level overview on the marketing campaigns, 
the latter provides more detailed information on the product level. 
In this overview for the simplicity we will skip the keywords & search terms 
reports although they have high value for the Vendors.


## DSP
The Demand Side Platform (DSP) which was introduced in the early 2020 
became an important tool for the Amazon Vendors. It allows to run advertising 
campaigns outside of Amazon itself. For instance, in the mobile apps, 
arbitrary retailing web-sites. The idea behind is to drive the traffic 
from third-party platforms to Amazon and increase the sales within Amazon itself.
The reports provided in DSP:
- Campaign
- Inventory
- Audience
- Product
- Tech And Geo

Again, for the simplicity reasons in this article we will focus only on the Campaign and Product reports.

## Vendor Central
The Vendor central is the main platform for the vendors. It is a place 
where the vendors upload their assortment, the content, pictures, bullet points 
for products, and last but not least download the retail related reports such 
as organic sales reports.

The reports available:
- Sales
- Inventory Health
- Amazon Search Terms
- Forecasting
- Net Pure Product Margin
- Traffic

[comment]: <> (# The business side)
# Limitations on Amazon
The data provided by Amazon has some limitations you need to consider when you start
a BI project. From the business side the obstacle you face working on Amazon is 
the *data availablility* and *data integration*

## Data integration
As it was mentioned earlier amazon offers 3 main platforms for their vendors 
(Advertising Platform, DSP, Vendor Central).
So the first challenge would be to pool the data from these 3 platforms. Unfortunetly,
amazon does not have any integration tools for these platforms, they are completely 
independant by design, there is no single sign on (SSO) that would simplify the login process.
Not to mention the fact that even within Vendor Central itself the Vendors are forsed 
to have independent accounts per country.
Now imagine how much time would it take to build a global overview of advertising, DSP 
and retail for a Vendor? In practice, it would mean that you need to:
1. login to the Advertising platform <br/>
   
   1.1 chose the account you need <br/>
   
   1.2 navigate to the reports <br/>
   
   1.3 download the reports <br/>
   

2. login to the DSP <br/>
   
   2.1 chose the account you need <br/>
      
   2.2 navigate to the reports <br/>
      
   2.3 download the reports <br/>

3. login to the Vendor Central <br/>
   
   3.1 navigate to the reports <br/>
   
   3.2 download the reports <br/>
   
and you have to repeat same steps for every country where you sell your products.
Once the reports are collected your teem needs to combine dozens of spreadsheets in 
a meaningful way and provide the final report. 
Hopefully, there were no mistakes in between, so you can lean your business decisions 
on this manual process.
Now imagine, that you have to repeat same steps next week/month, depending 
how often you review your numbers.
Obviously, this approach is error-prone, time-consuming and painful.


At the moment of writing there was no solution on the market that would solve most of 
the integration problems on Amazon.

## Data availability
In all of the 3 platforms Amazon set limits on both the *history available* to download, 
and the *level of detail (granularity*) of reports.

![Drag Racing](/self/img/2022-09-27-bi-solution-for-amazon-vendors-overview/amazon_grane_and_limits.png)

The limited history in Advertising and DSP requires extra passion when developing 
the data consumers, any issue/bug with data-consumers on production might lead to
the gaps in data, which will not be available anymore.

## Data reliability
Having more than 4 years experience with data from Amazon we revealed extraordinary number
of cases when Amazon changes the numbers back in the past. The reports from Vendor Central
Are heavily affected by this issue. Although, the minor changes and volatility of 
retail data is expected due to the product returns/amazon internal cache issues/data lags 
the changes amazon introduces to the historical reports go beyond expected borders.
Particularly, the numbers might change for the reports more than 12 months old with the 
order of magnitude of 10-15% in mission-critical metrics.
In practice, it means that the reports you have downloaded last week/month/quarter will not
match with the same reports downloaded today. 
Since most of the customers would  use the UI of Vendor Central as a source of the truth,
they would expect to see the same numbers in the DWH. 
Which makes the *incremental updates* (last week/month) impossible, because the data might change back in the 
history for no reason. However, the full re-downloads are also quite expensive in terms of
the resources and costs, furthermore, they will not save as from the cases when amazon 
updates the history older than 12 moths, since it will not be available for re-download through the API.
In our team were able to build a tradeoff between the cots and the data discrepancies.
We have build automation scripts that do check the current values in the Vendor Central UI on regular basis,
the number are then compared with the numbers in DWH and for the months with discrepancies 
more than 3% on we trigger re-downloads.

## Data consistency
Another criteria, which is highly related with the data reliability is the data consistency.
Back in the past, we revealed various cases when the number in Adverting UI dashboards, 
Advertising API and Advertising downloadable reports do not match between each other.
Although, we haven't seen these issues within last couple of years, the risk that amazon
messes up the data is always there.
Unfortunately, we can not fix the data-issues in this case, due to the fact that all 
available sources show different numbers.

# DWH Architecture
Under this section I will provide a bird eye view on the Architecture of our BI product.
On the very high level the architecture is broken on the:
- data collection area
- data processing area
- data representation area
![The architecture](/self/img/2022-09-27-bi-solution-for-amazon-vendors-overview/bi_architecture_schema.png)
  
The main purpose of the *data collection area* is to pull the data from Amazon and store 
it in our Data Lake (Google Cloud Storage) for the long term storage.
The downloads are established in incremental manner, meaning every day we do download 
the recent updates from Amazon. 

The data from the Data Lake gets consumed by the *processing area*, where the ELT processing
is happening. Here, the data is stored in BigQuery, the transformations are implemented 
using *dbt*, and the final reporting layer is exposed for the representation area.
The goal of the representation area is to make the data available for consumption. 
And here we have two options, the first option is to provide regular dumps 
of the "raw" data through Google Cloud Storage buckets. This option is usually 
preferable for our customers who already have data teams internally and some 
sort of BI tools implemented. Depending on the customer specifics
they might have some basic sources connected to BI, like 
Facebook/Instagram/Google Ads reports, internal ERP, CRM systems or any other 
source based on the internal processes of the customer. So, the amazon data is the 
only missing piece of the puzzle. 
The second option we offer to our customers are the BI Dashboards. The dashboards are
highly configurable and can reflect all of the aspects of the cusomer busines in Amazon.
We can build drill down views starting from the top level view on all of the accounts 
in all of the regions till the detailed view on a specific product in a specific 
country and amazon account.

# Summary
Overall, running business on Amazon is highly complicated. Once the sellers make
it through by passing all non-trivial burocratic steps on initialisation phase, they run
into completely another set of ongoing data related problems. Being truly 
data-driven is crucial for many of the customers, since the Amazon market is highly 
competitive, and you have to be smart when it comes to marketing and sales strategies. 
Ideally, all of your decisions should be backed by data 
(reliable, fresh, accurate, and trustworthy data). As we covered in the amazon limitation section
amazon lacks of data availability and integration. We in Factor-a try to solve many
of the challenges on Amazon through our Business Intelligence solution equipping our 
customers with a powerful tool, that of course will not make their business successfull 
right away, but at will definitely help to set their path towards that direction.


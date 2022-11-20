+++
date = 2022-07-04
isPopular = false
tags = ["amazon", "api", "data engineering"]
thumbnailPath = "/self/img/thumbs/laptop-tech.jpg" #TODO find a good pic
title = "Data challenges in Amazon Vendor Central"
+++

### Intro
Hi everyone, in this article I am going to shed some light on the Amazon Vendor Central
and explain the challenges that every data engineer faces working with data from 
Amazon Marketplace.

But first things first. What is Vendor Central and who are the vendors? <br />

**Vendors** are big enterprises that produce and sell their products on Amazon on
a large scale, they are key suppliers for Amazon. 

[**Vendor Central**](https://vendorcentral.amazon.com/) is a platform where the vendors 
manage their sales on Amazon.
Particularly, load the assortment, add content (images, description, title, bullet points, etc.)
and last but not least - download the reports.

### Vendor Central accounts setup
The **vendor central**, in fact, is not... centralised. What does it mean?
It means that if you are a large enterprise and you sell your products in 
multiple countries, then:
1. you would have to use separate web-apps for each country
([here](https://developer-docs.amazon.com/sp-api/docs/vendor-central-urls) you can find
full list of apps per country)
2. the apps would have separated/indepedent accounts for each of the country
##### Example
Imagine you are an enterprise XYZ and you sell your products in:
1. Germany
2. France
3. Italy
4. US

Then, you would use the following web-apps:
1. https://vendorcentral.amazon.de for Germany
2. https://vendorcentral.amazon.fr for France
3. https://vendorcentral.amazon.it for Italy
4. https://vendorcentral.amazon.com for US

For each of the account you would have to use separate pair of email/password:
1. vc@xyz.de for Germany
2. vc@xyz.fr for France
3. vc@xyz.it for Italy
4. vc@xyz.us for US

Now imagine you would need to make a monthly sales performance report 
to have an understanding of how the sales are doing on Amazon.
To provide such a report your team needs to login into each of the web-app, 
navigate to the dashboards and download the csv/excell file. Then those files has to be 
somehow processed:
1. the sales has to be converted to the base currency
2. the column names needs to be adjusted
3. the files have to be combined together to provide the total values

### Vendor Central reports
As we, tech folks are interested in what Amazon can provide, let's talk about data.


From the very begining till recent days Amazon Vendor Central did not have an API.

What it means, it means

The limitations on amazon can be splited by two groups:
- Data integration
- Data consistency
- Data availability
- Data reliability
#### Data consistency
The data that comes from Amazon has 

From the business side, Amazon does not focus on the solutions for Vendors or 
Sellers as much as they do for their usual buyers.
When it comes to the Vendor, Amazon provides a bare minimum- ability to download csv/xlsx 
reports and some basic graphs in Amazon Ads and DSP.

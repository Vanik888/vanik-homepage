+++
date = 2022-10-07
isPopular = false
tags = ["BigQuery", "gcp", "data engineering"]
thumbnailPath = "/self/img/articles/2022-10-07-biq-query-history/thumb1.jpeg" #TODO find a good pic
title = "Travels in time with BigQuery"
+++

The travels in time are possible in BigQuery. Not many of the BigQuery users
are aware of this feature, although it might be incredibly useful in a daily 
life of any data engineer.
There are multiple occasions when you can leverage the benefits of using `time travel`.
Imagine, you run a data pipeline that breaks the result table, or you
did a mistake in your sql query that destroyed a table used by other team-mates.
In all of these cases you can restore the table from the most recent state.
```.sql
SELECT *
FROM `MY_DATASET.MY_TABLE`
  FOR SYSTEM_TIME AS OF TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR);
```
here the `SYSTEM_TIME` defines the exact time stamp from which we would like
to restore the state from, in this case it will be the point of time in 1 
hours from now, the format would be "2022-11-07 10:44:28.409401 UTC".

Another case when you would use the `time travel` more often is the troubleshooting.
If you are wondering when a specific part of the data was introduced to the
table, or how a specific subset of rows was changing over the last 7 days, you can 
leverage the following query:

```sql
SELECT
* except (_CHANGE_TYPE,_CHANGE_TIMESTAMP),
_CHANGE_TYPE AS change_type,
_CHANGE_TIMESTAMP AS change_time
FROM
APPENDS(TABLE MY_DATASET.MY_TABLE, TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY), NULL);
```

here `APPENDS` returns a table of all rows appended to a table for a given time range
```sql
APPENDS(
  TABLE table,
  start_timestamp DEFAULT NULL,
  end_timestamp DEFAULT NULL)
```
where 
- **start_timestamp** - the earliest time at which a change is included in the output,
the NULL would include all the changes since the table creation.
- **end_timestamp** is a TIMESTAMP indicating the latest time, exclusive, 
at which a change is included in the output. If it is NULL, 
all changes made until the start of the query are included.
  

## The limitations
#### 1. Storage time
BigQuery can be configured to store from 2 up to 7 days of history. The
default configuration is 7 days. 
In case if the data is not available anymore, you will get the following error
```.sql
Invalid snapshot time 1601168925462 for table
MY_PROJECT:MY_DATASET.MY_TABLE@1601168925462. Cannot read before 1601573410026.
```

There are several occasions when you would like to have a longer time window.
In those cases the BigQuery [snapshots](https://cloud.google.com/bigquery/docs/table-snapshots-intro) 
would be a better option.

#### 2. Row Level Security
If you have tables with row level security configured, then you would need to have 
Admin priviliges to these tables to access the functionality of the `time travel`.
Particularly, the roles:
- `bigquery.rowAccessPolicies.overrideTimeTravelRestrictions`
- `roles/bigquery.admin`

on the table level are required.

## Summary
The `time travel` is a powerful feature of the BigQuery, it might come in
handy on emergency situations as well as in a daily Data Engineering routine. 
And as many other tools it requires some conciseness. 
It needs to be used wisely, since the
storage and queries will affect the end cost of the usage. 







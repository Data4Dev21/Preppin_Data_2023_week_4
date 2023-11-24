/*Data Source Bank acquires new customers every month.
They are stored in separate tabs of an Excel workbook so it's "easy" to see which customers joined in which month.
However, it's not so easy to do any comparisons between months. Therefore, we'd like to consolidate all the months into one dataset. 
There's an extra twist as well. The customer demographics are stored as rows rather than columns, which doesn't make for very easy reading.
So we'd also like to restructure the data.*/

/*Requirements
We want to stack the tables on top of one another, since they have the same fields in each sheet. We can do this one of 2 ways (help):
Drag each table into the canvas and use a union step to stack them on top of one another
Use a wildcard union in the input step of one of the tables
Some of the fields aren't matching up as we'd expect, due to differences in spelling. Merge these fields together
Make a Joining Date field based on the Joining Day, Table Names and the year 2023
Now we want to reshape our data so we have a field for each demographic, for each new customer (help)
Make sure all the data types are correct for each field
Remove duplicates (help)
If a customer appears multiple times take their earliest joining date*/


--Table Overview
WITH CTE AS
(
select *
     ,'JANUARY' as month
from TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_JANUARY
union ALL
select *
    ,'FEBRUARY' as month
from TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_FEBRUARY
union ALL
select *
     ,'MARCH' as month
from TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_MARCH
union ALL
select *
       ,'APRIL' as month
from TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_APRIL
union ALL
select *
     ,'MAY' as month
from TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_MAY
union ALL
select *
      ,'JUNE' as month
from TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_JUNE
union ALL
select *
,'JULY' as month
from TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_JULY
union ALL
select *
,'AUGUST' as month
from TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_AUGUST
union ALL
select *
,'SEPTEMBER' as month
from TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_SEPTEMBER
union ALL
select *
,'OCTOBER' as month
from TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_OCTOBER
union ALL
select *
,'NOVEMBER' as month
from TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_NOVEMBER
union ALL
select *
,'DECEMBER' as month
from TIL_PLAYGROUND.PREPPIN_DATA_INPUTS.PD2023_WK04_december
)
,P1 AS
(
select
ID
,DEMOGRAPHIC
,VALUE
,TO_DATE(CONCAT(joining_day,' ',MONTH,' ','2023'), 'DD MMMM YYYY') as JOINING_DATE
FROM CTE) 
,P2 AS
(
select
ID
,JOINING_DATE
,ethnicity
,account_type
,date_of_birth::DATE AS DATE_OF_BIRTH
,ROW_NUMBER()OVER(PARTITION BY ID ORDER BY JOINING_DATE DESC) AS RN 
FROM P1
PIVOT( max(value) FOR demographic IN ('Ethnicity', 'Account Type', 'Date of Birth')) AS P
(
ID
,JOINING_DATE
,ethnicity
,account_type
,date_of_birth
)) -- THE ORDER OF THE VALUE ENTITIES ARE IMPORTANT BOTH IN THE SELECT STATEMENTS AND THE 'IN'  CLAUSE
  -- THE CASES ARE ALSO IMORTANT IN THE IN CLAUSE
SELECT
ID
,JOINING_DATE
,ethnicity
,account_type
,date_of_birth
,RN
--,COUNT(ID)
FROM P2
QUALIFY RN=1
--GROUP BY 1,2--,3,4,5
--HAVING COUNT(ID)=2
ORDER BY 1

  
  







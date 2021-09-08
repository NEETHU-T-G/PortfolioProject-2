USE [PortfolioProject 2];
SELECT * FROM ZomatoData order by 3; 
--Inserting data into the country column--
SELECT DISTINCT  City,CountryCode from ZomatoData; 
ALTER TABLE ZomatoData
ADD  Country VARCHAR(255);
UPDATE ZomatoData
SET Country = CASE
WHEN CountryCode =1 THEN 'India'
WHEN CountryCode =214 THEN 'UAE'
WHEN CountryCode =215 THEN 'UK'
WHEN CountryCode= 216 THEN'USA'
WHEN CountryCode =14 THEN 'South Africa'
WHEN CountryCode =30 THEN 'Malayasia'
WHEN CountryCode =37 THEN 'Indonesia'
WHEN CountryCode =94 THEN 'Singapore'
WHEN CountryCode =148 THEN 'Hongkong'
WHEN CountryCode =162 THEN 'Nigeria'
WHEN CountryCode =166 THEN 'France'
WHEN CountryCode =184 THEN 'Switzerland'
WHEN CountryCode =189 THEN'Australia'
WHEN CountryCode =191 THEN 'NewZealand'
WHEN CountryCode =208 THEN 'Canada'
ELSE NULL 
END
SELECT * FROM ZomatoData; 
--Top 5 countries with most restaurants linked with Zomato--
SELECT TOP 5  Country,COUNT(Country) AS Total_Restaurants 
FROM ZomatoData
GROUP BY Country
ORDER BY 2 DESC; 
--Average Cost for two across all Zomato listed restaurants--
SELECT RestaurantName,Rating,Country,Currency,Average_Cost_for_two
FROM ZomatoData
SELECT DISTINCT  Country,CountryCode from ZomatoData;
--Details of restaurants with average rating of more than 4.5--
SELECT  RestaurantName,Address,City,Rating,Country from ZomatoData
WHERE Rating>4.5;
--Finding NULL value in cuisines--
SELECT * FROM ZomatoData WHERE Cuisines IS NULL;

--Top 5 countries with average rating of more than 4.5--
SELECT TOP 5 Country,AVG(Rating) AS Rating from ZomatoData
WHERE Rating>4.5
GROUP BY Country 
ORDER BY 2 DESC

--Cities with poor restaurant rating--
SELECT  DISTINCT City from ZomatoData
WHERE Rating<=2; 

--Looking for the best restaurants in Bangalore--
SELECT  RestaurantName,Address,City,Rating from ZomatoData
WHERE Rating>4.5 AND City='Bangalore'

--Breaking out Cuisines into individual columns--
ALTER TABLE ZomatoData
ADD Cuisine_1 VARCHAR(255);
UPDATE ZomatoData
SET Cuisine_1 =PARSENAME(REPLACE(Cuisines,',','.'),1)

ALTER TABLE ZomatoData
ADD Cuisine_2 VARCHAR(255);
UPDATE ZomatoData
SET Cuisine_2 =PARSENAME(REPLACE(Cuisines,',','.'),2)

ALTER TABLE ZomatoData
ADD Cuisine_3 VARCHAR(255);
UPDATE ZomatoData
SET Cuisine_3 =PARSENAME(REPLACE(Cuisines,',','.'),3)

ALTER TABLE ZomatoData
ADD Cuisine_4 VARCHAR(255);
UPDATE ZomatoData
SET Cuisine_4 =PARSENAME(REPLACE(Cuisines,',','.'),4)


--Looking for the best rated restaurant for pizza in New Delhi--
SELECT  RestaurantName,Address,City,Cuisines,Rating from ZomatoData
WHERE Rating>=4 AND City='New Delhi' AND (Cuisine_1 = 'Pizza' OR Cuisine_2 = 'Pizza'
 OR Cuisine_3 = 'Pizza' OR Cuisine_4 = 'Pizza');

--Most affordable & highly rated restaurants--
SELECT RestaurantName,Address,City,Cuisines,Rating,Country from ZomatoData
WHERE Rating>4 AND Price_range<=2 
ORDER BY 3;
--10 Most affordable & highly rated restaurants in India--
SELECT TOP 10 RestaurantName,Address,City,Cuisines,Rating,Country from ZomatoData
WHERE Rating>4.5 AND Average_Cost_for_two<=500 AND Country='India'
ORDER BY 5 DESC,3 ;
--Restaurants that have No online delivery--
SELECT RestaurantName,Address,City,Cuisines,Rating,Country from ZomatoData
WHERE Has_Online_delivery='No' 
ORDER BY 3;
--Restaurants with good services and high rating--
SELECT RestaurantName,Address,City,Cuisines,Rating,Country from ZomatoData
WHERE Has_Online_delivery='Yes'AND Has_Table_booking='Yes'AND Rating>4.5
ORDER BY 3;

--Cities which have atleast 3 restaurants with rating>=4.9--
SELECT  City,COUNT(City) AS Count FROM ZomatoData
WHERE Rating>=4.9 
GROUP BY City
HAVING COUNT(City)>=3
ORDER BY 1 ASC

--Removing a column --
ALTER TABLE ZomatoData DROP COLUMN Category

--Group restaurants on the basis of Price range--
ALTER TABLE ZomatoData
ADD Price_Category VARCHAR(255);
UPDATE ZomatoData
SET Price_Category = CASE
WHEN Price_range =1 THEN 'Low'
WHEN Price_range =2 THEN 'Average'
WHEN Price_range =3 THEN 'High'
WHEN Price_range =4 THEN'Expensive'
ELSE 'Not Defined'
END
SELECT * FROM ZomatoData; 
SELECT Price_Category,COUNT(Price_Category) AS Total FROM ZomatoData
GROUP BY Price_Category;
--Top 5 restaurants with highest rating and maximum votes--
SELECT top 10 * FROM ZomatoData 
WHERE Rating>4.5
ORDER BY Votes desc;

--Looking for McDonald's --
SELECT * FROM ZomatoData 
WHERE RestaurantName LIKE'McD%'AND Has_Online_delivery='Yes' 

--Top 10 restaurants with most outlet in a city--
SELECT TOP 10 RestaurantName,City,COUNT(RestaurantName) AS Total_Restaurants  FROM ZomatoData 
GROUP BY RestaurantName,City
ORDER BY 3 DESC
--Checking Duplicates--
WITH RestaurantsCTE AS
(
SELECT * ,ROW_NUMBER() OVER (PARTITION BY RestaurantID,Address,RestaurantName ORDER BY RestaurantID,Address,RestaurantName )AS Row FROM ZomatoData 
)
SELECT * FROM RestaurantsCTE
WHERE Row>1;
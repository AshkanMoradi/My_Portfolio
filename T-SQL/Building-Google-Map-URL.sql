DECLARE @date date= '2025-01-01';
WITH CustomerLocation AS
(
SELECT  c.CustomerID, CONVERT(date,s.CreationDate) as Request_Date, convert(time,s.CreationDate) as Request_Time,
--ad.Latitude as 'Customer_Latitude', ad.Longitude as 'Customer_Longitude',
CONCAT(ad.Latitude,',',ad.Longitude) as Concatinated_Customer_Cordinates,
--hs.Latitude as 'Sale_Latitude', hs.Longitude as 'Sale_Longitude',
CONCAT(hs.Latitude,',',hs.Longitude) as Concatinated_Sales_Cordinates
--i.Latitude as 'Invoice_Latitude',i.Longitude as 'Invoice_Longitude'
FROM [TehranDB].[SLS3].[Customer] c 
INNER JOIN [DATABASE_NAME].[SLS3].[CustomerAddress] a      ON c.CustomerID=a.CustomerRef
INNER JOIN [DATABASE_NAME].[GNR3].[Address] ad             ON a.AddressRef=ad.AddressID
INNER JOIN [DATABASE_NAME].[SLS3].[SaleRequest] s          ON s.CustomerRef=c.CustomerID
INNER JOIN [DATABASE_NAME].[SLS3].[SaleRequestItem] si     ON s.SaleRequestID=si.SaleRequestRef
INNER JOIN [DATABASE_NAME].[DSD3].[HandheldSaleRequest] hs ON hs.SaleRequestRef=s.SaleRequestID
INNER JOIN [DATABASE_NAME].[SLS3].[OrderItem] oi           ON oi.ReferenceRef=si.SaleRequestItemID
INNER JOIN [DATABASE_NAME].[SLS3].[Order] o                ON o.OrderID=oi.OrderRef
INNER JOIN [DATABASE_NAME].[DSD3].[Invoice] i              ON i.OrderRef=o.OrderID
WHERE s.Date > @date 
GROUP BY c.CustomerID,s.Number,s.CreationDate,AD.Latitude,AD.Longitude,hs.Latitude,hs.Longitude,i.Latitude,i.Longitude
)
SELECT CL.*,
CONCAT('https://www.google.com/maps/dir/?api=1&origin=',CL.Concatinated_Customer_Cordinates,'&destination=',CL.Concatinated_Sales_Cordinates,'&travelmode=driving')
AS CustomerToSaleGoogleMapURL
FROM CustomerLocation CL

SELECT * FROM OPENQUERY ([TEHRAN] , '
Declare @date date= ''2024-11-24'';
WITH CustomerLocation AS
(
SELECT  c.CustomerID, convert( date, s.CreationDate)as Request_Date,convert( time, s.CreationDate)as Request_Time,
ad.Latitude as ''Customer_Latitude'',ad.Longitude as ''Customer_Longitude'',
CONCAT(ad.Latitude,'','',ad.Longitude) AS Concatinated_Customer_Cordinates,
hs.Latitude as ''Sale_Latitude'',hs.Longitude as ''Sale_Longitude'',
CONCAT(hs.Latitude,'','',hs.Longitude) AS Concatinated_Sales_Cordinates
--i.Latitude as ''Invoice_Latitude'',i.Longitude as ''Invoice_Longitude''
FROM [TehranDB].[SLS3].[Customer] c 
inner join [TehranDB].[SLS3].[CustomerAddress] a on c.CustomerID=a.CustomerRef
inner join [TehranDB].[GNR3].[Address] ad on a.AddressRef=ad.AddressID
inner join [TehranDB].[SLS3].[SaleRequest] s on s.CustomerRef=c.CustomerID
inner join [TehranDB].[SLS3].[SaleRequestItem] si on s.SaleRequestID=si.SaleRequestRef
inner join [TehranDB].[DSD3].[HandheldSaleRequest] hs on hs.SaleRequestRef=s.SaleRequestID
inner join [TehranDB].[SLS3].[OrderItem] oi on oi.ReferenceRef=si.SaleRequestItemID
inner join [TehranDB].[SLS3].[Order] o on o.OrderID=oi.OrderRef
inner join [TehranDB].[DSD3].[Invoice] i on i.OrderRef=o.OrderID
where s.Date > @date 
GROUP BY c.CustomerID,s.Number,s.CreationDate,AD.Latitude,AD.Longitude,hs.Latitude,hs.Longitude,i.Latitude,i.Longitude
)
SELECT CL.*,
CONCAT(''https://www.google.com/maps/dir/?api=1&origin='',CL.Concatinated_Customer_Cordinates,''&destination='',CL.Concatinated_Sales_Cordinates,''&travelmode=driving'')
AS CustomerToSaleGoogleMapURL
FROM CustomerLocation CL
'
)
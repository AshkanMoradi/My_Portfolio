DECLARE @date date= '2025-01-01'
SELECT  c.CustomerID, MAX(S.Number) as Request_Number, convert(date,s.CreationDate) as Request_Date, convert(time,s.CreationDate) as Request_Time,
ad.Latitude as 'Customer_Latitude', ad.Longitude as 'CUSTOMER_Longitude',
hs.Latitude as 'Sale_Latitude', hs.Longitude as 'Sale_Longitude',
i.Latitude  as 'Invoice_Latitude', i.Longitude  as 'Invoice_Longitude' 
FROM SLS3.Customer c 
INNER JOIN SLS3.CustomerAddress a on c.CustomerID=a.CustomerRef
INNER JOIN GNR3.Address ad on a.AddressRef=ad.AddressID
INNER JOIN SLS3.SaleRequest s on s.CustomerRef=c.CustomerID
INNER JOIN SLS3.SaleRequestItem si on s.SaleRequestID=si.SaleRequestRef
INNER JOIN DSD3.HandheldSaleRequest hs on hs.SaleRequestRef=s.SaleRequestID
INNER JOIN SLS3.[OrderItem] oi on oi.ReferenceRef=si.SaleRequestItemID
INNER JOIN SLS3.[Order] o on o.OrderID=oi.OrderRef
INNER JOIN DSD3.Invoice i on i.OrderRef=o.OrderID
WHERE s.Date > @date 
GROUP BY c.CustomerID,s.Number,s.CreationDate,AD.Latitude,AD.Longitude,hs.Latitude,hs.Longitude,i.Latitude,i.Longitude


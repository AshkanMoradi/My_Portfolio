Declare @date date='2024-01-14'
SELECT  c.CustomerID, MAX(S.Number)Request_Number,convert( date, s.CreationDate)as Request_Date,convert( time, s.CreationDate)as Request_Time,
ad.Latitude as 'Customer_Latitude',ad.Longitude as 'CUSTOMER_Longitude',
hs.Latitude as 'Sale_Latitude',hs.Longitude as 'Sale_Longitude',i.Latitude as 'Invoice_Latitude',i.Longitude as 'Invoice_Longitude' 
FROM SLS3.Customer c 
inner join SLS3.CustomerAddress a on c.CustomerID=a.CustomerRef
inner join GNR3.Address ad on a.AddressRef=ad.AddressID
inner join SLS3.SaleRequest s on s.CustomerRef=c.CustomerID
inner join SLS3.SaleRequestItem si on s.SaleRequestID=si.SaleRequestRef
inner join DSD3.HandheldSaleRequest hs on hs.SaleRequestRef=s.SaleRequestID
inner join SLS3.[OrderItem] oi on oi.ReferenceRef=si.SaleRequestItemID
inner join SLS3.[Order] o on o.OrderID=oi.OrderRef
inner join DSD3.Invoice i on i.OrderRef=o.OrderID
where s.Date > @date 
GROUP BY c.CustomerID,s.Number,s.CreationDate,AD.Latitude,AD.Longitude,hs.Latitude,hs.Longitude,i.Latitude,i.Longitude


USE AdventureWorks2022;

WITH
StoreRevenue AS (
  SELECT StoreID, SUM(TotalDue) AS Revenue
  FROM Sales.Customer JOIN Sales.SalesOrderHeader ON
  Customer.CustomerID = SalesOrderHeader.CustomerID
  GROUP BY StoreID
),

StoreContacts AS (
	SELECT
		CONCAT(s.Name, ' (', FirstName,' ', LastName, ')') AS ContactName,
		p2.BusinessEntityID AS StoreID
	FROM Person.Person AS p1
	JOIN Person.BusinessEntityContact AS p2
		ON p1.BusinessEntityID = p2.PersonID
	JOIN Sales.Store AS s
		ON p2.BusinessEntityID = s.BusinessEntityID
	WHERE PersonType = 'SC'
)

SELECT ContactName, Revenue
FROM StoreContacts AS sc
JOIN StoreRevenue AS sr
	ON sc.StoreID = sr.StoreID
ORDER BY ContactName





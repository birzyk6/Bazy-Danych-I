USE AdventureWorks2022;

WITH EmployeeRateInfo AS (
  -- Joinowanie baz
  SELECT FirstName, LastName, Rate
  FROM Person.Person AS p
  JOIN HumanResources.EmployeePayHistory as payh ON p.BusinessEntityID = payh.BusinessEntityID
     WHERE PersonType = 'EM' AND
  -- Jest kilka Rate'ow wiec wybieramy ten najnowszy
      payh.ModifiedDate = (
        SELECT MAX(payh.ModifiedDate)
        FROM HumanResources.EmployeePayHistory as payh
        WHERE p.BusinessEntityID = payh.BusinessEntityID
    )
)

-- Tworzenie tymczasowej tabeli #nazwa_tabeli
SELECT * INTO #TempEmployeeInfo FROM EmployeeRateInfo;

SELECT * FROM #TempEmployeeInfo;

-- Usuwanie tabeli tymczasowej
DROP TABLE #TempEmployeeInfo;





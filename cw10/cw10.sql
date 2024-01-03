USE AdventureWorks2022;

--  1) Napisz zapytanie, które wykorzystuje transakcję (zaczyna ją),
--  a następnie aktualizuje cenę produktu o ProductID równym 680 w tabeli Production.
--  Product o 10% i następnie zatwierdza transakcję

BEGIN TRANSACTION;
UPDATE Production.Product
SET StandardCost = 1.1 * StandardCost
  WHERE ProductID = 680;
COMMIT;

-- 2) Napisz zapytanie, które zaczyna transakcję,
-- dodaje nowy produkt do tabeli Production.Product,
-- a następnie zatwierdza transakcję.

BEGIN TRANSACTION;
SET IDENTITY_INSERT Production.Product ON; -- jakis problem byl przy wstawianiu w DataGripie
INSERT INTO Production.Product (
  ProductID, Name, ProductNumber, MakeFlag, FinishedGoodsFlag, Color, SafetyStockLevel,
  ReorderPoint, StandardCost, ListPrice, "Size", SizeUnitMeasureCode, WeightUnitMeasureCode, Weight,
  DaysToManufacture, ProductLine, Class, Style, ProductSubcategoryID, ProductModelID, SellStartDate,
  SellEndDate, DiscontinuedDate, rowguid, ModifiedDate )
  VALUES ( 2137, 'Papiez', '21', '1', '1', 'Yellow', '1', '2', '21.37', '213.7',
           '5', 'CM', 'KG', '21.37', '21', 'R', 'H', 'U', 21, '6', '2137-04-5',
           '2138-04-05', '2139-04-05', '43DD68D6-14A4-461F-9069-55309D902137', '2024-01-03' );
SET IDENTITY_INSERT Production.Product OFF;
COMMIT;

-- 3) Napisz zapytanie, które zaczyna transakcję,
-- usuwa produkt (o ProductID równym temu dodanemu w poprzednim zadaniu)
-- z tabeli Production.Product, ale następnie wycofuje transakcję.

BEGIN TRANSACTION;
DELETE FROM Production.Product WHERE ProductID = '2137';
ROLLBACK;

-- 4) Napisz zapytanie, które zaczyna transakcję i aktualizuje
-- StandardCost wszystkich produktów w tabeli Production.Product o 10%,
-- jeżeli suma wszystkich StandardCost po aktualizacji nie przekracza 50000.
-- W przeciwnym razie zapytanie powinno wycofać transakcję.

BEGIN TRANSACTION;

UPDATE Production.Product
SET StandardCost = StandardCost * 1.1;

IF (SELECT SUM(StandardCost) FROM Production.Product) <= 50000
    COMMIT;
ELSE
    ROLLBACK;

-- 5) Napisz zapytanie SQL, które zaczyna transakcję
-- i próbuje dodać nowy produkt do tabeli Production.Product.
-- Jeśli ProductNumber już istnieje w tabeli, zapytanie powinno wycofać transakcję.
-- Należy najpierw usunąć indeks o nazwie AK_Product_ProductNumber.

SET IDENTITY_INSERT Production.Product ON;
BEGIN TRANSACTION;
BEGIN TRY
  INSERT INTO Production.Product (
    ProductID, Name, ProductNumber, MakeFlag, FinishedGoodsFlag, Color, SafetyStockLevel,
    ReorderPoint, StandardCost, ListPrice, "Size", SizeUnitMeasureCode, WeightUnitMeasureCode, Weight,
    DaysToManufacture, ProductLine, Class, Style, ProductSubcategoryID, ProductModelID, SellStartDate,
    SellEndDate, DiscontinuedDate, rowguid, ModifiedDate
  )
  VALUES ( 2137, 'Papiez', '21', '1', '1', 'Yellow', '1', '2', '21.37', '213.7',
           '5', 'CM', 'KG', '21.37', '21', 'R', 'H', 'U', 21, '6', '2137-04-5',
           '2138-04-05', '2139-04-05', '43DD68D6-14A4-461F-9069-55309D902137', '2024-01-03' );
  COMMIT;
END TRY
BEGIN CATCH
  ROLLBACK;
END CATCH;

-- 6) Napisz zapytanie SQL, które zaczyna transakcję i
-- aktualizuje wartość OrderQty dla każdego zamówienia w tabeli Sales.SalesOrderDetail.
-- Jeżeli którykolwiek z zamówień ma OrderQty równą 0, zapytanie powinno wycofać transakcję.

BEGIN TRANSACTION;

UPDATE Sales.SalesOrderDetail
SET OrderQty = OrderQty + 1

IF EXISTS (SELECT 1 FROM Sales.SalesOrderDetail WHERE OrderQty = 0)
BEGIN
    ROLLBACK;
END
ELSE
BEGIN
    COMMIT;
END

-- 7) Napisz zapytanie SQL, które zaczyna transakcję i usuwa wszystkie produkty,
-- których StandardCost jest wyższy niż średni koszt
-- wszystkich produktów w tabeli Production.Product.
-- Jeżeli liczba produktów do usunięcia przekracza 10,
-- zapytanie powinno wycofać transakcję.

BEGIN TRANSACTION;

DELETE FROM Production.Product
WHERE StandardCost > (SELECT AVG(StandardCost) FROM Production.Product);

DECLARE @DeletedProductCount INT;
SET @DeletedProductCount = @@ROWCOUNT; -- zwaraca ilość wierszy zmienionych przez DELETE

IF @DeletedProductCount > 10
BEGIN
    ROLLBACK;
END
ELSE
BEGIN
    COMMIT;
END
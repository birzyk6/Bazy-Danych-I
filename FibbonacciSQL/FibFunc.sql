CREATE OR ALTER FUNCTION dbo.FibbonacciSeq
( 
	@n INT 
)
RETURNS @FibTable TABLE -- Funckja zwraca tabelę
(
	nFib INT
)
AS
BEGIN
	-- Tworzenie zmiennych
	DECLARE @f1 INT = 0, @f2 INT = 1, @i INT = 1;

	WHILE @i <  @n
	BEGIN
		INSERT INTO @FibTable (nFib) VALUES (@f1);
		SET @f1 = @f1 + @f2;
		SET @f2 = @f1 - @f2;
		SET @i = @i + 1;
	END

	RETURN;
END;

CREATE OR ALTER PROCEDURE dbo.PrintFibbonacciSeq
(
	@n INT
)
AS
BEGIN
    -- Tworzenie tabeli do zwracania
    DECLARE @FibTable TABLE 
    (
        nFib INT
    )

    -- Wypełnianie tabeli ciągiem Fibbonaciego
    INSERT INTO @FibTable
    SELECT nFib FROM dbo.FibbonacciSeq(@n);

    -- Tworzenie zmiennej przechowującej wiersz tabeli
    DECLARE @nFib INT;

    -- Tworzenie kursora, aby przemieszczać się po tabeli
    DECLARE FibCursor CURSOR FOR
    SELECT nFib FROM @FibTable;

    OPEN FibCursor;

    -- Pobieranie kolejnych wierszy 
    FETCH NEXT FROM FibCursor INTO @nFib;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Wypisywanie wiersza i przechodzenie do następnego
        PRINT @nFib;
        FETCH NEXT FROM FibCursor INTO @nFib;
    END

    CLOSE FibCursor;
    DEALLOCATE FibCursor;
END;
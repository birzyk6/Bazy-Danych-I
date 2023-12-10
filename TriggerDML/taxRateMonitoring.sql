-- Przygotuj trigger taxRateMonitoring, ktory wyswietli komunikat o bledzie, 
-- jezeli nastapi zmiana wartosci w polu TaxRate o wiecej niz 30%.

CREATE OR ALTER TRIGGER taxRateMonitoring
ON Sales.SalesTaxRate
AFTER UPDATE 
AS
BEGIN
	IF UPDATE(TaxRate)
	BEGIN 
		DECLARE @OldTaxRate SMALLMONEY;
		DECLARE @NewTaxRate SMALLMONEY;

		SELECT @OldTaxRate = TaxRate FROM deleted;
		SELECT @NewTaxRate = TaxRate FROM inserted;

		IF @NewTaxRate > @OldTaxRate*1.3
		BEGIN
			RAISERROR('Tax rate cannot exceed 30%. Update rolled back.', 16, 1);
			ROLLBACK;
			RETURN;
		END;
	END;
END;
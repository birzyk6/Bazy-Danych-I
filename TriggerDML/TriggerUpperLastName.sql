-- Trigger DML, Po wstawieniu danych do tabeli persons, zmieni nazwisko w danym rekordzie na du�e litery

CREATE OR ALTER TRIGGER TriggerUpperLastName
ON Person.Person
AFTER INSERT 
AS
BEGIN
	UPDATE Person.Person
		SET LastName = UPPER(Person.LastName)
		FROM inserted
		WHERE Person.BusinessEntityID = inserted.BusinessEntityID
END;


-- a) Wyświetl tylko id pracownika oraz jego nazwisko */
SELECT id_pracownika, nazwisko FROM ksiegowosc.pracownicy;

-- b) Wyświetl id pracowników, których płaca jest większa niż 1000 */

SELECT id_pracownika FROM ksiegowosc.wynagrodzenie
INNER JOIN ksiegowosc.pensje USING (id_pensji)
INNER JOIN ksiegowosc.premie USING (id_premii)
WHERE premie.kwota + pensje.kwota > 1000;
 

-- c) Wyświetl id pracowników nieposiadających premii, 
-- 	  których płaca jest większa niż 2000. 

SELECT id_pracownika FROM ksiegowosc.wynagrodzenie
INNER JOIN ksiegowosc.pensje USING (id_pensji)
INNER JOIN ksiegowosc.premie USING (id_premii)
WHERE premie.kwota + pensje.kwota > 1000 AND premie.kwota = 0;

-- d) Wyświetl pracowników, których pierwsza 
--    litera imienia zaczyna się na literę ‘J’. 

SELECT * FROM ksiegowosc.pracownicy
WHERE pracownicy.imie LIKE 'J%';

-- e) Wyświetl pracowników, których nazwisko zawiera 
--    literę ‘n’ oraz imię kończy się na literę ‘a’. 

SELECT * FROM ksiegowosc.pracownicy
WHERE pracownicy.nazwisko LIKE '%n%' AND pracownicy.nazwisko LIKE '%a';

-- f) Wyświetl imię i nazwisko pracowników oraz liczbę ich nadgodzin, 
--    przyjmując, iż standardowy czas pracy to 160 h miesięcznie. 

SELECT pracownicy.imie, pracownicy.nazwisko, (godziny.liczba_godzin - 160) AS nadgodziny
FROM ksiegowosc.pracownicy INNER JOIN ksiegowosc.godziny USING (id_pracownika);

-- g) Wyświetl imię i nazwisko pracowników, których pensja 
--    zawiera się w przedziale 1500 – 3000 PLN. 

SELECT pracownicy.imie, pracownicy.nazwisko FROM ksiegowosc.pracownicy
INNER JOIN ksiegowosc.wynagrodzenie USING (id_pracownika)
INNER JOIN ksiegowosc.pensje USING (id_pensji)
WHERE pensje.kwota BETWEEN 1500 AND 3000;

-- h) Wyświetl imię i nazwisko pracowników, którzy 
--    pracowali w nadgodzinach i nie otrzymali premii 

SELECT pracownicy.imie, pracownicy.nazwisko, (godziny.liczba_godzin - 160) AS nadgodziny, premie.kwota 
FROM ksiegowosc.pracownicy 
INNER JOIN ksiegowosc.godziny USING (id_pracownika)
INNER JOIN ksiegowosc.wynagrodzenie USING (id_pracownika)
INNER JOIN ksiegowosc.premie USING (id_premii)
WHERE (godziny.liczba_godzin - 160) > 0 AND premie.kwota = 0;

-- i) Uszereguj pracowników według pensji 

SELECT * FROM ksiegowosc.pracownicy 
INNER JOIN ksiegowosc.wynagrodzenie USING (id_pracownika)
INNER JOIN ksiegowosc.pensje USING (id_pensji)
ORDER BY pensje.kwota DESC;

-- j) Uszereguj pracowników według pensji i premii malejąco. 

SELECT * FROM ksiegowosc.pracownicy 
INNER JOIN ksiegowosc.wynagrodzenie USING (id_pracownika)
INNER JOIN ksiegowosc.pensje USING (id_pensji)
INNER JOIN ksiegowosc.premie USING (id_premii)
ORDER BY pensje.kwota, premie.kwota DESC;

-- k) Zlicz i pogrupuj pracowników według pola ‘stanowisko’. 

SELECT pensje.stanowisko, COUNT(*) AS liczba_pracownikow FROM ksiegowosc.pracownicy
INNER JOIN ksiegowosc.wynagrodzenie USING (id_pracownika)
INNER JOIN ksiegowosc.pensje USING (id_pensji)
GROUP BY pensje.stanowisko;

-- l) Policz średnią, minimalną i maksymalną płacę dla stanowiska ‘kierownik’ 
--    (jeżeli takiego nie masz, to przyjmij dowolne inne). 

SELECT 
	AVG(pensje.kwota + premie.kwota) AS Average, 
	MIN(pensje.kwota + premie.kwota) AS Minimum, 
	MAX(pensje.kwota + premie.kwota) AS Maximum
FROM ksiegowosc.wynagrodzenie 
INNER JOIN ksiegowosc.pensje USING (id_pensji)
INNER JOIN ksiegowosc.premie USING (id_premii)
WHERE pensje.stanowisko = 'intern';

-- m) Policz sumę wszystkich wynagrodzeń.
	
SELECT SUM(pensje.kwota + premie.kwota) AS SalarySum
FROM ksiegowosc.wynagrodzenie
INNER JOIN ksiegowosc.pensje USING (id_pensji)
INNER JOIN ksiegowosc.premie USING (id_premii);

-- n) Policz sumę wynagrodzeń w ramach danego stanowiska.

SELECT pensje.stanowisko, SUM(pensje.kwota + premie.kwota) AS SalarySumPos
FROM ksiegowosc.wynagrodzenie
INNER JOIN ksiegowosc.pensje USING (id_pensji)
INNER JOIN ksiegowosc.premie USING (id_premii)
GROUP BY pensje.stanowisko;

-- o) Wyznacz liczbę premii przyznanych dla pracowników danego stanowiska.

SELECT pensje.stanowisko, COUNT(CASE WHEN premie.kwota != 0 THEN 1 END) AS NumOfBonuses 
FROM ksiegowosc.wynagrodzenie
INNER JOIN ksiegowosc.pensje USING (id_pensji)
INNER JOIN ksiegowosc.premie USING (id_premii)
GROUP BY pensje.stanowisko;

-- p) Usuń wszystkich pracowników mających pensję mniejszą niż 1200 zł.

DELETE FROM ksiegowosc.wynagrodzenie
WHERE wynagrodzenie.id_pracownika IN (
	SELECT wynagrodzenie.id_pracownika FROM
	ksiegowosc.wynagrodzenie 
	JOIN ksiegowosc.pensje USING (id_pensji)
	WHERE pensje.kwota < 1200
);

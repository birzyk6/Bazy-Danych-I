-- a) zmodyfikuj dane w tabeli pracownicy dodając do telefonu nr kierunkowy.

ALTER TABLE ksiegowosc.pracownicy 
ALTER COLUMN telefon TYPE VARCHAR(30);

UPDATE ksiegowosc.pracownicy 
SET telefon = CONCAT('+48', telefon);

-- b) zmodyfikuj nr telefonu aby był taki +48555-333-222

UPDATE ksiegowosc.pracownicy
SET telefon = SUBSTRING(telefon FROM 1 FOR 3) || '-' || -- +48-
		      SUBSTRING(telefon FROM 4 FOR 3) || '-' || -- 555-
			  SUBSTRING(telefon FROM 7 FOR 3) || '-' || -- 222-
			  SUBSTRING(telefon FROM 10 FOR 3); 		-- 333
			  
-- c) Wyświetl dane pracownika, którego nazwisko jest najdłuższe, używając dużych liter

SELECT * FROM ksiegowosc.pracownicy 
ORDER BY LENGTH(nazwisko) DESC
LIMIT 1;

-- d) Wyświetl dane pracowników i ich pensje zakodowane przy pomocy algorytmu md5 f) Wyświetl

SELECT imie, nazwisko, MD5(CAST(pensje AS TEXT)) AS MD5_Pensja FROM ksiegowosc.pracownicy 
INNER JOIN ksiegowosc.wynagrodzenie ON wynagrodzenie.id_pracownika = pracownicy.id_pracownika
INNER JOIN ksiegowosc.pensje ON pensje.id_pensji = wynagrodzenie.id_pensji;

-- f) Wyświetl pracowników, ich pensje oraz premie. Wykorzystaj złączenie lewostronne.

SELECT imie, nazwisko, pensje.kwota AS pensja, premie.kwota AS premia FROM ksiegowosc.wynagrodzenie
LEFT JOIN ksiegowosc.pensje ON pensje.id_pensji = wynagrodzenie.id_pensji
LEFT JOIN ksiegowosc.premie ON premie.id_premii = wynagrodzenie.id_premii
LEFT JOIN ksiegowosc.pracownicy ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika;

-- g) wygeneruj raport (zapytanie), które zwróci w wyniki treść wg poniższego szablonu:
-- Pracownik Jan Nowak, w dniu 7.08.2017 otrzymał pensję całkowitą na kwotę 7540 zł, 
-- gdzie wynagrodzenie zasadnicze wynosiło: 5000 zł, premia: 2000 zł, nadgodziny: 540 zł

SELECT 'Pracownik ' || pracownicy.imie || ' ' || pracownicy.nazwisko || ' w dniu ' || godziny.data_ || ' otrzymał pensję całkowitą na kwotę ' ||
	   (pensje.kwota + premie.kwota + ABS(godziny.liczba_godzin - 30)*50) || ' zł, gdzie wynagrodzenie zasadnicze wynosiło: ' || pensje.kwota ||
	   ' zł, premia: ' || premie.kwota || ' zł, nadgodziny: ' || ABS(godziny.liczba_godzin - 30)*50 || 'zł'
FROM ksiegowosc.wynagrodzenie
INNER JOIN ksiegowosc.godziny ON godziny.id_godziny = wynagrodzenie.id_godziny
INNER JOIN ksiegowosc.pracownicy  ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika
INNER JOIN ksiegowosc.premie ON premie.id_premii = wynagrodzenie.id_premii
INNER JOIN ksiegowosc.pensje ON pensje.id_pensji = wynagrodzenie.id_pensji;





 
--Creating databases 

	/* CREATE DATABASE firma_2; */



-- Creating schema 

	/* CREATE SCHEMA ksiegowosc; */


-- Creating tables 

CREATE TABLE IF NOT EXISTS ksiegowosc.pracownicy (
	id_pracownika INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	imie VARCHAR(30),
	nazwisko VARCHAR(30),
	adres VARCHAR(100),
	telefon INT
);

CREATE TABLE IF NOT EXISTS ksiegowosc.godziny (
	id_godziny INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	data_ DATE, 
	liczba_godzin INT DEFAULT 0, 
	id_pracownika INT NOT NULL
);

CREATE TABLE IF NOT EXISTS ksiegowosc.pensje (
	id_pensji INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	stanowisko VARCHAR(60),
	kwota DECIMAL(12,2) DEFAULT 0
);

CREATE TABLE IF NOT EXISTS ksiegowosc.premie (
	id_premii INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	rodzaj VARCHAR(30),
	kwota DECIMAL(12,2) DEFAULT 0
);

CREATE TABLE IF NOT EXISTS ksiegowosc.wynagrodzenie (
	id_wynagrodzenia INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	data_ DATE,
	id_pracownika INT NOT NULL,
	id_godziny INT NOT NULL,
	id_pensji INT NOT NULL,
	id_premii INT
);

-- Adding foreign keys 

ALTER TABLE ksiegowosc.godziny ADD
FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy(id_pracownika);

ALTER TABLE ksiegowosc.wynagrodzenie 
ADD FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy(id_pracownika),
ADD FOREIGN KEY (id_godziny) REFERENCES ksiegowosc.godziny(id_godziny),
ADD FOREIGN KEY (id_pensji) REFERENCES ksiegowosc.pensje(id_pensji),
ADD FOREIGN KEY (id_premii) REFERENCES ksiegowosc.premie(id_premii);

-- Adding comments 

COMMENT ON TABLE ksiegowosc.pracownicy IS 
'Table of workers with their id, name, surname, adress and phone number';

COMMENT ON TABLE ksiegowosc.godziny IS 
'Table of hours each worker has in a month, date of the month, number of hours, and id of the worker';

COMMENT ON TABLE ksiegowosc.pensje IS 
'Table of salaries each worker has, id of salary, their position, and amount';

COMMENT ON TABLE ksiegowosc.premie IS 
'Table of bonuses each worker has, id of the bonus, type of the bonus and amount';

COMMENT ON TABLE ksiegowosc.wynagrodzenie IS 
'Table of salaries including bonuses. Consists of: id, date, worker id, hour id, salary id and bonus id';

-- Adding data 

INSERT INTO ksiegowosc.pracownicy ( imie, nazwisko, adres, telefon ) 
VALUES 
( 'Andrzej', 'Stanowski', 'Kraków', 317836342 ),
( 'Kamil', 'Ślimak', 'Warszawa', 786065100 ),
( 'Piotr', 'Źięba', 'Pcim', 325793975 ),
( 'Krzysztof', 'Włodarczyk', 'Chełm', 648635681 ),
( 'Filip', 'Cichoń', 'Nowy Jork', 281849184 ),
( 'Dawid', 'Łętocha', 'Los Angeles', 153073721 ),
( 'Filip', 'Paruch', 'Myślenice', 555689162 ),
( 'Szymon', 'Proszek', 'Zasań', 43713791 ),
( 'Iza', 'Olszewska', 'Tokarnia', 777145294 ),
( 'Bogumiła', 'Olszewska', 'Zasań', 950198293 );

INSERT INTO ksiegowosc.godziny ( data_, liczba_godzin, id_pracownika) 
VALUES
( '2023-05-12', 30, 1 ),
( '2023-05-13', 31, 2 ),
( '2023-05-14', 29, 3 ),
( '2023-05-15', 32, 4 ),
( '2023-05-16', 28, 5 ),
( '2023-05-17', 33, 6 ),
( '2023-05-18', 27, 7 ),
( '2023-05-19', 34, 8 ),
( '2023-05-20', 26, 9 ),
( '2023-05-21', 35, 10 );

INSERT INTO ksiegowosc.pensje ( stanowisko, kwota ) 
VALUES
( 'intern', 800 ),
( 'intern', 900 ),
( 'data engineer', 6000 ),
( 'software manager', 4000 ),
( 'dev ops', 6000 ),
( 'social media', 2000 ),
( 'hr', 3500 ),
( 'ceo', 10000 ),
( 'manager', 3000 ),
( 'group manager', 3500 );

INSERT INTO ksiegowosc.premie ( rodzaj, kwota ) 
VALUES
( 'intern_half', 300 ),
( 'intern_year', 500 ),
( 'data engineer_year', 500 ),
( 'software manager_year', 500 ),
( 'dev ops_year', 500 ),
( 'social media_year', 200 ),
( 'hr_year', 300 ),
( 'ceo_year', 0 ),
( 'manager_year', 200 ),
( 'group manager_year', 300 );

INSERT INTO ksiegowosc.wynagrodzenie ( data_, id_pracownika, id_godziny, id_pensji, id_premii )
VALUES
( '2023-05-12', 1, 1, 1, 1 ),
( '2023-05-13', 2, 2, 2, 2 ),
( '2023-05-14', 3, 3, 3, 3 ),
( '2023-05-15', 4, 4, 4, 4 ),
( '2023-05-16', 5, 5, 5, 5 ),
( '2023-05-17', 6, 6, 6, 6 ),
( '2023-05-18', 7, 7, 7, 7 ),
( '2023-05-19', 8, 8, 8, 8 ),
( '2023-05-20', 9, 9, 9, 9 ),
( '2023-05-21', 10, 10, 10, 10 );


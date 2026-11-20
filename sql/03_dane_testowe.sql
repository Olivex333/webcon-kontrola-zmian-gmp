/* 03_dane_testowe.sql – fikcyjne dane testowe. Wyniki raportów opisano dla daty 20.11.2026. */

INSERT INTO dbo.Slownik_TypyZmian (Nazwa) VALUES
    (N'Materiał / opakowanie'), (N'Proces wytwarzania'), (N'Urządzenie'), (N'Dokument / SOP'), (N'System komputerowy');

INSERT INTO dbo.Slownik_Dzialy (Nazwa, OceniajacyLogin) VALUES
    (N'Produkcja',            N'firma\k.nowak'),
    (N'Kontrola jakości',     N'firma\e.lewandowska'),
    (N'Walidacja',            N'firma\t.wrobel'),
    (N'Sprawy rejestracyjne', N'firma\b.krol');

INSERT INTO dbo.Rejestr_Zmian
    (Sygnatura, TypID, Tytul, Inicjator, PowiazaneOdchylenie, Klasyfikacja, WymagaZgloszenia,
     ZgodaRejestracyjna, Krok, DataWniosku, TerminOcenyWplywu, DataZatwierdzenia, DataZamkniecia)
VALUES
    (N'CC/2026/0001', 1, N'Nowy dostawca butelki 100 ml', N'firma\zakupy.nowak', NULL,
     N'Poważna',   1, N'Uzyskana',    N'Zamknięta',                 '2026-07-01', '2026-07-15', '2026-07-20', '2026-09-30'),
    (N'CC/2026/0002', 4, N'Aktualizacja SOP mycia linii syropów', N'firma\k.nowak', NULL,
     N'Mniejsza',  0, N'Nie dotyczy', N'Zamknięta',                 '2026-09-01', '2026-09-15', '2026-09-05', '2026-09-19'),
    (N'CC/2026/0003', 1, N'Nowy wzór etykiety produktu testowego A', N'firma\marketing.zielinska', NULL,
     N'Poważna',   1, N'Uzyskana',    N'Realizacja zadań',          '2026-10-01', '2026-10-15', '2026-10-20', NULL),
    (N'CC/2026/0004', 2, N'Zmiana zakresu siły nacisku tabletkarki w instrukcji wytwarzania', N'firma\p.zajac', N'DEV/2026/0003',
     N'Krytyczna', 1, N'Oczekuje',    N'Ocena wpływu',              '2026-11-02', '2026-11-16', NULL,         NULL),
    (N'CC/2026/0005', 3, N'Wymiana drukarki etykiet na ten sam model', N'firma\ur.kowal', NULL,
     NULL,         0, N'Nie dotyczy', N'Ocena wstępna QA',          '2026-11-17', NULL,         NULL,         NULL);

/* Oceny wpływu dla CC/2026/0004: dwa działy złożyły ocenę, dwa nie */
INSERT INTO dbo.Ocena_Wplywu (ZmianaID, DzialID, Wplyw, Opis, DataOceny) VALUES
    (4, 1, 1, N'Aktualizacja instrukcji wytwarzania i szkolenie operatorów tabletkarki', '2026-11-09'),
    (4, 2, 1, N'Rozszerzone badania twardości i rozpadu dla 3 pierwszych serii',        '2026-11-12'),
    (4, 3, NULL, NULL, NULL),
    (4, 4, NULL, NULL, NULL);

INSERT INTO dbo.Zadania_Zmiany (ZmianaID, Opis, Wlasciciel, Termin, Status, DataWykonania) VALUES
    (3, N'Aktualizacja SOP etykietowania',          N'firma\k.nowak',       '2026-11-05', N'Wykonane', '2026-11-04'),
    (3, N'Kwalifikacja wzoru etykiety w systemie',  N'firma\t.wrobel',      '2026-11-18', N'Otwarte',  NULL),
    (3, N'Szkolenie operatorów linii syropów',      N'firma\k.nowak',       '2026-11-25', N'Otwarte',  NULL),
    (1, N'Badania kompatybilności opakowania',      N'firma\e.lewandowska', '2026-08-31', N'Wykonane', '2026-08-28');

/* Ślad audytowy: QA klasyfikuje CC/2026/0005 i przekazuje do oceny wpływu (2 wpisy w Audit_Zmiany) */
UPDATE dbo.Rejestr_Zmian
SET    Klasyfikacja = N'Mniejsza',
       Krok = N'Ocena wpływu'
WHERE  Sygnatura = N'CC/2026/0005';

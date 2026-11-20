/* =========================================================
   04_raporty.sql – raporty (T-SQL)
   Oczekiwane wyniki dla danych z 03_dane_testowe.sql i daty 20.11.2026.
   ========================================================= */

DECLARE @Dzis DATE = CAST(GETDATE() AS DATE);

/* 1. Otwarte zmiany według klasy i kroku
      oczekiwane: Krytyczna / Ocena wpływu = 1; Mniejsza / Ocena wpływu = 1; Poważna / Realizacja zadań = 1 */
SELECT  ISNULL(z.Klasyfikacja, N'(nieklasyfikowana)') AS Klasyfikacja,
        z.Krok,
        COUNT(*) AS Liczba
FROM    dbo.Rejestr_Zmian z
WHERE   z.DataZamkniecia IS NULL
  AND   z.Krok <> N'Odrzucona'
GROUP BY ISNULL(z.Klasyfikacja, N'(nieklasyfikowana)'), z.Krok
ORDER BY Klasyfikacja, z.Krok;

/* 2. Oceny wpływu po terminie – który dział blokuje zmianę
      oczekiwane: CC/2026/0004 – Walidacja (t.wrobel) i Sprawy rejestracyjne (b.krol), 4 dni */
SELECT  z.Sygnatura,
        z.Klasyfikacja,
        d.Nazwa                                     AS Dzial,
        d.OceniajacyLogin,
        z.TerminOcenyWplywu,
        DATEDIFF(DAY, z.TerminOcenyWplywu, @Dzis)   AS DniPoTerminie
FROM    dbo.Ocena_Wplywu o
JOIN    dbo.Rejestr_Zmian  z ON z.ZmianaID = o.ZmianaID
JOIN    dbo.Slownik_Dzialy d ON d.DzialID  = o.DzialID
WHERE   o.DataOceny IS NULL
  AND   z.TerminOcenyWplywu < @Dzis
ORDER BY DniPoTerminie DESC, d.Nazwa;

/* 3. Zadania wdrożeniowe po terminie
      oczekiwane: CC/2026/0003 – Kwalifikacja wzoru etykiety, t.wrobel, 2 dni */
SELECT  z.Sygnatura, t.Opis, t.Wlasciciel, t.Termin,
        DATEDIFF(DAY, t.Termin, @Dzis) AS DniPoTerminie
FROM    dbo.Zadania_Zmiany t
JOIN    dbo.Rejestr_Zmian  z ON z.ZmianaID = t.ZmianaID
WHERE   t.Status = N'Otwarte'
  AND   t.Termin < @Dzis
ORDER BY DniPoTerminie DESC;

/* 4. Średni czas od wniosku do zamknięcia [dni] według klasy
      oczekiwane: Mniejsza 18; Poważna 91 */
SELECT  z.Klasyfikacja,
        COUNT(*)                                            AS Zamkniete,
        AVG(DATEDIFF(DAY, z.DataWniosku, z.DataZamkniecia)) AS SrDni
FROM    dbo.Rejestr_Zmian z
WHERE   z.DataZamkniecia IS NOT NULL
GROUP BY z.Klasyfikacja
ORDER BY SrDni;

/* 5. Odsetek zmian wymagających zgłoszenia do urzędu
      oczekiwane: 3 z 5, czyli 60,0% */
SELECT  SUM(CASE WHEN z.WymagaZgloszenia = 1 THEN 1 ELSE 0 END) AS WymagaZgloszenia,
        COUNT(*)                                               AS Wszystkie,
        CAST(100.0 * SUM(CASE WHEN z.WymagaZgloszenia = 1 THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Procent
FROM    dbo.Rejestr_Zmian z;

/* 6. Zmiany powiązane z odchyleniami (integracja z projektem webcon-odchylenia-capa-gmp)
      oczekiwane: CC/2026/0004 ← DEV/2026/0003 */
SELECT  z.Sygnatura, z.Tytul, z.PowiazaneOdchylenie, z.Krok
FROM    dbo.Rejestr_Zmian z
WHERE   z.PowiazaneOdchylenie IS NOT NULL;

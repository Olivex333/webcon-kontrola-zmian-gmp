/* =========================================================
   02_rejestr_i_audit.sql – rejestr zmian, oceny wpływu, zadania
   i ślad audytowy. Reguły 1 i 2 wymuszone ograniczeniami CHECK.
   ========================================================= */

CREATE TABLE dbo.Rejestr_Zmian (
    ZmianaID                INT IDENTITY(1,1) PRIMARY KEY,
    Sygnatura               NVARCHAR(30)  NOT NULL UNIQUE,
    TypID                   INT           NOT NULL REFERENCES dbo.Slownik_TypyZmian(TypID),
    Tytul                   NVARCHAR(200) NOT NULL,
    Inicjator               NVARCHAR(100) NOT NULL,
    PowiazaneOdchylenie     NVARCHAR(30)  NULL,          -- np. DEV/2026/0003
    Klasyfikacja            NVARCHAR(20)  NULL
        CHECK (Klasyfikacja IN (N'Mniejsza', N'Poważna', N'Krytyczna')),
    WymagaZgloszenia        BIT           NOT NULL DEFAULT 0,
    ZgodaRejestracyjna      NVARCHAR(20)  NOT NULL DEFAULT N'Nie dotyczy'
        CHECK (ZgodaRejestracyjna IN (N'Nie dotyczy', N'Oczekuje', N'Uzyskana')),
    Krok                    NVARCHAR(50)  NOT NULL,
    DataWniosku             DATE          NOT NULL,
    TerminOcenyWplywu       DATE          NULL,
    DataZatwierdzenia       DATE          NULL,
    DataZamkniecia          DATE          NULL,
    /* reguła 1: realizacja i dalsze kroki tylko po zatwierdzeniu */
    CONSTRAINT CK_RealizacjaPoZatwierdzeniu CHECK (
        Krok NOT IN (N'Realizacja zadań', N'Weryfikacja skuteczności', N'Zamknięta')
        OR DataZatwierdzenia IS NOT NULL),
    /* reguła 2: zmiana wymagająca zgłoszenia – realizacja dopiero po uzyskaniu zgody */
    CONSTRAINT CK_ZgodaPrzedRealizacja CHECK (
        WymagaZgloszenia = 0
        OR Krok NOT IN (N'Realizacja zadań', N'Weryfikacja skuteczności', N'Zamknięta')
        OR ZgodaRejestracyjna = N'Uzyskana')
);

CREATE TABLE dbo.Ocena_Wplywu (
    OcenaID        INT IDENTITY(1,1) PRIMARY KEY,
    ZmianaID       INT           NOT NULL REFERENCES dbo.Rejestr_Zmian(ZmianaID),
    DzialID        INT           NOT NULL REFERENCES dbo.Slownik_Dzialy(DzialID),
    Wplyw          BIT           NULL,                   -- NULL = ocena jeszcze nie złożona
    Opis           NVARCHAR(400) NULL,
    DataOceny      DATE          NULL,
    CONSTRAINT UQ_Ocena UNIQUE (ZmianaID, DzialID),
    CONSTRAINT CK_OcenaKompletna CHECK (DataOceny IS NULL OR Wplyw IS NOT NULL)
);

CREATE TABLE dbo.Zadania_Zmiany (
    ZadanieID      INT IDENTITY(1,1) PRIMARY KEY,
    ZmianaID       INT           NOT NULL REFERENCES dbo.Rejestr_Zmian(ZmianaID),
    Opis           NVARCHAR(300) NOT NULL,
    Wlasciciel     NVARCHAR(100) NOT NULL,
    Termin         DATE          NOT NULL,
    Status         NVARCHAR(20)  NOT NULL DEFAULT N'Otwarte' CHECK (Status IN (N'Otwarte', N'Wykonane')),
    DataWykonania  DATE          NULL,
    CONSTRAINT CK_ZadanieWykonane CHECK (Status = N'Otwarte' OR DataWykonania IS NOT NULL)
);

CREATE TABLE dbo.Audit_Zmiany (
    AuditID        BIGINT IDENTITY(1,1) PRIMARY KEY,
    ZmianaID       INT           NOT NULL,
    Pole           NVARCHAR(50)  NOT NULL,
    StaraWartosc   NVARCHAR(200) NULL,
    NowaWartosc    NVARCHAR(200) NULL,
    ZmienilLogin   NVARCHAR(128) NOT NULL DEFAULT SUSER_SNAME(),
    DataZmiany     DATETIME2     NOT NULL DEFAULT SYSDATETIME()
);
GO

CREATE TRIGGER dbo.trg_Zmiany_Audit
ON dbo.Rejestr_Zmian
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Audit_Zmiany (ZmianaID, Pole, StaraWartosc, NowaWartosc)
    SELECT i.ZmianaID, v.Pole, v.Stara, v.Nowa
    FROM inserted i
    JOIN deleted d ON d.ZmianaID = i.ZmianaID
    CROSS APPLY (VALUES
        (N'Klasyfikacja',       d.Klasyfikacja,       i.Klasyfikacja),
        (N'Krok',               d.Krok,               i.Krok),
        (N'ZgodaRejestracyjna', d.ZgodaRejestracyjna, i.ZgodaRejestracyjna),
        (N'DataZatwierdzenia',  CONVERT(NVARCHAR(10), d.DataZatwierdzenia, 23), CONVERT(NVARCHAR(10), i.DataZatwierdzenia, 23))
    ) AS v(Pole, Stara, Nowa)
    WHERE ISNULL(v.Stara, N'') <> ISNULL(v.Nowa, N'');
END;
GO

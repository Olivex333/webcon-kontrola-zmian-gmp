/* =========================================================
   WEBCON BPS – Kontrola zmian (change control)
   01_slowniki.sql – słowniki pod pola wyboru (T-SQL)
   ========================================================= */

CREATE TABLE dbo.Slownik_TypyZmian (
    TypID     INT IDENTITY(1,1) PRIMARY KEY,
    Nazwa     NVARCHAR(100) NOT NULL UNIQUE,      -- materiał, proces, urządzenie, dokument, system komputerowy
    Aktywny   BIT           NOT NULL DEFAULT 1
);

CREATE TABLE dbo.Slownik_Dzialy (
    DzialID        INT IDENTITY(1,1) PRIMARY KEY,
    Nazwa          NVARCHAR(100) NOT NULL UNIQUE,
    OceniajacyLogin NVARCHAR(100) NOT NULL,       -- domyślna osoba do zadania oceny wpływu
    Aktywny        BIT           NOT NULL DEFAULT 1
);
GO
CREATE VIEW dbo.vw_Wybor_TypyZmian AS
    SELECT TypID AS ID, Nazwa FROM dbo.Slownik_TypyZmian WHERE Aktywny = 1;
GO
CREATE VIEW dbo.vw_Wybor_Dzialy AS
    SELECT DzialID AS ID, Nazwa FROM dbo.Slownik_Dzialy WHERE Aktywny = 1;
GO

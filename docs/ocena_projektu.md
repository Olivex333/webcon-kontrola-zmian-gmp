# Ocena projektu: czy to ma sens?

## Co ma sens

- **Realny problem branży.** Każda zmiana w zakładzie GMP (dostawca, parametr procesu, SOP, urządzenie) musi przejść udokumentowaną ocenę wpływu i zatwierdzenie przed wdrożeniem. W wielu firmach odbywa się to na papierze lub w Excelu, a to typowy proces, który przenosi się do WEBCON BPS.
- **Mechanika, którą WEBCON robi dobrze:** zadania równoległe (oceny wpływu kilku działów naraz), ścieżki zależne od klasy zmiany, warunek blokujący (zgoda urzędu), listy pozycji z zadaniami, przypomnienia, raporty w Portalu.
- **Powiązanie z drugim projektem.** CAPA z odchylenia uruchamia wniosek o zmianę, czyli tak, jak w prawdziwym systemie jakości.
- **Reguły wymuszone także w bazie** (CHECK), a nie tylko na formularzu.

## Ograniczenia (uczciwie)

- To projekt i specyfikacja, nie konfiguracja w WEBCON. Nie miałem dostępu do środowiska WEBCON BPS.
- Tabele `Rejestr_Zmian`, `Ocena_Wplywu` i `Zadania_Zmiany` to kopia na potrzeby raportów. W prawdziwym wdrożeniu dane trzyma WEBCON w swojej bazie, a raporty można budować bezpośrednio w Portalu.
- Klasyfikacja i role są uproszczone. W prawdziwym zakładzie wynikają z procedury firmy, a zmiany wymagające zgłoszenia do urzędu ocenia dział spraw rejestracyjnych według przepisów o zmianach w pozwoleniu na dopuszczenie do obrotu.
- Skrypty SQL sprawdziłem parserem składni (sqlglot) i ręcznym przeliczeniem wyników raportów, ale nie uruchomiłem ich na SQL Server.
- System nie jest zwalidowany (Annex 11).

## Co dalej

1. Konfiguracja w WEBCON BPS (wersja próbna lub Express) i zrzuty ekranu.
2. Uruchomienie skryptów na SQL Server Express i porównanie wyników z oczekiwanymi.
3. Ocena ryzyka (np. prosta FMEA) jako osobny formularz dla zmian krytycznych.

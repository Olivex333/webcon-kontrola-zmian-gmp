# Scenariusze testowe – Kontrola zmian

| # | Scenariusz | Kroki | Oczekiwany wynik | Reguła |
| --- | --- | --- | --- | --- |
| T01 | Wniosek bez uzasadnienia | krok 1, puste „Uzasadnienie”, Wyślij | walidacja blokuje wysłanie | formularz |
| T02 | Nadanie numeru | wyślij poprawny wniosek | sygnatura `CC/2026/000n` | – |
| T03 | Zwrot do uzupełnienia | krok 2, ścieżka „Do uzupełnienia” z komentarzem | wniosek wraca do inicjatora, komentarz widoczny | – |
| T04 | Klasyfikacja bez działów | krok 2, klasa „Poważna”, brak działów | walidacja blokuje przejście | formularz |
| T05 | Zadania równoległe | wybierz 4 działy | powstają 4 zadania oceny wpływu, termin +10 dni roboczych | 5 |
| T06 | Niepełna ocena wpływu | 3 z 4 działów złożyły ocenę | przejście do zatwierdzenia niedostępne | 3 |
| T07 | Przypomnienie | termin oceny minął | e-mail do oceniającego i QA; raport 2 pokazuje dział | 5 |
| T08 | Zmiana krytyczna – jeden podpis | klasa „Krytyczna”, zatwierdza tylko kierownik QA | obieg czeka na dyrektora zakładu | 4 |
| T09 | Ponowne uwierzytelnienie | ścieżka „Zatwierdź” | wymagane hasło (podpis elektroniczny) | Annex 11 |
| T10 | Realizacja przed zatwierdzeniem | `UPDATE` Krok = 'Realizacja zadań' bez DataZatwierdzenia | błąd `CK_RealizacjaPoZatwierdzeniu` | 1 |
| T11 | Brak zgody urzędu | WymagaZgloszenia = 1, zgoda „Oczekuje”, próba realizacji | obieg czeka w kroku 4a; w bazie błąd `CK_ZgodaPrzedRealizacja` | 2 |
| T12 | Otwarte zadanie | jedno zadanie „Otwarte”, ścieżka „Wszystkie zadania wykonane” | walidacja blokuje przejście | 6 |
| T13 | Nieskuteczna zmiana | krok 6, „Nieskuteczna” bez komentarza / z komentarzem | bez komentarza blokada; z komentarzem powrót do kroku 5 | – |
| T14 | Ślad audytowy | zmień klasyfikację i krok | 2 wpisy w `Audit_Zmiany` z loginem i datą | Annex 11 |

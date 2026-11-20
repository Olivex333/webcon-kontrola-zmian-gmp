# Obieg „Kontrola zmian”

## Kroki

| # | Krok | Kto | Ścieżki | Akcje i walidacje |
| --- | --- | --- | --- | --- |
| 1 | Wniosek o zmianę | inicjator | Wyślij | sygnatura `CC/{rok}/{numer}`; wymagane: stan obecny, proponowana zmiana, uzasadnienie |
| 2 | Ocena wstępna QA | grupa „QA” | Klasyfikuj i przekaż do oceny, Do uzupełnienia, Odrzuć | wymagane: klasyfikacja i co najmniej jeden dział do oceny; termin oceny = 10 dni roboczych |
| 3 | Ocena wpływu | wybrane działy (zadania równoległe) | Wszystkie oceny gotowe | każdy dział: wpływ tak/nie, opis, zadania; sprawy rejestracyjne: czy wymaga zgłoszenia do urzędu |
| 4 | Zatwierdzenie | kierownik QA (+ dyrektor zakładu dla krytycznych) | Zatwierdź, Do poprawy, Odrzuć | ponowne uwierzytelnienie; wybór ścieżki zależny od „wymaga zgłoszenia do urzędu” |
| 4a | Oczekiwanie na zgodę rejestracyjną | sprawy rejestracyjne | Zgoda uzyskana | data i numer decyzji |
| 5 | Realizacja zadań | właściciele zadań | Wszystkie zadania wykonane | walidacja: każde zadanie „wykonane” z datą |
| 6 | Weryfikacja skuteczności | kierownik QA | Skuteczna, Nieskuteczna | komentarz wymagany przy „Nieskuteczna” |
| – | Zamknięta / Odrzucona | – | – | e-mail do inicjatora |

## Akcje automatyczne

- Zapis do `dbo.Rejestr_Zmian`, `dbo.Ocena_Wplywu` i `dbo.Zadania_Zmiany` przy przejściach ścieżek (komenda SQL) na potrzeby raportów.
- Codziennie o 7:00: przypomnienia o ocenach wpływu i zadaniach przed terminem i po nim.
- Gdy wniosek ma powiązane odchylenie, link do niego jest widoczny na formularzu, a w odchyleniu pojawia się numer zmiany.

## Uprawnienia

- Inicjator widzi swój wniosek i jego status.
- Oceniający widzą wnioski, do których ich dział został wybrany.
- QA widzi wszystko; po zatwierdzeniu nie da się zmienić opisu zmiany bez powrotu do oceny wpływu.

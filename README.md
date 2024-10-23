System Zarządzania Zoo w Motoko ( dodawanie zwierzaków do struktury danych ) 

______________________
[+] Dodajemy Zwierzaka:
createAnimal: (text, variant {Gad; Owad; Plaz; Ptak; Ssak}, nat, variant {Afryka; Arktyka; AmerykaPoludniowa; Asia; Europa; AmerykaPolnocna; Antarktyda; Australia; Oceania}) → (text) 

1. Dodajemy kolejno: Nazwę (Text) np: Lew
2. Wskazujemy grupę zwierząt (variant): SSak
3. Podajemy wiek zwierzaka (Nat) : 5
4. Podajemy region zwierzaka (variant) : Afryka
   
[ == Call == ] 
Wynikiem wykonania Funkcji będzie komunikat z id zmierzaka
______________________
[x] Usuwamy Zwierzaka:
deleteAnimal: (nat) → () oneway

Podajemy Id zwierzaka do usunięcia. Po usunięciu dostajemy komunikat o usunięciu 
zwierzaka.
______________________
[v] Sprawdzamy Zwierzaka po Nazwie:
showAnimalByName: (text) → (text) 

Wprowadzamy nazwę zwierzaka. Buffer jest przeszukiwany i w momęcie znalezienia nazwy pasującej do podanej wyświetla nam dane zwierzaka.
______________________
[o] Wyświetlanie wszystkich nazw Zwierzaków w Bufforze 
showAllAnimal: () → (text) 

To jest wyłącznie testowo. Wyświetla wszystkie wartości animal_name z Buffora.
______________________
[B->A] Przenoszenie danych z Buffora do Tablicy ( Przed Aktualizacją )
PreUpgrade_A: () → () oneway

Funkcja służy do przenoszenia danych pomiędzy Aktualizacjami. Wykonujemy ją przed uruchomieniem aktualizacji poniważ po aktualizacji dane z Buffora polecą w kosmos.
Natomiast tablica oznaczona jako stable będzie po aktualizacji trzymała dane. Tablica służy jako przejściowy Storage danych do 
zapisu stanu bufora pomiędzy aktualizacjami. 
______________________
[A->B] Przenoszenie danych z  Tablicy do Bufora ( Po Aktualizacji )  

Funkcja służy do przenoszenia danych po Aktualizacji kanistra. Dane przenoszone są z Tablicy do Bufora.
______________________

Opis działania: 

Projekt ten implementuje prosty system zarządzania zoo, wykorzystujący funkcjonalność tablic, wariantów i bufora w języku Motoko. Kod umożliwia przechowywanie danych o zwierzętach w zoo oraz oferuje funkcje dodawania, usuwania i wyszukiwania zwierząt po nazwie.

Projekt pokazuje, jak obsługiwać tymczasowe dane przy użyciu buforów oraz jak  przenosić te dane do pamięci stabilnej za pomocą tablic. 
Ponieważ bufory w Motoko nie mogą przechowywać danych w pamięci stabilnej, to podejście zapewnia, że informacje o zwierzętach są bezpiecznie przechowywane między aktualizacjami kanistra lub restartami systemu.
Kluczowe funkcje:

    Dodawanie zwierząt: Możliwość łatwego dodawania nowych zwierząt z atrybutami, takimi jak indeks, nazwa, gatunek, wiek i region.
    Usuwanie zwierząt: Usuwanie rekordów zwierząt z kolekcji poprzez podanie ich indeksu.
    Podgląd danych zwierząt: Wyszukiwanie zwierząt po nazwie i uzyskiwanie szczegółowych informacji.
    Przenoszenie danych z bufora do tablic: Dane są najpierw przechowywane w buforze, a następnie przenoszone do pamięci stabilnej za pomocą tablic, co zapewnia ich trwałość.

Technologie i techniki:

    Bufory (Buffer): Używane do tymczasowego przechowywania danych o zwierzętach w pamięci operacyjnej ( docelowe operacje na buforach) 
    Tablice (Array): Służą jako stabilna pamięć do przechowywania danych o zwierzętach, zapewniając ich trwałość po przeniesieniu z bufora.
    Warianty (Variant): Służą do przechowywania danych o typie zwierzęcia i regionie z jakiego pochodzi.
    Pamięć stabilna w Motoko: Przykład efektywnego przenoszenia danych między pamięcią tymczasową a stabilną w kanistrze Motoko.

Zastosowania:

    Odpowiednie dla systemów, gdzie tymczasowe zbieranie danych wymaga bezpiecznego zapisywania w trwałej pamięci.
    Przykład: System zarządzania zoo, który tymczasowo przechowuje nowe wpisy w pamięci, a następnie okresowo przenosi je do pamięci stabilnej.

    Uwagi.

    Celem zapisania danych do tablicy z Bufora należy uruchomić funkcję () -> jednokierunkową public func PreUpgrade_A(): ()
               |
               |
                -----------------> Po Aktualizacji dane z Tablicy wpisujemy do Bufora przy pomocy funckji public func PostUpgrade_B(): ()

import Buffer "mo:base/Buffer";
import  Text "mo:base/Text";
import Array "mo:base/Array";
import Nat "mo:base/Nat";

actor Program 
{

// To są Varianty                                    https://play.motoko.org/?tag=782751346
type Spice = { #Ssak; #Gad; #Plaz; #Ptak; #Owad}; 
type Region = {#AmerykaPolnocna; #Asia;#Afryka;#Australia;#Europa;#Antarktyda;#Arktyka;#AmerykaPoludniowa;#Oceania};

stable var index = 10; // Dodajemy do Buffera rekordy numerowane od 10 

// To jest Rekord do Buffera dodajemy zmienne tego typu
type Animal = {
 index : Nat;
 animal_name:Text;
 spice : Spice;
 age : Nat;
 region : Region;
};

// To jest stabilna tablica do przechowywania rekordów zwierząt Array może być stable dlatego ją stosujemy 
// do przechowania wartości pomiędzy Aktualizacjami kanistra

stable var animalArray :[Animal] = [];

// To jest non-stable Buffer do zapisywania zwierząt działa on na bieżącą, ale nie może byc stable 
var buff = Buffer.Buffer<Animal>(0); 

    public func deleteAnimal(id: Nat) : () {
    var newBuffer = Buffer.Buffer<Animal>(0); // Nowy bufor do przechowywania zwierząt, które nie są usunięte
    Buffer.iterate<Animal>(buff, func(animal: Animal) {
    if (animal.index != id) { // Sprawdzamy, czy index zwierzęcia nie jest równy podanemu id
    newBuffer.add(animal); // Dodajemy zwierzę do nowego bufora
    }
        });
        buff := newBuffer; // Przypisujemy nowy bufor z usuniętymi elementami do buff
    };


public func createAnimal(name_anim : Text, spicex : Spice, agex : Nat, regionx : Region) : async Text
{
 index +=1;  // Zwiększamy index dla obiektu o 1 ( coś ala auto increment )
 let myAnimal : Animal = { index; animal_name=name_anim; spice = spicex;age = agex; region = regionx;};
 buff.add(myAnimal);
 let idx = buff.size();
 return " Dodałem zwierzaka o id: "#Nat.toText(index)#" i indeksie "#Nat.toText(idx);
};

private func bufferToText() : async Text 
{
 var zuno = "";
 Buffer.iterate<Animal>(buff, func( animals : Animal) {
 zuno  := Text.concat(zuno," "#animals.animal_name);
});
return zuno;
};

// Testowo do wyświetlania wszystkich nazw zwierzaków 
public func showAllAnimal() : async Text {

    return await bufferToText();
};

// Funkcja tłumacząca Variant na tekst z Regionu
private func checkRegion(region: Region) : Text 
{
switch(region)
{
  case (#AmerykaPolnocna) { return " Ameryka Północna "};
  case (#Asia) {return " Asia "};
  case (#Afryka) {return " Afryka "};
  case (#Australia) {return " Australia "};
  case (#Europa) {return " Europa "};
  case (#Antarktyda) { return "Antarktyda"};
  case (#Akrtyka) { return "Arktyka"};
  case (#AmerykaPoludniowa) { return "Ameryka Południowa"};
  case (#Oceania) { return "Oceania"};
}
};

// Funkcja tłumacząca Gatunek Spice na tekst z Variantu Spice
private func checkSpice(spic : Spice) : Text
{
switch(spic)
{
  case (#Ssak) { return " Mamal "};
  case (#Gad) {return " Reptile "};
  case (#Plaz) {return " Amfibiant "};
  case (#Ptak) {return " Bird "};
  case (#Owad) {return " Insect "};

}
};

// Funkcja wyświetlająca przy pomocy funkcji iteracji dane zwierzaka po nazwie 
public func showAnimalByName(name : Text) : async Text {

var spic = "";
var reg = "";
var animal_data = "Nie znaleziono zwierzaka o podanej nazwie "#name;
Buffer.iterate<Animal>(buff, func( animals : Animal) {
  if (name == animals.animal_name)
  {
  spic := checkSpice(animals.spice);
  reg := checkRegion(animals.region);
  animal_data := " Znaleziono : Obiekt ID = "#Nat.toText(animals.index)#" | "#animals.animal_name#" | Gatunek: "#spic#" | Wiek: "#Nat.toText(animals.age)#" | Region: "#reg;
   }
});
 return animal_data;
};

// TO WYKONAJ PRZED Updatem !!!                                   <---------- Przed Updatem
// Funkcja przed aktualizacją kanistra - przenosi dane z bufora do tablicy

  public func PreUpgrade_A(): () {
    // Zrzucanie danych z Buffer do stabilnej Array
    animalArray := [];
    Buffer.iterate<Animal>(buff, func(animal: Animal) {
    animalArray := Array.append<Animal>(animalArray, [animal]);
    });
  };

// TO WYKONAJ PO Updacie !!!                                   <----------------- Po Updacie
 
  public func PostUpgrade_B(): () {

    buff := Buffer.Buffer<Animal>(0); 
    buff := Buffer.fromArray<Animal>(animalArray);
   };
  };



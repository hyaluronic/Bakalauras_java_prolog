# Baigiamasis bakalauro darbas - Automatinio įrodymo sistema laiko logikai (angl. _Automated theorem prover for temporal logic_)

Faile [https://github.com/hyaluronic/Bakalauras_java_prolog/blob/master/src/main/resources/jar/prolog-0.0.1-SNAPSHOT.jar](https://github.com/hyaluronic/Bakalauras_java_prolog/blob/master/src/main/resources/prolog/bakalauras.pl)](https://github.com/hyaluronic/Bakalauras_java_prolog/blob/master/src/main/resources/prolog/bakalauras.pl) yra pateikiamas pagrindinis teoremų įrodymo algoritmas.

## Algoritmo paleidimo per komandinę eilutę instrukcija (darant pažingsniui užtruksite apie 5 min.):
1. Operacinė sistema turi būti Windows 10 ar naujesnė;
2. Atsisiųsti programinį kodą iš „Github“ versijų kontrolės sistemos į kompiuterį [https://github.com/hyaluronic/Bakalauras_java_prolog/archive/refs/heads/master.zip](https://github.com/hyaluronic/Bakalauras_java_prolog/archive/refs/heads/master.zip);
3. Atsisiųsti „SWI–Prolog“ 9.0.3 versiją [https://www.swi-prolog.org/download/stable/bin/swipl-9.0.3-1.x86.exe.envelope](https://www.swi-prolog.org/download/stable/bin/swipl-9.0.3-1.x64.exe.envelope);
4. Atsidaryti „SWI–Prolog.exe“ failą;
5. Iškviesti predikatą „consult(File)“, kur vietoj „File“ tarp kabučių nurodytas pilnas kelias iki „bakalauras.pl“ failo, esančio kompiuteryje (keliui nurodyti naudoti „/“ ne „\“) arba spausti mygtuką „File“ ‑> „Consult“ ir pasirinkti „bakalauras.pl“ failą.

## Algoritmo sąsajos su failais paleidimo instrukcija (darant pažingsniui užtruksite apie 7 min.):
1. Atlikti visus veiksmus tokius pačius kaip algoritmo paleidimui per komandinę eilutę;
2. Susikurti tekstinio formato (.txt) įvesties failą, kurio kiekviena eilutė yra norima išvesti teorema. Eilutė privaloma užbaigti tašku.;
3. „SWI–Prolog“ komandinėje eilutėje iškviesti predikatus: „read_file(Input_file, Input), prove_list(Input, Result), write_to_file(Output_file, Result).“, vietoj „Input_file“ kabutėse nurodant pilną kelią iki įvesties failo, o vietoj „Output_file“ – pilną kelią iki išvesties failo. (predikatų iškvietimo pavyzdys: „read_file(’C:/Users/user/Desktop/input.txt’, Input), prove_list(Input, Result), write_to_file(’C:/Users/user/Desktop/output.txt’, Result).“)
4. Rezultatą peržiūrėti atsidarius išvesties failą;

## Grafinio vizualizavimo sistemos paleidimo instrukcija, naudojant „prolog‑0.0.1‑SNAPSHOT.jar“ failą (darant pažingsniui užtruksite apie 5 min.):
1. Operacinė sistema turi būti Windows 10 ar naujesnė;
2. Atsisiųsti Oracle Java JDK 17 [https://download.oracle.com/java/17/archive/jdk-17.0.7_windows-x64_bin.msi](https://download.oracle.com/java/17/archive/jdk-17.0.7_windows-x64_bin.msi);
3. Atsisiųsti „SWI–Prolog“ 9.0.3 versiją [https://www.swi-prolog.org/download/stable/bin/swipl-9.0.3-1.x64.exe.envelope](https://www.swi-prolog.org/download/stable/bin/swipl-9.0.3-1.x64.exe.envelope)
4. Atsisiųsti „prolog‑0.0.1‑SNAPSHOT.jar“ failą iš „Github“ versijų kontrolės sistemos į kompiuterį [https://github.com/hyaluronic/Bakalauras_java_prolog/raw/master/src/main/resources/jar/prolog-0.0.1-SNAPSHOT.jar](https://github.com/hyaluronic/Bakalauras_java_prolog/raw/master/src/main/resources/jar/prolog-0.0.1-SNAPSHOT.jar);
5. Atsidaryti Windows komandinę eilutę („Command Prompt“), nueiti į katalogą, kuriame yra „prolog0.0.1‑SNAPSHOT.jar“ failas ir parašyti komandą: „java ‑jar prolog‑0.0.1‑SNAPSHOT.jar“;
Arba du kartus paspausti ant „prolog‑0.0.1‑SNAPSHOT.jar“ failo;
6. Sistema yra pasiekiama per žiniatinklio naršyklę adresu [http://localhost:8090](http://localhost:8090);
7. Norint sistemą išjungti Windows komandinėje eilutėje („Command Prompt“) parašyti komandą „taskkill /F /IM java.exe /T“.

## Grafinio vizualizavimo sistemos paleidimo instrukcija, naudojant IDE (darant pažingsniui užtruksite apie 15 min.):
1. Operacinė sistema turi būti Windows 10 ar naujesnė;
2. Atsisiųsti Oracle Java JDK 17 [https://download.oracle.com/java/17/archive/jdk-17.0.7windows-x64_bin.msi](https://download.oracle.com/java/17/archive/jdk-17.0.7_windows-x64_bin.msi);
3. Atsisiųsti „SWI–Prolog“ 9.0.3 versiją [https://www.swi-prolog.org/download/stable/bin/swipl-9.0.3-1.x64.exe.envelope](https://www.swi-prolog.org/download/stable/bin/swipl-9.0.3-1.x64.exe.envelope)
4. Atsisiųsti IDE, kuris palaiko Java (pvz.: „IntelliJ IDEA“ [https://www.jetbrains.com/idea/download/#section=windows](https://www.jetbrains.com/idea/download/#section=windows) arba „Eclipse IDE“);
5. Atsisiųsti programinį kodą iš „Github“ versijų kontrolės sistemos į kompiuterį [https://github.com/hyaluronic/Bakalauras_java_prolog/archive/refs/heads/master.zip](https://github.com/hyaluronic/Bakalauras_java_prolog/archive/refs/heads/master.zip) ir jį atsidaryti su IDE;
6. Surasti klasę „PrologApplication.java“ ir ją paleisti spaudžiant „Run ’PrologApplication’“ mygtuką arba spaudžiant „Shift + F10“ mygtukus („IntelliJ IDEA Ultimate edition“);
Jeigu naudojama „Intllij IDEA community edition“, tai paleisti galima spaudžiant „maven“ ‑> „prolog“ ‑> „plugins“ ‑> „spring‑boot“ ‑> „spring‑boot:run“;
7. Sistema yra pasiekiama per žiniatinklio naršyklę adresu [http://localhost:8090](http://localhost:8090).

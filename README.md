# Bible Toolbox sovellus

Android-sovellus [Bible Toolbox](https://www.bibletoolbox.net/) nettisivusta.

## Sisällysluettelo
1. [Yleiskatsaus](#yleiskatsaus)
1. [Järjestelmän yleiskatsaus](#järjestelmän-yleiskatsaus)
1. [Projektin rakenne](#projektin-rakenne)
1. [Avainkomponentit](#avainkomponentit)
1. [Testaus](#testaus)


## Yleiskatsaus

Sovellus on luotu nettisivun lisäksi palvelemaan sen käyttäjiä ympäri maailmaa. Sovelluksen materiaali on täysin sama
kuin nettisivulla, mutta se tarjoaa muutamia käyttöä helpottavia ominaisuuksia, kuten käytön ilman
nettiyhteyttä ja kirjainmerkkien asettamisen.

## Järjestelmän yleiskatsaus
- Koodauskieli: Dart (Flutter)
- API: https://www.bibletoolbox.net/d7/marty-api/info
- Sovelluksen käyttöjärjestelmä: Android (iOS on mahdollista toteuttaa saman koodin pohjalta)


## Projektin rakenne
```
lib/
├── core/           # Sovelluksen teemat, vakiot
├── data/           # API, datan käsittely, luokat
├── l10n/           # Sovelluksen käyttöön liittyvät tekstit
├── presentation/   # UI (sivut, widgetit)
├── providers/      # Sovelluksen kielen hallitsija
└── main.dart       # Sovelluksen käynnistystiedosto

assets/
├── btb_images/     # Sovelluksen käyttämät kuvat
├── fonts/          # Sovelluksen käyttämät fontit
```

## Avainkomponentit

### API-datan haku
- API-datan hakemisesta vastaa sovelluksen ApiService luokka (lib/data/services/api_service.dart).
- Data haetaan aina kokonaisuudessaan jokaiselle halutulle kielelle kerrallaan.
   - Poikkeuksena sovellukselle jo ladatun datan päivitys tarvittaessa, jolloin haetaan vain edellisen lataushetken jälkeiset artikkelit.
   - API rajoittaa haun korkeintaan 100 artikkelin saamiseen, joten haku toistetaan tarvittava määrä kaikkien artikkeleiden saamiseksi.
- Data tallennetaan laitteelle suoraan sen hakemisen jälkeen (ks. [API-datan tallennus laitteelle](#tallennus)), jonka lisäksi laitteella olevat metatiedot API-datasta päivitetään (ks. [Metatietojen käsittely](#metatiedot)).
- Jos datan hakeminen epäonnistuu (esim. heikon nettiyhteyden takia), mitään dataa kesken jääneeltä kieleltä ei tallenneta laitteelle.

<a id="tallennus"></a>
### Cache / API-datan tallennus laitteelle
- Haettu API-data tallennetaan laitteelle, jotta sitä ei tarvitse aina erikseen hakea. Tämä mahdollistaa myös sovelluksen offline käytön.
- Datan tallentamiseen laitteelle käytetään [Hive](https://github.com/isar/hive)-kirjastoa sen helppokäyttöisyyden, tehokkuuden ja monipuolisuuden johdosta.
- Jokainen oma kieli tallennetaan omana Hive-laatikkona. Laatikon rakenne on alla olevan kaltainen.
  - 'key' on kielen kaksikirjaiminen koodi.
  - 'data' sisältää suoraan API:n kautta haetut tiedot.
  - 'version' sisältää versionumeron (tällä hetkellä automaattisesti 1).
  - Jokaisen kielen ollessa omassa laatikossaan voi jokaisen kielen koon saada helposti selville.
```
key: [String, kielikoodi]
{
    'data': [List<Map<String, dynamic>>]
        [
            {
                id: [int]
                type: [String]
                title: [String]
                language: [String]
                created: [int, seconds]
                changed: [int, seconds]
                body: [Map<String, dynamic>]
                    value: [String]
                    summary: [String]
                taxonomy: [List<Map<String, dynamic>>]
                    [
                        {
                        tid: [int],
                        name: [String],
                        vid: [int],
                        vocabulary: [String]
                        }
                    ]
            },
            ...
        ]       
    'version': [int]
}
```
- Hive:n avulla halutut sivut/artikkelit on helppo hakea synkronisesti (ilman odotusta).
    
<a id="metatiedot"></a>
### Metatietojen käsittely
Kielilaatikoiden lisäksi laitteella on Hiven avulla tallennettu "Meta-laatikko", joka sisältää jokaisesta ladatusta kielestä versionumeron ja viimeisimmän päivitysajankohdan. Näiden tietojen avulla pidetään kirjaa ladatuista kielistä ja tarkistetaan mahdollisia päivityksiä API-datalle. Alla näkyy "Meta-laatikon" rakenne.

```
[Map<String, dynamic>]
{
[String, kielikoodi]: 
    {
    "version": [int]1,
    "lastUpdated": [int, millisecondsSinceEpoch]
    },
...
}
```

### API tekstin esittäminen

API-datan sisältämät tekstit ovat Markdown-muodossa sisältäen HTML-muotoisia komponentteja. Sovellus käyttää datan käsittelyyn [flutter_markdown_plus](https://pub.dev/packages/flutter_markdown_plus)-kirjastoa. Se pystyy suoraan muuttamaan Markdown-tyylisen tekstin niin kuin se on tarkoitettu näytettäväksi. Markdown-tekstin tyylittelystä vastaa ApiTextWidget-widgetti (lib/data/widgets/api_text_widget.dart).

HTML-komponentteja valittu kirjasto ei kuitenkaan pysty käsittelemään. Se oli kuitenkin kaikista monipuolisin vaihtoehto, ja sen avulla pystyi löytämään kiertoteitä HTML-komponenttien näyttämiseen. Seuraava info näyttää, miten dataa on tarvinnut muokata, jotta se toimisi näkyisi oikein.

API-datan tekstiä tulee muokata kahdesta syystä:  
1. Tekstin ulkoasu halutaan yhteneväiseksi muun ulkoasun kanssa.
2. HMTL-komponentit pitää muokata yhteensopiviksi Markdownin kanssa.

API-datan putsaus on pääasiallisesti suoritettu ApiTextCleaner-luokassa (lib/data/services/api_text_cleaner.dart). Seuraavaksi esitellään ne kohdat, joissa on API-dataa muokattu erityisellä tavalla:

#### Lainaukset
Lainaukset ovat jo Markdown-muodossa, mutta ne on muokattu visuaalisesti, esimerkiksi sisältämään "-merkin.

#### Linkit
HTML-linkit on muokattu Markdown-muotoon.
```
<a href=\"https://raamattu.fi/raamattu/KR92/GEN.1/1.-Mooseksen-kirja-1\" target=\"_blank\">Raamattu netissä</a> 

=> [Raamattu netissä](https://raamattu.fi/raamattu/KR92/GEN.1/1.-Mooseksen-kirja-1\)
```

#### Koti-, Vastaukset- ja Raamattu-sivut
Näille sivuille tuli ulkoasuksi erilainen kuin nettisivuilla, joten ne tarvitsivat vähän enemmän muokkaamista. Ensin jokaisen sivun muokattava osuus (yleensä se, mikä sisältä jatkolinkit), muokattiin markdownissa koodilaatikon muotoon sisältäen tunnisteen alla olevan mallin mukaisesti.

~~~
[Muokattava tekstiosuus]

=>

´´´
[ID][ID_erottaja][Muokattava tekstiosuus]
´´´
~~~

Tämän jälkeen Markdownia näyttävän kirjaston tunnistettaessa koodilaatikko, pystyin erikseen rakentamaan tarvittavat koodipalaset ID-tunnisteiden perusteella.

##### Koti-sivu
- Koti-sivulla alkuperäinen taulukko sisältäen linkit eri kategorioihin toteutettiin sovelluksessa visuaalisesti hieman eri tavalla.
- Jokainen taulukon elementti muutettiin napiksi sisältäen oikean kuvan.
- Näiden jälkeen lisättiin Satunnainen kysymys -nappi.
- Nämä asetettiin näkymään ensimmäisen tekstikappaleen jälkeen.

##### Vastaukset-sivu
- Vastaukset-sivulla olevat kysymykset oli tarkoitus kategorisoida käyttäjäystävällisyyden vuoksi.
- Kysymykset kategorisoitiin niissä olevien URL-linkkien perusteella.

##### Raamattu-sivu
- ...

#### Muuta

- Fonttimerkinnät
``` <FONT ...> ja </FONT> ``` poistettu.  
- Boldaukset muutettu ```<b> [teksti] </b> => ** [teksti] ** ```-
- Rivinvaihdosmerkit ```<br> ja </br>``` poistettu.
- HTML-kommentit ```<!-- [Kommentti] -->``` poistettu.
- Otsikot muokattu ```#Otsikko => # Otsikko``` (välilyönti #-merkin jälkeen).



## Running the App

## Testaus

## Tunnetut ongelmat


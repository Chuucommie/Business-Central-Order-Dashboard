# Business Central Order Dashboard

Una moderna estensione per Microsoft Dynamics 365 Business Central che fornisce una dashboard completa per la visualizzazione degli ordini di vendita con filtri colorati e statistiche in tempo reale.

## 🚀 Caratteristiche Principali

### 📊 **Dashboard Ordini**
- Visualizzazione completa degli ordini di vendita
- Filtri per stato (aperti/chiusi/in attesa)
- Colorazione automatica basata sullo stato
- Statistiche in tempo reale

### 🎨 **Sistema di Colori**
- 🟢 **Verde** - Ordini aperti e rilasciati
- 🟡 **Giallo** - Ordini in elaborazione
- 🟠 **Arancione** - Ordini in attesa di approvazione/prepagamento
- 🔴 **Rosso** - Ordini chiusi o urgenti

### 📈 **Statistiche Avanzate**
- Numero totale di ordini
- Valore totale e medio
- Ordini del giorno
- Ordini in ritardo
- Statistiche per priorità

### 🔍 **Filtri Dinamici**
- Filtri per stato ordine
- Filtri per range di date
- Filtri per priorità
- Reset rapido filtri

## 📁 Struttura del Progetto

```
Business-Central-Order-Dashboard/
├── app.json                           # Manifesto dell'applicazione
├── Page50100.OrderDashboard.al        # Dashboard principale
├── Page50101.OrderStatisticsFactBox.al # FactBox statistiche
├── Page50102.OrderDashboardCard.al   # Dashboard con filtri
├── Page50103.OrderDashboardList.al   # Lista ordini stilizzata
├── Report50100.OrderDashboardReport.al # Report esportazione
├── TableExt50100.SalesHeaderExtension.al # Estensione tabella
├── Enum50100.OrderPriority.al        # Enum priorità ordini
├── EnumExt50100.OrderStatusExtension.al # Estensione stati ordini
└── README.md                          # Documentazione
```

## 🛠️ Componenti dell'Estensione

### Pages (Pagine)
- **Order Dashboard** - Dashboard principale con lista ordini
- **Order Statistics FactBox** - Statistiche in tempo reale
- **Order Dashboard Card** - Dashboard con controlli filtri
- **Order Dashboard List** - Lista ordini con colorazione dinamica

### Tables & Extensions
- **Sales Header Extension** - Campi aggiuntivi per priorità e statistiche
- **Order Priority Enum** - Livelli di priorità ordini
- **Order Status Extension** - Stati aggiuntivi per ordini

### Reports
- **Order Dashboard Report** - Report esportabile Excel

## 🎯 Utilizzo

### Accesso alla Dashboard
1. Installare l'estensione in Business Central
2. Navigare a "Order Dashboard" dal menu principale
3. Utilizzare i filtri per visualizzare ordini specifici

### Funzionalità Principali
- **Visualizzazione Ordini**: Lista completa con stato colorato
- **Filtri Rapidi**: Status, date, priorità
- **Statistiche**: Totali, medie, ordini del giorno
- **Esportazione**: Export Excel dei dati filtrati

### Colori e Stili
- **Verde**: Ordini attivi e in lavorazione
- **Giallo**: Ordini rilasciati ma non completati
- **Arancione**: Ordini in attesa di azioni
- **Rosso**: Ordini urgenti o scaduti

## 🔧 Requisiti di Sistema

- **Microsoft Dynamics 365 Business Central** versione 21.0 o superiore
- **Permessi**: Lettura su testate ordini di vendita
- **Lingue**: Italiano, Inglese

## 📦 Installazione

### Passo 1: Download
```bash
git clone https://github.com/Chuucommie/Business-Central-Order-Dashboard.git
cd Business-Central-Order-Dashboard
```

### Passo 2: Compilazione
```bash
# Usando AL Language Extension in VS Code
# oppure con comando AL Compiler
alc /project:Business-Central-Order-Dashboard /out:Business-Central-Order-Dashboard.app
```

### Passo 3: Pubblicazione
- Caricare il file .app in Business Central
- Installare l'estensione nell'ambiente desiderato

## 🎨 Personalizzazione

### Modifica Colori
I colori possono essere personalizzati modificando le funzioni `GetStatusStyle()` e `GetPriorityStyle()` nelle pagine.

### Aggiunta Nuovi Filtri
Nuovi filtri possono essere aggiunti nel Page50102.OrderDashboardCard.al

### Statistiche Personalizzate
Le statistiche possono essere estese nel Page50101.OrderStatisticsFactBox.al

## 📊 Funzionalità Tecniche

### Performance
- Query ottimizzate per statistiche aggregate
- Calcolo asincrono dei valori
- Caching dei risultati

### Sicurezza
- Validazione permessi utente
- Filtri automatici per ambiente
- Logging delle operazioni

### Integrazione
- Compatibile con standard Business Central
- API REST disponibili
- Supporto multi-lingua

## 🤝 Contributi

I contributi sono benvenuti! Per favore:
1. Fare fork del repository
2. Creare una branch per la feature
3. Fare commit delle modifiche
4. Fare push della branch
5. Creare una Pull Request

## 📄 Licenza

Questo progetto è distribuito sotto licenza MIT. Vedi il file [LICENSE](LICENSE) per dettagli.

## 🐛 Supporto e Bug

Per segnalazioni di bug o richieste di supporto:
- Aprire una Issue su GitHub
- Contattare il supporto tecnico
- Consultare la documentazione ufficiale

## 🔄 Changelog

### v1.0.0.0 (Release Iniziale)
- Dashboard ordini con filtri colorati
- Statistiche in tempo reale
- Export Excel
- FactBox con riepilogo dati
- Sistema priorità ordini

---

**Sviluppato da IgelDev** | **Powered by Business Central**

Per maggiori informazioni e supporto, visita il [repository GitHub](https://github.com/Chuucommie/Business-Central-Order-Dashboard).
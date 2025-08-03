# 💰 Couple Financial Manager  

A collaborative financial management app for couples, featuring **real-time synchronization** using **STOMP WebSocket**, expense categorization, and interactive charts.  

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.x-green?logo=springboot)
![WebSocket](https://img.shields.io/badge/WebSocket-STOMP-yellow)
![Build](https://img.shields.io/github/actions/workflow/status/your-username/couple-financial-manager/ci.yml?branch=main&label=Build)
![License](https://img.shields.io/badge/license-MIT-blue)

---

## ✅ Features  
✔️ Add transactions (title, amount, category, date)  
✔️ Real-time sync across devices using **Spring Boot + STOMP**  
✔️ Responsive UI with **Material Design 3**  
✔️ Expense charts by category (**PieChart and BarChart**)  
✔️ Total balance tracking  
✔️ Transaction history list  

---

## 🛠 Tech Stack  

### **Frontend (Flutter 3.x)**  
- **Provider** (state management)  
- **stomp_dart_client** (STOMP WebSocket client)  
- **charts_flutter** (charts and graphs)  
- **Material Design 3**  

### **Backend (Spring Boot 3.x)**  
- **Spring WebSocket + STOMP**  
- **Jackson** (JSON serialization)  

---

## 📂 Project Structure  

couple-financial-manager/
│
├── flutter_offline_ready/ # Flutter app
│ ├── lib/
│ │ ├── main.dart # App entry point
│ │ ├── providers/ # State management
│ │ ├── screens/ # Screens (Home, Transactions, Settings)
│ │ ├── widgets/ # Reusable UI components
│ └── pubspec.yaml
│
└── stomp-backend/ # Spring Boot backend
├── src/main/java/
│ ├── config/ # WebSocketConfig
│ ├── controller/ # TransactionController
│ ├── model/ # TransactionModel
└── pom.xml


---

## ▶ How to Run the Project  

### **1. Clone the repository**
```bash
git clone https://github.com/your-username/couple-financial-manager.git
cd couple-financial-manager
```

### **2. Run the Backend**
```bash
cd stomp-backend
mvn spring-boot:run
```

### **3. Run the Flutter App**
```bash
cd flutter_offline_ready
flutter pub get
flutter run
```

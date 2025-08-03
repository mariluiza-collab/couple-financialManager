💰 Couple Financial Manager
A collaborative financial management app for couples, featuring real-time synchronization using STOMP WebSocket, expense categorization, and interactive charts.

✅ Current Features
✔ Add transactions (title, amount, category, date)
✔ Real-time sync across devices with Spring Boot + STOMP
✔ Responsive UI using Material 3
✔ Expense charts by category (PieChart and BarChart)
✔ Total balance tracking
✔ Transaction history list

🛠 Tech Stack
Frontend (Flutter)
Flutter 3.x

Provider (state management)

stomp_dart_client (STOMP WebSocket client)

charts_flutter (charts and graphs)

Material Design 3

Backend (Spring Boot)
Spring Boot 3.x

Spring WebSocket + STOMP

Jackson (JSON serialization)

📂 Project Structure
bash
Copiar
Editar
couple-financial-manager/
│
├── flutter_offline_ready/      # Flutter app
│   ├── lib/
│   │   ├── main.dart           # App entry point
│   │   ├── providers/          # State management
│   │   ├── screens/            # Screens (Home, Transactions, Settings)
│   │   └── widgets/            # Reusable UI components
│   └── pubspec.yaml
│
└── stomp-backend/              # Spring Boot backend
    ├── src/main/java/
    │   ├── config/             # WebSocketConfig
    │   ├── controller/         # TransactionController
    │   └── model/              # TransactionModel
    └── pom.xml
▶ How to Run the Project
1. Clone the repository
bash
Copiar
Editar
git clone https://github.com/your-username/couple-financial-manager.git
2. Run the Backend
bash
Copiar
Editar
cd stomp-backend
mvn spring-boot:run
Backend will start at:

arduino
Copiar
Editar
http://localhost:8080
Key Endpoints:

WebSocket STOMP endpoint: /ws

Broadcast topic: /topic/transactions

Send transaction endpoint: /app/add-transaction

3. Run the Flutter App
bash
Copiar
Editar
cd flutter_offline_ready
flutter pub get
flutter run -d emulator-5554    # Run on Android emulator
flutter run -d chrome           # Run on browser
🌐 Multi-Device Testing
To test on multiple devices:

Find your local IP address (ipconfig on Windows).

Update Flutter code:

dart
Copiar
Editar
url: 'http://YOUR_LOCAL_IP:8080/ws'
Allow firewall access for port 8080.

📌 Message Structure (JSON)
All WebSocket messages follow this structure:

json
Copiar
Editar
{
  "id": "2025-08-03T16:00:00Z",
  "title": "Lunch",
  "amount": -50.0,
  "category": "Food",
  "date": "2025-08-03"
}
📊 Next Steps
✅ SQLite offline storage

✅ Authentication for multiple users

✅ Offline mode + auto-sync

✅ Export reports (PDF/Excel)

🖼 UI Preview
(Screenshots will be added after charts and improved UI are ready)
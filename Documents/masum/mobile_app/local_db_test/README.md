# Offline-First Customer Visit Management App

A Flutter mobile app that lets field sales agents manage customer visits fully offline and sync data to a server when internet is available.

---

## Project Overview

- Customers are fetched from a REST API and stored locally in SQLite
- All reads come from local storage — the API is only used for syncing
- Users can update visit status and log new visits while offline
- Offline changes are queued and synced automatically when internet returns
- A manual "Sync Now" button is also available

---

## Setup Instructions

### 1. Run the Mock Server

The app uses [json-server](https://github.com/typicode/json-server) as a local mock API.

```bash
# Install json-server globally (once)
npm install -g json-server

# Start the server from the mock-server folder
cd mock-server
json-server db.json --port 3000
```

#### For Android Emulator
The base URL is already set to `http://10.0.2.2:3000` in `lib/core/constant.dart`. No change needed.

#### For a Real Device (e.g., SCG15)
1. Find your Mac's local IP: `ifconfig | grep "inet " | grep -v 127`
2. Open `lib/core/constant.dart`
3. Change `baseUrl` to `"http://YOUR_MAC_IP:3000"` (e.g., `"http://192.168.1.5:3000"`)
4. Make sure your phone and Mac are on the **same Wi-Fi network**

### 2. Run the Flutter App

```bash
flutter pub get
flutter run
```

---

## Architecture Explanation

The app follows **Clean Architecture** with clear layer separation:

```
lib/
├── core/               # App-wide utilities
│   ├── constant.dart   # API URL and status constants
│   └── sync/           # Sync engine (SyncService)
├── data/               # Data layer
│   ├── local/          # SQLite data sources
│   ├── models/         # Data models (fromJson / toMap)
│   ├── remote/         # Dio HTTP clients
│   └── repository/     # Combines local + remote
├── database/           # SQLite schema and initialization
├── domain/             # Pure business rules (no framework deps)
│   ├── entities/       # Plain Dart classes
│   └── repository/     # Abstract repository contract
└── presentation/       # UI layer
    ├── controllers/    # GetX state management
    └── screens/        # Flutter widgets
```

**Data flow:**
```
Screen → Controller → Repository → Local DB (always the source of truth)
                               ↘ Remote API (only for syncing)
```

---

## State Management

**GetX** is used for state management.

- `CustomerController` holds all reactive state (`customers`, `isOnline`, `pendingCount`, etc.)
- `Obx()` widgets rebuild automatically when any `RxType` they read changes
- Search and filter are reactive — the list updates instantly as you type

---

## Local Database

**SQLite** via the `sqflite` package with two tables:

### `customers` table
Stores all customer data. The key field is `syncStatus`:
- `synced` — matches server data
- `pending_update` — user changed visit status/notes offline
- `pending_create` — user logged a new visit offline
- `failed` — sync failed after 3 retries

### `sync_queue` table
A queue of pending outgoing API calls. Each row is one request waiting to be sent.
- `operationType`: `create` (POST /visits) or `update` (PUT /customers/{id}/visit-status)
- `payload`: JSON string with the request body
- `retryCount`: incremented on each failed attempt, capped at 3
- `syncStatus`: `pending` → `synced` or `failed`

---

## Offline Sync Flow

```
User saves changes while offline
        ↓
Local DB updated immediately
(syncStatus = pending_update or pending_create)
        ↓
Entry added to sync_queue table
        ↓
Internet detected (auto-sync) OR user taps "Sync Now"
        ↓
SyncService reads all pending queue items
        ↓
For each item: sends HTTP request
  ✓ Success → mark queue item "synced", update customer syncStatus → "synced"
  ✗ Failure → retryCount++ (max 3) → mark "failed" if limit reached
```

**Important rule:** When fetching fresh data from the server, any local customer with `pending_update` or `pending_create` is **skipped** — offline changes are never lost.

---

## API / Mock Server

| Method | Path | Description |
|--------|------|-------------|
| GET | `/customers` | Fetch all customers |
| PUT | `/customers/:id/visit-status` | Update visit status and notes |
| POST | `/visits` | Create a new visit record |

Sample `GET /customers` response:
```json
[
  {
    "id": 1,
    "name": "Rahim Traders",
    "phone": "01700000001",
    "email": "rahim@example.com",
    "address": "Banani, Dhaka",
    "lastVisitDate": "2026-04-20",
    "visitStatus": "pending",
    "notes": "",
    "updatedAt": "2026-04-20T10:00:00Z"
  }
]
```

---

## Known Limitations / Assumptions

- **Real device URL**: Change `baseUrl` in `lib/core/constant.dart` from `10.0.2.2` to your Mac's local IP when using a physical device
- **No conflict detection**: If the server updates a record while you have a pending local change, the local change wins (local-first policy)
- **No pagination**: All customers load at once
- **Customer creation**: New customers come only from the server; the app supports logging new *visits* for existing customers offline

---

## Features Checklist

- [x] Offline-first — always reads from SQLite
- [x] Initial sync from API on app start
- [x] Auto-sync when internet reconnects
- [x] Manual "Sync Now" with pending count badge
- [x] Orange offline mode banner
- [x] Search by name or phone number
- [x] Filter by visit status (All / Pending / Visited / Not Available)
- [x] Pull-to-refresh
- [x] Update visit status and notes offline
- [x] Log a new visit offline (POST /visits queued)
- [x] Sync status indicator on detail screen
- [x] Retry mechanism (max 3 attempts per queue item)
- [x] Pending local changes never overwritten by server sync

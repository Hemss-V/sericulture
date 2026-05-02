# 🌿 Sericulture IoT — Flutter Android App

A smart IoT monitoring and control app for silk farming (sericulture) farm managers.

Built with Flutter + Dart, targeting Android.

---

## Tech Stack

| Package | Purpose |
|---|---|
| `mqtt_client` | MQTT live sensor data & actuator control |
| `dio` | REST API for historical data |
| `fl_chart` | Sensor line charts |
| `flutter_riverpod` | State management |
| `shared_preferences` | Persistent session & settings |
| `flutter_local_notifications` | Background threshold alerts |
| `google_fonts` | Outfit font |
| `go_router` | Navigation |

## MQTT Configuration

- **Broker:** `broker.hivemq.com:1883`
- **Subscribe:** `sericulture/field1/sensors` → `{ temp, humidity, co2, light }`
- **Subscribe:** `sericulture/field1/actuators/status` → `{ fan, heater, mister, status }`
- **Publish:** `sericulture/field1/actuators/cmd` → `{ device, action, source }`

## Sensor Thresholds

| Sensor | Normal | Warning | Critical |
|---|---|---|---|
| Temperature | 24–28°C | 28–33°C | > 33°C |
| Humidity | 70–80% | 60–70% | < 60% |
| CO₂ | < 1000 ppm | 1000–1500 ppm | > 1500 ppm |
| Light | 2000–4000 lux | < 2000 lux | < 1000 lux |

## Project Structure

```
lib/
├── core/
│   ├── constants/     # MqttConstants, ThresholdConstants, AppColors, AppStrings
│   ├── models/        # SensorData, ActuatorStatus, AlertModel, CommandLog
│   ├── services/      # StorageService, MqttService, SimulatorService, NotificationService
│   ├── providers/     # Global Riverpod providers
│   └── theme/         # AppTheme, AppColors
└── features/
    ├── auth/          # Login screen
    ├── dashboard/     # Live sensor cards
    ├── charts/        # Historical fl_chart graphs
    ├── alerts/        # Alert history
    ├── actuators/     # Device control & scheduling
    ├── settings/      # Threshold config & notification prefs
    └── shell/         # Bottom navigation shell
```

## Build Progress

- [x] **Phase 1** — Project skeleton, AppTheme (dark green #1B4332 + amber #F59E0B), feature folder structure, screen skeletons, bottom nav shell
- [x] **Phase 2** — Data layer: constants, immutable models with fromJson/toJson/copyWith, full StorageService
- [ ] **Phase 3** — Auth + MQTT service + MqttSimulator
- [ ] **Phase 4** — Live Dashboard (sensor cards, status badges, online indicator)
- [ ] **Phase 5** — Historical Charts (fl_chart, mock sinusoidal data, time range selector)
- [ ] **Phase 6** — Alerts (in-app banner, local notifications, history list)
- [ ] **Phase 7** — Actuator Control (MQTT publish, automation rules, scheduling)

## Demo Credentials

```
Email:    manager@silk.farm
Password: silk1234
```

## Getting Started

```bash
flutter pub get
flutter run -d android
```

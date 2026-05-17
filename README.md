# BanexCoin

App Flutter (web / mobile) para BanexCoin — integrada con **data-ingestion** y **reports** en AWS.

## Backend

| Servicio | URL (CloudFront) | Uso |
|----------|------------------|-----|
| **data-ingestion** | `https://d1nx874xbtjx9q.cloudfront.net` | Subir CSV/XLS/XLSX/JSON/TXT |
| **reports** | `https://d2nozg4tzo8ah6.cloudfront.net` | Listar cashback calculado (S3) |

Configuración en `lib/core/config/app_config.dart` (o `--dart-define`):

```bash
flutter run -d chrome \
  --dart-define=INGESTION_API_URL=https://d1nx874xbtjx9q.cloudfront.net \
  --dart-define=REPORTS_API_URL=https://d2nozg4tzo8ah6.cloudfront.net
```

## Flujo Admin

1. Elegir **Pagos QR** o **Transferencias**
2. Subir archivo → `POST /api/v1/ingest/...`
3. La app hace polling a `GET /api/cashback` (reports)
4. Muestra tabla de reintegros y exportación local (CSV/XLSX/JSON)

## Desarrollo

```bash
cd BanexCoin
flutter pub get
flutter run -d chrome
```

Vista Admin: icono de escudo en el AppBar del inicio.

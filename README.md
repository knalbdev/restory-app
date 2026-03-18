# Restory App

Aplikasi rekomendasi restoran berbasis Flutter sebagai submission Dicoding Flutter Fundamental.

## Fitur

- **Daftar Restoran** — menampilkan daftar restoran dari API dengan gambar, nama, kota, dan rating
- **Detail Restoran** — informasi lengkap meliputi deskripsi, kategori, menu makanan & minuman, serta ulasan pelanggan
- **Cari Restoran** — pencarian restoran berdasarkan nama atau kota
- **Favorit** — simpan dan kelola restoran favorit menggunakan SQLite
- **Dark Mode** — tema gelap/terang yang dapat diubah dari halaman pengaturan
- **Daily Reminder** — notifikasi harian pukul 11.00 sebagai pengingat makan siang, didukung `flutter_local_notifications` dan `WorkManager`

## Teknologi

| Kategori | Library |
|---|---|
| State Management | `provider` |
| HTTP Client | `http` |
| Local Database | `sqflite` |
| Notifikasi | `flutter_local_notifications`, `workmanager` |
| Timezone | `timezone`, `flutter_timezone` |
| Persistent Settings | `shared_preferences` |
| Font | `google_fonts` |

## Struktur Proyek

```
lib/
├── data/               # Repository pattern (remote & local)
├── models/             # Data model (Restaurant, RestaurantDetail, dll)
├── providers/          # State management (Provider)
├── screens/            # Halaman UI
├── services/           # API service & notification service
└── widgets/            # Widget reusable
test/                   # Unit test & widget test
integration_test/       # Integration test (end-to-end)
```

## Testing

```bash
# Unit test & widget test
flutter test

# Integration test (butuh device/emulator)
flutter test integration_test/
```

## Cara Menjalankan

```bash
flutter pub get
flutter run
```

# Core Components

Koleksi widget yang dapat digunakan kembali di seluruh aplikasi Snappie untuk memastikan konsistensi UI dan mengurangi duplikasi kode.

## Struktur Komponen

### Layout dan Struktur
- **AppHeaderWidget** - Header aplikasi dengan gradient background, greeting, dan action button
- **BottomSheetWidget** - Bottom sheet yang dapat dikustomisasi dengan animasi
- **CardWidget** - Card dengan berbagai style (elevated, outlined, filled)

### Form Components
- **InputFieldWidget** - Input field dengan berbagai konfigurasi dan validasi
- **ButtonWidget** - Button dengan berbagai tipe (primary, secondary, outline, text, icon)

### Display Components
- **AvatarWidget** - Avatar dengan support untuk gambar, inisial, dan status online
- **RatingWidget** - Widget untuk menampilkan rating dengan bintang
- **LoadingStateWidget** - Widget untuk menampilkan loading state
- **EmptyStateWidget** - Widget untuk menampilkan empty state dengan berbagai skenario

### Navigation Components
- **TabBarWidget** - Tab bar dengan berbagai style (default, segmented, chip)
- **NotificationButtonWidget** - Button notifikasi dengan badge

### Feedback Components
- **DialogWidget** - Dialog dengan berbagai tipe (info, success, warning, error, confirmation)
- **SnackBarWidget** - Snackbar untuk notifikasi singkat

## Cara Penggunaan

### Import
```dart
import 'package:snappie_app/app/core/components/index.dart';
```

### Contoh Penggunaan

#### ButtonWidget
```dart
ButtonWidget(
  text: 'Submit',
  type: ButtonType.primary,
  size: ButtonSize.medium,
  onPressed: () {
    // Handle button press
  },
)
```

#### InputFieldWidget
```dart
InputFieldWidget(
  label: 'Email',
  hintText: 'Masukkan email Anda',
  keyboardType: TextInputType.emailAddress,
  onChanged: (value) {
    // Handle input change
  },
)
```

#### CardWidget
```dart
CardWidget(
  type: CardType.elevated,
  onTap: () {
    // Handle card tap
  },
  child: Column(
    children: [
      Text('Card Title'),
      Text('Card Content'),
    ],
  ),
)
```

#### AvatarWidget
```dart
AvatarWidget(
  imageUrl: 'https://example.com/avatar.jpg',
  name: 'John Doe',
  size: AvatarSize.large,
  showOnlineStatus: true,
  isOnline: true,
)
```

#### DialogWidget
```dart
AppDialog.showConfirmation(
  context: context,
  title: 'Konfirmasi',
  message: 'Apakah Anda yakin ingin melanjutkan?',
  confirmText: 'Ya',
  cancelText: 'Batal',
).then((result) {
  if (result == true) {
    // User confirmed
  }
});
```

#### SnackBarWidget
```dart
AppSnackBar.showSuccess(
  context: context,
  message: 'Data berhasil disimpan!',
);
```

## Prinsip Design

1. **Konsistensi** - Semua komponen menggunakan design system yang sama
2. **Reusability** - Komponen dapat digunakan di berbagai tempat dengan konfigurasi yang fleksibel
3. **Accessibility** - Mendukung accessibility features
4. **Performance** - Optimized untuk performa yang baik
5. **Customization** - Dapat dikustomisasi sesuai kebutuhan spesifik

## Konvensi Penamaan

- Widget utama menggunakan suffix `Widget` (contoh: `ButtonWidget`)
- Enum menggunakan PascalCase (contoh: `ButtonType`, `AvatarSize`)
- Helper class menggunakan prefix `App` (contoh: `AppDialog`, `AppSnackBar`)

## Kontribusi

Ketika menambahkan komponen baru:
1. Pastikan komponen dapat digunakan kembali
2. Ikuti konvensi penamaan yang ada
3. Tambahkan dokumentasi yang memadai
4. Update file `index.dart` untuk export
5. Tambahkan contoh penggunaan di README ini
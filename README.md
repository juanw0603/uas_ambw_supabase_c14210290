# 🧾 Simple Recipe Keeper

Simple Recipe Keeper adalah aplikasi Flutter yang memungkinkan pengguna menyimpan dan mengelola resep masakan pribadi. Aplikasi ini cocok untuk pengguna yang ingin mencatat resep favoritnya, baik yang sederhana maupun rumit.

---

## ✨ Fitur Aplikasi

- **Autentikasi Pengguna**
  - Login, Register, dan Logout menggunakan Supabase Auth
- **Manajemen Resep**
  - Tambah, Edit, dan Hapus resep
  - Menyimpan nama, deskripsi, dan bahan-bahan resep
- **Get Started Screen**
  - Hanya muncul sekali saat pertama kali install
- **Penyimpanan Sesi Login**
  - Menggunakan SharedPreferences agar user tetap login
- **Navigasi Halaman**
  - Navigasi rapi menggunakan `Navigator`

---

## 🚀 Langkah Install & Build

1. **Clone repo**
   ```bash
   git clone https://github.com/username/simple-recipe-keeper.git
   cd simple-recipe-keeper
2. **Install dependensi**
   ```bash
   flutter pub get
 
3. **Setup Supabase**
   Buat project di https://supabase.com

   Buat table recipes:
   Field


| Field        | Type     |
|--------------|----------|
| id           | uuid (primary key, auto gen) |
| user\_id      | uuid (foreign key ke `auth.users`) |
| name         | text     |
| description  | text     |
| ingredients  | text     |
| created\_at   | timestamp (default: now()) |


- note : setelah membuat query untuk recipes, jalankan perintah ini di sql editor supabase
  ```bash
  alter table public.recipes enable row level security;
- tambahkan kebijakan untuk user login
  ```bash
  create policy "User can access own recipes only"
  on public.recipes
  for all
  using (auth.uid() = user_id);



4. **Edit environment Supabase**
   Buat file .env atau langsung ubah inisialisasi Supabase.initialize(...) di main.dart sesuai URL dan anon key milikmu.

5. **Jalankan aplikasi**
   ```bash
   flutter run




**dummy user**
- email : admin@gmail.com 
- password : password

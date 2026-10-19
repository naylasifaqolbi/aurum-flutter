import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

  static const Color _backgroundColor = Color(0xFFFFF8F0);
  static const Color _primaryColor = Color(0xFFF28C28);
  static const Color _darkColor = Color(0xFF3D2B1F);
  static const Color _softColor = Color(0xFFFFE5CC);
  static const Color _textColor = Color(0xFF555555);

  // ==========================================
  // BUKA WHATSAPP PELAYANAN PELANGGAN
  // ==========================================

  Future<void> _openWhatsApp(BuildContext context) async {
    const String phoneNumber = '6285290307845';

    const String message =
        'Halo Firza, saya membutuhkan bantuan terkait '
        'penggunaan aplikasi AURUM.';

    final Uri whatsappUrl = Uri.https('wa.me', '/$phoneNumber', {
      'text': message,
    });

    try {
      final bool launched = await launchUrl(
        whatsappUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'WhatsApp tidak dapat dibuka. '
              'Silakan coba kembali.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Terjadi kesalahan saat membuka WhatsApp. '
            'Periksa koneksi internet Anda.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        toolbarHeight: 64,
        titleSpacing: 20,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _darkColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pelayanan Pelanggan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _darkColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER PELAYANAN PELANGGAN
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _primaryColor, width: 1),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: const BoxDecoration(
                        color: _softColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.support_agent_rounded,
                        size: 38,
                        color: _primaryColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Pusat Bantuan AURUM',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _darkColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Temukan panduan penggunaan aplikasi, '
                      'jawaban atas pertanyaan umum, dan informasi '
                      'kontak pelayanan pelanggan di halaman ini.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.6,
                        color: _textColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // BAGIAN CARA PENGGUNAAN
              _buildSectionTitle(
                icon: Icons.menu_book_rounded,
                title: 'Cara Penggunaan Aplikasi',
              ),

              const SizedBox(height: 12),

              _buildGuideCard(
                number: '01',
                icon: Icons.login_rounded,
                title: 'Masuk ke Aplikasi',
                description:
                    'Masuk menggunakan akun AURUM yang telah '
                    'terdaftar. Pastikan email dan password '
                    'yang dimasukkan sudah benar.',
              ),

              _buildGuideCard(
                number: '02',
                icon: Icons.home_rounded,
                title: 'Mengenal Halaman Beranda',
                description:
                    'Pada halaman Beranda, pengguna dapat melihat '
                    'informasi yang tersedia, termasuk data harga '
                    'historis dan berita yang ditampilkan oleh '
                    'aplikasi.',
              ),

              _buildGuideCard(
                number: '03',
                icon: Icons.calculate_rounded,
                title: 'Menggunakan Kalkulator',
                description:
                    'Pilih kalkulator yang tersedia sesuai '
                    'kebutuhan. Masukkan nilai yang diminta, '
                    'seperti harga atau data pasar, lalu jalankan '
                    'perhitungan untuk melihat hasilnya.',
              ),

              _buildGuideCard(
                number: '04',
                icon: Icons.history_rounded,
                title: 'Melihat Riwayat',
                description:
                    'Buka menu Riwayat untuk melihat catatan '
                    'perhitungan yang tersimpan dan tersedia '
                    'pada akun Anda.',
              ),

              _buildGuideCard(
                number: '05',
                icon: Icons.person_outline_rounded,
                title: 'Mengelola Profil',
                description:
                    'Buka menu Profil untuk mengubah informasi '
                    'akun, mengganti password, membaca informasi '
                    'aplikasi, dan mengakses pelayanan pelanggan.',
              ),

              _buildGuideCard(
                number: '06',
                icon: Icons.logout_rounded,
                title: 'Keluar dari Akun',
                description:
                    'Pilih menu Keluar pada halaman Profil, '
                    'kemudian konfirmasikan jika ingin mengakhiri '
                    'sesi penggunaan aplikasi.',
              ),

              const SizedBox(height: 24),

              // BAGIAN FAQ
              _buildSectionTitle(
                icon: Icons.quiz_outlined,
                title: 'Pertanyaan Umum (FAQ)',
              ),

              const SizedBox(height: 8),

              const Text(
                'Pilih pertanyaan untuk melihat jawabannya.',
                style: TextStyle(fontSize: 12, color: _textColor),
              ),

              const SizedBox(height: 12),

              _buildFaqItem(
                question: 'Apa itu aplikasi AURUM?',
                answer:
                    'AURUM merupakan aplikasi yang menyediakan '
                    'fitur kalkulator perhitungan dan informasi '
                    'pasar untuk membantu pengguna memahami hasil '
                    'perhitungan berdasarkan data yang dimasukkan.',
              ),

              _buildFaqItem(
                question: 'Bagaimana cara menggunakan kalkulator?',
                answer:
                    'Pilih kalkulator yang ingin digunakan, '
                    'masukkan data sesuai kolom yang tersedia, '
                    'kemudian lakukan perhitungan. Pastikan '
                    'seluruh data yang dimasukkan sudah benar '
                    'sebelum melihat hasilnya.',
              ),

              _buildFaqItem(
                question: 'Mengapa hasil perhitungan saya berbeda?',
                answer:
                    'Perbedaan hasil dapat terjadi karena '
                    'perbedaan data masukan, periode data, '
                    'pembaruan harga, atau metode perhitungan '
                    'yang digunakan. Periksa kembali data yang '
                    'dimasukkan dan rumus pada fitur terkait.',
              ),

              _buildFaqItem(
                question: 'Apakah hasil perhitungan menjamin keuntungan?',
                answer:
                    'Tidak. Hasil perhitungan merupakan indikasi '
                    'berdasarkan data dan metode yang digunakan, '
                    'bukan jaminan hasil transaksi. Kondisi pasar '
                    'sebenarnya dapat berubah dan hasil aktual '
                    'dapat berbeda dari hasil perhitungan.',
              ),

              _buildFaqItem(
                question: 'Bagaimana jika data tidak muncul?',
                answer:
                    'Periksa koneksi internet terlebih dahulu. '
                    'Pastikan aplikasi dapat terhubung ke layanan '
                    'yang diperlukan, kemudian coba buka kembali '
                    'halaman tersebut. Jika masalah berlanjut, '
                    'hubungi pelayanan pelanggan.',
              ),

              _buildFaqItem(
                question: 'Bagaimana cara mengubah informasi profil?',
                answer:
                    'Buka menu Profil, pilih Edit Profil, lalu '
                    'ubah informasi yang tersedia. Simpan '
                    'perubahan dan periksa kembali profil Anda.',
              ),

              _buildFaqItem(
                question: 'Bagaimana jika lupa atau ingin mengganti password?',
                answer:
                    'Untuk mengganti password, buka menu Profil '
                    'dan pilih Ubah Password. Ikuti instruksi '
                    'yang tersedia pada halaman tersebut. Jika '
                    'mengalami kendala, hubungi pelayanan pelanggan.',
              ),

              _buildFaqItem(
                question: 'Apakah riwayat perhitungan selalu tersedia?',
                answer:
                    'Riwayat yang ditampilkan bergantung pada '
                    'data yang berhasil disimpan dan fitur '
                    'yang digunakan. Jika riwayat tidak muncul, '
                    'periksa kembali menu Riwayat dan hubungi '
                    'pelayanan pelanggan jika diperlukan.',
              ),

              const SizedBox(height: 24),

              // BAGIAN KONTAK
              _buildSectionTitle(
                icon: Icons.headset_mic_rounded,
                title: 'Kontak Pelayanan Pelanggan',
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFFFD2A8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Butuh bantuan lebih lanjut?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _darkColor,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Hubungi kontak pelayanan pelanggan berikut '
                      'apabila Anda memiliki pertanyaan atau '
                      'mengalami kendala saat menggunakan aplikasi '
                      'AURUM.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.6,
                        color: _textColor,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // KONTAK FIRZA - BISA DIKLIK
                    Material(
                      color: _backgroundColor,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        onTap: () => _openWhatsApp(context),
                        borderRadius: BorderRadius.circular(14),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 24,
                                backgroundColor: _softColor,
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 28,
                                  color: _primaryColor,
                                ),
                              ),

                              const SizedBox(width: 12),

                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Firza',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: _darkColor,
                                      ),
                                    ),

                                    SizedBox(height: 5),

                                    Text(
                                      '085290307845',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: _textColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    SizedBox(height: 5),

                                    Text(
                                      'Ketuk untuk menghubungi via WhatsApp',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: _primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 8),

                              const Icon(
                                Icons.chat_rounded,
                                size: 25,
                                color: Color(0xFF25D366),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 16,
                          color: _primaryColor,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tekan kartu kontak di atas untuk membuka '
                            'WhatsApp dan memulai percakapan dengan '
                            'pelayanan pelanggan AURUM.',
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.5,
                              color: _textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // DISCLAIMER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: _primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Informasi dan hasil perhitungan pada '
                        'AURUM ditujukan untuk membantu pengguna '
                        'memahami data yang tersedia. Hasil '
                        'perhitungan bukan jaminan hasil transaksi '
                        'dan dapat berbeda dari kondisi pasar '
                        'sebenarnya.',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.6,
                          color: _darkColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================================================
  // JUDUL BAGIAN
  // ==================================================

  Widget _buildSectionTitle({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: _softColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 19, color: _primaryColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _darkColor,
            ),
          ),
        ),
      ],
    );
  }

  // ==================================================
  // KARTU PANDUAN PENGGUNAAN
  // ==================================================

  Widget _buildGuideCard({
    required String number,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _primaryColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$number. ',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _darkColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.6,
                    color: _textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // FAQ YANG BISA DIBUKA DAN DITUTUP
  // ==================================================

  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(
          dividerColor: Colors.transparent,
          splashColor: _softColor.withOpacity(0.3),
          highlightColor: _softColor.withOpacity(0.15),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(15, 0, 15, 16),
          iconColor: _primaryColor,
          collapsedIconColor: _primaryColor,
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _darkColor,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.7,
                  color: _textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

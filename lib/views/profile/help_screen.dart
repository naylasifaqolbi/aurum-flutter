import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const Color backgroundColor = Color(0xFFFFF8F0);
  static const Color orangeColor = Color(0xFFF28C28);
  static const Color darkBrown = Color(0xFF3D2B1F);
  static const Color lightOrange = Color(0xFFFFE5CC);
  static const Color greyColor = Color(0xFF777777);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: darkBrown,
        title: const Text(
          'Tentang AURUM',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // =========================
              // HEADER AURUM
              // =========================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF28C28), Color(0xFFFFB45C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  borderRadius: BorderRadius.circular(24),

                  boxShadow: [
                    BoxShadow(
                      color: orangeColor.withOpacity(0.20),
                      blurRadius: 15,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Container(
                      width: 58,
                      height: 58,

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: const Icon(
                        Icons.auto_graph_rounded,
                        size: 32,
                        color: orangeColor,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'AURUM',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Gold Calculation & Analysis',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Aplikasi yang membantu pengguna melakukan '
                      'perhitungan dan analisis harga emas secara '
                      'lebih praktis, terstruktur, dan mudah dipahami.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // =========================
              // JUDUL
              // =========================
              const Text(
                'Mengenal AURUM',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: darkBrown,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Kenali fungsi dan fitur yang tersedia di dalam aplikasi.',
                style: TextStyle(fontSize: 13, color: greyColor),
              ),

              const SizedBox(height: 18),

              // =========================
              // TENTANG AURUM
              // =========================
              _buildInfoCard(
                icon: Icons.info_outline_rounded,
                title: 'Tentang AURUM',
                description:
                    'AURUM merupakan aplikasi perhitungan dan analisis '
                    'yang dirancang untuk membantu pengguna dalam memahami '
                    'perhitungan harga emas dan memperoleh indikasi '
                    'berdasarkan metode perhitungan yang tersedia.',
              ),

              // =========================
              // TUJUAN APLIKASI
              // =========================
              _buildInfoCard(
                icon: Icons.lightbulb_outline_rounded,
                title: 'Tujuan Aplikasi',
                description:
                    'AURUM dibuat untuk menyederhanakan proses perhitungan '
                    'yang sebelumnya dapat dilakukan secara manual. '
                    'Pengguna dapat memasukkan data yang diperlukan dan '
                    'memperoleh hasil perhitungan dengan lebih cepat dan '
                    'terstruktur.',
              ),

              const SizedBox(height: 8),

              // =========================
              // FITUR UTAMA
              // =========================
              const Text(
                'Fitur Utama',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: darkBrown,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _buildFeatureCard(
                      icon: Icons.calculate_outlined,
                      title: 'Emas Fisik',
                      description:
                          'Perhitungan harga dan keuntungan emas fisik.',
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _buildFeatureCard(
                      icon: Icons.show_chart_rounded,
                      title: 'Pivot Point',
                      description:
                          'Perhitungan Pivot Point untuk emas dan Hangseng.',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildFeatureCard(
                      icon: Icons.swap_vert_rounded,
                      title: 'NEST',
                      description:
                          'Menampilkan indikasi BUY atau SELL berdasarkan Open dan Close.',
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _buildFeatureCard(
                      icon: Icons.history_rounded,
                      title: 'Riwayat',
                      description:
                          'Melihat kembali hasil perhitungan yang telah dilakukan.',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // =========================
              // METODE PERHITUNGAN
              // =========================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),

                  border: Border.all(color: lightOrange, width: 1.2),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,

                          decoration: BoxDecoration(
                            color: lightOrange,
                            borderRadius: BorderRadius.circular(13),
                          ),

                          child: const Icon(
                            Icons.functions_rounded,
                            color: orangeColor,
                          ),
                        ),

                        const SizedBox(width: 13),

                        const Expanded(
                          child: Text(
                            'Metode Perhitungan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: darkBrown,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildMethodItem(
                      number: '01',
                      title: 'Emas Fisik',
                      description:
                          'Menggunakan data modal, kurs, harga beli, '
                          'dan harga jual untuk menghitung jumlah emas '
                          'serta estimasi keuntungan.',
                    ),

                    const SizedBox(height: 13),

                    _buildMethodItem(
                      number: '02',
                      title: 'Pivot Point',
                      description:
                          'Menggunakan data Open, High, Low, dan Close '
                          'untuk memperoleh nilai Pivot Point serta '
                          'level Resistance dan Support.',
                    ),

                    const SizedBox(height: 13),

                    _buildMethodItem(
                      number: '03',
                      title: 'NEST',
                      description:
                          'Membandingkan nilai Open dan Close untuk '
                          'memberikan indikasi BUY atau SELL.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // =========================
              // DATA & RIWAYAT
              // =========================
              _buildInfoCard(
                icon: Icons.storage_rounded,
                title: 'Data dan Riwayat',
                description:
                    'AURUM menampilkan data harga emas yang digunakan '
                    'dalam proses analisis. Hasil perhitungan juga dapat '
                    'disimpan sehingga pengguna dapat melihat kembali '
                    'perhitungan sebelumnya melalui menu Riwayat.',
              ),

              // =========================
              // CATATAN
              // =========================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1E2),
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: orangeColor,
                      size: 24,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: const [
                          Text(
                            'Catatan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: darkBrown,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            'Hasil perhitungan dan indikasi pada AURUM '
                            'merupakan informasi berdasarkan data dan '
                            'metode yang digunakan dalam aplikasi, bukan '
                            'merupakan rekomendasi untuk melakukan transaksi.',
                            style: TextStyle(
                              fontSize: 12.5,
                              height: 1.5,
                              color: greyColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // =========================
              // VERSI
              // =========================
              Center(
                child: Column(
                  children: const [
                    Text(
                      'AURUM Mobile',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: darkBrown,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      'Gold Calculation & Analysis',
                      style: TextStyle(fontSize: 12, color: greyColor),
                    ),

                    SizedBox(height: 5),

                    Text(
                      'Versi 1.0.0',
                      style: TextStyle(fontSize: 11, color: Color(0xFF999999)),
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

  // ============================================================
  // INFO CARD
  // ============================================================

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 45,
            height: 45,

            decoration: BoxDecoration(
              color: lightOrange,
              borderRadius: BorderRadius.circular(13),
            ),

            child: Icon(icon, color: orangeColor, size: 23),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: darkBrown,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: greyColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FEATURE CARD
  // ============================================================

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 155),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 43,
            height: 43,

            decoration: BoxDecoration(
              color: lightOrange,
              borderRadius: BorderRadius.circular(13),
            ),

            child: Icon(icon, color: orangeColor, size: 22),
          ),

          const SizedBox(height: 13),

          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            description,
            style: const TextStyle(
              fontSize: 11.5,
              height: 1.45,
              color: greyColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // METHOD ITEM
  // ============================================================

  Widget _buildMethodItem({
    required String number,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Container(
          width: 36,
          height: 36,

          alignment: Alignment.center,

          decoration: BoxDecoration(
            color: orangeColor,
            borderRadius: BorderRadius.circular(11),
          ),

          child: Text(
            number,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: darkBrown,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.45,
                  color: greyColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

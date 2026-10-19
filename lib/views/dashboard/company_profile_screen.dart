import 'package:flutter/material.dart';

class CompanyProfileScreen extends StatelessWidget {
  const CompanyProfileScreen({super.key});

  // ============================================================
  // COLOR AURUM
  // ============================================================

  static const Color backgroundColor = Color(0xFFFFF8F0);
  static const Color orangeColor = Color(0xFFF28C28);
  static const Color darkBrown = Color(0xFF3D2B1F);
  static const Color lightOrange = Color(0xFFFFE5CC);
  static const Color borderColor = Color(0xFFFFE0C2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        toolbarHeight: 64,
        titleSpacing: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: darkBrown,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          'Profil Perusahaan',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: darkBrown,
          ),
        ),

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // HEADER PERUSAHAAN
              // ==================================================
              _buildCompanyHeader(),

              const SizedBox(height: 28),

              // ==================================================
              // TENTANG KAMI
              // ==================================================
              _buildSectionHeading(
                title: 'Tentang Kami',
                subtitle: 'Mengenal PT Equityworld Futures',
                icon: Icons.business_rounded,
              ),

              const SizedBox(height: 14),

              _buildContentCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PT. EQUITYWORLD FUTURES',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: darkBrown,
                        letterSpacing: 0.3,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'PT Equityworld Futures ("EWF") hadir sebagai '
                      'mitra investasi yang mengutamakan kepercayaan '
                      'dan profesionalisme di industri perdagangan '
                      'berjangka. Dengan fokus pada kualitas layanan '
                      'dan edukasi berkelanjutan, EWF membantu nasabah '
                      'menavigasi peluang pasar secara lebih terarah '
                      'dan aman.',
                      style: _bodyTextStyle,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Sejak mulai beroperasi pada tahun 2005, EWF '
                      'terus tumbuh dan memperluas jangkauan layanan '
                      'hingga memiliki tujuh kantor operasional di '
                      'Jakarta, Surabaya, Semarang, Manado, dan Cirebon. '
                      'Sebagai perusahaan pialang berjangka resmi, '
                      'EWF terdaftar dan diawasi oleh Badan Pengawas '
                      'Perdagangan Berjangka Komoditi (BAPPEBTI), '
                      'Otoritas Jasa Keuangan (OJK), dan Bank Indonesia '
                      '(BI), serta menjadi anggota PT Bursa Berjangka '
                      'Jakarta (BBJ) dan PT Kliring Berjangka Indonesia '
                      '(Persero). Dengan landasan regulasi yang kuat, '
                      'EWF berkomitmen memberikan pengalaman transaksi '
                      'yang transparan, akuntabel, dan berstandar tinggi.',
                      style: _bodyTextStyle,
                    ),

                    const SizedBox(height: 20),

                    // INFORMASI SINGKAT
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5EB),
                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: Column(
                        children: [
                          _buildCompanyFact(
                            icon: Icons.calendar_month_outlined,
                            label: 'Mulai beroperasi',
                            value: '2005',
                          ),

                          const Divider(height: 24, color: Color(0xFFFFDFC0)),

                          _buildCompanyFact(
                            icon: Icons.location_city_outlined,
                            label: 'Kota operasional yang disebutkan',
                            value:
                                'Jakarta, Surabaya, Semarang, '
                                'Manado, dan Cirebon',
                          ),

                          const Divider(height: 24, color: Color(0xFFFFDFC0)),

                          _buildCompanyFact(
                            icon: Icons.verified_outlined,
                            label: 'Bidang usaha',
                            value: 'Perdagangan berjangka',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // VISI
              // ==================================================
              _buildSectionHeading(
                title: 'Visi',
                subtitle: 'Tujuan yang ingin dicapai perusahaan',
                icon: Icons.visibility_outlined,
              ),

              const SizedBox(height: 14),

              _buildVisionCard(),

              const SizedBox(height: 28),

              // ==================================================
              // MISI
              // ==================================================
              _buildSectionHeading(
                title: 'Misi',
                subtitle: 'Komitmen dalam menjalankan kegiatan usaha',
                icon: Icons.flag_outlined,
              ),

              const SizedBox(height: 14),

              _buildMissionCard(),

              const SizedBox(height: 28),

              // ==================================================
              // NILAI-NILAI PERUSAHAAN
              // ==================================================
              _buildSectionHeading(
                title: 'Nilai-Nilai Perusahaan',
                subtitle: 'Prinsip yang menjadi landasan perusahaan',
                icon: Icons.workspace_premium_outlined,
              ),

              const SizedBox(height: 14),

              _buildValueCard(
                icon: Icons.handshake_outlined,
                title: 'Integritas Profesional',
                description:
                    'Menegakkan standar etika yang tinggi serta '
                    'menjaga konsistensi tindakan dan keputusan '
                    'dalam setiap aktivitas perusahaan.',
              ),

              const SizedBox(height: 12),

              _buildValueCard(
                icon: Icons.people_outline_rounded,
                title: 'Fokus pada Nasabah',
                description:
                    'Mengutamakan kebutuhan dan tujuan investasi '
                    'nasabah melalui layanan yang responsif, '
                    'akurat, dan transparan.',
              ),

              const SizedBox(height: 12),

              _buildValueCard(
                icon: Icons.gavel_outlined,
                title: 'Disiplin Kepatuhan',
                description:
                    'Menjalankan seluruh proses bisnis sesuai '
                    'kerangka regulasi dengan kontrol internal '
                    'yang kuat dan berkelanjutan.',
              ),

              const SizedBox(height: 12),

              _buildValueCard(
                icon: Icons.lightbulb_outline_rounded,
                title: 'Inovasi Berkelanjutan',
                description:
                    'Mendorong pengembangan teknologi, produk, '
                    'dan proses kerja untuk menghadirkan '
                    'pengalaman transaksi yang semakin efisien '
                    'dan kompetitif.',
              ),

              const SizedBox(height: 28),

              // ==================================================
              // BADAN REGULASI
              // ==================================================
              _buildSectionHeading(
                title: 'Badan Regulasi',
                subtitle: 'Mengenal lembaga dan sistem terkait',
                icon: Icons.account_balance_outlined,
              ),

              const SizedBox(height: 12),

              const Text(
                'Berikut adalah badan-badan regulasi utama dan '
                'sistem terkait industri perdagangan berjangka '
                'serta sektor keuangan di Indonesia. '
                'Setiap lembaga memiliki peran dalam menjaga '
                'transparansi, pengawasan, dan integritas pasar.',
                style: _bodyTextStyle,
              ),

              const SizedBox(height: 16),

              // BAPPEBTI
              _buildRegulationCard(
                number: '01',
                icon: Icons.account_balance_outlined,
                acronym: 'BAPPEBTI',
                fullName: 'Badan Pengawas Perdagangan Berjangka Komoditi',
                description:
                    'BAPPEBTI adalah lembaga pemerintah di bawah '
                    'Kementerian Perdagangan yang diberi mandat '
                    'untuk memastikan industri perdagangan '
                    'berjangka berjalan secara tertib, transparan, '
                    'dan aman. Melalui regulasi serta pengawasan, '
                    'BAPPEBTI berperan menjaga integritas pasar '
                    'dan memastikan kegiatan perdagangan berjangka '
                    'dilaksanakan sesuai ketentuan yang berlaku.',
              ),

              const SizedBox(height: 14),

              // OJK
              _buildRegulationCard(
                number: '02',
                icon: Icons.account_balance_rounded,
                acronym: 'OJK',
                fullName: 'Otoritas Jasa Keuangan',
                description:
                    'Otoritas Jasa Keuangan merupakan lembaga '
                    'independen yang menyelenggarakan pengaturan '
                    'dan pengawasan di sektor jasa keuangan sesuai '
                    'kewenangannya. OJK berperan mendukung '
                    'terciptanya sektor jasa keuangan yang teratur, '
                    'adil, transparan, dan akuntabel serta '
                    'memberikan perlindungan kepada konsumen.',
              ),

              const SizedBox(height: 14),

              // BANK INDONESIA
              _buildRegulationCard(
                number: '03',
                icon: Icons.account_balance_wallet_outlined,
                acronym: 'BI',
                fullName: 'Bank Indonesia',
                description:
                    'Bank Indonesia adalah bank sentral Republik '
                    'Indonesia yang memiliki tujuan menjaga '
                    'stabilitas nilai rupiah. Bank Indonesia '
                    'menjalankan kebijakan moneter, mengatur dan '
                    'menjaga kelancaran sistem pembayaran, serta '
                    'menjalankan kebijakan makroprudensial sesuai '
                    'mandat dan kewenangannya.',
              ),

              const SizedBox(height: 14),

              // SITNA
              _buildRegulationCard(
                number: '04',
                icon: Icons.receipt_long_outlined,
                acronym: 'SITNA',
                fullName: 'Sistem Informasi Transaksi Nasional',
                description:
                    'Sistem Informasi Transaksi Nasional (SITNA) '
                    'merupakan sistem elektronik yang digunakan '
                    'dalam pencatatan dan pelaporan transaksi '
                    'perdagangan berjangka komoditi. Sistem ini '
                    'mendukung ketersediaan informasi transaksi '
                    'untuk keperluan pengawasan dan transparansi '
                    'sesuai ketentuan yang berlaku.',
              ),

              const SizedBox(height: 24),

              // ==================================================
              // CATATAN INFORMASI
              // ==================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFD4AD)),
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: orangeColor,
                      size: 23,
                    ),

                    const SizedBox(width: 10),

                    const Expanded(
                      child: Text(
                        'Informasi pada halaman ini disusun '
                        'sebagai pengenalan perusahaan dan '
                        'lembaga terkait. Untuk memastikan '
                        'keakuratan informasi mengenai izin '
                        'usaha, status pengawasan, keanggotaan, '
                        'dan alamat kantor, silakan merujuk '
                        'pada sumber resmi masing-masing lembaga '
                        'dan PT Equityworld Futures.',
                        style: TextStyle(
                          fontSize: 12,
                          color: darkBrown,
                          height: 1.6,
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

  // ============================================================
  // COMPANY HEADER
  // ============================================================

  Widget _buildCompanyHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFEAD6), Color(0xFFFFF5EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: const Color(0xFFFFD4AD)),

        boxShadow: [
          BoxShadow(
            color: orangeColor.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        children: [
          Container(
            width: 82,
            height: 82,
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),

            child: Image.asset(
              'assets/images/ewf-logo.png',
              fit: BoxFit.contain,

              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.business_rounded,
                  color: orangeColor,
                  size: 46,
                );
              },
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'PT. EQUITYWORLD FUTURES',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: darkBrown,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Kepercayaan, profesionalisme, '
            'dan pelayanan dalam perdagangan berjangka.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.7),
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),

            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: orangeColor,
                ),

                SizedBox(width: 8),

                Text(
                  'Beroperasi sejak 2005',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: darkBrown,
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
  // SECTION HEADING
  // ============================================================

  Widget _buildSectionHeading({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,

          decoration: BoxDecoration(
            color: lightOrange,
            borderRadius: BorderRadius.circular(13),
          ),

          child: Icon(icon, color: orangeColor, size: 24),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkBrown,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CONTENT CARD
  // ============================================================

  Widget _buildContentCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: child,
    );
  }

  // ============================================================
  // COMPANY FACT
  // ============================================================

  Widget _buildCompanyFact({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: orangeColor),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: darkBrown,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // VISION CARD
  // ============================================================

  Widget _buildVisionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: const Color(0xFFFFEAD6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD4AD)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.visibility_rounded, size: 30, color: orangeColor),

          const SizedBox(height: 14),

          const Text(
            'Visi Perusahaan',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Menjadi perusahaan pialang berjangka yang '
            'unggul dan terpercaya, dengan standar operasional '
            'yang modern, transparan, serta memberikan nilai '
            'strategis bagi perkembangan industri dan '
            'perekonomian nasional.',
            style: TextStyle(fontSize: 14, color: darkBrown, height: 1.8),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MISSION CARD
  // ============================================================

  Widget _buildMissionCard() {
    const List<String> missions = [
      'Menyediakan layanan perdagangan berjangka yang '
          'profesional, aman, dan berintegritas tinggi.',

      'Mengembangkan kualitas sumber daya manusia untuk '
          'menghadirkan layanan yang kompeten dan berdaya saing.',

      'Mengimplementasikan tata kelola perusahaan yang '
          'transparan dan akuntabel.',

      'Memperluas akses edukasi serta literasi perdagangan '
          'berjangka kepada masyarakat.',

      'Mengoptimalkan teknologi untuk mendukung operasional '
          'dan pengalaman nasabah secara efisien.',
    ];

    return _buildContentCard(
      child: Column(
        children: [
          for (int i = 0; i < missions.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 30,
                  height: 30,

                  decoration: BoxDecoration(
                    color: lightOrange,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  alignment: Alignment.center,

                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: orangeColor,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      missions[i],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.7,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            if (i != missions.length - 1) const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // COMPANY VALUE CARD
  // ============================================================

  Widget _buildValueCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return _buildContentCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,

            decoration: BoxDecoration(
              color: lightOrange,
              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(icon, color: orangeColor, size: 27),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: darkBrown,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.7,
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
  // REGULATION CARD
  // ============================================================

  Widget _buildRegulationCard({
    required String number,
    required IconData icon,
    required String acronym,
    required String fullName,
    required String description,
  }) {
    return _buildContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,

                decoration: BoxDecoration(
                  color: lightOrange,
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Icon(icon, color: orangeColor, size: 29),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      number,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: orangeColor,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      acronym,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: darkBrown,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      fullName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Divider(height: 1, color: Color(0xFFFFEAD6)),

          const SizedBox(height: 14),

          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BODY TEXT STYLE
  // ============================================================

  static const TextStyle _bodyTextStyle = TextStyle(
    fontSize: 13,
    color: Colors.black54,
    height: 1.8,
  );
}

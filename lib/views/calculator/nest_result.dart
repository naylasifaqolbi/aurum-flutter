import 'package:flutter/material.dart';

class NestResult extends StatelessWidget {
  final double open;
  final double close;
  final String indication;
  final String description;

  const NestResult({
    super.key,
    required this.open,
    required this.close,
    required this.indication,
    required this.description,
  });

  Color _getIndicationColor() {
    if (indication == 'BUY') {
      return const Color(0xFF2E9B5B);
    }

    if (indication == 'SELL') {
      return const Color(0xFFD9534F);
    }

    return const Color(0xFFF28C28);
  }

  IconData _getIndicationIcon() {
    if (indication == 'BUY') {
      return Icons.trending_up_rounded;
    }

    if (indication == 'SELL') {
      return Icons.trending_down_rounded;
    }

    return Icons.remove_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final Color indicationColor = _getIndicationColor();
    final IconData indicationIcon = _getIndicationIcon();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E5)),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF3D2B1F),
            size: 25,
          ),
        ),
        title: const Text(
          'Hasil Nest',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF28C28),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hasil Indikator',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Hasil perbandingan harga Open dan Close.',
                style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: indicationColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Icon(indicationIcon, color: Colors.white, size: 54),
                    const SizedBox(height: 12),
                    Text(
                      indication,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.92),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFFFE5CC),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  children: [
                    _buildPriceRow(label: 'Harga Open', value: open),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Color(0xFFEFEFEF)),
                    const SizedBox(height: 16),
                    _buildPriceRow(label: 'Harga Close', value: close),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF28C28),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Kembali ke Nest',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow({required String label, required double value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF777777)),
        ),
        Text(
          value.toStringAsFixed(2),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3D2B1F),
          ),
        ),
      ],
    );
  }
}

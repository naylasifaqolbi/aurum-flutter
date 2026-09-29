import 'package:flutter/material.dart';

import '../../viewmodels/calculator_menu_viewmodel.dart';

class CalculatorMenuScreen extends StatefulWidget {
  const CalculatorMenuScreen({super.key});

  @override
  State<CalculatorMenuScreen> createState() => _CalculatorMenuScreenState();
}

class _CalculatorMenuScreenState extends State<CalculatorMenuScreen> {
  // ============================================================
  // VIEWMODEL
  // ============================================================

  final CalculatorMenuViewModel _viewModel = CalculatorMenuViewModel();

  // ============================================================
  // COLOR
  // ============================================================

  static const Color backgroundColor = Color(0xFFFFF8F0);

  static const Color orangeColor = Color(0xFFF28C28);

  static const Color darkBrownColor = Color(0xFF3D2B1F);

  static const Color lightOrangeColor = Color(0xFFFFE5CC);

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _viewModel.addListener(_onViewModelChanged);
  }

  // ============================================================
  // VIEWMODEL LISTENER
  // ============================================================

  void _onViewModelChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);

    _viewModel.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (_viewModel.selectedCalculator != null) {
      return _viewModel.selectedCalculator!;
    }

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        toolbarHeight: 64,
        titleSpacing: 20,

        // ==================================================
        // HEADER
        // ==================================================
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 42,
              height: 42,
              fit: BoxFit.contain,
            ),

            const SizedBox(width: 10),

            const Text(
              'AURUM',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF28C28),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              _buildSectionTitle(
                title: 'Kalkulator',
                subtitle: 'Pilih kalkulator sesuai dengan kebutuhan anda.',
              ),

              const SizedBox(height: 16),

              _buildCalculatorList(),

              const SizedBox(height: 14),

              _buildSectionTitle(
                title: 'Konsep Transaksi',
                subtitle: 'Membantu anda untuk menganalisis kondisi pasar.',
              ),

              const SizedBox(height: 16),

              _buildTransactionConceptList(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style: const TextStyle(
            color: darkBrownColor,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          subtitle,

          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
      ],
    );
  }

  // ============================================================
  // CALCULATOR LIST
  // ============================================================

  Widget _buildCalculatorList() {
    return Column(
      children: [
        _buildCalculatorCard(
          icon: Icons.monetization_on_outlined,

          title: _viewModel.calculatorMenus[0].title,

          description: _viewModel.calculatorMenus[0].description,

          onTap: () {
            _viewModel.openPhysicalGoldCalculator(
              _viewModel.clearSelectedCalculator,
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // TRANSACTION CONCEPT LIST
  // ============================================================

  Widget _buildTransactionConceptList() {
    return Column(
      children: [
        _buildCalculatorCard(
          icon: Icons.show_chart_rounded,

          title: _viewModel.transactionConceptMenus[0].title,

          description: _viewModel.transactionConceptMenus[0].description,

          onTap: () {
            _viewModel.openPivotCalculator(_viewModel.clearSelectedCalculator);
          },
        ),

        const SizedBox(height: 16),

        _buildCalculatorCard(
          icon: Icons.trending_up_rounded,

          title: _viewModel.transactionConceptMenus[1].title,

          description: _viewModel.transactionConceptMenus[1].description,

          onTap: () {
            _viewModel.openPivotHangsengCalculator(
              _viewModel.clearSelectedCalculator,
            );
          },
        ),

        const SizedBox(height: 16),

        _buildCalculatorCard(
          icon: Icons.account_tree_outlined,

          title: _viewModel.transactionConceptMenus[2].title,

          description: _viewModel.transactionConceptMenus[2].description,

          onTap: () {
            _viewModel.openNestCalculator(_viewModel.clearSelectedCalculator);
          },
        ),
      ],
    );
  }

  // ============================================================
  // CALCULATOR CARD
  // ============================================================

  Widget _buildCalculatorCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(17),

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(17),

          border: Border.all(color: lightOrangeColor, width: 1.2),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Container(
              width: 50,
              height: 50,

              decoration: BoxDecoration(
                color: lightOrangeColor,
                borderRadius: BorderRadius.circular(15),
              ),

              child: Icon(icon, color: orangeColor, size: 26),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      color: darkBrownColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    description,

                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: orangeColor,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}

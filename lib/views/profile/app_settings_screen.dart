import 'package:flutter/material.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool _notifications = true;
  bool _sound = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F0),
        elevation: 0,
        foregroundColor: const Color(0xFF3D2B1F),

        title: const Text(
          'Pengaturan Aplikasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                'Pengaturan Aplikasi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF28C28),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Atur preferensi penggunaan aplikasi Aurum.',
                style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    SwitchListTile(
                      value: _notifications,

                      activeColor: const Color(0xFFF28C28),

                      secondary: const Icon(
                        Icons.notifications_outlined,
                        color: Color(0xFFF28C28),
                      ),

                      title: const Text(
                        'Notifikasi',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),

                      subtitle: const Text('Aktifkan notifikasi aplikasi'),

                      onChanged: (value) {
                        setState(() {
                          _notifications = value;
                        });
                      },
                    ),

                    const Divider(height: 1, indent: 20, endIndent: 20),

                    SwitchListTile(
                      value: _sound,

                      activeColor: const Color(0xFFF28C28),

                      secondary: const Icon(
                        Icons.volume_up_outlined,
                        color: Color(0xFFF28C28),
                      ),

                      title: const Text(
                        'Suara',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),

                      subtitle: const Text('Aktifkan suara aplikasi'),

                      onChanged: (value) {
                        setState(() {
                          _sound = value;
                        });
                      },
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
}

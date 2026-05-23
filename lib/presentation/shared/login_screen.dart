import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/config/seed_service.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/theme/app_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _seeding = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(String email, String password) async {
    try {
      await ref.read(authStateProvider.notifier).login(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión: $e'), backgroundColor: AppTheme.activeRed),
        );
      }
    }
  }

  Future<void> _triggerSeed() async {
    setState(() => _seeding = true);
    try {
      await SeedService.seedDatabase();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Base de datos local inicializada con datos demo.'),
            backgroundColor: AppTheme.activeGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de inicialización: $e'), backgroundColor: AppTheme.activeRed),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _seeding = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppTheme.darkSlate,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 460),
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.cardSlate,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF334155)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Logo
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.accentTeal.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shield_outlined, color: AppTheme.accentTeal, size: 40),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'BurnoutMeter',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
                ),
                const Text(
                  'Plataforma B2B Wellness • Ingesta Segura',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppTheme.softText),
                ),
                const SizedBox(height: 32),

                // Seeding Console Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.02),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        '1. CONFIGURACIÓN INICIAL',
                        style: TextStyle(color: AppTheme.accentTeal, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Inicializa el emulador con la organización, usuarios, membresías y consentimientos:',
                        style: TextStyle(color: AppTheme.softText, fontSize: 11, height: 1.4),
                      ),
                      const SizedBox(height: 12),
                      _seeding
                          ? const Center(child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(color: AppTheme.accentTeal),
                          ))
                          : ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentTeal,
                                foregroundColor: AppTheme.darkSlate,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: _triggerSeed,
                              icon: const Icon(Icons.play_circle_outline, size: 18),
                              label: const Text('Inicializar DB Local (Seed)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  '2. INGRESO MANUAL',
                  style: TextStyle(color: AppTheme.accentTeal, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1),
                ),
                const SizedBox(height: 12),

                // Email Input
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.softText, size: 18),
                    hintText: 'email@burnoutmeter.demo',
                    hintStyle: const TextStyle(color: AppTheme.softText, fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),

                // Password Input
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.softText, size: 18),
                    hintText: 'Contraseña (password123)',
                    hintStyle: const TextStyle(color: AppTheme.softText, fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),

                // Login Trigger button
                authState.maybeWhen(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  orElse: () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.darkSlate,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _handleLogin(_emailController.text, _passwordController.text),
                    child: const Text('Ingresar', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 28),

                // Quick selector accounts drawer
                const Text(
                  '3. ACCESOS RÁPIDOS DEMO',
                  style: TextStyle(color: AppTheme.accentTeal, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1),
                ),
                const SizedBox(height: 10),

                _buildQuickAccessButton(
                  label: 'Alan (Empleado • teamEng)',
                  email: 'employee_eng1@burnoutmeter.demo',
                  color: AppTheme.activeGreen,
                ),
                const SizedBox(height: 8),
                _buildQuickAccessButton(
                  label: 'Sofía (Empleado • teamEng • Sin compartir)',
                  email: 'employee_eng2@burnoutmeter.demo',
                  color: AppTheme.softText,
                ),
                const SizedBox(height: 8),
                _buildQuickAccessButton(
                  label: 'Victor (Manager • teamEng)',
                  email: 'manager_eng@burnoutmeter.demo',
                  color: AppTheme.activeOrange,
                ),
                const SizedBox(height: 8),
                _buildQuickAccessButton(
                  label: 'Admin (Global multi-tenant)',
                  email: 'admin@burnoutmeter.demo',
                  color: AppTheme.activeRed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton({required String label, required String email, required Color color}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _handleLogin(email, 'password123'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    Text(email, style: const TextStyle(color: AppTheme.softText, fontSize: 10)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.softText, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}

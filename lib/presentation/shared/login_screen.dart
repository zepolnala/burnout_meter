import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/config/seed_service.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/theme/app_theme.dart';
import 'vector_icons.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Registration Controllers
  final TextEditingController _regEmailController = TextEditingController();
  final TextEditingController _regPasswordController = TextEditingController();
  final TextEditingController _regOrgController = TextEditingController(text: 'org789');
  final TextEditingController _regTeamController = TextEditingController(text: 'teamEng');
  
  bool _seeding = false;
  bool _isRegisterMode = false;
  String _selectedRole = 'employee'; // 'employee' or 'manager'

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _regEmailController.dispose();
    _regPasswordController.dispose();
    _regOrgController.dispose();
    _regTeamController.dispose();
    super.dispose();
  }

  void _showConfigErrorDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: AppTheme.cardSlate,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 24,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppTheme.cardSlate,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.activeOrange.withValues(alpha: 0.2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.activeOrange.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.warning_amber_rounded, color: AppTheme.activeOrange, size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Autenticación Requerida',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'El proveedor de inicio de sesión con "Correo electrónico y contraseña" está desactivado en tu proyecto Firebase Cloud (burnoutmeter-zepolnala).\n\nPara activarlo y poder loguearte o registrar usuarios, sigue estos pasos:',
                  style: TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Paso 1: Entra al panel de proveedores de Firebase:',
                        style: TextStyle(color: AppTheme.accentTeal, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                      SizedBox(height: 6),
                      SelectableText(
                        'https://console.firebase.google.com/project/burnoutmeter-zepolnala/authentication/providers',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'monospace',
                          fontSize: 11,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Paso 2: Haz clic en "Agregar nuevo proveedor" (o "Add new provider"), elige "Correo electrónico/contraseña" (Email/Password), actívalo y guarda los cambios.',
                        style: TextStyle(color: AppTheme.softText, fontSize: 11, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.softText,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Entendido', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentTeal,
                        foregroundColor: AppTheme.darkSlate,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final navigator = Navigator.of(context);
                        await Clipboard.setData(const ClipboardData(text: 'https://console.firebase.google.com/project/burnoutmeter-zepolnala/authentication/providers'));
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Enlace copiado al portapapeles.'), backgroundColor: AppTheme.activeGreen),
                        );
                        navigator.pop();
                      },
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Copiar Enlace', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleLogin(String email, String password) async {
    try {
      await ref.read(authStateProvider.notifier).login(email, password);
    } catch (e) {
      if (mounted) {
        final errStr = e.toString();
        if (errStr.contains('configuration-not-found')) {
          _showConfigErrorDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al iniciar sesión: $e'), backgroundColor: AppTheme.activeRed),
          );
        }
      }
    }
  }

  Future<void> _handleRegister() async {
    final email = _regEmailController.text.trim();
    final password = _regPasswordController.text;
    final org = _regOrgController.text.trim();
    final team = _selectedRole == 'employee' ? _regTeamController.text.trim() : null;
    final managedTeams = _selectedRole == 'manager' ? [_regTeamController.text.trim()] : null;

    if (email.isEmpty || password.isEmpty || org.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, rellena todos los campos.'), backgroundColor: AppTheme.activeOrange),
      );
      return;
    }

    try {
      await ref.read(authStateProvider.notifier).register(
        email: email,
        password: password,
        role: _selectedRole,
        orgId: org,
        teamId: team,
        managedTeamIds: managedTeams,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso. ¡Sesión iniciada!'), backgroundColor: AppTheme.activeGreen),
        );
      }
    } catch (e) {
      if (mounted) {
        final errStr = e.toString();
        if (errStr.contains('configuration-not-found')) {
          _showConfigErrorDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al registrar usuario: $e'), backgroundColor: AppTheme.activeRed),
          );
        }
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
              color: AppTheme.cardSlate.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                )
              ],
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Logo
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.accentTeal.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const ShieldVectorIcon(size: 44),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'BurnoutMeter',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
                  ),
                  const Text(
                    'Plataforma B2B Wellness • Ingesta Segura',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppTheme.softText),
                  ),
                  const SizedBox(height: 32),

                  if (!_isRegisterMode) ...[
                    // --- LOGIN VIEW ---
                    const Text(
                      'INGRESO DE USUARIO',
                      style: TextStyle(color: AppTheme.accentTeal, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1),
                    ),
                    const SizedBox(height: 12),

                    // Email Input
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.softText, size: 18),
                        hintText: 'ejemplo@burnoutmeter.demo',
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

                    // Login Button
                    authState.maybeWhen(
                      loading: () => const Center(child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(color: AppTheme.accentTeal),
                      )),
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

                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => setState(() => _isRegisterMode = true),
                      child: const Text(
                        '¿No tienes cuenta? Regístrate aquí',
                        style: TextStyle(color: AppTheme.accentTeal, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ] else ...[
                    // --- REGISTER VIEW ---
                    const Text(
                      'NUEVO REGISTRO B2B',
                      style: TextStyle(color: AppTheme.accentTeal, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1),
                    ),
                    const SizedBox(height: 16),

                    // Role Selector
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _selectedRole = 'employee'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedRole == 'employee' ? AppTheme.accentTeal.withValues(alpha: 0.15) : const Color(0xFF0F172A),
                                border: Border.all(color: _selectedRole == 'employee' ? AppTheme.accentTeal : Colors.white.withValues(alpha: 0.05)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Empleado',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _selectedRole == 'employee' ? AppTheme.accentTeal : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _selectedRole = 'manager'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedRole == 'manager' ? AppTheme.accentTeal.withValues(alpha: 0.15) : const Color(0xFF0F172A),
                                border: Border.all(color: _selectedRole == 'manager' ? AppTheme.accentTeal : Colors.white.withValues(alpha: 0.05)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Mánager',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _selectedRole == 'manager' ? AppTheme.accentTeal : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Email Input
                    TextField(
                      controller: _regEmailController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.softText, size: 18),
                        hintText: 'Correo electrónico corporativo',
                        hintStyle: const TextStyle(color: AppTheme.softText, fontSize: 13),
                        filled: true,
                        fillColor: const Color(0xFF0F172A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Password Input
                    TextField(
                      controller: _regPasswordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.softText, size: 18),
                        hintText: 'Contraseña (mínimo 6 caracteres)',
                        hintStyle: const TextStyle(color: AppTheme.softText, fontSize: 13),
                        filled: true,
                        fillColor: const Color(0xFF0F172A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Org Input
                    TextField(
                      controller: _regOrgController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.business_outlined, color: AppTheme.softText, size: 18),
                        hintText: 'ID Organización (Ej: org789)',
                        hintStyle: const TextStyle(color: AppTheme.softText, fontSize: 13),
                        filled: true,
                        fillColor: const Color(0xFF0F172A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Team Input
                    TextField(
                      controller: _regTeamController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.groups_outlined, color: AppTheme.softText, size: 18),
                        hintText: _selectedRole == 'employee' ? 'ID Equipo (Ej: teamEng)' : 'ID Equipo Asignado (Ej: teamEng)',
                        hintStyle: const TextStyle(color: AppTheme.softText, fontSize: 13),
                        filled: true,
                        fillColor: const Color(0xFF0F172A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Register Button
                    authState.maybeWhen(
                      loading: () => const Center(child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(color: AppTheme.accentTeal),
                      )),
                      orElse: () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentTeal,
                          foregroundColor: AppTheme.darkSlate,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _handleRegister,
                        child: const Text('Crear Cuenta', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),

                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => setState(() => _isRegisterMode = false),
                      child: const Text(
                        '¿Ya tienes cuenta? Inicia sesión aquí',
                        style: TextStyle(color: AppTheme.softText, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],

                  const Divider(color: Color(0xFF334155), height: 32),

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
                          'CONFIGURACIÓN INICIAL',
                          style: TextStyle(color: AppTheme.accentTeal, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Inicializa el emulador local con las membresías y consentimientos demo:',
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
                                  backgroundColor: AppTheme.accentTeal.withValues(alpha: 0.12),
                                  foregroundColor: AppTheme.accentTeal,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  side: const BorderSide(color: AppTheme.accentTeal),
                                ),
                                onPressed: _triggerSeed,
                                icon: const Icon(Icons.play_circle_outline, size: 18),
                                label: const Text('Sembrar Base de Datos Local', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick selector accounts drawer
                  const Text(
                    'ACCESOS RÁPIDOS DEMO',
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
                    label: 'Sofía (Empleado • teamEng • Privado)',
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

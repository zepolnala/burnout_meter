import 'package:flutter/material.dart';
import '../shared/vector_icons.dart';
import '../../shared/theme/app_theme.dart';

class OnboardingDialog extends StatefulWidget {
  const OnboardingDialog({super.key});

  static Future<void> show(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // Must close via the 'X' button or primary button
      barrierColor: Colors.black.withValues(alpha: 0.85), // Premium darkened glass overlay
      builder: (context) => const OnboardingDialog(),
    );
  }

  @override
  State<OnboardingDialog> createState() => _OnboardingDialogState();
}

class _OnboardingDialogState extends State<OnboardingDialog> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        decoration: BoxDecoration(
          color: AppTheme.cardSlate.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentTeal.withValues(alpha: 0.05),
              blurRadius: 40,
              spreadRadius: 5,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Ambient subtle background gradient glow
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentTeal.withValues(alpha: 0.08),
                      blurRadius: 50,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.activeOrange.withValues(alpha: 0.05),
                      blurRadius: 50,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),

            // Main Content Area
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  // App Branding Header
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WellnessSparkles(size: 20),
                      SizedBox(width: 8),
                      Text(
                        'BURNOUT METER B2B',
                        style: TextStyle(
                          color: AppTheme.accentTeal,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Carousel Pages
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: [
                        _buildWelcomePage(),
                        _buildMetricsPage(),
                        _buildPrivacyPage(),
                      ],
                    ),
                  ),

                  // Bottom Controls Row
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Page Indicator Dots
                      Row(
                        children: List.generate(
                          _totalPages,
                          (index) => _buildPageIndicator(index),
                        ),
                      ),

                      // Navigation Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentTeal,
                          foregroundColor: AppTheme.darkSlate,
                          elevation: 8,
                          shadowColor: AppTheme.accentTeal.withValues(alpha: 0.3),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          if (_currentPage < _totalPages - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          _currentPage == _totalPages - 1 ? '¡Comenzar!' : 'Siguiente',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Top-Right Close Button ('X')
            Positioned(
              top: 16,
              right: 16,
              child: ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.softText, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Cerrar introducción',
                    hoverColor: Colors.white.withValues(alpha: 0.05),
                    splashColor: Colors.white.withValues(alpha: 0.1),
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    final bool isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.accentTeal : AppTheme.softText.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 80,
          height: 80,
          child: LoadVectorIcon(), // Custom load icon representing energy/resilience
        ),
        const SizedBox(height: 24),
        const Text(
          'Tu Bienestar Primero',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'Bienvenido a la plataforma líder de detección de carga psicofisiológica. Diseñada para proteger tu salud y optimizar tu resiliencia diaria de forma completamente segura y privada.',
            style: TextStyle(
              color: AppTheme.softText,
              fontSize: 13,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        _buildFeatureItem(
          icon: Icons.auto_graph_outlined,
          title: 'Algoritmo Avanzado',
          description: 'Calcula tu índice de burnout consolidado de 0 a 100.',
        ),
      ],
    );
  }

  Widget _buildMetricsPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '¿Cómo Mide Tu Estado?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        const Text(
          'A través de tus dispositivos wearables o integración móvil, el algoritmo analiza en tiempo real tres pilares críticos:',
          style: TextStyle(
            color: AppTheme.softText,
            fontSize: 12,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildMetricCard(
                icon: const RecoveryVectorIcon(),
                title: 'HRV (Variabilidad Cardíaca)',
                description: 'Monitorea el valor RMSSD (ms) del corazón. Una caída sostenida de HRV indica fatiga del sistema autónomo.',
                color: AppTheme.activeGreen,
              ),
              const SizedBox(height: 12),
              _buildMetricCard(
                icon: const SleepVectorIcon(),
                title: 'Calidad del Sueño',
                description: 'Controla tus horas de descanso diario. Dormir menos de 7 horas penaliza de forma exponencial tu recuperación.',
                color: AppTheme.accentTeal,
              ),
              const SizedBox(height: 12),
              _buildMetricCard(
                icon: const StressVectorIcon(),
                title: 'Estrés Simpático',
                description: 'Evalúa la frecuencia cardíaca y tasa respiratoria en reposo para detectar picos de activación de alarma.',
                color: AppTheme.activeOrange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 80,
          height: 80,
          child: ShieldVectorIcon(), // Gorgeous vector shield lock representing GDPR control
        ),
        const SizedBox(height: 20),
        const Text(
          'Tu Privacidad es Absoluta',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'Cumplimos estrictamente con la normativa GDPR. Tienes control incondicional sobre tus datos compartidos con tu manager u organización.',
            style: TextStyle(
              color: AppTheme.softText,
              fontSize: 13,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.activeGreen.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.activeGreen.withValues(alpha: 0.15)),
          ),
          child: const Row(
            children: [
              Icon(Icons.gpp_good_outlined, color: AppTheme.activeGreen, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Si desactivas el consentimiento en la pestaña Privacidad, tu manager solo verá "Consentimiento Denegado" sin acceso a tus métricas.',
                  style: TextStyle(
                    color: AppTheme.activeGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.accentTeal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.accentTeal, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  color: AppTheme.softText,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required Widget icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: icon,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.softText,
                    fontSize: 10.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:encuestas_uni/screens/home_encuesta.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeEncuesta()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  static const Color _bgColor = Color(0xFFFF8F26);
  static const Color _circleLight = Color(0xFFFF9A3D);
  static const Color _circleDark = Color(0xFFE8841F);
  static const Color _textDark = Color(0xFF2B2118);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        children: [
      
          Positioned(
            top: -90,
            left: -80,
            child: _circle(260, _circleLight),
          ),
          Positioned(
            top: -40,
            right: -70,
            child: _circle(190, _circleLight),
          ),
          Positioned(
            top: 145,
            right: 28,
            child: _circle(50, _circleDark),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: _circle(200, _circleDark),
          ),
          Positioned(
            bottom: 20,
            right: -50,
            child: _circle(130, _circleLight),
          ),

          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

              Image.asset(
                  'assets/images/logo_jfm.png',
                  width: 230,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 28),

                const Text(
                  'Bienvenidos',
                  style: TextStyle(
                    color: _textDark,
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 14),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Tu voz transforma nuestra comunidad.\nJuntos construimos el cambio.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF4A3A2C),
                      fontSize: 15,
                      height: 1.45,
                    ),
                  ),
                ),

                const SizedBox(height: 38),
                Container(
                  width: 56,
                  height: 1.5,
                  color: _textDark.withValues(alpha: 0.25),
                ),

                const SizedBox(height: 26),

                const Text(
                  'JUVENTUD Y FAMILIA MISIONERA',
                  style: TextStyle(
                    color: _textDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '×',
                  style: TextStyle(
                    color: _textDark.withValues(alpha: 0.6),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'UNIVERSIDAD ANÁHUAC CANCÚN',
                  style: TextStyle(
                    color: _textDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),

                const Spacer(flex: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dot(_textDark),
                    const SizedBox(width: 8),
                    _dot(_textDark.withValues(alpha: 0.35)),
                    const SizedBox(width: 8),
                    _dot(_textDark.withValues(alpha: 0.2)),
                  ],
                ),
                const SizedBox(height: 12),

                Text(
                  'Cargando...',
                  style: TextStyle(
                    color: _textDark.withValues(alpha: 0.45),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
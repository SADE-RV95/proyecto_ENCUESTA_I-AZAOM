import 'package:encuestas_uni/screens/homeencuesta.dart';
import 'package:flutter/material.dart';
import 'dart:async';



class Splashencuesta extends StatefulWidget {
  const Splashencuesta({super.key});

  @override
  State<Splashencuesta> createState() => _SplashencuestaState();
}


class _SplashencuestaState extends State<Splashencuesta>{
  static const Color _fondo = Color(0xFFFF8F26);
  static const Color _circuloClaro = Color(0xFFFF9C45);
  static const Color _circuloOscuro = Color(0xFFEA8222);
  static const Color _textoOscuro = Color(0xFF2B1A0E);
  int _puntoActivo = 0;

  @override
  void initState() {
    super.initState();

    _dotsTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted) return;
      setState(() => _puntoActivo = (_puntoActivo + 1) % 3);
    });

    _navTimer = Timer(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homeencuesta()),
      );
    });
  }


  @override
  void dispose() {
    _navTimer?.cancel();
    _dotsTimer?.cancel();
    super.dispose();
  }

  Widget _circulo(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _punto(bool activo) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: activo ? _textoOscuro : _textoOscuro.withOpacity(0.25),
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondo,
      body: Stack(
        children: [

          Positioned(top: -90, left: -60, child: _circulo(280, _circuloClaro)),
          Positioned(top: -40, right: -80, child: _circulo(220, _circuloClaro)),
          Positioned(top: 140, right: 20, child: _circulo(50, _circuloOscuro)),
          Positioned(
              bottom: -60, left: -60, child: _circulo(210, _circuloOscuro)),
          Positioned(
              bottom: 20, right: -50, child: _circulo(150, _circuloClaro)),


          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo (agrega tu imagen en assets y decláralo en pubspec.yaml)
                    Image.asset(
                      'assets/images/logo_jfm.png',
                      width: 230,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      'Bienvenidos',
                      style: TextStyle(
                        color: _textoOscuro,
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      'Tu voz transforma nuestra comunidad.\nJuntos construimos el cambio.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _textoOscuro.withOpacity(0.8),
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 40),

            
                    Container(
                      width: 40,
                      height: 1,
                      color: _textoOscuro.withOpacity(0.25),
                    ),
                    const SizedBox(height: 28),

                    const Text(
                      'JUVENTUD Y FAMILIA MISIONERA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _textoOscuro,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '×',
                      style: TextStyle(
                        color: _textoOscuro.withOpacity(0.5),
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'UNIVERSIDAD ANÁHUAC CANCÚN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _textoOscuro,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          
          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) => _punto(i == _puntoActivo)),
                ),
                const SizedBox(height: 12),
                Text(
                  'Cargando...',
                  style: TextStyle(
                    color: _textoOscuro.withOpacity(0.45),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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

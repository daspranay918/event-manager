import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// in pubspec.yaml (currently "next_meet" but the project is "Eventora").
// import 'package:eventora/screens/login_screen.dart';
// import 'package:eventora/screens/main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _floatingController;
  late AnimationController _textController;
  late AnimationController _iconController;
  late AnimationController _backgroundController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _backgroundScale;
  late Animation<Offset> _iconSlide;

  // Total time your animation sequence actually takes to finish:
  // 300ms (start delay) + 1200ms (logo) ≈ overlapping with text/icon starts.
  // The icon animation is the last one to *start* (at 300+600+500=1400ms)
  // and takes 1000ms, so it *finishes* at ~2400ms.
  // We give it a little breathing room and land on 2600ms as the
  // single source of truth for "minimum splash duration."
  static const Duration _minSplashDuration = Duration(milliseconds: 2600);

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _logoScale = Tween(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacity = Tween(begin: 0.0, end: 1.0).animate(_logoController);

    _textOpacity = Tween(begin: 0.0, end: 1.0).animate(_textController);

    _backgroundScale = Tween(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeOut),
    );

    _iconSlide = Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeOutBack),
    );

    _startAnimation();

    // Kick off the session check + navigation logic independently of
    // the animation timers above — they're two separate concerns.
    _initAndNavigate();
  }

  void _startAnimation() async {
    _backgroundController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    _iconController.forward();
  }

  /// Checks the Supabase session immediately (it's a synchronous local
  /// read, so there's no reason to delay it), then makes sure the splash
  /// screen stays visible for at least `_minSplashDuration` so the
  /// animation isn't cut off mid-way. Real async work (e.g. fetching a
  /// user profile/role) should happen inside the `Future.wait` below so
  /// it overlaps with the animation instead of stacking on top of it.
  Future<void> _initAndNavigate() async {
    String? destination;

    try {
      final results = await Future.wait([
        _resolveDestination(),
        Future.delayed(_minSplashDuration),
      ]);
      destination = results[0] as String;
    } catch (e) {
      // Fail safe: if anything goes wrong (bad init, network hiccup,
      // corrupted local session), don't crash — just send them to login.
      debugPrint('Splash session check failed: $e');
      destination = '/login';
      // Still respect the minimum splash time even on the error path,
      // so the UI doesn't flash/jump.
      await Future.delayed(_minSplashDuration);
    }

    if (!mounted) return;
    context.go(destination);
  }

  /// Resolves where to navigate based on auth state.
  /// Add any additional async checks here (e.g. loading the user's role
  /// from a `profiles` table) — they'll run in parallel with the splash
  /// animation instead of adding to the total wait time.
  Future<String> _resolveDestination() async {
    final session = Supabase.instance.client.auth.currentSession;
    return session != null ? '/navigation' : '/login';
  }

  @override
  void dispose() {
    _logoController.dispose();
    _floatingController.dispose();
    _textController.dispose();
    _iconController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background Zoom
          AnimatedBuilder(
            animation: _backgroundScale,
            builder: (_, child) {
              return Transform.scale(
                scale: _backgroundScale.value,
                child: child,
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background2.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: .45),
                  Colors.black.withValues(alpha: .65),
                  Colors.black.withValues(alpha: .82),
                ],
              ),
            ),
          ),

          /// Golden Curves
          const TopGoldenCurve(),
          const BottomGoldenCurve(),

          /// Twinkling Stars
          const StarParticles(),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBuilder(
                          animation: _floatingController,
                          builder: (_, child) {
                            return Transform.translate(
                              offset: Offset(
                                0,
                                sin(_floatingController.value * pi * 2) * 8,
                              ),
                              child: child,
                            );
                          },
                          child: FadeTransition(
                            opacity: _logoOpacity,
                            child: ScaleTransition(
                              scale: _logoScale,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 170,
                                    height: 170,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.amber.withValues(
                                            alpha: .35,
                                          ),
                                          blurRadius: 70,
                                          spreadRadius: 10,
                                        ),
                                      ],
                                    ),
                                  ),

                                  Image.asset(
                                    "assets/images/logo.png",
                                    height: 200,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        FadeTransition(
                          opacity: _textOpacity,
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: "Event",
                                  style: TextStyle(
                                    fontSize: 46,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                TextSpan(
                                  text: "ora",
                                  style: TextStyle(
                                    fontSize: 46,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffFFD54F),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 900),
                          tween: Tween(begin: 0, end: 180),
                          builder: (_, width, __) {
                            return Container(
                              width: width,
                              height: 2,
                              decoration: BoxDecoration(
                                color: const Color(0xffFFD54F),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withValues(alpha: .6),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 14),

                        FadeTransition(
                          opacity: _textOpacity,
                          child: const Text(
                            "CREATE. PLAN. CELEBRATE.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    left: 40,
                    right: 40,
                    bottom: 40,
                  ),
                  child: Column(
                    children: [
                      SlideTransition(
                        position: _iconSlide,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            SplashIcon(Icons.calendar_month),

                            SplashIcon(Icons.people_alt),

                            SplashIcon(Icons.confirmation_num),

                            SplashIcon(Icons.celebration),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      Container(
                        width: 180,
                        height: 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [
                              Colors.transparent,
                              Color(0xffFFD54F),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      const SizedBox(
                        width: 140,
                        child: LinearProgressIndicator(
                          minHeight: 2,
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation(Color(0xffFFD54F)),
                        ),
                      ),
                    ],
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

//==============================================================
// Splash Icon
//==============================================================

class SplashIcon extends StatelessWidget {
  final IconData icon;

  const SplashIcon(this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withValues(alpha: .25)),
      ),
      child: Icon(icon, color: const Color(0xffFFD54F), size: 28),
    );
  }
}

//==============================================================
// Top Golden Curve
//==============================================================

class TopGoldenCurve extends StatelessWidget {
  const TopGoldenCurve({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -140,
      left: -170,
      child: IgnorePointer(
        child: Container(
          width: 420,
          height: 420,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500),
            border: Border.all(
              color: const Color(0xffFFD54F).withValues(alpha: .45),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(alpha: .15),
                blurRadius: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//==============================================================
// Bottom Golden Curve
//==============================================================

class BottomGoldenCurve extends StatelessWidget {
  const BottomGoldenCurve({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -180,
      right: -180,
      child: IgnorePointer(
        child: Container(
          width: 470,
          height: 470,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(600),
            border: Border.all(
              color: const Color(0xffFFD54F).withValues(alpha: .40),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(alpha: .18),
                blurRadius: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//==============================================================
// Twinkling Stars
//==============================================================

class StarParticles extends StatefulWidget {
  const StarParticles({super.key});

  @override
  State<StarParticles> createState() => _StarParticlesState();
}

class _StarParticlesState extends State<StarParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  final List<Offset> stars = const [
    Offset(.18, .20),
    Offset(.28, .14),
    Offset(.72, .18),
    Offset(.84, .28),
    Offset(.78, .60),
    Offset(.22, .72),
    Offset(.60, .78),
    Offset(.38, .32),
    Offset(.56, .26),
    Offset(.90, .52),
    Offset(.10, .45),
    Offset(.42, .82),
  ];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: StarPainter(controller.value, stars),
        );
      },
    );
  }
}

//==============================================================
// Star Painter
//==============================================================

class StarPainter extends CustomPainter {
  final double value;
  final List<Offset> stars;

  StarPainter(this.value, this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < stars.length; i++) {
      final opacity = (0.25 + (value * 0.75));

      final paint = Paint()..color = Colors.amber.withValues(alpha: opacity);

      final dx = stars[i].dx * size.width;
      final dy = stars[i].dy * size.height;

      canvas.drawCircle(Offset(dx, dy), 2 + (i % 3).toDouble(), paint);

      canvas.drawCircle(
        Offset(dx, dy),
        7,
        Paint()..color = Colors.amber.withValues(alpha: .05 * value),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Only repaint when the animation value actually changes.
    if (oldDelegate is StarPainter) {
      return oldDelegate.value != value;
    }
    return true;
  }
}

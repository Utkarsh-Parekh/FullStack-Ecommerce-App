import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_event.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  // Animation Controllers
  late final AnimationController _bgController;
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _dotsController;
  late final AnimationController _shineController;

  // Animations
  late final Animation<double> _bgScale;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _taglineOpacity;
  late final Animation<double> _shinePosition;

  bool _animationsDone = false;
  bool? _pendingAuth;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _playAnimations();
    context.read<AuthBloc>().add(CheckAuthStatus());
  }

  void _initAnimations() {
    // Background animation
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _bgScale = Tween<double>(begin: 1.0, end: 1.08)
        .animate(CurvedAnimation(parent: _bgController, curve: Curves.easeInOut));

    // Logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.15), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 0.95), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 20),
    ]).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));
    _logoOpacity = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _logoController, curve: const Interval(0, 0.4, curve: Curves.easeIn)));
    _logoSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    // Text animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(_textController);
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _taglineOpacity = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _textController, curve: const Interval(0.4, 1.0, curve: Curves.easeIn)));

    // Loading dots
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();

    // Shine animation
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _shinePosition = Tween<double>(begin: -1, end: 2)
        .animate(CurvedAnimation(parent: _shineController, curve: Curves.easeInOut));
  }

  Future<void> _playAnimations() async {
    _bgController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 700));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _shineController.forward();
    await Future.delayed(const Duration(milliseconds: 600));

    setState(() => _animationsDone = true);
    _tryNavigate();
  }

  void _tryNavigate() {
    if (_pendingAuth != null) _navigate(_pendingAuth!);
  }

  void _navigate(bool isAuthenticated) {
    if (!mounted) return;
    context.goNamed(isAuthenticated ? 'dashboard' : 'onboarding');
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _dotsController.dispose();
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == Status.loading || state.status == Status.initial) return;
        if (_animationsDone) {
          _navigate(state.isAuthenticated);
        } else {
          _pendingAuth = state.isAuthenticated;
        }
      },
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _bgController,
          builder: (context, child) {
            return Transform.scale(
              scale: _bgScale.value,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    _buildDecorativeCircles(),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLogo(),
                          const SizedBox(height: 32),
                          _buildText(),
                          const SizedBox(height: 60),
                          _buildLoadingDots(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDecorativeCircles() => Stack(
    children: [
      _circle(280, 280, -80, -60, const Color(0xFFE94560).withValues(alpha:   0.08)),
      _circle(340, 340, null, null, const Color(0xFF0F3460).withValues(alpha:  0.5), bottom: -100, left: -80),
      _circle(150, 150, 180, -40, const Color(0xFFE94560).withValues(alpha:  0.05)),
    ],
  );

  Widget _circle(double w, double h, double? top, double? right, Color color, {double? bottom, double? left}) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: Container(width: w, height: h, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
    );
  }

  Widget _buildLogo() => SlideTransition(
    position: _logoSlide,
    child: FadeTransition(
      opacity: _logoOpacity,
      child: ScaleTransition(
        scale: _logoScale,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Glow
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: const Color(0xFFE94560).withValues(alpha:   0.4), blurRadius: 40, spreadRadius: 10)],
              ),
            ),
            // Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [Color(0xFFE94560), Color(0xFFc62a47)]),
                boxShadow: [BoxShadow(color: const Color(0xFFE94560).withValues(alpha:   0.3), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: const Icon(Icons.shopping_bag_rounded, size: 48, color: Colors.white),
            ),
            // Shine
            AnimatedBuilder(
              animation: _shineController,
              builder: (_, _) {
                return ClipOval(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Transform.translate(
                      offset: Offset(_shinePosition.value * 100, 0),
                      child: Container(
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white.withValues(alpha:   0), Colors.white.withValues(alpha:  0.3), Colors.white.withValues(alpha:  0)],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildText() => SlideTransition(
    position: _textSlide,
    child: FadeTransition(
      opacity: _textOpacity,
      child: Column(
        children: [
          const Text(
            'ShopEase',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.5),
          ),
          const SizedBox(height: 8),
          FadeTransition(
            opacity: _taglineOpacity,
            child: const Text(
              'Shop Smart. Live Better.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFFE94560), letterSpacing: 2),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildLoadingDots() {
    return AnimatedBuilder(
      animation: _dotsController,
      builder: (_, a_) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delay = index / 3;
            final value = (_dotsController.value - delay).clamp(0.0, 1.0);
            final bounce = (value < 0.5) ? value * 2 : (1 - value) * 2;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Transform.translate(
                offset: Offset(0, -10 * bounce),
                child: Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: Color.lerp(Colors.white38, const Color(0xFFE94560), bounce))),
              ),
            );
          }),
        );
      },
    );
  }
}
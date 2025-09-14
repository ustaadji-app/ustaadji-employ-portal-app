import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Large tilted rounded rectangle - top left
        Positioned(
          top: -120,
          left: -80,
          child: Transform.rotate(
            angle: -0.4,
            child: _ShapeBox(
              width: 280,
              height: 220,
              colors: [
                Colors.cyan.shade200.withOpacity(0.4),
                Colors.blue.shade400.withOpacity(0.3),
              ],
              borderRadius: 80,
              blurSigma: 50,
            ),
          ),
        ),

        // Medium soft shape - bottom right
        Positioned(
          bottom: -100,
          right: -70,
          child: Transform.rotate(
            angle: 0.6,
            child: _ShapeBox(
              width: 260,
              height: 180,
              colors: [
                Colors.blue.shade300.withOpacity(0.4),
                Colors.blue.shade600.withOpacity(0.35),
              ],
              borderRadius: 100,
              blurSigma: 40,
            ),
          ),
        ),

        // Small overlapping shape - center left
        Positioned(
          top: 180,
          left: 20,
          child: Transform.rotate(
            angle: -0.2,
            child: _ShapeBox(
              width: 160,
              height: 120,
              colors: [
                Colors.cyan.shade100.withOpacity(0.3),
                Colors.blue.shade300.withOpacity(0.3),
              ],
              borderRadius: 60,
              blurSigma: 30,
            ),
          ),
        ),

        // Your screen content on top
        child,
      ],
    );
  }
}

class _ShapeBox extends StatelessWidget {
  final double width;
  final double height;
  final List<Color> colors;
  final double borderRadius;
  final double blurSigma;

  const _ShapeBox({
    Key? key,
    required this.width,
    required this.height,
    required this.colors,
    required this.borderRadius,
    required this.blurSigma,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.last.withOpacity(0.5),
            blurRadius: blurSigma,
            spreadRadius: blurSigma / 2,
          ),
        ],
      ),
    );
  }
}

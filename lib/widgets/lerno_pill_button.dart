import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/lerno_colors.dart';

/// Figma primary CTA: solid coral pill (#FD5454, radius 50, 54 tall,
/// shadow 0/5 blur 50 @ 25%) with a deep-plum Montserrat SemiBold 18 label.
class LernoPillButton extends StatelessWidget {
  const LernoPillButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: LernoColors.coral,
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              offset: Offset(0, 5),
              // Figma blur 50 ≈ Gaussian σ 25.
              blurRadius: 42,
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(50),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 23.25 / 18,
                  color: LernoColors.plumDeep,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

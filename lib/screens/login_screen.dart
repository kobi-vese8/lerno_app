import 'package:flutter/material.dart';
import '../theme/lerno_theme.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/lerno_button.dart';

/// Login screen — email + password sign-in.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Back button ────────────────────────────
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: LernoColors.teal.withValues(alpha: 0.2),
                  ),
                  child: const Icon(Icons.chevron_left_rounded,
                      color: LernoColors.teal, size: 24),
                ),
              ),
              const SizedBox(height: 32),

              // ── Logo ───────────────────────────────────
              Text('LERNO', style: LernoTextStyles.logo),
              const SizedBox(height: 8),
              Text(
                'Welcome back',
                style: LernoTextStyles.sectionTitle.copyWith(
                  fontFamily: 'MuseoModerno',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue your learning journey.',
                style: LernoTextStyles.bodySmall,
              ),
              const SizedBox(height: 40),

              // ── Email field ────────────────────────────
              Text('Email', style: LernoTextStyles.body),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hint: 'you@university.ac.uk',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail_outline_rounded,
              ),
              const SizedBox(height: 20),

              // ── Password field ─────────────────────────
              Text('Password', style: LernoTextStyles.body),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _passwordController,
                hint: 'Enter your password',
                obscure: _obscurePassword,
                prefixIcon: Icons.lock_outline_rounded,
                suffixIcon: GestureDetector(
                  onTap: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: LernoColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ── Forgot password ────────────────────────
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // TODO: Forgot password flow
                  },
                  child: Text(
                    'Forgot password?',
                    style: LernoTextStyles.bodySmall.copyWith(
                      color: LernoColors.coral,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ── Sign in button ─────────────────────────
              LernoButton(
                label: 'Sign in',
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/onboarding/studies');
                },
              ),
              const SizedBox(height: 20),

              // ── Divider ────────────────────────────────
              Row(
                children: [
                  Expanded(child: Divider(color: LernoColors.divider)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('or', style: LernoTextStyles.caption),
                  ),
                  Expanded(child: Divider(color: LernoColors.divider)),
                ],
              ),
              const SizedBox(height: 20),

              // ── Social sign-in buttons ─────────────────
              _socialButton(
                label: 'Continue with Google',
                icon: Icons.g_mobiledata_rounded,
              ),
              const SizedBox(height: 12),
              _socialButton(
                label: 'Continue with Apple',
                icon: Icons.apple_rounded,
              ),
              const SizedBox(height: 32),

              // ── Sign up link ───────────────────────────
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/signup');
                  },
                  child: RichText(
                    text: TextSpan(
                      style: LernoTextStyles.bodySmall,
                      children: [
                        const TextSpan(text: 'Don’t have an account? '),
                        TextSpan(
                          text: 'Sign up',
                          style: LernoTextStyles.bodySmall.copyWith(
                            color: LernoColors.coral,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    bool obscure = false,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: LernoColors.inputFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: LernoColors.divider),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        style: LernoTextStyles.body,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: LernoTextStyles.bodySmall,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: LernoColors.textSecondary, size: 20)
              : null,
          suffixIcon: suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: suffixIcon,
                )
              : null,
          suffixIconConstraints:
              const BoxConstraints(minWidth: 20, minHeight: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _socialButton({required String label, required IconData icon}) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: LernoColors.white, size: 24),
        label: Text(
          label,
          style: LernoTextStyles.body.copyWith(fontWeight: FontWeight.w500),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: LernoColors.white,
          side: const BorderSide(color: LernoColors.divider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

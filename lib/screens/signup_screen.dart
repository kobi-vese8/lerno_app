import 'package:flutter/material.dart';
import '../theme/lerno_theme.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/lerno_button.dart';

/// Sign-up screen — create a new account.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
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

              // ── Header ─────────────────────────────────
              Text('LERNO', style: LernoTextStyles.logo),
              const SizedBox(height: 8),
              Text(
                'Create account',
                style: LernoTextStyles.sectionTitle.copyWith(
                  fontFamily: 'MuseoModerno',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Join Lerno and take control of your studies.',
                style: LernoTextStyles.bodySmall,
              ),
              const SizedBox(height: 36),

              // ── Full name ──────────────────────────────
              Text('Full name', style: LernoTextStyles.body),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _nameController,
                hint: 'e.g. Maya Singh',
                prefixIcon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 20),

              // ── University email ───────────────────────
              Text('University email', style: LernoTextStyles.body),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hint: 'you@university.ac.uk',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail_outline_rounded,
              ),
              const SizedBox(height: 20),

              // ── Password ───────────────────────────────
              Text('Password', style: LernoTextStyles.body),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _passwordController,
                hint: 'At least 8 characters',
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
              const SizedBox(height: 20),

              // ── Confirm password ───────────────────────
              Text('Confirm password', style: LernoTextStyles.body),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _confirmController,
                hint: 'Re-enter your password',
                obscure: _obscureConfirm,
                prefixIcon: Icons.lock_outline_rounded,
                suffixIcon: GestureDetector(
                  onTap: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                  child: Icon(
                    _obscureConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: LernoColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Terms checkbox ─────────────────────────
              GestureDetector(
                onTap: () =>
                    setState(() => _agreeToTerms = !_agreeToTerms),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: _agreeToTerms
                            ? LernoColors.coral
                            : Colors.transparent,
                        border: Border.all(
                          color: _agreeToTerms
                              ? LernoColors.coral
                              : LernoColors.textSecondary,
                          width: 1.5,
                        ),
                      ),
                      child: _agreeToTerms
                          ? const Icon(Icons.check,
                              size: 16, color: LernoColors.white)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: LernoTextStyles.bodySmall,
                          children: [
                            const TextSpan(text: 'I agree to Lerno’s '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: LernoTextStyles.bodySmall.copyWith(
                                color: LernoColors.coral,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: LernoTextStyles.bodySmall.copyWith(
                                color: LernoColors.coral,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Create account button ──────────────────
              LernoButton(
                label: 'Create account',
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

              // ── Social sign-up buttons ─────────────────
              _socialButton(
                label: 'Continue with Google',
                icon: Icons.g_mobiledata_rounded,
              ),
              const SizedBox(height: 12),
              _socialButton(
                label: 'Continue with Apple',
                icon: Icons.apple_rounded,
              ),
              const SizedBox(height: 28),

              // ── Sign in link ───────────────────────────
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  child: RichText(
                    text: TextSpan(
                      style: LernoTextStyles.bodySmall,
                      children: [
                        const TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Sign in',
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

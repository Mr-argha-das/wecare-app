import 'package:flutter/material.dart';
import 'package:healthcare/core/theme/app_theme.dart';
import 'package:healthcare/core/utils/app_access.dart';
import 'package:healthcare/core/utils/app_message.dart';
import 'package:healthcare/features/auth/auth_service.dart';
import 'package:healthcare/features/auth/privacy_policy_page.dart';
import 'package:healthcare/features/auth/terms_conditions_page.dart';
import 'package:healthcare/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneCtrl = TextEditingController();
  bool loading = false;
  bool agreed = false;

  @override
  void initState() {
    super.initState();
    AppPermissions.requestAll();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (AppMessage.snack != null) {
        _snack(AppMessage.snack!);
        AppMessage.snack = null;
      }
    });
  }

  @override
  void dispose() {
    phoneCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? AppTheme.danger : AppTheme.success,
      ),
    );
  }

  Future<void> _sendOtp() async {
    if (phoneCtrl.text.trim().length != 10) {
      _snack('Please enter a valid 10-digit number', error: true);
      return;
    }
    if (!agreed) {
      _snack('Please accept Privacy Policy & Terms to continue', error: true);
      return;
    }
    setState(() => loading = true);
    try {
      if (AuthService.isTestPhone(phoneCtrl.text.trim())) {
        await AuthService.loginTestAccount(phoneCtrl.text.trim(), context);
        return;
      }
      await AuthService.sendOtp(phoneCtrl.text.trim());
      if (!mounted) return;
      Navigator.pushNamed(context, AppRoutes.otp,
          arguments: phoneCtrl.text.trim());
    } catch (error) {
      if (!mounted) return;
      _snack(error.toString().replaceAll('Exception:', '').trim(), error: true);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final wide = size.width >= 760;
    final horizontal = size.width < 380 ? 16.0 : 24.0;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _LoginBackdrop()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: horizontal, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: wide
                      ? Row(
                          children: [
                            const Expanded(child: _BrandStory()),
                            const SizedBox(width: 54),
                            Expanded(
                              child: _LoginCard(
                                phoneCtrl: phoneCtrl,
                                loading: loading,
                                agreed: agreed,
                                onAgreementChanged: (value) =>
                                    setState(() => agreed = value),
                                onSendOtp: _sendOtp,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            const _CompactBrand(),
                            const SizedBox(height: 24),
                            _LoginCard(
                              phoneCtrl: phoneCtrl,
                              loading: loading,
                              agreed: agreed,
                              onAgreementChanged: (value) =>
                                  setState(() => agreed = value),
                              onSendOtp: _sendOtp,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginBackdrop extends StatelessWidget {
  const _LoginBackdrop();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE4F4EF), Color(0xFFF8FBFA), Color(0xFFE8F0F7)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -60,
            child: _Glow(size: 250, color: AppTheme.primary),
          ),
          Positioned(
            bottom: -110,
            left: -80,
            child: _Glow(size: 280, color: AppTheme.secondary),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final double size;
  final Color color;
  const _Glow({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: .08),
        ),
      );
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({this.size = 72});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size * .28),
          boxShadow: const [
            BoxShadow(
                color: Color(0x1A176B5B),
                blurRadius: 28,
                offset: Offset(0, 12)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size * .2),
          child: Image.asset('assets/media/logo.png', fit: BoxFit.cover),
        ),
      );
}

class _CompactBrand extends StatelessWidget {
  const _CompactBrand();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const _BrandMark(),
          const SizedBox(height: 14),
          Text('Welcome to WeCare',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 5),
          const Text('Care made connected, secure and simple.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary)),
        ],
      );
}

class _BrandStory extends StatelessWidget {
  const _BrandStory();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const _BrandMark(size: 84),
            const SizedBox(height: 28),
            Text('Healthcare that feels human.',
                style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 16),
            const Text(
              'One secure workspace for caregivers, patients and clinical teams.',
              style: TextStyle(
                  fontSize: 17, height: 1.5, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 28),
            const _TrustPoint(
                icon: Icons.verified_user_outlined, text: 'Secure OTP access'),
            const _TrustPoint(
                icon: Icons.health_and_safety_outlined,
                text: 'Connected care journeys'),
            const _TrustPoint(
                icon: Icons.support_agent_rounded,
                text: 'Built for care teams'),
          ],
        ),
      );
}

class _TrustPoint extends StatelessWidget {
  final IconData icon;
  final String text;
  const _TrustPoint({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, size: 20),
          ),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
        ]),
      );
}

class _LoginCard extends StatelessWidget {
  final TextEditingController phoneCtrl;
  final bool loading;
  final bool agreed;
  final ValueChanged<bool> onAgreementChanged;
  final VoidCallback onSendOtp;

  const _LoginCard({
    required this.phoneCtrl,
    required this.loading,
    required this.agreed,
    required this.onAgreementChanged,
    required this.onSendOtp,
  });

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding:
              EdgeInsets.all(MediaQuery.sizeOf(context).width < 380 ? 20 : 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sign in', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              const Text('Use your registered mobile number to continue.',
                  style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 26),
              TextFormField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => loading ? null : onSendOtp(),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone_iphone_rounded),
                  labelText: 'Mobile number',
                  hintText: '10-digit number',
                  counterText: '',
                ),
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: agreed,
                    onChanged: (value) => onAgreementChanged(value ?? false),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 11),
                      child: Wrap(children: [
                        const Text('I agree to the ',
                            style: TextStyle(fontSize: 12)),
                        _PolicyLink(
                          text: 'Privacy Policy',
                          page: const PrivacyPolicyPage(),
                        ),
                        const Text(' and ', style: TextStyle(fontSize: 12)),
                        _PolicyLink(
                          text: 'Terms & Conditions',
                          page: const TermsConditionsPage(),
                        ),
                        const Text('.', style: TextStyle(fontSize: 12)),
                      ]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: loading ? null : onSendOtp,
                  icon: loading
                      ? const SizedBox.square(
                          dimension: 19,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.arrow_forward_rounded),
                  label: Text(loading ? 'SENDING OTP…' : 'CONTINUE WITH OTP'),
                ),
              ),
              const SizedBox(height: 22),
              const Row(children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('NEW TO WECARE?',
                      style: TextStyle(
                          fontSize: 11, color: AppTheme.textSecondary)),
                ),
                Expanded(child: Divider())
              ]),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.nurseSignup),
                  icon: const Icon(Icons.badge_outlined),
                  label: const Text('APPLY AS A CAREGIVER'),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: InkWell(
                  onTap: () => launchUrl(
                    Uri.parse('https://digitalwishmedia.com/'),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: const Text('© 2026 Digital Wish Media',
                      style: TextStyle(
                          fontSize: 11, color: AppTheme.textSecondary)),
                ),
              ),
            ],
          ),
        ),
      );
}

class _PolicyLink extends StatelessWidget {
  final String text;
  final Widget page;
  const _PolicyLink({required this.text, required this.page});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
        child: Text(text,
            style: const TextStyle(
                fontSize: 12,
                color: AppTheme.primary,
                fontWeight: FontWeight.w700)),
      );
}

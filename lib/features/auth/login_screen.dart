import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/snack.dart';
import '../../core/validators.dart';
import '../../l10n/app_localizations.dart';
import '../images/presentation/images_screen.dart';
import 'auth_service.dart';
import 'signup_screen.dart';
import '../../main.dart';
import '../../widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();

  bool _obscure = true;
  bool _loading = false;

  final _auth = AuthService();

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _toggleLanguage() {
    final isArabic = appLocale.value.languageCode == 'ar';
    appLocale.value = Locale(isArabic ? 'en' : 'ar');
  }

  Future<void> _onLogin() async {
    final t = AppLocalizations.of(context)!;

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);
    try {

      final userCredential = await _auth.login(email: _email.text.trim(), password: _pass.text);

      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        await FirebaseAuth.instance.signOut();
        if (!mounted) return;
        setState(() => _loading = false);

        AppSnack.error(context, t.verifyEmailFirst);
        return;
      }

      if (!mounted) return;

      AppSnack.success(context, t.successLogin);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ImagesScreen()),
      );
    } on FirebaseAuthException catch (e) {
      print("Firebase Error Code: ${e.code}");

      if (!mounted) return;

      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(t.emailNotFoundCreateAccount),
            action: SnackBarAction(
              label: t.signUp,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
              },
            ),
          ),
        );
      } else {
        final key = _auth.mapAuthCodeToKey(e.code);
        AppSnack.error(context, _tr(t, key));
      }
    }
    finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleForgotPassword() async {
    final emailController = TextEditingController();
    final t = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(
          t.forgotPasswordTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.forgotPasswordDialogBody),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: t.email,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.cancel, style: TextStyle(color: Colors.grey[700])),
          ),
          GestureDetector(
            onTap: () async {
              final email = emailController.text.trim();
              if (email.isEmpty) {
                AppSnack.error(
                    context,
                    t.pleaseEnterEmail
                );
                return;
              }

              try {
                await _auth.sendResetPassword(email);
                if (!mounted) return;
                Navigator.pop(context);
                AppSnack.success(context, t.resetLinkSent);
              } catch (e) {
                AppSnack.error(context, t.checkEmailCorrect);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [Color(0xFF5B7CFF), Color(0xFF7C4DFF)],
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                    color: Colors.black.withOpacity(0.12),
                  ),
                ],
              ),
              child: Text(
                t.send,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _tr(AppLocalizations t, String key) {
    switch (key) {
      case 'errWrongPassword':
        return t.authErrWrongPassword;
      case 'errUserNotFound':
        return t.authErrUserNotFound;
      case 'errInvalidEmail':
        return t.authErrInvalidEmail;
      case 'errTooManyRequests':
        return t.authErrTooManyRequests;
      default:
        return t.authErrGeneric;
    }
  }

  Widget _fieldCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 12),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE7F3FF),
              Color(0xFFFFF0FA),
              Color(0xFFF3F0FF),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 8),
                    _LangSwitch(
                      isArabic: isArabic,
                      onTap: () {
                        _toggleLanguage();
                        setState(() {});
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.white.withOpacity(0.95),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 26,
                          offset: const Offset(0, 14),
                          color: Colors.black.withOpacity(0.10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.verified_user_rounded,
                      size: 40,
                      color: Color(0xFF5B7CFF),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  t.loginTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  t.loginSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.5,
                    height: 1.4,
                    color: Colors.black.withOpacity(0.55),
                  ),
                ),

                const SizedBox(height: 18),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      // Email field
                      _fieldCard(
                        child: AuthTextField(
                          controller: _email,
                          hint: t.email,
                          icon: Icons.email_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if ((v ?? '').trim().isEmpty) return t.fieldRequired;
                            if (!Validators.isEmailValid(v!)) return t.invalidEmail;
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Password field
                      _fieldCard(
                        child: AuthTextField(
                          controller: _pass,
                          hint: t.password,
                          icon: Icons.lock_rounded,
                          obscure: _obscure,
                          validator: (v) {
                            if ((v ?? '').isEmpty) return t.fieldRequired;
                            return null;
                          },
                          suffix: IconButton(
                            onPressed: () => setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Align(
                  alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
                  child: TextButton(
                    onPressed: _handleForgotPassword,
                    child: Text(
                      t.forgotPassword,
                      style: const TextStyle(
                        color: Color(0xFF5B7CFF),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5B7CFF), Color(0xFF7C4DFF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                        color: Colors.black.withOpacity(0.12),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: _loading ? null : _onLogin,
                    child: _loading
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Text(
                      t.login,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(t.dontHaveAccount),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignupScreen()),
                        );
                      },
                      child: Text(
                        t.createAccount,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LangSwitch extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onTap;

  const _LangSwitch({
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = isArabic ? 'EN' : 'AR';
    final subtitle = isArabic ? 'English' : 'العربية';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language_rounded, size: 18, color: Color(0xFF5B7CFF)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(width: 8),
            Text(subtitle, style: TextStyle(color: Colors.black.withOpacity(0.55))),
          ],
        ),
      ),
    );
  }
}

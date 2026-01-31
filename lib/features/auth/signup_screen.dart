import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/snack.dart';
import '../../core/validators.dart';
import '../../l10n/app_localizations.dart';
import 'auth_service.dart';
import '../../widgets/auth_text_field.dart';
import '../../main.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _agreed = false;
  bool _loading = false;

  final _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _pass.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _toggleLanguage() {
    final isArabic = appLocale.value.languageCode == 'ar';
    appLocale.value = Locale(isArabic ? 'en' : 'ar');
  }

  Future<void> _onSignup() async {
    final t = AppLocalizations.of(context)!;

    final ok = (_formKey.currentState?.validate() ?? false);
    if (!ok) return;

    if (!_agreed) {
      AppSnack.error(context, t.agreeTermsShort);
      return;
    }

    setState(() => _loading = true);
    try {
      final fullName = _name.text.trim();

      final userCredential = await _auth.signup(
        email: _email.text.trim(),
        password: _pass.text,
        fullName: fullName,
      );

      // Update the user's display name
      await userCredential.user?.updateDisplayName(fullName);

      // refresh the user data
      await userCredential.user?.reload();

      // send a verification email to confirm the account
      await userCredential.user?.sendEmailVerification();

      if (!mounted) return;

      AppSnack.success(context, t.signupVerifyEmailSuccess);


      await FirebaseAuth.instance.signOut();

      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      setState(() => _loading = false);

      if (e.code == 'email-already-in-use') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              t.emailAlreadyRegisteredLogin,
            ),
            action: SnackBarAction(
              label: t.loginAction,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        );
      } else {
        final key = _auth.mapAuthCodeToKey(e.code);
        if (!mounted) return;
        AppSnack.error(context, _tr(t, key));
      }
    } catch (e) {
      setState(() => _loading = false);
      if (!mounted) return;
      AppSnack.error(context, t.errGeneric);
    }
  }

  String _tr(AppLocalizations t, String key) {
    switch (key) {
      case 'errEmailInUse':
        return t.errEmailInUse;
      case 'errWeakPassword':
        return t.errWeakPassword;
      default:
        return t.errGeneric;
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

    final pass = _pass.text;
    final showRules = pass.isNotEmpty;

    final okMin = Validators.min8(pass);
    final okU = Validators.hasUpper(pass);
    final okL = Validators.hasLower(pass);
    final okN = Validators.hasNumber(pass);

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
                      Icons.person_add_alt_1_rounded,
                      size: 40,
                      color: Color(0xFF5B7CFF),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  t.signupTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  t.signupSubtitle,
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
                      _fieldCard(
                        child: AuthTextField(
                          controller: _name,
                          hint: t.fullName,
                          icon: Icons.person_outline_rounded,
                          validator: (v) {
                            final s = (v ?? '').trim();
                            if (s.isEmpty) return t.fieldRequired;

                            final onlyLettersAndSpaces =
                            RegExp(r'^[\u0600-\u06FFa-zA-Z\s]+$');
                            if (!onlyLettersAndSpaces.hasMatch(s)) {
                              return t.nameLettersOnly;
                            }

                            final lettersCount =
                                s.replaceAll(RegExp(r'\s+'), '').length;
                            if (lettersCount < 3) {
                              return t.nameMinLetters;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

                      _fieldCard(
                        child: AuthTextField(
                          controller: _email,
                          hint: t.email,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            final s = (v ?? '').trim();
                            if (s.isEmpty) return t.fieldRequired;
                            if (!Validators.isEmailValid(s)) return t.invalidEmail;
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

                      _fieldCard(
                        child: AuthTextField(
                          controller: _pass,
                          hint: t.password,
                          icon: Icons.lock_open_rounded,
                          obscure: _obscure1,
                          validator: (v) {
                            final s = (v ?? '');
                            if (s.isEmpty) return t.fieldRequired;
                            return null;
                          },
                          suffix: IconButton(
                            onPressed: () => setState(() => _obscure1 = !_obscure1),
                            icon: Icon(
                              _obscure1
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                            ),
                          ),
                        ),
                      ),

                      if (showRules)
                        Padding(
                          padding: const EdgeInsets.only(top: 12, left: 4, right: 4),
                          child: Column(
                            children: [
                              _RuleRow(ok: okMin, text: t.passwordMin),
                              _RuleRow(ok: okU, text: t.passwordUpper),
                              _RuleRow(ok: okL, text: t.passwordLower),
                              _RuleRow(ok: okN, text: t.passwordNumber),
                            ],
                          ),
                        ),

                      const SizedBox(height: 10),

                      _fieldCard(
                        child: AuthTextField(
                          controller: _confirm,
                          hint: t.confirmPassword,
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscure2,
                          validator: (v) {
                            final s = (v ?? '');
                            if (s.isEmpty) return t.fieldRequired;
                            if (s != _pass.text) return t.passwordMismatch;
                            return null;
                          },
                          suffix: IconButton(
                            onPressed: () => setState(() => _obscure2 = !_obscure2),
                            icon: Icon(
                              _obscure2
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: const Color(0xFF5B7CFF).withOpacity(0.5),
                  ),
                  child: CheckboxListTile(
                    value: _agreed,
                    onChanged: (v) => setState(() => _agreed = v ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: const Color(0xFF5B7CFF),
                    title: Text(
                      t.agreeTerms,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black.withOpacity(0.65),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

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
                    onPressed: _loading ? null : _onSignup,
                    child: _loading
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Text(
                      t.signUp,
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
                    Text(t.alreadyHaveAccount),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        t.login,
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
            const Icon(Icons.language_rounded,
                size: 18, color: Color(0xFF5B7CFF)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(width: 8),
            Text(subtitle,
                style: TextStyle(color: Colors.black.withOpacity(0.55))),
          ],
        ),
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  final bool ok;
  final String text;

  const _RuleRow({required this.ok, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final successColor = const Color(0xFF2E7D32);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ok ? successColor.withOpacity(0.1) : Colors.transparent,
            ),
            child: Icon(
              ok ? Icons.check_circle_rounded : Icons.circle_outlined,
              size: 16,
              color: ok ? successColor : theme.colorScheme.onSurface.withOpacity(0.3),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: ok ? successColor : theme.colorScheme.onSurface.withOpacity(0.5),
                fontWeight: ok ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

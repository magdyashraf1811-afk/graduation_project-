
import 'package:athaar_app/home/widget/custom_elevated_button.dart';
import 'package:athaar_app/home/widget/custom_text_form_field.dart';
import 'package:athaar_app/l10n/app_localizations.dart';
import 'package:athaar_app/models/auth_service..dart';
import 'package:athaar_app/utils/app_colors.dart';
import 'package:athaar_app/utils/app_image.dart';
import 'package:athaar_app/utils/app_routes.dart';
import 'package:athaar_app/utils/app_style.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../providers/app_theme_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed(
        AppRoutes.homeRouteScreen,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final themeProvider = Provider.of<AppThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: AppColors.transparentColor,
        title: AppStyle.atharText,
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
          vertical: height * 0.04,
        ),

        child: SingleChildScrollView(
          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: height * 0.0185,

              children: [
                Text(
                  AppLocalizations.of(context)!.welcome_to_athar,
                  style: themeProvider.isDarkMode()
                      ? AppStyle.bold20White
                      : AppStyle.bold20Gold,
                ),

                Text(
                  AppLocalizations.of(context)!.login_description,
                  style: themeProvider.isDarkMode()
                      ? AppStyle.bold16lightGray
                      : AppStyle.bold16Black,
                ),

                // Email Field
                CustomTextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  filled: true,
                  fillColor: themeProvider.isDarkMode()
                      ? AppColors.darkColor
                      : AppColors.whiteColor,
                  borderSideColor: themeProvider.isDarkMode()
                      ? AppColors.goldAccentColor
                      : AppColors.beigeColor,
                  hintText:
                  AppLocalizations.of(context)!.email_address,
                  hintStyle: AppStyle.bold16lightGray,
                  prefixIcon: Icon(
                    Icons.mail_outline_outlined,
                    color: AppColors.primaryColor,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!RegExp(
                      r'^[^@]+@[^@]+\.[^@]+',
                    ).hasMatch(value.trim())) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                // Password Field
                CustomTextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  filled: true,
                  fillColor: themeProvider.isDarkMode()
                      ? AppColors.darkColor
                      : AppColors.whiteColor,
                  borderSideColor: themeProvider.isDarkMode()
                      ? AppColors.goldAccentColor
                      : AppColors.beigeColor,
                  hintText: 'Password',
                  hintStyle: AppStyle.bold16lightGray,
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.primaryColor,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }

                    return null;
                  },
                ),

                // Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // todo: Forgot password
                      },
                      child: Text(
                        AppLocalizations.of(context)!.forget_password,
                        style: AppStyle.bold14Primary,
                      ),
                    ),
                  ],
                ),

                // Login Button
                CustomElevatedButton(
                  backgroundColor: AppColors.primaryColor,
                  isLoading: _isLoading,
                  onPressed: login,
                  child: Text(
                    AppLocalizations.of(context)!.login,
                    style: AppStyle.bold18sunFace,
                  ),
                ),

                // OR Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: themeProvider.isDarkMode()
                            ? AppColors.goldAccentColor
                            : AppColors.lightGrayColor,
                        thickness: 1,
                        indent: width * 0.06,
                        endIndent: width * 0.03,
                      ),
                    ),

                    Text(
                      AppLocalizations.of(context)!.or,
                      style: themeProvider.isDarkMode()
                          ? AppStyle.bold16bgWhite
                          : AppStyle.bold16Black2,
                    ),

                    Expanded(
                      child: Divider(
                        color: themeProvider.isDarkMode()
                            ? AppColors.goldAccentColor
                            : AppColors.lightGrayColor,
                        thickness: 1,
                        indent: width * 0.06,
                        endIndent: width * 0.03,
                      ),
                    ),
                  ],
                ),

                // Google Login
                CustomElevatedButton(
                  borderSideColor: themeProvider.isDarkMode()
                      ? AppColors.goldAccentColor
                      : AppColors.beigeColor,
                  backgroundColor: themeProvider.isDarkMode()
                      ? AppColors.darkColor
                      : AppColors.whiteColor,
                  onPressed: () {
                    // todo: google login
                  },
                  child: Row(
                    spacing: width * 0.02,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppImage.googleLogo),

                      Text(
                        AppLocalizations.of(context)!.login_with_google,
                        style: themeProvider.isDarkMode()
                            ? AppStyle.bold16bgWhite
                            : AppStyle.bold16lightGray,
                      ),
                    ],
                  ),
                ),

                // Sign In Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!
                          .already_have_an_account,
                      style: themeProvider.isDarkMode()
                          ? AppStyle.bold14lightGray
                          : AppStyle.bold16Black2,
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.signinScreen,
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.sign_in,
                        style: AppStyle.bold14Primary,
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

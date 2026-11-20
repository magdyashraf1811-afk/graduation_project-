
import 'dart:convert';

import 'package:athaar_app/home/widget/custom_elevated_button.dart';
import 'package:athaar_app/home/widget/custom_text_form_field.dart';
import 'package:athaar_app/l10n/app_localizations.dart';
import 'package:athaar_app/models/api_config.dart';
import 'package:athaar_app/utils/app_colors.dart';
import 'package:athaar_app/utils/app_image.dart';
import 'package:athaar_app/utils/app_routes.dart';
import 'package:athaar_app/utils/app_style.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../providers/app_theme_provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.register),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
          'confirmPassword': _confirmPasswordController.text,
        }),
      );

      final dynamic responseData = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacementNamed(
          context,
          AppRoutes.loginScreen,
        );
      } else {
        String message = 'Registration failed';

        if (responseData is Map<String, dynamic>) {
          message = responseData['message']?.toString() ??
              responseData['error']?.toString() ??
              message;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on FormatException {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid response from server'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to connect to the server'),
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

    final l10n = AppLocalizations.of(context)!;

    final fieldFillColor = themeProvider.isDarkMode() ? AppColors.darkColor : AppColors.whiteColor;

    final fieldBorderColor =
    themeProvider.isDarkMode()  ? AppColors.goldAccentColor : AppColors.beigeColor;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: AppStyle.atharText,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.06,
              vertical: height * 0.02,
            ),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: height * 0.015),

                  Text(
                    l10n.create_account,
                    style: AppStyle.bold20White,
                  ),

                  SizedBox(height: height * 0.01),

                  Text(
                    l10n.join_athar,
                    style: AppStyle.bold16lightGray,
                  ),

                  SizedBox(height: height * 0.03),

                  // FULL NAME
                  CustomTextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    hintText: l10n.full_name,
                    filled: true,
                    fillColor: fieldFillColor,
                    borderSideColor: fieldBorderColor,
                    hintStyle: AppStyle.bold16lightGray,
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: AppColors.primaryColor,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your full name';
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: height * 0.02),

                  // EMAIL
                  CustomTextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: l10n.email_address,
                    filled: true,
                    fillColor: fieldFillColor,
                    borderSideColor: fieldBorderColor,
                    hintStyle: AppStyle.bold16lightGray,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color:AppColors.primaryColor,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }

                      final emailRegex =
                      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Please enter a valid email';
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: height * 0.02),

                  // PASSWORD
                  CustomTextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    hintText: l10n.password,
                    filled: true,
                    fillColor: fieldFillColor,
                    borderSideColor: fieldBorderColor,
                    hintStyle: AppStyle.bold16lightGray,
                    prefixIcon: Icon(
                      Icons.lock_outline,
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
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }

                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: height * 0.02),

                  // CONFIRM PASSWORD
                  CustomTextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    hintText: l10n.conform_password,
                    filled: true,
                    fillColor: fieldFillColor,
                    borderSideColor: fieldBorderColor,
                    hintStyle: AppStyle.bold16lightGray,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppColors.primaryColor,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword =
                          !_obscureConfirmPassword;
                        });
                      },
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }

                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: height * 0.035),

                  // REGISTER BUTTON
                  CustomElevatedButton(
                    onPressed: register,
                    isLoading: _isLoading,
                    backgroundColor: AppColors.primaryColor,
                    child: Text(
                      l10n.sign_in,
                      style: AppStyle.bold18sunFace,
                    ),
                  ),

                  SizedBox(height: height * 0.025),

                  // DIVIDER
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: fieldBorderColor,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: Text(
                          'OR',
                          style: AppStyle.bold16lightGray,
                        ),
                      ),

                      Expanded(
                        child: Divider(
                          color: fieldBorderColor,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.025),

                  // GOOGLE BUTTON
                  CustomElevatedButton(
                    onPressed: () {
                      // todo: Google Sign-In integration
                    },
                    backgroundColor: fieldFillColor,
                    borderSideColor: fieldBorderColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImage.googleLogo,
                          height: 24,
                          width: 24,
                        ),

                        const SizedBox(width: 12),

                        Text(
                          'Continue with Google',
                          style: AppStyle.bold16lightGray,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.035),

                  // LOGIN NAVIGATION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          l10n.already_have_an_account,
                          style: AppStyle.bold16lightGray,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.loginScreen,
                          );
                        },
                        child: Text(
                          l10n.login,
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
      ),
    );
  }
}

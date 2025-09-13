import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:noviindus_task/core/color_config.dart';
import 'package:noviindus_task/core/size_config.dart';
import 'package:noviindus_task/presentation/providers/auth_provider.dart';
import 'package:noviindus_task/presentation/ui/login_screen/widgets/bottom_text.dart';
import 'package:noviindus_task/presentation/ui/login_screen/widgets/text_filed.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    _emailCtrl.text = "test_user";
    _passwordCtrl.text = "12345678";


    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: height),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: Image.asset(
                              'assets/img/topcard.png',
                              fit: BoxFit.cover,
                            ),
                          ),

                       
                          Image(
                            height: 80,
                            width: 80,
                            image: AssetImage('assets/img/logo.png'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Login Or Register To Book\nYour Appointments',
                              style: TextStyle(
                                color: Color(0xFF404040),
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                height: 1.15,
                              ),
                            ),

                            SizedBox(height: SizeConfig.screenHeight / 40),

                            
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  
                                  buildInputField(
                                    controller: _emailCtrl,
                                    hint: 'Enter your email',
                                    label: 'Email',
                                    borderGrey: ColorConfig.fillGrey,
                                    textInputType: TextInputType.emailAddress,
                                  ),

                                  SizedBox(
                                    height: SizeConfig.screenHeight / 40,
                                  ),

                                  buildInputField(
                                    controller: _passwordCtrl,
                                    hint: 'Enter password',
                                    label: 'Password',
                                    borderGrey: ColorConfig.fillGrey,
                                    obscure: true,
                                  ),

                                  SizedBox(
                                    height: SizeConfig.screenHeight / 40,
                                  ),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            ColorConfig.primaryGreen,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      onPressed:
                                          auth.status == AuthStatus.loading
                                          ? null
                                          : () async {
                                              if (!_formKey.currentState!
                                                  .validate())
                                                return;
                                              final ok = await context
                                                  .read<AuthProvider>()
                                                  .login(
                                                    _emailCtrl.text.trim(),
                                                    _passwordCtrl.text.trim(),
                                                  );
                                              if (!ok) {
                                                final msg =
                                                    context
                                                        .read<AuthProvider>()
                                                        .errorMessage ??
                                                    'Login failed';
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    backgroundColor: Colors.red,
                                                    content: Text(msg),
                                                  ),
                                                );
                                              }
                                            },
                                      child: auth.status == AuthStatus.loading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text('Login'),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: SizeConfig.screenHeight / 5),

                            
                            bottomText(),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),

                 
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

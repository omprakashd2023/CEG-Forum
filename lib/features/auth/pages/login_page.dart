import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

//Constants
import '../../../core/constants/constants.dart';

//Controller
import '../controller/auth_controller.dart';

//Widgets
import '../../../core/widgets/sign_in_button.dart';
import '../../../core/widgets/loader.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  // Form validation variables
  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool isConfirmPasswordValid = true;

  // Function to validate email
  void validateEmail(String value) {
    // Regular expression pattern for email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    setState(() {
      isEmailValid = emailRegex.hasMatch(value);
    });
  }

  // Function to validate password
  void validatePassword(String value) {
    setState(() {
      isPasswordValid = value.isNotEmpty;
    });
  }

  void navigateToSignUpPage() {
    print('Navigating to sign up page');
    Routemaster.of(context).push('/sign-up');
  }

  void signUpWithEmailAndPassword(String email, String password) {
    ref
        .read(authControllerProvider.notifier)
        .signInWithEmail(context, null, email, password);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    Size size = MediaQuery.of(context).size;

    Expanded buildDivider() {
      return const Expanded(
        child: Divider(
          color: Color(0xFFD9D9D9),
          height: 1.5,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          Constants.logoPath,
          height: 50,
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Welcome',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Dive into anything',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      Constants.loginEmotePath,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Email',
                            errorText: isEmailValid
                                ? null
                                : 'Please enter a valid email',
                          ),
                          onChanged: validateEmail,
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Password',
                            errorText: isPasswordValid
                                ? null
                                : 'Please enter a password',
                          ),
                          onChanged: validatePassword,
                        ),
                        const SizedBox(height: 32.0),
                        ElevatedButton(
                          onPressed: () {
                            if (isEmailValid &&
                                isPasswordValid &&
                                isConfirmPasswordValid) {
                              signUpWithEmailAndPassword(emailController.text,
                                  passwordController.text);
                            }
                          },
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      TextButton(
                        onPressed: navigateToSignUpPage,
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
                    width: size.width * 0.8,
                    child: Row(
                      children: <Widget>[
                        buildDivider(),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "OR",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        buildDivider(),
                      ],
                    ),
                  ),
                  const SignInButton(),
                ],
              ),
            ),
    );
  }
}

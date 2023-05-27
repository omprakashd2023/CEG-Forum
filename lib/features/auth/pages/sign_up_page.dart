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

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  // Form validation variables
  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool isConfirmPasswordValid = true;
  bool isUserNameValid = true;
  String validationUserNameMessage = 'Please enter a username';
  String passwordErrorText = '';

  // Function to validate username
  void validateUserName(String value) async {
    final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_]{8,}$');

    setState(() {
      isUserNameValid = value.isNotEmpty && usernameRegex.hasMatch(value);
      validationUserNameMessage = '';
    });
    if (isUserNameValid) {
      if (value.length <= 8) {
        isUserNameValid = false;
        setState(() {
          validationUserNameMessage =
              'Username must be greater than 8 characters';
        });
      } else if (RegExp(r'[!@#\$%\^&\*]').hasMatch(value)) {
        isUserNameValid = false;
        setState(() {
          validationUserNameMessage =
              'Username must not contain special characters';
        });
      } else {
        // Check if the username already exists
        bool usernameExists = await ref
            .watch(authControllerProvider.notifier)
            .checkUsernameExists(value);

        if (usernameExists) {
          isUserNameValid = false;
          setState(() {
            validationUserNameMessage = 'Username already exists';
          });
        }
      }
    } else {
      setState(() {
        validationUserNameMessage =
            'Username must be greater than 8 characters and must not contain special characters';
      });
    }
  }

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
    bool hasUppercase = false;
    bool hasLowercase = false;
    bool hasDigit = false;
    bool hasSpecialChar = false;
    bool isLengthValid = false;

    if (value.contains(RegExp(r'[A-Z]'))) {
      hasUppercase = true;
    }

    if (value.contains(RegExp(r'[a-z]'))) {
      hasLowercase = true;
    }

    if (value.contains(RegExp(r'[0-9]'))) {
      hasDigit = true;
    }

    if (value.contains(RegExp(r'[!@#\$%\^&\*]'))) {
      hasSpecialChar = true;
    }

    if (value.length >= 8) {
      isLengthValid = true;
    }

    setState(() {
      isPasswordValid = hasUppercase &&
          hasLowercase &&
          hasDigit &&
          hasSpecialChar &&
          isLengthValid;

      if (!hasUppercase) {
        passwordErrorText =
            'Password must contain at least one uppercase letter';
      } else if (!hasLowercase) {
        passwordErrorText =
            'Password must contain at least one lowercase letter';
      } else if (!hasDigit) {
        passwordErrorText = 'Password must contain at least one digit';
      } else if (!hasSpecialChar) {
        passwordErrorText =
            'Password must contain at least one special character';
      } else if (!isLengthValid) {
        passwordErrorText = 'Password must be at least 8 characters long';
      } else {
        passwordErrorText = '';
      }
    });
  }

  // Function to validate confirm password
  void validateConfirmPassword(String value) {
    setState(() {
      isConfirmPasswordValid =
          value.isNotEmpty && value == passwordController.text;
    });
  }

  void navigateToLoginPage() {
    Routemaster.of(context).push('/');
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
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      Constants.loginEmotePath,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: userNameController,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Username',
                            errorMaxLines: 2,
                            errorText: isUserNameValid
                                ? null
                                : validationUserNameMessage,
                          ),
                          onChanged: validateUserName,
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
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
                            errorText:
                                isPasswordValid ? null : passwordErrorText,
                          ),
                          onChanged: validatePassword,
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Confirm Password',
                            errorText: isConfirmPasswordValid
                                ? null
                                : 'Passwords do not match',
                          ),
                          onChanged: validateConfirmPassword,
                        ),
                        const SizedBox(height: 32.0),
                        ElevatedButton(
                          onPressed: () {
                            // Perform form submission
                            if (isEmailValid &&
                                isPasswordValid &&
                                isConfirmPasswordValid) {
                              // Perform sign-up logic
                              // ...
                            }
                          },
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: navigateToLoginPage,
                        child: const Text('Sign In'),
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

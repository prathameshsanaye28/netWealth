
import 'package:flutter/material.dart';
import 'package:netwealth_vjti/resources/auth_methods.dart';
import 'package:netwealth_vjti/resources/user_provider.dart';
import 'package:netwealth_vjti/screens/auth_screens/signin.dart';
import 'package:netwealth_vjti/screens/networking_screen.dart';
import 'package:netwealth_vjti/widgets/text_field_input.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  // RxBool isLoading = false.obs;
  // AuthController authController = Get.put(AuthController());

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  // void loginUser() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   String res = await AuthMethods().loginUser(
  //       email: _emailController.text, password: _passwordController.text);
  //   if (res == 'success') {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
  //       builder: (context) => HomeScreen(),
  //     ));
  //   } else {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     showSnackBar(res, context);
  //   }
  // }
  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    
    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (res == "success") {
      // Get UserProvider
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      
      // Refresh user data after successful login
      await userProvider.refreshUser();

      // Navigate to home screen
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => NetworkingScreen(),
        ),
      );
    } else {
      // Show error message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignUp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignInScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
                child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
              ),
              Text(
                'Log In',
                style: TextStyle(color: Colors.black, fontSize: 35),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: const Color.fromARGB(255, 22, 55, 23))),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 25.0, right: 25, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      const Text(
                        "Email",
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextFieldInput(
                          hintText: 'Enter your email',
                          textEditingController: _emailController,
                          textInputType: TextInputType.emailAddress),
                      const SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      //password input
                      const Text(
                        "Password",
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextFieldInput(
                        hintText: 'Enter your password',
                        textEditingController: _passwordController,
                        textInputType: TextInputType.text,
                        isPass: true,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      //button
                      InkWell(
                        onTap: () {
                          loginUser();
                        },
                        child: Container(
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.black,

                                  )
                                : const Text('Log In'),
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(colors: [
                              const Color.fromARGB(255, 24, 66, 25),
                              Colors.green
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight
                            )
                            )),
                      ),
                      const SizedBox(
                height: 24,
              ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("OR",style: TextStyle(
                    fontSize: 25
                  ),)
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              
              // Obx(
              //   () => isLoading.value
              //       ? CircularProgressIndicator()
              //       : PrimaryButtonWithIcon(
              //           buttonText: "Sign in with Google",
              //           onTap: () {
              //             isLoading.value = true;
              //             authController.login();
              //           },
              //           //iconPath: IconsPath.google,
              //         ),
              // ),
              //signup page link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Don't have an account?"),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: () {
                      navigateToSignUp();
                    },
                    child: Container(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              )
            ],
          ),
                ),
              ),
        ));
  }
}


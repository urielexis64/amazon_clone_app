import 'package:amazon_clone/common/widgets/amazon_button.dart';
import 'package:amazon_clone/common/widgets/amazon_text_field.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/auth/services/auth_service.dart';
import 'package:amazon_clone/utils/copies.dart';
import 'package:flutter/material.dart';

enum Auth {
  signIn,
  signUp,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signUp;
  final AuthService _authService = AuthService();
  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AmazonCopies.welcome,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    RadioListTile(
                        tileColor: _auth == Auth.signUp
                            ? GlobalVariables.backgroundColor
                            : GlobalVariables.greyBackgroundColor,
                        title: const Text(
                          AmazonCopies.createAccount,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        activeColor: GlobalVariables.secondaryColor,
                        value: Auth.signUp,
                        groupValue: _auth,
                        onChanged: (Auth? value) =>
                            setState(() => _auth = value!)),
                    if (_auth == Auth.signUp)
                      Container(
                        color: GlobalVariables.backgroundColor,
                        padding: const EdgeInsets.all(12),
                        child: Form(
                          key: _signUpFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AmazonTextField(
                                hintText: AmazonCopies.name,
                                validator: (val) => val!.length < 3
                                    ? 'Name must be 3 characters minimum'
                                    : null,
                                controller: _nameController,
                              ),
                              const SizedBox(height: 10),
                              AmazonTextField(
                                hintText: AmazonCopies.email,
                                validator: (val) => !val!.contains('@')
                                    ? 'Invalid email'
                                    : null,
                                controller: _emailController,
                              ),
                              const SizedBox(height: 10),
                              AmazonTextField(
                                hintText: AmazonCopies.password,
                                validator: (val) => val!.length < 8
                                    ? 'Password must be 8 characters minimum'
                                    : null,
                                controller: _passwordController,
                              ),
                              const SizedBox(height: 10),
                              AmazonButton(
                                onPressed: _signUpUser,
                                text: AmazonCopies.signUp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    RadioListTile(
                        tileColor: _auth == Auth.signIn
                            ? GlobalVariables.backgroundColor
                            : GlobalVariables.greyBackgroundColor,
                        title: const Text(
                          AmazonCopies.signIn,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        activeColor: GlobalVariables.secondaryColor,
                        value: Auth.signIn,
                        groupValue: _auth,
                        onChanged: (Auth? value) =>
                            setState(() => _auth = value!)),
                    if (_auth == Auth.signIn)
                      Container(
                        color: GlobalVariables.backgroundColor,
                        padding: const EdgeInsets.all(12),
                        child: Form(
                          key: _signInFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AmazonTextField(
                                hintText: AmazonCopies.email,
                                validator: (val) => !val!.contains('@')
                                    ? 'Invalid email'
                                    : null,
                                controller: _emailController,
                              ),
                              const SizedBox(height: 10),
                              AmazonTextField(
                                hintText: AmazonCopies.password,
                                controller: _passwordController,
                              ),
                              const SizedBox(height: 10),
                              AmazonButton(
                                onPressed: _signInUser,
                                text: AmazonCopies.signIn,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Center(
                child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              color: Colors.black12,
              child: const Center(child: CircularProgressIndicator.adaptive()),
            ))
        ],
      ),
    );
  }

  Future<void> _signUpUser() async {
    if (_signUpFormKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      final name = _nameController.text;
      setState(() {
        _isLoading = true;
      });
      await _authService.signUpUser(
          context: context, email: email, password: password, name: name);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInUser() async {
    if (_signInFormKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      setState(() {
        _isLoading = true;
      });
      await _authService.signInUser(
          context: context, email: email, password: password);
      setState(() {
        _isLoading = false;
      });
    }
  }
}

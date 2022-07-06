import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive_layout.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_field_input.dart';
import 'package:instagram_flutter/screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(res, context);
    }
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        shrinkWrap: true,
        //  crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(child: Container(), flex: 2),
          SvgPicture.asset(
            'assets/ic_instagram.svg',
            color: primaryColor,
            height: 64,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPfCfynXv42fOnrTQAs-99j09O8uz7mDilOQ&usqp=CAU'),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          TextFieldInput(
              textEditingController: _usernameController,
              hintText: 'Enter your username',
              textInputType: TextInputType.text),
          const SizedBox(height: 24),
          TextFieldInput(
              textEditingController: _emailController,
              hintText: 'Enter your Email',
              textInputType: TextInputType.emailAddress),
          const SizedBox(height: 24),
          TextFieldInput(
            textEditingController: _passwordController,
            hintText: 'Enter your Password',
            textInputType: TextInputType.text,
            isPass: true,
          ),
          const SizedBox(height: 24),
          TextFieldInput(
              textEditingController: _bioController,
              hintText: 'Enter your bio',
              textInputType: TextInputType.text),
          const SizedBox(height: 24),
          InkWell(
            child: Container(
              child: !_isLoading
                  ? const Text(
                      'Sign up',
                    )
                  : const CircularProgressIndicator(
                      color: primaryColor,
                    ),
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                color: blueColor,
              ),
            ),
            onTap: signUpUser,
          ),
          const SizedBox(height: 12),
          Flexible(child: Container(), flex: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  child: const Text("Have an account?"),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                ),
              ),
              GestureDetector(
                onTap: navigateToLogin,
                child: Container(
                  child: const Text(
                    "Login.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ));

    // )
    //   ),
    // )
    ;
  }
}

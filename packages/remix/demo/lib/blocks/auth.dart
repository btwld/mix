import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart' hide Scaffold;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthBlock(),
    );
  }
}

class AuthBlock extends StatefulWidget {
  const AuthBlock({super.key});

  @override
  State<AuthBlock> createState() => _AuthBlockState();
}

class _AuthBlockState extends State<AuthBlock> {
  bool showPassword = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                ),
                Row(
                  spacing: 8,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(fontSize: 15),
                    ),
                    RxButton(
                      onPressed: () {},
                      label: 'Create account',
                      style: LinkButtonStyle(),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                FlexBox(
                  direction: Axis.vertical,
                  style: FlexBoxStyle()
                    ..border.all.color.grey.shade300()
                    ..border.all.strokeAlign.outside()
                    ..clipBehavior.antiAlias()
                    ..color.grey.shade300()
                    ..flex.gap(1)
                    ..borderRadius(8),
                  children: [
                    RxTextField(
                      controller: usernameController,
                      hintText: 'Username',
                      style: TextFieldStyle(),
                    ),
                    RxTextField(
                      controller: passwordController,
                      obscureText: !showPassword,
                      hintText: 'Password',
                      suffix: RxButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        label: showPassword ? 'Hide' : 'Show',
                        style: LinkButtonStyle()..textStyle.fontSize(14),
                      ),
                      style: TextFieldStyle(),
                    ),
                  ],
                ),
                RxButton(
                  label: 'Forgot password?',
                  onPressed: () {},
                  style: LinkButtonStyle(),
                ),
                RxButton(
                  onPressed: () {},
                  label: 'Sign in',
                  style: RxButtonStyle()
                    ..textStyle.color.white()
                    ..textStyle.fontWeight.w500()
                    ..container.color.black()
                    ..container.border.all.color.grey.shade300()
                    ..container.height(56)
                    ..container.borderRadius(8)
                    ..container.width.infinity()
                    ..container.alignment.center(),
                ),
              ],
            ),
            StyledText(
              'or',
              style: StyledTextStyle()..color.grey.shade500(),
            ),
            Column(
              spacing: 8,
              children: [
                RxButton(
                  label: 'Continue with Apple',
                  onPressed: () {},
                  icon: Icons.apple,
                  style: SocialMediaButtonStyle(),
                ),
                RxButton(
                  label: 'Continue with Facebook',
                  onPressed: () {},
                  icon: Icons.facebook,
                  style: SocialMediaButtonStyle(),
                ),
                RxButton(
                  label: 'Show more options',
                  onPressed: () {},
                  icon: Icons.add,
                  style: SocialMediaButtonStyle(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LinkButtonStyle extends RxButtonStyle {
  LinkButtonStyle() : super() {
    textStyle
      ..color.black()
      ..fontSize(15)
      ..fontWeight.w500();

    container
      ..padding(0)
      ..height(20)
      ..margin.vertical(2)
      ..borderRadius(0)
      ..border.bottom.color.black()
      ..border.bottom.strokeAlign.inside()
      ..border.bottom.width(1)
      ..color.transparent();
  }
}

class TextFieldStyle extends RxTextFieldStyle {
  TextFieldStyle() : super() {
    container
      ..border.none()
      ..borderRadius(0)
      ..padding(16)
      ..height(56);
    style.fontSize(16);
    hintTextColor.grey.shade500();
  }
}

class SocialMediaButtonStyle extends RxButtonStyle {
  SocialMediaButtonStyle() : super() {
    container
      ..alignment.center()
      ..height(56)
      ..color.white()
      ..border.all.color.grey.shade300();
    textStyle
      ..color.black()
      ..fontWeight.w500();
    icon
      ..color.black()
      ..size(24);
  }
}

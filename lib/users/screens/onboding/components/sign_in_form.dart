import 'package:eva/manager/screens/entryPoint/entry_point_Manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../entryPoint/entry_point.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isShowLoading = false;
  bool isShowConfetti = false;
  late SMITrigger error;
  late SMITrigger success;
  late SMITrigger reset;

  late SMITrigger confetti;

  void _onCheckRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');

    artboard.addController(controller!);
    error = controller.findInput<bool>('Error') as SMITrigger;
    success = controller.findInput<bool>('Check') as SMITrigger;
    reset = controller.findInput<bool>('Reset') as SMITrigger;
    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }

  void _onConfettiRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);

    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }

  void singIn(BuildContext context) {
    setState(() {
      isShowConfetti = false;
      isShowLoading = true;
    });

    Future.delayed(
      const Duration(seconds: 1),
          () async {
        if (_formKey.currentState!.validate()) {
          try {
            setState(() {
              isShowLoading = true;
            });

            // Đăng nhập với Firebase Authentication
            final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passwordTextController.text,
            );
            final user = userCredential.user;
            print(user?.uid);

            // Kiểm tra xem việc đăng nhập có thành công hay không
            if (FirebaseAuth.instance.currentUser != null) {
              // Nếu thành công, bạn có thể tiếp tục chuyển hướng đến trang chính của ứng dụng
              // Lưu thông tin đăng nhập vào SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              final uid = FirebaseAuth.instance.currentUser!.uid;
              prefs.setString('uid', FirebaseAuth.instance.currentUser!.uid);
              setState(() {
                isShowLoading = false;
              });
              if (uid == 'RE12kjX0fvZm64lesUcgERWRqM13') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EntryPointManager(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EntryPoint(),
                  ),
                );
              }
            }
          } catch (e) {
            // Xử lý lỗi khi đăng nhập
            setState(() {
              isShowLoading = false;
              isShowConfetti = false;
            });
            if (e is FirebaseAuthException) {
              if (e.code == 'user-not-found') {
                // Lỗi tài khoản không tồn tại
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Lỗi đăng nhập'),
                      content: Text('Tài khoản không tồn tại.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else if (e.code == 'wrong-password') {
                // Lỗi sai mật khẩu
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Lỗi đăng nhập'),
                      content: Text('Sai mật khẩu.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                // Xử lý các lỗi khác (nếu cần)
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Lỗi đăng nhập'),
                      content: Text('Đăng nhập không thành công.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            }
          }
        } else {
          error.fire();
          Future.delayed(
            const Duration(seconds: 2),
                () {
              setState(() {
                isShowLoading = false;
              });
              reset.fire();
            },
          );
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tài khoản",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                    controller:_emailTextController,
                  validator: (emailTextController) {
                    if (emailTextController!.isEmpty) {
                      return "Vui lòng nhập tài khoản của bạn";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.person, color: Color(0xFF14AEE7),),
                    ),
                  ),
                ),
              ),
              const Text(
                "Mật khẩu",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  controller: _passwordTextController,
                  obscureText: true,
                  validator: (passwordTextController) {
                    if (passwordTextController!.isEmpty) {
                      return "Vui lòng nhập mật khẩu của bạn";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.lock, color: Color(0xFF14AEE7),),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: ElevatedButton.icon(
                  onPressed: () {
                    singIn(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14AEE7),
                    minimumSize: const Size(double.infinity, 56),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                    ),
                  ),
                  icon: const Icon(
                    CupertinoIcons.arrow_right,
                    color: Color(0xFFFFFFFF),
                  ),
                  label: const Text("Đăng nhập"),
                ),
              ),
            ],
          ),
        ),
        isShowLoading
            ? CustomPositioned(
                child: RiveAnimation.asset(
                  'assets/RiveAssets/check.riv',
                  fit: BoxFit.cover,
                  onInit: _onCheckRiveInit,
                ),
              )
            : const SizedBox(),
        isShowConfetti
            ? CustomPositioned(
               scale: 6,
                child: RiveAnimation.asset(
                  "assets/RiveAssets/confetti.riv",
                  onInit: _onConfettiRiveInit,
                  fit: BoxFit.cover,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, this.scale = 1, required this.child});

  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 100,
            width: 100,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

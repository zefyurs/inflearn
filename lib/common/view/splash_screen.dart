import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn/common/const/colors.dart';
import 'package:inflearn/common/const/data.dart';
import 'package:inflearn/common/layout/default_layout.dart';
import 'package:inflearn/common/secure_storage/secure_storage.dart';
import 'package:inflearn/common/view/root_tab.dart';
import 'package:inflearn/user/view/login_screen.dart';
import 'package:dio/dio.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkToken();
  }

  void checkToken() async {
    final storage = ref.read(secureStorageProvider);
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final dio = Dio();

    try {
      final resp = await dio.post('http://$ip/auth/token',
          options: Options(headers: {
            'authorization': 'Bearer $refreshToken',
          }));

      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const RootTab(),
          ),
          (route) => false);
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
          (route) => false);
    }
  }

  void deleteToken() async {
    final storage = ref.read(secureStorageProvider);

    await storage.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Splash Screen'),
          SizedBox(height: 16),
          CircularProgressIndicator(
            color: Colors.white,
          )
        ]),
      ),
    );
  }
}

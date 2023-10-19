import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn/common/component/custom_text_form.dart';
import 'package:inflearn/common/const/colors.dart';
import 'package:inflearn/common/const/data.dart';
import 'package:inflearn/common/layout/default_layout.dart';
import 'package:inflearn/common/secure_storage/secure_storage.dart';
import 'package:inflearn/common/view/root_tab.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String userName = '';
  String passWord = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    return DefaultLayout(
        child: SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Title(),
              const SizedBox(height: 16),
              const _SubTitle(),
              const SizedBox(height: 16),
              CustomTextFormField(
                  hintText: '이메일을 입력해주세요',
                  onChanged: (String value) {
                    userName = value;
                  }),
              const SizedBox(height: 8),
              CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요',
                  obscureText: true,
                  onChanged: (String value) {
                    passWord = value;
                  }),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // ID:비밀번호
                  // final rawString = 'test@codefactory.ai:testtest';
                  final rawString = '$userName:$passWord';
                  Codec<String, String> stringToBase64 = utf8.fuse(base64);

                  String token = stringToBase64.encode(rawString);
                  final resp = await dio.post('http://$ip/auth/login',
                      options: Options(headers: {
                        'authorization': 'Basic $token',
                      }));

                  final refreshToken = resp.data['refreshToken'];
                  final accessToken = resp.data['accessToken'];

                  final storage = ref.read(secureStorageProvider);

                  await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                  await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
                  // Flutter secure storage 사용해서 저장
                  if (!mounted) return;
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RootTab()));
                },
                style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR),
                child: const Text('로그인'),
              ),
              TextButton(
                onPressed: () async {},
                style: TextButton.styleFrom(foregroundColor: Colors.black),
                child: const Text('회원가입'),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    ));
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다.',
      style: TextStyle(fontSize: 34, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요! \n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(color: BODY_TEXT_COLOR, fontSize: 16),
    );
  }
}

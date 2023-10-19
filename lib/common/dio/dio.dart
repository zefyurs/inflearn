import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inflearn/common/const/data.dart';
import 'package:inflearn/common/secure_storage/secure_storage.dart';

// * Custominterceptor가 반영된 dio를 return 해주는 provider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);
  dio.interceptors.add(CustomInterceptor(storage: storage));

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  CustomInterceptor({required this.storage});
  // 1) 요청을 받을떄
  // 요청을 받을때마다 accessToken이 true인지 확인하고 true이면 accessToken을 header에 넣어준다.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    return super.onRequest(options, handler);
  }

// 2) 응답을 받을떄
  @override
  void onResponse(Response responce, ResponseInterceptorHandler handler) {
    print('[RES] [${responce.requestOptions.method}] ${responce.requestOptions.uri}');

    return super.onResponse(responce, handler);
  }

// 3) 에러가 났을떄
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러가 났을때
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
    // 1) refreshToken을 사용해서 accessToken을 재발급 받는다.

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken  null이면 에러를 던진다.

    if (refreshToken == null) {
      // 에러를 던질떄는 handler.reject를 사용한다
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token'; // refreshToken 에 문제가 있다는 말

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        // 토큰 재발급
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(headers: {'authorization': 'Bearer $refreshToken'}),
        );

        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;

        // 토큰 변경하기
        options.headers.addAll(
          {'authorization': 'Bearer $accessToken'},
        );

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 요청 재전송
        final response = await dio.fetch(options);
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.reject(e);
      }
    }
  }
}

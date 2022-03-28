import 'dart:convert';
import 'dart:io';

enum ApiClientExeptionType { Network, Auth, Other }

class ApiClientExeption implements Exception {
  final ApiClientExeptionType type;
  ApiClientExeption(this.type);
}

class ApiClient {
  final _client = HttpClient();
  static const _host = 'https://api.themoviedb.org/3';
  static const _imageUrl = 'https:/image.tmdb.org/t/p/w500';
  static const _apiKey = 'e3a3e7ba78d2df48176a4571fc568f2f';

  Future<String> auth({
    required String username,
    required String password,
  }) async {
    final token = await _makeToken();
    final validToken = await _validateUser(
        username: username, password: password, requestToken: token);
    final sessionId = await _makeSession(requestToken: validToken);
    return sessionId;
  }

  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('$_host$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  Future<T> _get<T>(String path, T Function(dynamic json) parser,
      [Map<String, dynamic>? parameters]) async {
    final url = _makeUri(path, parameters);
    try {
      final request = await _client.getUrl(url);
      final response = await request.close();
      final dynamic json = (await response.jsonDecode());
      _validateResponse(response, json);

      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientExeption(ApiClientExeptionType.Network);
    } on ApiClientExeption {
      rethrow;
    } catch (_) {
      throw ApiClientExeption(ApiClientExeptionType.Other);
    }
  }

  Future<String> _makeToken() async {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String,dynamic>;
       final token = jsonMap['request_token'] as String;
    };
    final result = _get('/authentication/token/new', parser, <String, dynamic>{'api_key': _apiKey});
    return result;
   
    
  }

  Future<String> _validateUser(
      {required String username,
      required String password,
      required String requestToken}) async {
    try {
      final url = _makeUri('/authentication/token/validate_with_login',
          <String, dynamic>{'api_key': _apiKey});

      final parameters = <String, dynamic>{
        'username': username,
        'password': password,
        'request_token': requestToken,
      };
      final request = await _client.postUrl(url);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(parameters));
      final response = await request.close();
      final json = (await response.jsonDecode()) as Map<String, dynamic>;
      _validateResponse(response, json);

      final token = json['request_token'] as String;
      return token;
    } on SocketException {
      throw ApiClientExeption(ApiClientExeptionType.Network);
    } on ApiClientExeption {
      rethrow;
    } catch (_) {
      throw ApiClientExeption(ApiClientExeptionType.Other);
    }
  }

  Future<String> _makeSession({required String requestToken}) async {
    try {
      final url = _makeUri(
          '/authentication/session/new', <String, dynamic>{'api_key': _apiKey});

      final parameters = <String, dynamic>{
        'request_token': requestToken,
      };
      final request = await _client.postUrl(url);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(parameters));
      final response = await request.close();
      final json = (await response.jsonDecode()) as Map<String, dynamic>;
      _validateResponse(response, json);
      final sessionId = json['session_id'] as String;
      return sessionId;
    } on SocketException {
      throw ApiClientExeption(ApiClientExeptionType.Network);
    } on ApiClientExeption {
      rethrow;
    } catch (_) {
      throw ApiClientExeption(ApiClientExeptionType.Other);
    }
  }
}

extension HttpClientResponseJsonDecode on HttpClientResponse {
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder).toList().then((value) {
      final result = value.join();
      return result;
    }).then<dynamic>((v) => json.decode(v));
  }
}

void _validateResponse(HttpClientResponse response, dynamic json) {
  if (response.statusCode == 401) {
    final dynamic status = json['status_code'];
    final code = status is int ? status : 0;
    if (code == 30) {
      throw ApiClientExeption(ApiClientExeptionType.Auth);
    } else {
      throw ApiClientExeption(ApiClientExeptionType.Other);
    }
  }
}

// status_code:
// 30 - неверный логин пароль
// 7 - неверный api key
// 33 - неверный реквест токен
import 'dart:convert';
import 'dart:io';

enum ApiClientExeptionType { network, auth, other }

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

  Future<T> _get<T>(
    String path,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? parameters,
  ]) async {
    final url = _makeUri(path, parameters);
    try {
      final request = await _client.getUrl(url);
      final response = await request.close();
      final dynamic json = (await response.jsonDecode());
      _validateResponse(response, json);
      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientExeption(ApiClientExeptionType.network);
    } on ApiClientExeption {
      rethrow;
    } catch (_) {
      throw ApiClientExeption(ApiClientExeptionType.other);
    }
  }

  Future<T> _post<T>(
    String path,
    Map<String, dynamic> bodyparameters,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? urlparameters,
  ]) async {
    try {
      final url = _makeUri(path, urlparameters);

      final request = await _client.postUrl(url);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(bodyparameters));
      final response = await request.close();
      final dynamic json = (await response.jsonDecode());
      _validateResponse(response, json);

      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientExeption(ApiClientExeptionType.network);
    } on ApiClientExeption {
      rethrow;
    } catch (_) {
      throw ApiClientExeption(ApiClientExeptionType.other);
    }
  }

  Future<String> _makeToken() async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final result = _get('/authentication/token/new', parser,
        <String, dynamic>{'api_key': _apiKey});
    return result;
  }

  Future<dynamic> popularMovie(int page, String locale) async {
    parser(dynamic json) {
      // final jsonMap = json as Map<String, dynamic>;
      // final token = jsonMap['request_token'] as String;
      // return token;
      return json;
    }

    final result = _get<dynamic>('/movie/popular', parser, <String, dynamic>{
      'api_key': _apiKey,
      'page': page.toString(),
      'language': locale
    });
    return result;
  }

  Future<String> _validateUser(
      {required String username,
      required String password,
      required String requestToken}) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final parameters = <String, dynamic>{
      'username': username,
      'password': password,
      'request_token': requestToken,
    };
    final result = _post('/authentication/token/validate_with_login',
        parameters, parser, <String, dynamic>{'api_key': _apiKey});
    return result;
  }

  Future<String> _makeSession({required String requestToken}) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final sessionId = jsonMap['session_id'] as String;
      return sessionId;
    }

    final parameters = <String, dynamic>{
      'request_token': requestToken,
    };
    final result = _post('/authentication/session/new', parameters, parser,
        <String, dynamic>{'api_key': _apiKey});
    return result;
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
      throw ApiClientExeption(ApiClientExeptionType.auth);
    } else {
      throw ApiClientExeption(ApiClientExeptionType.other);
    }
  }
}

// status_code:
// 30 - неверный логин пароль
// 7 - неверный api key
// 33 - неверный реквест токен

//'/authentication/token/validate_with_login'

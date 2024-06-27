import 'dart:io';

import 'package:get/get.dart';

class CustomGetConnect extends GetConnect {
  final Map _cookies = {};

  Map<String, String> _getHeaders(String contentType) {
    Map<String, String> headers = {
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
      'Accept-Encoding': 'gzip, deflate, br, zstd',
      'Accept-Language':
          'ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7,zh-CN;q=0.6,zh-MO;q=0.5,zh;q=0.4',
      'Cache-Control': 'max-age=0',
      'Connection': 'keep-alive',
      'Content-Type': '$contentType',
      'Host': 'wmail.kw.ac.kr',
      'Origin': 'https://wmail.kw.ac.kr',
      'Referer': 'https://wmail.kw.ac.kr/index.html',
      'Sec-Ch-Ua':
          '"Not/A)Brand";v="8", "Chromium";v="126", "Google Chrome";v="126"',
      'Sec-Ch-Ua-Mobile': '?0',
      'Sec-Ch-Ua-Platform': '"macOS"',
      'Sec-Fetch-Dest': 'document',
      'Sec-Fetch-Mode': 'navigate',
      'Sec-Fetch-Site': 'same-origin',
      'Sec-Fetch-User': '?1',
      'Upgrade-Insecure-Requests': '1',
      'User-Agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36'
    };

    if (_cookies.isNotEmpty) {
      headers["Cookie"] =
          "${_cookies.entries.map((e) => '${e.key}=${e.value}').join("; ")};";
    }

    return headers;
  }

  void _saveCookies(String cookies) {
    cookies.split(";").forEach((element) {
      int index = element.indexOf("=");
      if (index == -1) return;

      List<String> tokens = element.split("=");
      String key = tokens[0].trim();
      String value = tokens[1].trim();
      _cookies[key] = value;
    });
  }

  void _saveCookiesFromHeader(Map<String, String>? headers) {
    if (headers == null) return;

    String? newCookie = headers[HttpHeaders.setCookieHeader];
    if (newCookie == null) return;

    newCookie = newCookie.replaceAll(",", ";");
    _saveCookies(newCookie);
  }

  String? getCookie(String key) {
    return _cookies[key];
  }

  @override
  Future<Response<T>> post<T>(String? url, body,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query,
      Decoder<T>? decoder,
      Progress? uploadProgress}) async {
    contentType ??= "application/json";
    headers = _getHeaders(contentType);

    Response<T> response = await super.post(url, body,
        contentType: contentType,
        headers: headers,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress);

    _saveCookiesFromHeader(response.headers);

    return response;
  }

  @override
  Future<Response<T>> get<T>(String url,
      {Map<String, String>? headers,
      String? contentType,
      Map<String, dynamic>? query,
      Decoder<T>? decoder}) async {
    contentType ??= "application/json";
    headers = _getHeaders(contentType);
    Response<T> response = await super.get(url,
        headers: headers,
        contentType: contentType,
        query: query,
        decoder: decoder);

    _saveCookiesFromHeader(response.headers);

    return response;
  }
}

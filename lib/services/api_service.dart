import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ApiService {
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
  
  // Basic Auth 헤더 생성 (모든 요청에 자동으로 포함)
  Map<String, String> get _defaultHeaders {
    final username = dotenv.env['API_BASE_AUTH_USERNAME'] ?? '';
    final password = dotenv.env['API_BASE_AUTH_PASSWORD'] ?? '';
    final credentials = base64Encode(utf8.encode('$username:$password'));
    
    return {
      'Authorization': 'Basic $credentials',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
  
  // GET 요청
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final fullUrl = '$baseUrl$endpoint';
      log('🌐 API 요청: $fullUrl');
      
      // 기본 헤더 + 추가 헤더 병합
      final requestHeaders = {..._defaultHeaders};
      if (headers != null) {
        requestHeaders.addAll(headers);
      }
      
      final response = await http.get(
        Uri.parse(fullUrl),
        headers: requestHeaders,
      );
      
      return _handleResponse(response);
    } catch (e) {
      log('GET 요청 실패: $e');
      rethrow;
    }
  }
  
  // POST 요청
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _defaultHeaders, // Basic Auth 자동 포함
        body: json.encode(data),
      );
      
      return _handleResponse(response);
    } catch (e) {
      print('POST 요청 실패: $e');
      rethrow;
    }
  }
  
  // PUT 요청
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _defaultHeaders, // Basic Auth 자동 포함
        body: json.encode(data),
      );
      
      return _handleResponse(response);
    } catch (e) {
      print('PUT 요청 실패: $e');
      rethrow;
    }
  }
  
  // DELETE 요청
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _defaultHeaders, // Basic Auth 자동 포함
      );
      
      return _handleResponse(response);
    } catch (e) {
      print('DELETE 요청 실패: $e');
      rethrow;
    }
  }
  
  // 응답 처리
  Map<String, dynamic> _handleResponse(http.Response response) {
    log('API 응답: ${response.statusCode}');
    log('응답 본문 타입: ${response.body.runtimeType}');
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {}; // 빈 응답 처리
      }
      
      try {
        // JSON 파싱 시도
        var decoded = json.decode(response.body);
        
        // String인 경우 한 번 더 파싱 (이중 인코딩된 JSON)
        if (decoded is String) {
          decoded = json.decode(decoded);
        }
        
        // 타입 안전한 변환
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else if (decoded is Map) {
          // Map이지만 다른 타입인 경우 변환
          return Map<String, dynamic>.from(decoded);
        } else {
          print('최종 예상하지 못한 응답 타입: ${decoded.runtimeType}');
          print('응답 내용: $decoded');
          throw Exception('예상하지 못한 응답 타입: ${decoded.runtimeType}');
        }
      } catch (e) {
        print('JSON 파싱 실패: $e');
        print('응답 본문: ${response.body.substring(0, 200)}...'); // 처음 200자만 로그
        throw Exception('JSON 파싱 실패: $e');
      }
    } else if (response.statusCode == 401) {
      throw Exception('인증 실패: 잘못된 사용자명 또는 비밀번호');
    } else if (response.statusCode == 403) {
      throw Exception('접근 권한 없음');
    } else if (response.statusCode == 404) {
      throw Exception('요청한 리소스를 찾을 수 없습니다');
    } else if (response.statusCode >= 500) {
      throw Exception('서버 오류: ${response.statusCode}');
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }
  
  // 커스텀 헤더와 함께 요청 (기본 헤더에 추가)
  Future<Map<String, dynamic>> getWithCustomHeaders(
    String endpoint, 
    Map<String, String> additionalHeaders
  ) async {
    try {
      final headers = {..._defaultHeaders, ...additionalHeaders};
      
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      
      return _handleResponse(response);
    } catch (e) {
      print('GET 요청 실패: $e');
      rethrow;
    }
  }
}
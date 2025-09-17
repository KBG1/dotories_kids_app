import 'dart:developer';
import 'dart:math' as math;
import './api_service.dart';
import '../models/cafe.dart';

class CafeService {
  final ApiService _api = ApiService();

  // 모든 카페 데이터 가져오기 (전체 페이지네이션)
  Future<List<Cafe>> getAllCafes() async {
    List<Cafe> allCafes = [];
    int currentPage = 0;
    bool hasNext = true;

    try {
      while (hasNext) {
        // 페이지 파라미터 추가해서 요청
        var response = await _api.get(
          '/cafe',
          headers: {'page': currentPage.toString()},
        );
        var cafeResponse = CafeResponse.fromJson(response);
        print(cafeResponse.hasNext);

        // 현재 페이지 카페들을 전체 리스트에 추가
        allCafes.addAll(cafeResponse.cafes);

        currentPage++;

        // 다음 페이지 존재 여부 확인
        hasNext = cafeResponse.hasNext;
      }

      print('✅ 총 ${allCafes.length}개의 카페 데이터 로드 완료!');
      return allCafes;
    } catch (e) {
      log('카페 데이터 로드 실패: $e');
      throw Exception('카페 데이터를 불러올 수 없습니다: $e');
    }
  }

  // 현재 위치에서 가까운 카페들 필터링 (거리순 정렬, 개수 제한)
  List<Cafe> getNearbycafes(
    List<Cafe> allCafes,
    double currentLat,
    double currentLng, {
    double radiusKm = 10.0,
    int limit = 10,
  }) {
    List<CafeWithDistance> cafesWithDistance = [];

    for (Cafe cafe in allCafes) {
      double distance = _calculateDistance(
        currentLat,
        currentLng,
        cafe.latitude,
        cafe.longitude,
      );

      // 지정된 반경 내의 카페만 포함
      if (distance <= radiusKm) {
        cafesWithDistance.add(CafeWithDistance(cafe, distance));
      }
    }

    // 거리순으로 정렬
    cafesWithDistance.sort((a, b) => a.distance.compareTo(b.distance));

    // 제한된 개수만 반환
    return cafesWithDistance
        .take(limit)
        .map((cafeWithDistance) => cafeWithDistance.cafe)
        .toList();
  }

  // 특정 카페 상세 정보 가져오기
  Future<Cafe> getCafeDetail(String cafeId) async {
    try {
      final response = await _api.get('/api/cafes/$cafeId');
      return Cafe.fromJson(response['cafe']);
    } catch (e) {
      log('카페 상세 정보 로드 실패: $e');
      throw Exception('카페 상세 정보를 불러올 수 없습니다: $e');
    }
  }

  // 카페 검색
  List<Cafe> searchCafes(List<Cafe> allCafes, String query) {
    if (query.isEmpty) return allCafes;

    final lowerQuery = query.toLowerCase();
    return allCafes.where((cafe) {
      return cafe.name.toLowerCase().contains(lowerQuery) ||
          cafe.address.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // 두 좌표 간의 거리 계산 (Haversine 공식, km 단위)
  double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const double earthRadius = 6371; // Earth radius in kilometers
    final double dLat = _degToRad(lat2 - lat1);
    final double dLng = _degToRad(lng2 - lng1);

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degToRad(lat1)) *
            math.cos(_degToRad(lat2)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _degToRad(double deg) => deg * (math.pi / 180.0);

  // 거리 포맷팅 (km 또는 m 단위로 표시)
  String formatDistance(double distanceKm) {
    if (distanceKm < 1.0) {
      return '${(distanceKm * 1000).round()}m';
    } else {
      return '${distanceKm.toStringAsFixed(1)}km';
    }
  }
}

// 카페와 거리를 함께 저장하는 헬퍼 클래스
class CafeWithDistance {
  final Cafe cafe;
  final double distance;

  CafeWithDistance(this.cafe, this.distance);
}

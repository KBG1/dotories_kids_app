import 'dart:developer';
import 'dart:math' as math;
import 'package:get/get.dart';
import '../models/cafe.dart';
import '../services/cafe_service.dart';

class CafeController extends GetxController {
  final CafeService _cafeService = CafeService();
  
  // 상태 변수들
  var allCafes = <Cafe>[].obs; // 모든 카페 데이터
  var nearbyCafes = <Cafe>[].obs; // 현재 위치 주변 카페들 (지도에 표시될 카페들)
  var selectedCafe = Rxn<Cafe>(); // 선택된 카페 (마커 클릭 시)
  var isLoading = false.obs;
  var isLoadingNearby = false.obs;
  var errorMessage = ''.obs;
  
  // 현재 위치 정보
  var currentLatitude = 0.0.obs;
  var currentLongitude = 0.0.obs;
  var searchRadius = 10.0.obs; // 현재 검색 반경
  
  @override
  void onInit() {
    super.onInit();
    log('CafeController 초기화됨');
    // 페이지 진입 시 모든 카페 데이터 로드
    loadAllCafes();
  }
  
  // 1단계: 모든 카페 데이터 로드 (페이지 진입 시)
  Future<void> loadAllCafes() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      log('모든 카페 데이터 로드 시작...');
      final cafes = await _cafeService.getAllCafes();
      allCafes.value = cafes;
      
      log('✅ 총 ${cafes.length}개의 카페 데이터 로드 완료');
      print('📊 카페 데이터 로드 완료: ${cafes.length}개');
      
    } catch (e) {
      errorMessage.value = '카페 데이터를 불러올 수 없습니다';
      log('카페 데이터 로드 실패: $e');
      // Snackbar 임시 제거 (GetX 초기화 문제로 인한 에러 방지)
      print('🔥 API 에러: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // 2단계: 현재 위치 기반으로 주변 카페 필터링 (지도 준비 후)
  void updateNearbycafes(double latitude, double longitude) {
    try {
      isLoadingNearby.value = true;
      currentLatitude.value = latitude;
      currentLongitude.value = longitude;
      
      log('현재 위치: $latitude, $longitude');
      log('주변 카페 필터링 시작... (총 ${allCafes.length}개 카페 중)');
      
      // 반경을 점점 늘려가며 카페 검색 (10km → 20km → 30km → 40km)
      List<Cafe> nearby = [];
      final radiusList = [10.0, 20.0, 30.0, 40.0];
      
      // searchRadius 초기화
      searchRadius.value = 0.0;
      
      for (final radius in radiusList) {
        nearby = _cafeService.getNearbycafes(
          allCafes.toList(),
          latitude,
          longitude,
          radiusKm: radius,
          limit: radius.toInt(),
        );
        
        log('${radius}km 반경에서 ${nearby.length}개 카페 발견');
        
        // 카페가 1개 이상 발견되면 검색 중단
        if (nearby.isNotEmpty) {
          searchRadius.value = radius; // 사용된 반경 저장
          log('${radius}km 반경에서 검색 완료');
          break;
        }
      }
      
      // 40km까지 검색했는데도 카페가 없으면
      if (nearby.isEmpty) {
        searchRadius.value = 40.0;
        log('40km 반경에서도 카페를 찾을 수 없습니다');
      }
      
      nearbyCafes.value = nearby;
      log('주변 카페 ${nearby.length}개 필터링 완료');
      
      // 선택된 카페 초기화
      selectedCafe.value = null;
      
    } catch (e) {
      log('주변 카페 필터링 실패: $e');
    } finally {
      isLoadingNearby.value = false;
    }
  }
  
  // 3단계: 마커 클릭 시 카페 선택
  void selectCafe(String cafeId) {
    try {
      final cafe = nearbyCafes.firstWhere((cafe) => cafe.id == cafeId);
      selectedCafe.value = cafe;
      print('카페 선택됨: ${cafe.name}');
    } catch (e) {
      print('카페 선택 실패: $e');
    }
  }
  
  // 카페 검색 (이름, 주소 포함 검색)
  void searchCafes(String query) {
    if (query.isEmpty) {
      // 검색어가 없으면 현재 위치 기반 주변 카페로 복원
      if (currentLatitude.value != 0.0 && currentLongitude.value != 0.0) {
        updateNearbycafes(currentLatitude.value, currentLongitude.value);
      }
    } else {
      // 검색 결과로 필터링 (이름, 주소에서 검색)
      final searchResults = _searchCafesByNameAndAddress(query);
      nearbyCafes.value = searchResults.take(20).toList(); // 최대 20개 표시
      selectedCafe.value = null; // 선택 초기화
      log('검색 결과: ${searchResults.length}개 카페');
    }
  }
  
  // 카페 이름과 주소에서 검색어 포함 검색
  List<Cafe> _searchCafesByNameAndAddress(String query) {
    if (query.isEmpty) return [];
    
    final lowercaseQuery = query.toLowerCase();
    
    final searchResults = allCafes.where((cafe) {
      // 카페 이름에서 검색
      final nameMatch = cafe.name.toLowerCase().contains(lowercaseQuery);
      
      // 카페 주소에서 검색
      final addressMatch = cafe.address.toLowerCase().contains(lowercaseQuery);
      
      return nameMatch || addressMatch;
    }).toList();
    
    // 현재 위치가 있으면 거리 기준으로 정렬
    if (currentLatitude.value != 0.0 && currentLongitude.value != 0.0) {
      return _sortCafesByDistance(searchResults);
    }
    
    return searchResults;
  }
  
  // 카페들을 현재 위치 기준으로 거리 순 정렬
  List<Cafe> _sortCafesByDistance(List<Cafe> cafes) {
    return _cafeService.getNearbycafes(
      cafes,
      currentLatitude.value,
      currentLongitude.value,
      radiusKm: 1000, // 충분히 큰 값으로 설정
      limit: cafes.length, // 모든 검색 결과 포함
    );
  }
  
  // 카페와 현재 위치 간의 거리 반환 (private 메서드 직접 호출 대신 public 메서드 사용)
  String getDistanceText(Cafe cafe) {
    if (currentLatitude.value == 0.0 || currentLongitude.value == 0.0) {
      return '';
    }
    
    // CafeService의 public 메서드를 통해 거리 계산
    final cafesWithDistance = _cafeService.getNearbycafes(
      [cafe],
      currentLatitude.value,
      currentLongitude.value,
      radiusKm: 1000, // 충분히 큰 값으로 설정
      limit: 1,
    );
    
    if (cafesWithDistance.isEmpty) return '';
    
    // 거리를 직접 계산하여 포맷팅
    const double earthRadius = 6371; // km
    final double lat1Rad = currentLatitude.value * (3.14159 / 180);
    final double lat2Rad = cafe.latitude * (3.14159 / 180);
    final double deltaLatRad = (cafe.latitude - currentLatitude.value) * (3.14159 / 180);
    final double deltaLngRad = (cafe.longitude - currentLongitude.value) * (3.14159 / 180);
    
    final double a = math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
        math.cos(lat1Rad) * math.cos(lat2Rad) *
        math.sin(deltaLngRad / 2) * math.sin(deltaLngRad / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final double distance = earthRadius * c;
    
    return _cafeService.formatDistance(distance);
  }
  
  // 상태 초기화
  void reset() {
    allCafes.clear();
    nearbyCafes.clear();
    selectedCafe.value = null;
    currentLatitude.value = 0.0;
    currentLongitude.value = 0.0;
    isLoading.value = false;
    isLoadingNearby.value = false;
    errorMessage.value = '';
  }
}

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../theme/app_theme.dart';
import 'cafe_detail.dart';
import 'package:get/get.dart';
import '../controllers/location_controller.dart';
import '../controllers/cafe_controller.dart';
import '../models/cafe.dart';

class KidsCafePage extends StatefulWidget {
  const KidsCafePage({super.key});

  @override
  State<KidsCafePage> createState() => _KidsCafePageState();
}

class _KidsCafePageState extends State<KidsCafePage> {
  late DraggableScrollableController _dragController;
  final LocationController locationController = Get.put(LocationController());
  final CafeController cafeController = Get.put(CafeController());
  NaverMapController? mapController;
  DateTime? _lastCameraUpdateAt;
  double? _lastLat;
  double? _lastLng;
  Set<String> _currentMarkerIds = {}; // 현재 표시된 마커 ID들
  Map<String, NMarker> _currentMarkers = {}; // 현재 표시된 마커들
  NInfoWindow? _openedInfoWindow;
  String? _openedInfoWindowMarkerId;

  // 현재 지도 중앙 좌표 저장
  NLatLng? _currentMapCenter;

  @override
  void initState() {
    super.initState();
    print('🔥 KidsCafePage initState 시작'); // print로 변경
    _dragController = DraggableScrollableController();

    try {
      // CafeController 강제 초기화 테스트
      print('🔥 CafeController 타입: ${cafeController.runtimeType}');
      print('🔥 CafeController 해시: ${cafeController.hashCode}');

      // 직접 호출 테스트
      cafeController.loadAllCafes();
      print('🔥 loadAllCafes 호출 완료');
    } catch (e) {
      print('🔥 CafeController 에러: $e');
    }

    // 첫 위치 요청
    _requestLocationAndUpdateMap();

    // 위치 변경을 디바운스하여 카메라 업데이트 과도 호출 방지
    debounce(
      locationController.latitude,
      (_) => _updateMapCameraAndLocation(),
      time: const Duration(milliseconds: 1000),
    );
    debounce(
      locationController.longitude,
      (_) => _updateMapCameraAndLocation(),
      time: const Duration(milliseconds: 1000),
    );
  }

  Future<void> _requestLocationAndUpdateMap() async {
    await locationController.getCurrentPosition();

    // 위치를 가져온 후 지도 업데이트 (지연 없이 즉시 실행)
    if (locationController.hasLocation) {
      _updateMapCameraAndLocation();
    }
  }

  void _updateMapCameraAndLocation() async {
    if (mapController != null && locationController.hasLocation) {
      final double newLat = locationController.latitudeDouble;
      final double newLng = locationController.longitudeDouble;
      final DateTime now = DateTime.now();

      // 시간 스로틀: 최소 1초 간격
      if (_lastCameraUpdateAt != null &&
          now.difference(_lastCameraUpdateAt!).inMilliseconds < 1000) {
        return;
      }

      // 거리 스로틀: 10m 이상 이동시에만
      if (_lastLat != null && _lastLng != null) {
        final double movedMeters = _distanceMeters(
          _lastLat!,
          _lastLng!,
          newLat,
          newLng,
        );
        if (movedMeters < 10) {
          return;
        }
      }

      _lastLat = newLat;
      _lastLng = newLng;
      _lastCameraUpdateAt = now;

      await mapController!.updateCamera(
        NCameraUpdate.scrollAndZoomTo(
          target: NLatLng(newLat, newLng),
          zoom: 18,
        ),
      );

      // 위치가 업데이트되면 주변 카페 마커 업데이트
      _updateNearbyMarkers(newLat, newLng);
    }
  }

  // 주변 카페 마커 업데이트
  void _updateNearbyMarkers(double lat, double lng) {
    // CafeController에 현재 위치 업데이트 및 주변 카페 필터링 요청
    cafeController.updateNearbycafes(lat, lng);

    // 마커 업데이트 (Reactive하게 처리하기 위해 ever 사용)
    ever(cafeController.nearbyCafes, (List<Cafe> cafes) {
      _updateMapMarkers(cafes);
    });
  }

  // 지도에 마커 업데이트
  Future<void> _updateMapMarkers(List<Cafe> cafes) async {
    if (mapController == null) return;

    try {
      // 새로운 마커 ID들
      Set<String> newMarkerIds = cafes.map((cafe) => cafe.id).toSet();

      // 제거할 마커들 (현재 표시된 것 중 새 목록에 없는 것)
      Set<String> toRemove = _currentMarkerIds.difference(newMarkerIds);

      // 추가할 마커들 (새 목록 중 현재 표시되지 않은 것)
      Set<String> toAdd = newMarkerIds.difference(_currentMarkerIds);

      for (String markerId in toRemove) {
        final marker = _currentMarkers[markerId];
        if (marker != null) {
          // 만약 이 마커에 연 정보창이 열려있다면 먼저 닫아준다
          if (_openedInfoWindowMarkerId == markerId) {
            try {
              // InfoWindow 자체에 close()가 있으면 호출
              _openedInfoWindow?.close();
            } catch (e) {
              // close()가 없거나 실패하면 안전하게 시도해보기
              try {
                // 마커에 연결된 info 오버레이를 삭제 (플러그인 API 사용)
                await mapController!.deleteOverlay(marker.info);
              } catch (e2) {
                print('InfoWindow 닫기/삭제 시도 실패: $e2');
              }
            }
            _openedInfoWindow = null;
            _openedInfoWindowMarkerId = null;
          }

          // 마커 자체 삭제
          try {
            await mapController!.deleteOverlay(marker.info);
          } catch (e) {
            print('마커 삭제 실패 (id=$markerId): $e');
          }
          _currentMarkers.remove(markerId);
        }
      }

      // 마커 추가
      for (String markerId in toAdd) {
        Cafe cafe = cafes.firstWhere((c) => c.id == markerId);
        final marker =
            NMarker(
              id: markerId,
              position: NLatLng(cafe.latitude, cafe.longitude),
              caption: NOverlayCaption(text: cafe.name),
              size: const Size(30, 30),
            )..setOnTapListener((overlay) {
              _onMarkerTap(cafe);
            });

        await mapController!.addOverlay(marker);
        _currentMarkers[markerId] = marker;
      }

      // 현재 마커 ID 목록 업데이트
      _currentMarkerIds = newMarkerIds;
    } catch (e) {
      print('마커 업데이트 실패: $e');
    }
  }

  void _onMarkerTap(Cafe cafe) {
    cafeController.selectCafe(cafe.id);

    final markerId = cafe.id;
    final marker = _currentMarkers[markerId];

    if (marker == null || mapController == null) return;

    // 같은 마커를 다시 탭하면 토글로 닫기
    if (_openedInfoWindowMarkerId == markerId) {
      try {
        _openedInfoWindow?.close();
      } catch (e) {
        // close()가 없으면 마커의 info 오버레이 삭제 시도
        try {
          mapController!.deleteOverlay(marker.info);
        } catch (e2) {
          print('InfoWindow 닫기 실패: $e2');
        }
      }

      // 마커 크기를 원래대로 되돌리기
      marker.setSize(const Size(30, 30));

      _openedInfoWindow = null;
      _openedInfoWindowMarkerId = null;
      return;
    }

    // 이전에 열려있던 info 창 닫기
    if (_openedInfoWindow != null) {
      try {
        _openedInfoWindow!.close();
      } catch (e) {
        print('InfoWindow 닫기 실패: $e');
      }

      // 이전 마커 크기를 원래대로 되돌리기
      if (_openedInfoWindowMarkerId != null) {
        final prevMarker = _currentMarkers[_openedInfoWindowMarkerId];
        if (prevMarker != null) {
          prevMarker.setSize(const Size(30, 30));
        }
      }

      _openedInfoWindow = null;
      _openedInfoWindowMarkerId = null;
    }

    // 새로운 InfoWindow 생성 및 오픈
    final infoWindow = NInfoWindow.onMarker(
      id: 'info_${cafe.id}', // 가능하면 고유 id 사용
      text: '${cafe.name}\n${cafe.address}',
    );

    // 선택된 마커를 크게 만들기
    marker.setSize(const Size(40, 40));
    marker.openInfoWindow(infoWindow);

    _openedInfoWindow = infoWindow;
    _openedInfoWindowMarkerId = markerId;
  }

  // 현재 지도 중앙 기준으로 카페 검색
  void _searchCafesAtCurrentCenter() async {
    if (_currentMapCenter == null) {
      print('❌ 현재 지도 중앙 좌표가 없습니다');
      return;
    }

    print(
      '🔍 현재 지도 중앙 기준 카페 검색 시작: ${_currentMapCenter!.latitude}, ${_currentMapCenter!.longitude}',
    );

    try {
      // 현재 지도 중앙 좌표 기준으로 10km 이내 카페 검색
      cafeController.updateNearbycafes(
        _currentMapCenter!.latitude,
        _currentMapCenter!.longitude,
      );

      // 검색 완료 후 nearbyCafes 업데이트
      final nearbyCafes = cafeController.nearbyCafes.toList();
      print('✅ 검색된 카페 수: ${nearbyCafes.length}');

      // 지도 마커 업데이트
      _updateMapMarkers(nearbyCafes);

      // 검색 결과 메시지 표시
      final radius = cafeController.searchRadius.value;
      final count = nearbyCafes.length;

      String message;
      if (count == 0) {
        message = '카페를 찾을 수 없습니다';
      } else {
        message = '${radius.toInt()}km 반경에서 ${count}개의 카페를 찾았습니다!';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          backgroundColor: count == 0 ? Colors.orange : Colors.green,
        ),
      );
    } catch (e) {
      print('❌ 카페 검색 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('카페 검색에 실패했습니다'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 해당 카페 위치로 지도 이동
  void _moveToCafeLocation(Cafe cafe) async {
    if (mapController == null) return;

    try {
      // DraggableScrollableSheet를 낮춤으로 지도를 더 잘 보이게 하기
      _dragController.animateTo(
        0.35, // minChildSize로 낮춤
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );

      // 카페 위치로 지도 이동
      await mapController!.updateCamera(
        NCameraUpdate.withParams(
          target: NLatLng(cafe.latitude, cafe.longitude),
          zoom: 16, // 적당한 줌 레벨
        ),
      );

      // 현재 지도 중앙 좌표 업데이트 (거리 계산용)
      _currentMapCenter = NLatLng(cafe.latitude, cafe.longitude);

      // 거리 갱신은 하지 않고, 지도만 이동

      print('📍 카페 위치로 이동: ${cafe.name} (${cafe.latitude}, ${cafe.longitude})');
    } catch (e) {
      print('❌ 지도 이동 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('지도 이동에 실패했습니다'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Haversine 근사 계산 (미터)
  double _distanceMeters(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // meters
    final double dLat = _degToRad(lat2 - lat1);
    final double dLon = _degToRad(lon2 - lon1);
    final double a =
        (math.sin(dLat / 2) * math.sin(dLat / 2)) +
        math.cos(_degToRad(lat1)) *
            math.cos(_degToRad(lat2)) *
            (math.sin(dLon / 2) * math.sin(dLon / 2));
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _degToRad(double deg) => deg * (3.141592653589793 / 180.0);

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 화면 크기 가져오기
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드가 올라와도 레이아웃 유지
      body: Container(
        width: screenWidth,
        height: screenHeight,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 메인 콘텐츠 (뒤로가기, 검색바, 지도)
              Column(
                children: [
                  // 상단 뒤로가기 버튼
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: const Icon(
                              Icons.arrow_back,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 검색바
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                      ),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFD9D9D9),
                          ),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                // 실시간 검색
                                cafeController.searchCafes(value);
                              },
                              decoration: InputDecoration(
                                hintText: '카페 이름 또는 주소를 입력하세요.',
                                hintStyle: TextStyle(
                                  color: const Color(0xFFB3B3B3),
                                  fontSize: screenWidth * 0.04,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.search,
                            size: screenWidth * 0.04,
                            color: const Color(0xFFB3B3B3),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 네이버 지도 영역
                  Container(
                    height: screenHeight * 0.5,
                    margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        NaverMap(
                          options: NaverMapViewOptions(
                            locationButtonEnable: true,
                            initialCameraPosition: NCameraPosition(
                              target: NLatLng(
                                locationController.latitudeDouble,
                                locationController.longitudeDouble,
                              ),
                              zoom: locationController.hasLocation ? 17 : 10,
                            ),
                            mapType: NMapType.basic,
                            activeLayerGroups: [
                              NLayerGroup.building,
                              NLayerGroup.transit,
                            ],
                          ),
                          onCameraChange: (reason, isGesture) {
                            // 지도 이동 시 현재 중앙 좌표 저장
                            mapController?.getCameraPosition().then((position) {
                              _currentMapCenter = position.target;
                            });
                          },
                          onMapReady: (controller) async {
                            mapController = controller;

                            // 초기 중앙 좌표 설정
                            _currentMapCenter = NLatLng(
                              locationController.latitudeDouble,
                              locationController.longitudeDouble,
                            );

                            // 지도가 준비되면 현재 위치로 이동 및 현위치 표시 (위치가 있는 경우)
                            if (locationController.hasLocation) {
                              _updateMapCameraAndLocation();
                            } else {
                              // 위치가 없어도 현위치 버튼 활성화를 위해 기본 설정
                              mapController!.setLocationTrackingMode(
                                NLocationTrackingMode.follow,
                              );
                            }

                            // 초기 마커 설정 (위치가 있는 경우)
                            if (locationController.hasLocation) {
                              _updateNearbyMarkers(
                                locationController.latitudeDouble,
                                locationController.longitudeDouble,
                              );
                            }
                          },
                          onMapTapped: (point, latLng) {
                            // InfoWindow 닫기
                            _openedInfoWindow?.close();

                            // 마커 크기를 원래대로 되돌리기
                            if (_openedInfoWindowMarkerId != null) {
                              final prevMarker =
                                  _currentMarkers[_openedInfoWindowMarkerId];
                              if (prevMarker != null) {
                                prevMarker.setSize(const Size(30, 30));
                              }
                            }

                            _openedInfoWindow = null;
                            _openedInfoWindowMarkerId = null;
                          },
                        ),

                        // 돋보기 버튼 (현위치 버튼 옆)
                        Positioned(
                          left: 65,
                          bottom: 45, // 현위치 버튼 위에 배치
                          child: GestureDetector(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                overlayColor:
                                    WidgetStateProperty.resolveWith<Color?>((
                                      Set<WidgetState> states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.hovered,
                                      )) {
                                        return Colors.grey.withValues(
                                          alpha: 0.2,
                                        ); // hover 시
                                      }
                                      if (states.contains(
                                        WidgetState.pressed,
                                      )) {
                                        return Colors.grey.withValues(
                                          alpha: 0.3,
                                        ); // 클릭 시
                                      }
                                      return null; // 기본값
                                    }),
                                onTap: () {
                                  _searchCafesAtCurrentCenter();
                                },
                                child: Ink(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.2,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.search_outlined,
                                    color: AppColors.textDark,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // DraggableScrollableSheet를 Stack 안에 배치
              DraggableScrollableSheet(
                controller: _dragController, // 컨트롤러 연결
                initialChildSize: 0.3, // 초기 크기 (화면의 30%)
                minChildSize: 0.25, // 최소 크기 (화면의 25%)
                maxChildSize: 0.85, // 최대 크기 (화면의 85%)
                builder: (context, scrollController) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: const Border(
                        top: BorderSide(width: 1, color: Color(0xFF333333)),
                        left: BorderSide(width: 1, color: Color(0xFF333333)),
                        right: BorderSide(width: 1, color: Color(0xFF333333)),
                        bottom: BorderSide.none,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      children: [
                        // 상단 인디케이터와 카페 개수 (전체 영역이 드래그 핸들)
                        Flexible(
                          flex: 0, // 최소 크기만 차지
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              // 위로 드래그할 때 DraggableScrollableSheet 확장
                              if (details.delta.dy < 0) {
                                double currentSize = _dragController.size;
                                double newSize =
                                    (currentSize + (-details.delta.dy / 500))
                                        .clamp(0.25, 0.85);
                                _dragController.animateTo(
                                  newSize,
                                  duration: const Duration(milliseconds: 50),
                                  curve: Curves.linear,
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // 드래그 인디케이터
                                  Container(
                                    width: 32,
                                    height: 4,
                                    decoration: ShapeDecoration(
                                      color: AppColors.main,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // 카페 개수 (실제 데이터 반영)
                                  Row(
                                    children: [
                                      Obx(
                                        () => Text(
                                          '${cafeController.nearbyCafes.length}개의 카페',
                                          style: AppTextStyles.subText.copyWith(
                                            color: AppColors.textDark,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // 카페 목록 (스크롤 가능) - 하단 패딩 추가
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              screenWidth * 0.04,
                              0,
                              screenWidth * 0.04,
                              MediaQuery.of(context).padding.bottom +
                                  20, // 네비게이션바 + 여유공간
                            ),
                            child: Obx(() {
                              if (cafeController.isLoading.value) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (cafeController.nearbyCafes.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.store_outlined,
                                        size: 48,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        '주변에 키즈카페가 없습니다',
                                        style: AppTextStyles.subText.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return ListView.separated(
                                controller: scrollController,
                                itemCount: cafeController.nearbyCafes.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) => _buildCafeItem(
                                  screenWidth,
                                  cafeController.nearbyCafes[index],
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCafeItem(double screenWidth, Cafe cafe) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Obx(
        () => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 2,
                color: cafeController.selectedCafe.value?.id == cafe.id
                    ? AppColors.main.withValues(alpha: 0.8)
                    : AppColors.main,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            children: [
              // 카페 이미지
              Container(
                width: 84,
                height: 84,
                decoration: ShapeDecoration(
                  color: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: cafe.imageUrl != null && cafe.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          cafe.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.store,
                            size: 40,
                            color: AppColors.textSub,
                          ),
                        ),
                      )
                    : Icon(Icons.store, size: 40, color: AppColors.textSub),
              ),

              const SizedBox(width: 12),

              // 카페 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            cafe.name,
                            style: AppTextStyles.subText.copyWith(
                              color: AppColors.textDark,
                              fontSize: screenWidth * 0.045,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // 거리 표시
                        Text(
                          cafeController.getDistanceText(cafe),
                          style: AppTextStyles.description.copyWith(
                            color: AppColors.main,
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      cafe.address,
                      style: AppTextStyles.description.copyWith(
                        color: const Color(0xFF9B9B9B),
                        fontSize: screenWidth * 0.035,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 평점 표시
                        if (cafe.rating != null)
                          Row(
                            children: [
                              Icon(Icons.star, size: 16, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                cafe.rating!.toStringAsFixed(1),
                                style: AppTextStyles.description.copyWith(
                                  color: const Color(0xFF9B9B9B),
                                  fontSize: screenWidth * 0.03,
                                ),
                              ),
                            ],
                          )
                        else
                          const SizedBox.shrink(),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: ShapeDecoration(
                            color: AppColors.main,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              cafeController.selectCafe(cafe.id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CafeDetailPage(),
                                ),
                              );
                            },
                            child: Text(
                              '상세 보기',
                              style: AppTextStyles.description.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth * 0.03,
                              ),
                            ),
                          ),
                        ),
                        // 지도에서 보기 버튼
                        GestureDetector(
                          onTap: () {
                            // 해당 카페 위치로 지도 이동
                            _moveToCafeLocation(cafe);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: ShapeDecoration(
                              color: AppColors.main,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text(
                              '지도에서 보기',
                              style: AppTextStyles.description.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth * 0.03,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

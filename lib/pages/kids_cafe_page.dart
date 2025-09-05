import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../theme/app_theme.dart';

class KidsCafePage extends StatefulWidget {
  const KidsCafePage({super.key});

  @override
  State<KidsCafePage> createState() => _KidsCafePageState();
}

class _KidsCafePageState extends State<KidsCafePage> {
  late DraggableScrollableController _dragController;

  @override
  void initState() {
    super.initState();
    _dragController = DraggableScrollableController();
  }

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
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                          decoration: InputDecoration(
                            hintText: '카페 이름을 입력하세요.',
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
                height: screenHeight * 0.5, // 화면 높이의 50% 고정
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: NaverMap(
                  options: NaverMapViewOptions(
                    initialCameraPosition: NCameraPosition(
                      target: NLatLng(37.5666102, 126.9783881), // 서울 중심
                      zoom: 10,
                    ),
                    mapType: NMapType.basic,
                    activeLayerGroups: [NLayerGroup.building, NLayerGroup.transit],
                  ),
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
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: const Border(
                        top: BorderSide(width: 4, color: Color(0xFF333333)),
                        left: BorderSide(width: 4, color: Color(0xFF333333)),
                        right: BorderSide(width: 4, color: Color(0xFF333333)),
                        bottom: BorderSide.none, // 아래쪽 border 제거
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
                                double newSize = (currentSize + (-details.delta.dy / 500)).clamp(0.25, 0.85);
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
                                  
                                  // 카페 개수
                                  Row(
                                    children: [
                                      Text(
                                        '279개의 카페',
                                        style: AppTextStyles.subText.copyWith(
                                          color: AppColors.textDark,
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
                              MediaQuery.of(context).padding.bottom + 20, // 네비게이션바 + 여유공간
                            ),
                            child: ListView.separated(
                              controller: scrollController, // DraggableScrollableSheet의 컨트롤러 연결
                              itemCount: 10, // 예시로 10개 아이템
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) => _buildCafeItem(screenWidth),
                            ),
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

  Widget _buildCafeItem(double screenWidth) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: AppColors.main,
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
            child: Icon(
              Icons.store,
              size: 40,
              color: AppColors.textSub,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // 카페 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '제니스 키즈카페 신영통점',
                  style: AppTextStyles.subText.copyWith(
                    color: AppColors.textDark,
                    fontSize: screenWidth * 0.045,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  '경기도 화성시 반월동 66-9 명성프라자 3층 303호',
                  style: AppTextStyles.description.copyWith(
                    color: const Color(0xFF9B9B9B),
                    fontSize: screenWidth * 0.035,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                // 지도에서 보기 버튼
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
                  child: Text(
                    '지도에서 보기',
                    style: AppTextStyles.description.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

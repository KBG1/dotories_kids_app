import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'kids_cafe_visit_detail.dart';

class VisitItemData {
  VisitItemData({
    required this.dateYmd,
    required this.cafeName,
    required this.address,
    required this.totalDurationText,
    required this.totalSteps,
    required this.childCount,
    required this.totalKcal,
    required this.avgBpm,
    required this.childName,
  });

  final String dateYmd;
  final String cafeName;
  final String address;
  final String totalDurationText;
  final int totalSteps;
  final int childCount;
  final int totalKcal;
  final int avgBpm;
  final String childName; // 리스트에서 보조 텍스트로 사용
}

class KidsCafeVisitListPage extends StatelessWidget {
  const KidsCafeVisitListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 방문기록 섹션과 동일한 스타일의 리스트를 8개 더미로
    final List<VisitItemData> items = List.generate(8, (i) {
      return VisitItemData(
        dateYmd: '2025.09.${(i + 1).toString().padLeft(2, '0')}',
        cafeName: i % 2 == 0 ? '제니스키즈카페 신영통점' : '숲속키즈카페 동탄점',
        address: i % 2 == 0
            ? '경기도 화성시 반월동 66-9 명성프라자 3층 303호'
            : '경기도 화성시 동탄순환대로 123',
        totalDurationText: i % 2 == 0
            ? '12:00 ~ 13:00 (1시간 0분)'
            : '15:20 ~ 16:10 (50분)',
        totalSteps: 3000 + i * 250,
        childCount: 1 + (i % 3),
        totalKcal: 600 + i * 40,
        avgBpm: 105 + (i % 12),
        childName: i % 2 == 0 ? '민수' : '민희',
      );
    });
    // 날짜 내림차순(최신이 위) 정렬
    items.sort((a, b) => _parseYmd(b.dateYmd).compareTo(_parseYmd(a.dateYmd)));

    return Scaffold(
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
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: screenWidth * 0.04,
            ),
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return _buildHeader(screenWidth, context);
              final item = items[index - 1];
              return Padding(
                padding: EdgeInsets.only(bottom: screenWidth * 0.04),
                child: _buildVisitCard(context, screenWidth, item),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: screenWidth * 0.05,
        top: screenWidth * 0.03,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.textDark,
              size: 28,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '방문 기록 전체',
                style: AppTextStyles.title.copyWith(
                  color: AppColors.textDark,
                  fontSize: screenWidth * 0.07,
                ),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.07),
        ],
      ),
    );
  }

  Widget _buildVisitCard(
    BuildContext context,
    double screenWidth,
    VisitItemData d,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const KidsCafeVisitDetailPage()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(screenWidth * 0.03),
        decoration: ShapeDecoration(
          color: AppColors.main, // 메인 컬러 배경으로 카드 영역 구분
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: AppColors.main),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            children: [
              // 상단: 카페명, 날짜
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      d.cafeName,
                      style: AppTextStyles.subText.copyWith(
                        color: AppColors.textMain,
                        fontSize: screenWidth * 0.045,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    d.dateYmd.substring(5), // MM.DD
                    style: AppTextStyles.description.copyWith(
                      color: AppColors.textMain,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenWidth * 0.03),
              // 아이 이름 태그
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenWidth * 0.01,
                    ),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: AppColors.main),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      d.childName,
                      style: AppTextStyles.description.copyWith(
                        color: AppColors.textMain,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenWidth * 0.03),
              // 하단: 활동 정보 (이모지 + 값) / 우측 시간
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _activityRow('🔥', '${d.totalKcal} Kcal', screenWidth),
                        SizedBox(height: screenWidth * 0.015),
                        _activityRow('👟', '${d.totalSteps} 걸음', screenWidth),
                        SizedBox(height: screenWidth * 0.015),
                        _activityRow('❤️‍🔥', '${d.avgBpm} bpm', screenWidth),
                      ],
                    ),
                  ),
                  Text(
                    _extractDuration(d.totalDurationText),
                    style: AppTextStyles.description.copyWith(
                      color: AppColors.textMain,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _activityRow(String emoji, String text, double screenWidth) {
    return Row(
      children: [
        Text(emoji, style: TextStyle(fontSize: screenWidth * 0.04)),
        SizedBox(width: screenWidth * 0.02),
        Text(
          text,
          style: AppTextStyles.description.copyWith(
            color: AppColors.textSub,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // "12:00 ~ 13:00 (1시간 0분)" 같은 문자열에서 괄호 안(총 소요시간)만 추출
  String _extractDuration(String src) {
    final match = RegExp(r'\(([^)]+)\)').firstMatch(src);
    return match?.group(1) ?? src;
  }
}

// 'YYYY.MM.DD' 문자열을 DateTime으로 파싱
DateTime _parseYmd(String ymd) {
  // 예: 2025.09.04 -> 2025-09-04
  final iso = ymd.replaceAll('.', '-');
  return DateTime.tryParse(iso) ?? DateTime.fromMillisecondsSinceEpoch(0);
}

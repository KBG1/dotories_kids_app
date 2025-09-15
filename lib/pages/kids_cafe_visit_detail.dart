import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class KidsCafeVisitDetailPage extends StatelessWidget {
  const KidsCafeVisitDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 뒤로가기
                Padding(
                  padding: EdgeInsets.only(top: screenWidth * 0.02),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: AppColors.textDark, size: 28),
                  ),
                ),
                SizedBox(height: screenWidth * 0.06),

                // 상단 흰 카드
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Color(0xFF333333)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '방문일',
                        style: AppTextStyles.description.copyWith(
                          color: AppColors.textMain,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '2025.09.04',
                                  style: AppTextStyles.description.copyWith(
                                    color: AppColors.textSub,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Expanded(
                                  child: Text(
                                    '제니스키즈카페 신영통점',
                                    style: AppTextStyles.subText.copyWith(
                                      color: const Color(0xFF333333),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Text(
                              '경기도 화성시 반월동 66-9 명성프라자 3층 303호',
                              style: AppTextStyles.description.copyWith(
                                color: AppColors.textSub,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenWidth * 0.04),

                // 초록 박스 1
                _greenStatBox(screenWidth,
                    duration: '1 시간', kcal: '955 kcal', steps: '4620 걸음', people: '2명', title: '민수 활동량'),
                SizedBox(height: screenWidth * 0.03),
                // 초록 박스 2
                _greenStatBox(screenWidth,
                    duration: '1 시간', kcal: '955 kcal', steps: '4620 걸음', people: '2명', title: '민희 활동량'),

                SizedBox(height: screenWidth * 0.03),
                // 하단 라인 카드
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.035),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Color(0xFF333333)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '민수의 활동',
                        style: AppTextStyles.subText.copyWith(
                          color: const Color(0xFF333333),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '12:00 ~ 13:00 (1시간 0분)',
                        style: AppTextStyles.description.copyWith(
                          color: AppColors.textSub,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.035),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Color(0xFF333333)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '민희의 활동',
                        style: AppTextStyles.subText.copyWith(
                          color: const Color(0xFF333333),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '12:00 ~ 13:00 (1시간 0분)',
                        style: AppTextStyles.description.copyWith(
                          color: AppColors.textSub,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenWidth * 0.06),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _greenStatBox(double screenWidth,
      {required String duration,
      required String kcal,
      required String steps,
      required String people,
      required String title}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenWidth * 0.04),
      decoration: ShapeDecoration(
        color: AppColors.main,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF333333)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.subText.copyWith(
              color: const Color(0xFF333333),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: screenWidth * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metric('총 활동시간', duration, true),
              _metric('소모 칼로리', kcal, true),
            ],
          ),
          SizedBox(height: screenWidth * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metric('총 걸음수', steps, true),
              _metric('방문 아이 수', people, true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value, bool white) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.description.copyWith(
            color: AppColors.textMain,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.subText.copyWith(
            color: white ? Colors.white : AppColors.textMain,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}



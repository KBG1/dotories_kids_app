import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';

class ChildDetailPage extends StatefulWidget {
  const ChildDetailPage({super.key});

  @override
  State<ChildDetailPage> createState() => _ChildDetailPageState();
}

class _ChildDetailPageState extends State<ChildDetailPage> {
  int? touchedBarIndex; // 터치된 막대 인덱스

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
          child: Column(
            children: [
              // 상단 헤더 (뒤로가기 + 제목)
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
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
                      child: Text(
                        '민수 상세',
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.textDark,
                          fontSize: screenWidth * 0.07,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 28), // 뒤로가기 버튼과 균형 맞추기
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 아이 정보 카드
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: ShapeDecoration(
                          color: AppColors.main.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: AppColors.main,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            // 아이 아이콘
                            Container(
                              width: 60,
                              height: 60,
                              decoration: const ShapeDecoration(
                                color: AppColors.main,
                                shape: CircleBorder(),
                              ),
                              child: const Icon(
                                Icons.child_care,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // 아이 정보
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '민수',
                                    style: AppTextStyles.title.copyWith(
                                      color: AppColors.textDark,
                                      fontSize: screenWidth * 0.07,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '7세 • 남자',
                                    style: AppTextStyles.subText.copyWith(
                                      color: AppColors.textSub,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 영양소 섹션
                      _buildNutritionSection(),

                      const SizedBox(height: 24),

                      // 발달 활동 통계 섹션
                      _buildDevelopmentSection(),

                      const SizedBox(height: 100), // 하단 여백
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 영양소 버튼들 (더미 데이터)
        ...[
              {
                'name': '총 칼로리',
                'value': 18261,
                'icon': Icons.local_fire_department,
              },
              {'name': '총 걸음수', 'value': 18446, 'icon': Icons.directions_walk},
              {'name': '평균 심박수', 'value': 124, 'icon': Icons.favorite},
            ]
            .map(
              (nutrition) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: ShapeDecoration(
                    color: AppColors.main,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        nutrition['icon'] as IconData,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          nutrition['name'] as String,
                          style: AppTextStyles.subText.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        nutrition['name'] == '총 칼로리'
                            ? '${nutrition['value']} Kcal'
                            : nutrition['name'] == '총 걸음수'
                            ? '${nutrition['value']} 걸음'
                            : '${nutrition['value']} bpm',
                        style: AppTextStyles.subText.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildDevelopmentSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: AppColors.main),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '월간 활동 통계',
            style: AppTextStyles.title.copyWith(
              color: AppColors.textDark,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '최근 6개월간 활동 데이터',
            style: AppTextStyles.description.copyWith(color: AppColors.textSub),
          ),
          const SizedBox(height: 20),

          // 칼로리 & 걸음수 막대 차트
          _buildCombinedBarChart(),
        ],
      ),
    );
  }

  Widget _buildCombinedBarChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 차트 제목과 범례
        Row(
          children: [
            Text(
              '월간 활동량',
              style: AppTextStyles.subText.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Spacer(),
            // 범례
            Row(
              children: [
                Container(width: 12, height: 12, color: AppColors.main),
                SizedBox(width: 4),
                Text('칼로리', style: AppTextStyles.description),
                SizedBox(width: 12),
                Container(width: 12, height: 12, color: Colors.blue),
                SizedBox(width: 4),
                Text('걸음수', style: AppTextStyles.description),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 터치된 막대의 정보 표시
        if (touchedBarIndex != null) ...[
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.main.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  _getMonthName(touchedBarIndex!),
                  style: AppTextStyles.subText.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${_getCalorieData()[touchedBarIndex!].y.toInt()} Kcal',
                        style: AppTextStyles.subText.copyWith(
                          color: AppColors.main,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('칼로리', style: AppTextStyles.description),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${(_getStepsData()[touchedBarIndex!].y * 1000).toInt()} 보',
                        style: AppTextStyles.subText.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('걸음 수', style: AppTextStyles.description),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
        ],

        // 막대 차트
        SizedBox(
          height: 380,
          width: double.infinity,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceEvenly,
              maxY: 4000, // 칼로리 기준
              groupsSpace: 10, // 막대 그룹 간 간격
              barTouchData: BarTouchData(
                enabled: true,
                touchCallback: (FlTouchEvent event, barTouchResponse) {
                  setState(() {
                    if (barTouchResponse != null &&
                        barTouchResponse.spot != null &&
                        event is FlTapUpEvent) {
                      touchedBarIndex =
                          barTouchResponse.spot!.touchedBarGroupIndex;
                    }
                  });
                },
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return null; // 기본 툴팁 비활성화 (우리가 커스텀 정보창 만들어서)
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30, // 여백 더 증가
                    getTitlesWidget: (double value, TitleMeta meta) {
                      // 1000 단위로만 표시
                      if (value % 1000 == 0) {
                        return Text(
                          '${(value).toInt()}',
                          style: AppTextStyles.description.copyWith(
                            color: AppColors.main,
                            fontSize: 10,
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30, // 여백 더 증가 (걸음수가 더 길어서)
                    getTitlesWidget: (double value, TitleMeta meta) {
                      // 5000보 단위로만 표시 (1000 값마다 = 5000보)
                      if (value % 1000 == 0) {
                        return Text(
                          '${(value * 5 / 1000).toInt()}', // 5000보 단위, k 제거
                          style: AppTextStyles.description.copyWith(
                            color: Colors.blue,
                            fontSize: 10,
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30, // 하단 여백 증가
                    getTitlesWidget: (double value, TitleMeta meta) {
                      const months = [
                        '7월',
                        '8월',
                        '9월',
                        '10월',
                        '11월',
                        '12월',
                      ]; // 6개월로 확장
                      if (value.toInt() >= 0 && value.toInt() < months.length) {
                        return Text(
                          months[value.toInt()],
                          style: AppTextStyles.description.copyWith(
                            color: AppColors.textSub,
                            fontSize: 12,
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: _getBarGroups(),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withValues(alpha: 0.2),
                    strokeWidth: 1,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    final calorieData = _getCalorieData();
    final stepsData = _getStepsData();

    return List.generate(6, (index) {
      // 6개월로 변경
      final isSelected = touchedBarIndex == index;
      return BarChartGroupData(
        x: index,
        barRods: [
          // 칼로리 막대 (왼쪽)
          BarChartRodData(
            toY: calorieData[index].y,
            color: isSelected
                ? AppColors.main.withValues(alpha: 0.8)
                : AppColors.main,
            width: 15, // 막대 두께 증가
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
          // 걸음수 막대 (오른쪽) - 스케일 조정
          BarChartRodData(
            toY: stepsData[index].y * 200, // 걸음수를 칼로리 스케일에 맞게 조정
            color: isSelected
                ? Colors.blue.withValues(alpha: 0.8)
                : Colors.blue,
            width: 15, // 막대 두께 증가
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
      );
    });
  }

  String _getMonthName(int index) {
    const months = ['7월', '8월', '9월', '10월', '11월', '12월']; // 6개월로 변경
    return months[index];
  }

  // 더미 데이터 생성 함수들 (6개월)
  List<FlSpot> _getCalorieData() {
    return [
      FlSpot(0, 2800), // 7월
      FlSpot(1, 3200), // 8월
      FlSpot(2, 2900), // 9월
      FlSpot(3, 3400), // 10월
      FlSpot(4, 3100), // 11월
      FlSpot(5, 3600), // 12월
    ];
  }

  List<FlSpot> _getStepsData() {
    return [
      FlSpot(0, 14), // 14천보
      FlSpot(1, 18), // 18천보
      FlSpot(2, 12), // 12천보
      FlSpot(3, 15), // 15천보
      FlSpot(4, 8), // 8천보
      FlSpot(5, 16), // 16천보
    ];
  }
}

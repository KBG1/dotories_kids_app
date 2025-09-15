import 'package:dotories_kids/pages/edit_user_page.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'child_detail_page.dart';
import 'edit_user_page.dart';
import 'kids_cafe_visit_list.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String selectedFilter = '전체'; // 현재 선택된 필터
  bool isDropdownOpen = false; // 드롭다운 열림 상태
  
  final List<String> filterOptions = ['전체', '민수', '민희']; // 필터 옵션들
  
  // 더미 데이터
  final Map<String, Map<String, String>> filterData = {
    '전체': {
      '걸음': '30707 걸음',
      '칼로리': '3709 Kcal',
      '방문': '10회',
    },
    '민수': {
      '걸음': '18446 걸음',
      '칼로리': '1848 Kcal',
      '방문': '6회',
    },
    '민희': {
      '걸음': '12261 걸음',
      '칼로리': '1861 Kcal',
      '방문': '4회',
    },
  };

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: screenWidth,
        height: screenHeight,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  // 외부 클릭 시 드롭다운 닫기
                  if (isDropdownOpen) {
                    setState(() {
                      isDropdownOpen = false;
                    });
                  }
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                // 상단 헤더
                _buildHeader(screenWidth),
                
                // 사용자 프로필
                _buildUserProfile(screenWidth),
                
                // 이번 달 요약 섹션
                _buildMonthlySummary(screenWidth),
                
                // 내 아이들 섹션
                _buildMyChildren(screenWidth),
                
                SizedBox(height: screenWidth * 0.05),
                
                // 방문 기록 섹션
                _buildVisitHistory(screenWidth),
                
                // 하단 여백
                SizedBox(height: screenWidth * 0.1),
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

  Widget _buildHeader(double screenWidth) {
    return Padding(
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
          Expanded(
            child: Text(
              '마이페이지',
              textAlign: TextAlign.center,
              style: AppTextStyles.subTitle.copyWith(
                fontSize: screenWidth * 0.07,
              ),
            ),
          ),
          SizedBox(width: 28), // 균형을 위한 여백
        ],
      ),
    );
  }

  Widget _buildUserProfile(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
      child: Row(
        children: [
          // 프로필 이미지
          Container(
            width: screenWidth * 0.21,
            height: screenWidth * 0.21,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: OvalBorder(
                side: BorderSide(
                  width: 1,
                  color: AppColors.main,
                ),
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: AssetImage("assets/images/dotories.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          SizedBox(width: screenWidth * 0.06),
          
          // 사용자 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '김범규',
                  style: AppTextStyles.text.copyWith(
                    color: AppColors.textDark,
                    fontSize: screenWidth * 0.06,
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                Text(
                  'KBG',
                  style: AppTextStyles.subText.copyWith(
                    fontSize: screenWidth * 0.045,
                  ),
                ),
              ],
            ),
          ),
          
          // 설정 버튼
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditUserPage(),
                ),
              );
            },
            child: Text(
              '설정',
              style: AppTextStyles.subText.copyWith(
                color: AppColors.textSub,
                fontSize: screenWidth * 0.045,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlySummary(double screenWidth) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.all(screenWidth * 0.07),
          padding: EdgeInsets.all(screenWidth * 0.05),
          decoration: ShapeDecoration(
            color: AppColors.main,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: AppColors.main),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            children: [
              // 섹션 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '이번 달 요약',
                    style: AppTextStyles.text.copyWith(
                      color: AppColors.textMain,
                      fontSize: screenWidth * 0.06,
                    ),
                  ),
                  // 빈 공간 (실제 드롭다운은 Positioned로 위에 배치)
                  SizedBox(width: screenWidth * 0.2), // 드롭다운 버튼 크기만큼 공간 확보
                ],
              ),
              
              SizedBox(height: screenWidth * 0.05),
              
              // 통계 카드들
              _buildStatCard(screenWidth, '🏃‍♂️', '총 걸음 수', filterData[selectedFilter]!['걸음']!),
              SizedBox(height: screenWidth * 0.03),
              _buildStatCard(screenWidth, '🔥', '총 칼로리', filterData[selectedFilter]!['칼로리']!),
              SizedBox(height: screenWidth * 0.03),
              _buildStatCard(screenWidth, '🏠', '방문 횟수', filterData[selectedFilter]!['방문']!),
            ],
          ),
        ),
        
        // 실제 클릭 가능한 드롭다운 버튼을 위에 배치
        Positioned(
          top: screenWidth * 0.12, // 정확한 위치 조정
          right: screenWidth * 0.12, // 정확한 위치 조정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isDropdownOpen = !isDropdownOpen;
                  });
                },
                child: Container(
                  width: screenWidth * 0.2,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenWidth * 0.01,
                  ),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: AppColors.textDark),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        selectedFilter,
                        style: AppTextStyles.description.copyWith(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Icon(
                        isDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: screenWidth * 0.04,
                        color: AppColors.textDark,
                      ),
                    ],
                  ),
                ),
              ),
              
              // 드롭다운 메뉴
              if (isDropdownOpen)
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Material(
                    elevation: 24,
                    shadowColor: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: screenWidth * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.textDark),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: filterOptions.map((option) {
                          final isSelected = option == selectedFilter;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedFilter = option;
                                isDropdownOpen = false;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03,
                                vertical: screenWidth * 0.025,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.main : Colors.white,
                                borderRadius: option == filterOptions.first
                                    ? BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      )
                                    : option == filterOptions.last
                                        ? BorderRadius.only(
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          )
                                        : BorderRadius.zero,
                              ),
                              child: Text(
                                option,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.description.copyWith(
                                  color: isSelected ? Colors.white : AppColors.textDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(double screenWidth, String emoji, String title, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Text(
            emoji,
            style: TextStyle(fontSize: screenWidth * 0.09),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.text.copyWith(
                    color: AppColors.textMain,
                    fontSize: screenWidth * 0.06,
                  ),
                ),
                Text(
                  value,
                  style: AppTextStyles.subText.copyWith(
                    color: AppColors.textSub,
                    fontSize: screenWidth * 0.045,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyChildren(double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: ShapeDecoration(
        color: AppColors.main,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.main),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        children: [
          // 섹션 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '내 아이들',
                style: AppTextStyles.text.copyWith(
                  color: AppColors.textMain,
                  fontSize: screenWidth * 0.06,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenWidth * 0.01,
                ),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: AppColors.textDark),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  '2명',
                  style: AppTextStyles.description.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: screenWidth * 0.05),
          
          // 아이들 정보
          _buildChildCard(screenWidth, '민수', '7세', '52회', '18261 Kcal'),
          SizedBox(height: screenWidth * 0.03),
          _buildChildCard(screenWidth, '민희', '6세', '12회', '5661 Kcal'),
        ],
      ),
    );
  }

   Widget _buildChildCard(double screenWidth, String name, String age, String visits, String calories) {
     return GestureDetector(
       onTap: () {
         // 아이 상세 페이지로 이동
         Navigator.push(
           context,
           MaterialPageRoute(
             builder: (context) => ChildDetailPage(),
           ),
         );
       },
       child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          // 프로필 이미지
          Container(
            width: screenWidth * 0.12,
            height: screenWidth * 0.12,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: OvalBorder(
                side: BorderSide(width: 1, color: AppColors.main),
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: AssetImage("assets/images/dotories.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          SizedBox(width: screenWidth * 0.04),
          
          // 이름과 나이
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.text.copyWith(
                    color: AppColors.textMain,
                    fontSize: screenWidth * 0.06,
                  ),
                ),
                Text(
                  age,
                  style: AppTextStyles.subText.copyWith(
                    color: AppColors.textSub,
                    fontSize: screenWidth * 0.045,
                  ),
                ),
              ],
            ),
          ),
          
          // 방문 횟수
          Column(
            children: [
              Text(
                '방문',
                style: AppTextStyles.subText.copyWith(
                  color: AppColors.textMain,
                  fontSize: screenWidth * 0.045,
                ),
              ),
              Text(
                visits,
                style: AppTextStyles.description.copyWith(
                  color: AppColors.textSub,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          SizedBox(width: screenWidth * 0.04),
          
          // 칼로리
          Column(
            children: [
              Text(
                '총 칼로리',
                style: AppTextStyles.subText.copyWith(
                  color: AppColors.textMain,
                  fontSize: screenWidth * 0.045,
                ),
              ),
              Text(
                calories,
                style: AppTextStyles.description.copyWith(
                  color: AppColors.textSub,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
     ),
   );
  }

  Widget _buildVisitHistory(double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: ShapeDecoration(
        color: AppColors.main,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.main),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        children: [
          // 섹션 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '방문 기록',
                style: AppTextStyles.text.copyWith(
                  color: AppColors.textMain,
                  fontSize: screenWidth * 0.06,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KidsCafeVisitListPage(),
                    ),
                  );
                },
                child: Text(
                  '전체 보기',
                  style: AppTextStyles.description.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: screenWidth * 0.05),
          
          // 방문 기록 카드들
          _buildVisitCard(screenWidth, '민희', '09.03', '1시간 31분'),
          SizedBox(height: screenWidth * 0.03),
          _buildVisitCard(screenWidth, '민수', '09.03', '1시간 31분'),
          SizedBox(height: screenWidth * 0.03),
          _buildVisitCard(screenWidth, '민희', '09.03', '1시간 31분'),
          SizedBox(height: screenWidth * 0.03),
          _buildVisitCard(screenWidth, '민희', '09.03', '1시간 31분'),
        ],
      ),
    );
  }

  Widget _buildVisitCard(double screenWidth, String childName, String date, String duration) {
    return Container(
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
          // 상단: 카페명, 날짜, 아이 이름
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '제니스키즈카페 신영통점',
                  style: AppTextStyles.subText.copyWith(
                    color: AppColors.textMain,
                    fontSize: screenWidth * 0.045,
                  ),
                ),
              ),
              Text(
                date,
                style: AppTextStyles.description.copyWith(
                  color: AppColors.textMain,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          SizedBox(height: screenWidth * 0.02),
          
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
                  childName,
                  style: AppTextStyles.description.copyWith(
                    color: AppColors.textMain,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: screenWidth * 0.03),
          
          // 하단: 활동 정보
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 칼로리, 걸음, 심박수
              Expanded(
                child: Column(
                  children: [
                    _buildActivityInfo('🔥', '272 Kcal'),
                    SizedBox(height: screenWidth * 0.015),
                    _buildActivityInfo('👟', '3397 걸음'),
                    SizedBox(height: screenWidth * 0.015),
                    _buildActivityInfo('❤️‍🔥', '124 bpm'),
                  ],
                ),
              ),
              
              // 시간
              Text(
                duration,
                style: AppTextStyles.description.copyWith(
                  color: AppColors.textMain,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityInfo(String emoji, String value) {
    return Row(
      children: [
        Text(
          emoji,
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(width: 8),
        Text(
          value,
          style: AppTextStyles.description.copyWith(
            color: AppColors.textSub,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

}

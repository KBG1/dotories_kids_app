import 'package:dotories_kids/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'theme/app_theme.dart';
import 'pages/kids_cafe_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 환경 변수 로드
  await dotenv.load(fileName: ".env");

  // 네이버 지도 초기화
  await FlutterNaverMap().init(
    clientId: dotenv.env['NAVER_MAP_CLIENT_ID'] ?? '11kj9rkc2p',
  );

  runApp(const ForestKidsApp());
}

class ForestKidsApp extends StatelessWidget {
  const ForestKidsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forest Kids',
      theme: AppTheme.theme, // 글로벌 테마 적용
      home: const ForestKidsHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ForestKidsHomePage extends StatelessWidget {
  const ForestKidsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 화면 크기 가져오기
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var isLogin = false;

    return Scaffold(
      body: Container(
        width: screenWidth, // 화면 전체 너비
        height: screenHeight, // 화면 전체 높이
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0xFF6BCF7F),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 3),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 상단 영역 (도토리 + 제목)
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 로고 이미지
                      Image.asset(
                        'assets/images/logo.png',
                        width: screenWidth * 0.65, // 화면 너비의 70%
                        errorBuilder: (context, error, stackTrace) {
                          // 로고 이미지가 없을 때 기존 텍스트로 대체
                          return Column(
                            children: [
                              Text(
                                'Forest\nKids',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.16,
                                  fontFamily: 'Chab',
                                  fontWeight: FontWeight.w400,
                                  height: 0.9,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '아이들을 위한 특별한 경험',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.06,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '아이들을 위한 특별한 경험',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.05,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 하단 버튼 영역
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 키즈 카페 찾기 버튼
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            minHeight: screenHeight * 0.1,
                            maxHeight: screenHeight * 0.12,
                          ),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const KidsCafePage(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '키즈 카페 찾기',
                                      style: TextStyle(
                                        color: const Color(0xFF2D5016),
                                        fontSize: screenWidth * 0.05,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '주변에 있는 키즈카페를 찾아보세요',
                                      style: TextStyle(
                                        color: const Color(0xFF4A7C59),
                                        fontSize: screenWidth * 0.035,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15), // 버튼 사이 간격 조정
                      // 마이페이지 버튼
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            minHeight: screenHeight * 0.1,
                            maxHeight: screenHeight * 0.12,
                          ),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '마이페이지',
                                      style: TextStyle(
                                        color: const Color(0xFF2D5016),
                                        fontSize: screenWidth * 0.05,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '아이들의 운동량을 확인해보세요',
                                      style: TextStyle(
                                        color: const Color(0xFF4A7C59),
                                        fontSize: screenWidth * 0.035,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
}

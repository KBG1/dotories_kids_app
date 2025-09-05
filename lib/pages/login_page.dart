import 'package:dotories_kids/main.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false; // 비밀번호 표시 상태

  @override
  Widget build(BuildContext context) {
    // 화면 크기 가져오기
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true, // 키보드가 올라올 때 화면 조정
      body: Container(
        width: screenWidth,
        height: screenHeight,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: AppColors.main,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView( // 스크롤 가능하게 만들기
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // 키보드 높이만큼 패딩 추가
            ),
            child: Column(
            children: [
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
              
              // 메인 컨텐츠 영역
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      const SizedBox(height: 50),
                      Center(
                        child: Text(
                          'LOGIN',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.title.copyWith(
                            fontSize: screenWidth * 0.12,
                            fontFamily: 'Chab',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // 환영 메시지
                      Center(
                        child: Text(
                          'Forest Kids App에 오신 것을 환영합니다.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.subText.copyWith(
                            color: Colors.white,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 50),
                      
                      // 아이디 입력 영역
                      Text(
                        '아이디',
                        style: AppTextStyles.text.copyWith(
                          fontSize: screenWidth * 0.06,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: ShapeDecoration(
                          color: AppColors.sub,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '아이디를 입력하세요.',
                            hintStyle: AppTextStyles.subText.copyWith(
                              color: const Color(0xFF9D9D9D),
                              fontSize: screenWidth * 0.045,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 35),
                      
                      // 비밀번호 입력 영역
                      Text(
                        '비밀번호',
                        style: AppTextStyles.text.copyWith(
                          fontSize: screenWidth * 0.06,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: ShapeDecoration(
                          color: AppColors.sub,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: TextField(
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: '비밀번호를 입력하세요.',
                            hintStyle: AppTextStyles.subText.copyWith(
                              color: const Color(0xFF9D9D9D),
                              fontSize: screenWidth * 0.045,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03,
                              vertical: screenHeight * 0.01,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.textDark,
                              ),
                              iconSize: screenWidth * 0.05,
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // 로그인 버튼
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ForestKidsHomePage()));
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: ShapeDecoration(
                            color: AppColors.textMain,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '로그인',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.text.copyWith(
                                fontSize: screenWidth * 0.06,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // 회원가입, 비밀번호 찾기 링크
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // TODO: 회원가입 페이지로 이동
                            },
                            child: Text(
                              '회원가입',
                              style: AppTextStyles.description.copyWith(
                                color: Colors.white,
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 30),
                          
                          GestureDetector(
                            onTap: () {
                              // TODO: 비밀번호 찾기 페이지로 이동
                            },
                            child: Text(
                              '비밀번호 찾기',
                              style: AppTextStyles.description.copyWith(
                                color: Colors.white,
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
import 'package:flutter/material.dart';

// 색상 팔레트 (이미지 기준)
class AppColors {
  static const Color main = Color(0xFF6BCF7F);        // Main green (#68CF7F)
  static const Color sub = Colors.white;              // Sub (#FFFF)
  static const Color textMain = Color(0xFF2D5016);    // Text Main (#2D5016)
  static const Color textSub = Color(0xFF4A7C59);     // Text Sub (#4A7C59)
  static const Color textDark = Color(0xFF333333);    // Text Dark (#333)
  static const Color cancel = Color(0xFFFF9898);      // Cancel (#FF9898)
}

// 폰트 사이즈 (이미지 기준)
class AppFontSizes {
  static const double header = 64.0;     // Header - 64px
  static const double title = 48.0;      // Title - 48px  
  static const double subTitle = 36.0;   // SubTitle - 36px
  static const double text = 24.0;       // Text - 24px
  static const double subText = 18.0;    // SubText - 18px
  static const double description = 14.0; // description - 14px
}

// 텍스트 스타일
class AppTextStyles {
  static const TextStyle header = TextStyle(
    fontSize: AppFontSizes.header,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: 0.9,
  );
  
  static const TextStyle title = TextStyle(
    fontSize: AppFontSizes.title,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static const TextStyle subTitle = TextStyle(
    fontSize: AppFontSizes.subTitle,
    fontWeight: FontWeight.w600,
    color: AppColors.textMain,
  );
  
  static const TextStyle text = TextStyle(
    fontSize: AppFontSizes.text,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  
  static const TextStyle subText = TextStyle(
    fontSize: AppFontSizes.subText,
    fontWeight: FontWeight.w600,
    color: AppColors.textMain,
  );
  
  static const TextStyle description = TextStyle(
    fontSize: AppFontSizes.description,
    fontWeight: FontWeight.normal,
    color: AppColors.textSub,
  );
}

// 전체 앱 테마
class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      fontFamily: 'Pretendard',
      // 기본 배경은 흰색으로, 개별 화면에서 필요시 색상 지정
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.main,
        surface: Colors.white,      // 기본 화면 배경은 흰색
        onSurface: Colors.black,    // 기본 텍스트는 검은색
      ),
      scaffoldBackgroundColor: Colors.white, // Scaffold 기본 배경 흰색
      useMaterial3: true,
    );
  }
}
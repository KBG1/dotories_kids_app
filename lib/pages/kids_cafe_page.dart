import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class KidsCafePage extends StatelessWidget {
  const KidsCafePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🤍 배경 지정 안함 = 자동으로 흰색!
      appBar: AppBar(
        title: Text(
          '키즈 카페 찾기',
          style: AppTextStyles.subTitle, // SubTitle - 36px
        ),
        backgroundColor: AppColors.main,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              '이 페이지는 흰색 배경!',
              style: AppTextStyles.text, // Text - 24px
            ),
            SizedBox(height: 20),
            Text(
              '설명 텍스트입니다.',
              style: AppTextStyles.description, // description - 14px
            ),
          ],
        ),
      ),
    );
  }
}

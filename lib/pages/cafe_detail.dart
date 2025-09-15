import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CafeDetailPage extends StatefulWidget {
  const CafeDetailPage({
    super.key,
    this.cafeName = '제니스키즈카페 신영통점',
    this.address = '경기도 화성시 반월동 66-9 명성프라자 3층 303호',
    this.registeredAt = '2025년 06월 27일',
    this.imageUrl = 'assets/images/kids_cafe.png',
    this.rating = 4.5,
    this.menuCount = 0,
    this.reviewCount = 0,
  });

  final String cafeName;
  final String address;
  final String registeredAt;
  final String imageUrl;
  final double rating;
  final int menuCount;
  final int reviewCount;

  @override
  State<CafeDetailPage> createState() => _CafeDetailPageState();
}

enum CafeTab { info, menu, review }

class _CafeDetailPageState extends State<CafeDetailPage> {
  CafeTab current = CafeTab.info;

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
          color: Colors.white.withValues(alpha: 0.95),
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
                SizedBox(height: screenWidth * 0.02),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: AppColors.textDark, size: 28),
                ),
                SizedBox(height: screenWidth * 0.02),
                Center(
                  child: Text(
                    widget.cafeName.length > 14
                        ? '${widget.cafeName.substring(0, 14)} ...'
                        : widget.cafeName,
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.textMain,
                      fontSize: screenWidth * 0.08,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenWidth * 0.04),

                // 상단 카드 (이미지 + 기본 정보 요약)
                Container(
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Color(0xFF333333)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 카페 이미지
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: _buildCafeImage(screenWidth),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(screenWidth * 0.04, screenWidth * 0.03,
                            screenWidth * 0.04, screenWidth * 0.03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.cafeName,
                              style: AppTextStyles.subText.copyWith(
                                color: AppColors.textMain,
                                fontSize: screenWidth * 0.048,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              '📍 ${widget.address}',
                              style: AppTextStyles.description.copyWith(
                                color: AppColors.textSub,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: screenWidth * 0.02),
                            Row(
                              children: [
                                _pill('⭐ ${widget.rating.toStringAsFixed(1)}'),
                                SizedBox(width: screenWidth * 0.02),
                                _pill('📝 리뷰 ${widget.reviewCount}개'),
                                SizedBox(width: screenWidth * 0.02),
                                _pill('🍽️ 메뉴 ${widget.menuCount}개'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenWidth * 0.04),

                // 탭 버튼
                Row(
                  children: [
                    _tabButton('🏪 기본정보', CafeTab.info, isPrimary: current == CafeTab.info),
                    SizedBox(width: screenWidth * 0.03),
                    _tabButton('🍽️ 메뉴', CafeTab.menu, isPrimary: current == CafeTab.menu),
                    SizedBox(width: screenWidth * 0.03),
                    _tabButton('⭐ 리뷰', CafeTab.review, isPrimary: current == CafeTab.review),
                  ],
                ),

                SizedBox(height: screenWidth * 0.03),

                // 컨텐츠 영역
                if (current == CafeTab.info) _buildInfoSection(screenWidth),
                if (current == CafeTab.menu) _buildEmptySection(screenWidth, '아직 메뉴가 없어요!'),
                if (current == CafeTab.review)
                  _buildEmptySection(screenWidth, '아직 리뷰가 없어요!'),

                SizedBox(height: screenWidth * 0.06),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.main),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.description.copyWith(
          color: AppColors.textMain,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCafeImage(double screenWidth) {
    final String src = widget.imageUrl;
    final bool isAsset = !src.startsWith('http') && !src.startsWith('https');
    if (isAsset) {
      return Image.asset(
        src,
        width: double.infinity,
        height: screenWidth * 0.35,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) {
          return Container(
            height: screenWidth * 0.35,
            color: Colors.grey[200],
            alignment: Alignment.center,
            child: const Icon(Icons.store, color: Colors.grey, size: 40),
          );
        },
      );
    }
    return Image.network(
      src,
      width: double.infinity,
      height: screenWidth * 0.35,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) {
        return Container(
          height: screenWidth * 0.35,
          color: Colors.grey[200],
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
        );
      },
    );
  }

  Widget _tabButton(String text, CafeTab tab, {required bool isPrimary}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => current = tab),
        child: Container(
          height: 40,
          decoration: ShapeDecoration(
            color: isPrimary ? AppColors.main : Colors.white,
            shape: RoundedRectangleBorder(
              side: isPrimary ? BorderSide.none : const BorderSide(width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: AppTextStyles.description.copyWith(
                color: isPrimary ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(double screenWidth) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: ShapeDecoration(
        color: AppColors.main,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.main),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoBox(screenWidth, '📍 위치 정보', widget.address),
          SizedBox(height: screenWidth * 0.03),
          _infoBox(screenWidth, '📅 등록 정보', '등록일 : ${widget.registeredAt}'),
          SizedBox(height: screenWidth * 0.03),
          _mapButton(screenWidth),
        ],
      ),
    );
  }

  Widget _infoBox(double screenWidth, String title, String content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.035),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1),
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
          SizedBox(height: 8),
          Text(
            content,
            style: AppTextStyles.description.copyWith(
              color: AppColors.textSub,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapButton(double screenWidth) {
    return Container(
      height: 40,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Center(
        child: Text(
          '지도에서 보기',
          style: AppTextStyles.description.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySection(double screenWidth, String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: ShapeDecoration(
        color: AppColors.main,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.main),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(screenWidth * 0.05),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Center(
          child: Text(
            message,
            style: AppTextStyles.subText.copyWith(
              color: AppColors.textSub,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}



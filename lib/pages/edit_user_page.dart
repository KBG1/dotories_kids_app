import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({super.key});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressDetailController = TextEditingController();

  // 자녀 폼 관련
  final TextEditingController _childNameController = TextEditingController();
  final TextEditingController _childNicknameController = TextEditingController();
  final TextEditingController _childBirthController = TextEditingController();
  
  // 알러지 체크박스
  bool _hasMilkAllergy = false;    // 유제품 (우유, 치즈 등)
  bool _hasEggAllergy = false;     // 계란
  bool _hasPeanutAllergy = false;  // 땅콩
  bool _hasNutAllergy = false;     // 견과류 (호두, 아몬드 등)
  bool _hasSoyAllergy = false;     // 대두 (콩)
  bool _hasWheatAllergy = false;   // 밀 (글루텐 포함)
  bool _hasFishAllergy = false;    // 생선
  bool _hasShrimpAllergy = false;  // 갑각류 (게, 새우 등)

  final List<_ChildInfo> _children = [
    _ChildInfo(name: '민수'),
    _ChildInfo(name: '민희'),
  ];

  bool _showChildForm = false;
  String _formTitle = '';
  int? _editingChildIndex; // null이면 새 자녀 추가, 인덱스가 있으면 해당 자녀 수정

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
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(screenWidth),
                SizedBox(height: screenWidth * 0.06),
                
                // 사용자 정보 입력 필드들
                _buildInputField(screenWidth, '아이디', _userIdController, 'User Id'),
                SizedBox(height: screenWidth * 0.04),
                _buildInputField(screenWidth, '생년월일', _birthController, '1997-09-21'),
                SizedBox(height: screenWidth * 0.04),
                _buildInputField(screenWidth, '휴대폰 번호', _phoneController, '010-0000-0000'),
                SizedBox(height: screenWidth * 0.04),
                _buildAddressField(screenWidth),
                SizedBox(height: screenWidth * 0.04),
                _buildInputField(screenWidth, '상세 주소', _addressDetailController, '상세 주소를 입력하세요. (동, 호수 등)'),
                
                // 구분선
                Container(
                  margin: EdgeInsets.symmetric(vertical: screenWidth * 0.06),
                  height: 1,
                  color: Colors.grey.withValues(alpha: 0.3),
                ),
                
                // 자녀 관리 섹션
                _buildChildrenSection(screenWidth),
                
                // 자녀 추가/수정 폼 (조건부 표시)
                if (_showChildForm)
                  _buildChildForm(screenWidth),
                
                SizedBox(height: screenWidth * 0.08),
                
                // 하단 액션 버튼들
                _buildActions(screenWidth),
                SizedBox(height: screenWidth * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
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
              '프로필 수정',
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(
                color: AppColors.textDark,
                fontSize: screenWidth * 0.07,
              ),
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _buildInputField(double screenWidth, String label, TextEditingController controller, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.subTitle.copyWith(
            color: AppColors.textDark,
            fontSize: screenWidth * 0.06,
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Container(
          width: double.infinity,
          height: 50,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFF333333)),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: controller,
                decoration: InputDecoration.collapsed(
                  hintText: placeholder,
                  hintStyle: AppTextStyles.subText.copyWith(
                    color: const Color(0xFF9D9D9D),
                  ),
                ),
                style: AppTextStyles.subText.copyWith(
                  color: const Color(0xFF9D9D9D),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressField(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '주소',
          style: AppTextStyles.subTitle.copyWith(
            color: AppColors.textDark,
            fontSize: screenWidth * 0.06,
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFF333333)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: _addressController,
                      decoration: InputDecoration.collapsed(
                        hintText: '경기도 수원시 권선구 수성로 8',
                        hintStyle: AppTextStyles.subText.copyWith(
                          color: const Color(0xFF9D9D9D),
                        ),
                      ),
                      style: AppTextStyles.subText.copyWith(
                        color: const Color(0xFF9D9D9D),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Container(
              width: 24,
              height: 24,
              child: Icon(
                Icons.search,
                color: AppColors.textDark,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChildrenSection(double screenWidth) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
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
          Text(
            '자녀 관리',
            style: AppTextStyles.text.copyWith(
              color: AppColors.textDark,
              fontSize: screenWidth * 0.06,
            ),
          ),
          SizedBox(height: screenWidth * 0.04),
          
          // 자녀 리스트
          ..._children.asMap().entries.map((entry) {
            final idx = entry.key;
            final child = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
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
                      width: 48,
                      height: 48,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: OvalBorder(
                          side: BorderSide(width: 1, color: AppColors.main),
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/dotories.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    
                    // 자녀 이름
                    Expanded(
                      child: Text(
                        child.name,
                        style: AppTextStyles.subText.copyWith(
                          color: AppColors.textDark,
                          fontSize: screenWidth * 0.06,
                        ),
                      ),
                    ),
                    
                    // 수정 버튼
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _editingChildIndex = idx;
                          _formTitle = '자녀 수정';
                          _childNameController.text = child.name;
                          _childNicknameController.text = child.nickname ?? '';
                          _childBirthController.text = child.birth ?? '';
                          _hasMilkAllergy = child.hasMilkAllergy;
                          _hasEggAllergy = child.hasEggAllergy;
                          _hasPeanutAllergy = child.hasPeanutAllergy;
                          _hasNutAllergy = child.hasNutAllergy;
                          _hasSoyAllergy = child.hasSoyAllergy;
                          _hasWheatAllergy = child.hasWheatAllergy;
                          _hasFishAllergy = child.hasFishAllergy;
                          _hasShrimpAllergy = child.hasShrimpAllergy;
                          _showChildForm = true;
                        });
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        child: Icon(
                          Icons.edit,
                          color: AppColors.textDark,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    
                    // 삭제 버튼
                    GestureDetector(
                      onTap: () {
                        // TODO: API 연동 시 삭제 로직
                        setState(() {
                          _children.removeAt(idx);
                        });
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        child: Icon(
                          Icons.close,
                          color: AppColors.textDark,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          
          // 자녀 추가 버튼
          GestureDetector(
            onTap: () {
              setState(() {
                _editingChildIndex = null;
                _formTitle = '새 아이 추가';
                _childNameController.clear();
                _childNicknameController.clear();
                _childBirthController.clear();
                _hasMilkAllergy = false;
                _hasEggAllergy = false;
                _hasPeanutAllergy = false;
                _hasNutAllergy = false;
                _hasSoyAllergy = false;
                _hasWheatAllergy = false;
                _hasFishAllergy = false;
                _hasShrimpAllergy = false;
                _showChildForm = true;
              });
            },
            child: Container(
              width: double.infinity,
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
                  '+ 자녀 추가',
                  style: AppTextStyles.description.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildForm(double screenWidth) {
    return Container(
      margin: EdgeInsets.only(top: screenWidth * 0.04),
      padding: EdgeInsets.all(screenWidth * 0.05),
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
          Text(
            _formTitle,
            style: AppTextStyles.text.copyWith(
              color: AppColors.textDark,
              fontSize: screenWidth * 0.055,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: screenWidth * 0.04),
          
          // 이름 입력
          _buildFormField(screenWidth, '이름', _childNameController, '자녀 이름을 입력하세요'),
          SizedBox(height: screenWidth * 0.03),
          
          // 별명 입력
          _buildFormField(screenWidth, '별명', _childNicknameController, '별명을 입력하세요'),
          SizedBox(height: screenWidth * 0.03),
          
          // 생년월일 입력
          _buildFormField(screenWidth, '생년월일', _childBirthController, 'YYYY-MM-DD'),
          SizedBox(height: screenWidth * 0.04),
          
          // 알러지 체크박스 섹션
          _buildAllergySection(screenWidth),
          SizedBox(height: screenWidth * 0.04),
          
          // 폼 액션 버튼들
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showChildForm = false;
                    });
                  },
                  child: Container(
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
                        '취소',
                        style: AppTextStyles.description.copyWith(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // TODO: 저장 로직 구현
                    setState(() {
                      if (_editingChildIndex == null) {
                        // 새 자녀 추가
                        _children.add(_ChildInfo(
                          name: _childNameController.text,
                          nickname: _childNicknameController.text.isEmpty ? null : _childNicknameController.text,
                          birth: _childBirthController.text.isEmpty ? null : _childBirthController.text,
                          hasMilkAllergy: _hasMilkAllergy,
                          hasEggAllergy: _hasEggAllergy,
                          hasPeanutAllergy: _hasPeanutAllergy,
                          hasNutAllergy: _hasNutAllergy,
                          hasSoyAllergy: _hasSoyAllergy,
                          hasWheatAllergy: _hasWheatAllergy,
                          hasFishAllergy: _hasFishAllergy,
                          hasShrimpAllergy: _hasShrimpAllergy,
                        ));
                      } else {
                        // 기존 자녀 수정
                        _children[_editingChildIndex!].name = _childNameController.text;
                        _children[_editingChildIndex!].nickname = _childNicknameController.text.isEmpty ? null : _childNicknameController.text;
                        _children[_editingChildIndex!].birth = _childBirthController.text.isEmpty ? null : _childBirthController.text;
                        _children[_editingChildIndex!].hasMilkAllergy = _hasMilkAllergy;
                        _children[_editingChildIndex!].hasEggAllergy = _hasEggAllergy;
                        _children[_editingChildIndex!].hasPeanutAllergy = _hasPeanutAllergy;
                        _children[_editingChildIndex!].hasNutAllergy = _hasNutAllergy;
                        _children[_editingChildIndex!].hasSoyAllergy = _hasSoyAllergy;
                        _children[_editingChildIndex!].hasWheatAllergy = _hasWheatAllergy;
                        _children[_editingChildIndex!].hasFishAllergy = _hasFishAllergy;
                        _children[_editingChildIndex!].hasShrimpAllergy = _hasShrimpAllergy;
                      }
                      _showChildForm = false;
                    });
                  },
                  child: Container(
                    height: 40,
                    decoration: ShapeDecoration(
                      color: AppColors.textDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '저장',
                        style: AppTextStyles.description.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(double screenWidth, String label, TextEditingController controller, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.subText.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Container(
          width: double.infinity,
          height: 40,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: controller,
                decoration: InputDecoration.collapsed(
                  hintText: placeholder,
                  hintStyle: AppTextStyles.description.copyWith(
                    color: const Color(0xFF9D9D9D),
                  ),
                ),
                style: AppTextStyles.description.copyWith(
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAllergySection(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '알러지',
          style: AppTextStyles.subText.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: screenWidth * 0.03),
        
        // 알러지 체크박스들
        _buildCheckboxItem('유제품 (우유, 치즈 등)', _hasMilkAllergy, (value) {
          setState(() {
            _hasMilkAllergy = value ?? false;
          });
        }),
        _buildCheckboxItem('계란', _hasEggAllergy, (value) {
          setState(() {
            _hasEggAllergy = value ?? false;
          });
        }),
        _buildCheckboxItem('땅콩', _hasPeanutAllergy, (value) {
          setState(() {
            _hasPeanutAllergy = value ?? false;
          });
        }),
        _buildCheckboxItem('견과류 (호두, 아몬드 등)', _hasNutAllergy, (value) {
          setState(() {
            _hasNutAllergy = value ?? false;
          });
        }),
        _buildCheckboxItem('대두 (콩)', _hasSoyAllergy, (value) {
          setState(() {
            _hasSoyAllergy = value ?? false;
          });
        }),
        _buildCheckboxItem('밀 (글루텐 포함)', _hasWheatAllergy, (value) {
          setState(() {
            _hasWheatAllergy = value ?? false;
          });
        }),
        _buildCheckboxItem('생선', _hasFishAllergy, (value) {
          setState(() {
            _hasFishAllergy = value ?? false;
          });
        }),
        _buildCheckboxItem('갑각류 (게, 새우 등)', _hasShrimpAllergy, (value) {
          setState(() {
            _hasShrimpAllergy = value ?? false;
          });
        }),
      ],
    );
  }

  Widget _buildCheckboxItem(String label, bool? value, ValueChanged<bool?> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Checkbox(
            value: value ?? false,
            onChanged: onChanged,
            activeColor: AppColors.main,
            checkColor: Colors.white,
          ),
          Text(
            label,
            style: AppTextStyles.description.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(double screenWidth) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
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
                  '취소',
                  style: AppTextStyles.description.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.04),
        Expanded(
          child: GestureDetector(
            onTap: () {
              // TODO: 전체 저장 로직 구현
              Navigator.pop(context);
            },
            child: Container(
              height: 40,
              decoration: ShapeDecoration(
                color: AppColors.textDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  '저장',
                  style: AppTextStyles.description.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChildInfo {
  String name;
  String? nickname;
  String? birth;
  bool hasMilkAllergy;    // 유제품 (우유, 치즈 등)
  bool hasEggAllergy;     // 계란
  bool hasPeanutAllergy;  // 땅콩
  bool hasNutAllergy;     // 견과류 (호두, 아몬드 등)
  bool hasSoyAllergy;     // 대두 (콩)
  bool hasWheatAllergy;   // 밀 (글루텐 포함)
  bool hasFishAllergy;    // 생선
  bool hasShrimpAllergy;  // 갑각류 (게, 새우 등)

  _ChildInfo({
    required this.name,
    this.nickname,
    this.birth,
    this.hasMilkAllergy = false,
    this.hasEggAllergy = false,
    this.hasPeanutAllergy = false,
    this.hasNutAllergy = false,
    this.hasSoyAllergy = false,
    this.hasWheatAllergy = false,
    this.hasFishAllergy = false,
    this.hasShrimpAllergy = false,
  });
}

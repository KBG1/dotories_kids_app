import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  var latitude = ''.obs;
  var longitude = ''.obs;
  var isLoading = false.obs;

  // 현재위치 가져오기
  Future getCurrentPosition() async {
    isLoading.value = true;
    
    // 기기에서 위치 정보 획득 기능이 활성화되어 있는지 확인
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("위치정보 허용안함");
      isLoading.value = false;
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) { // 거부 
        print('위치 권한이 거부되었습니다.'); 
        isLoading.value = false;
        return;
      }
    }
    
    // 권한이 허용되었으면 위치 가져오기 재시도
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      print('위치 권한이 허용되었습니다. 현재 위치를 가져옵니다...');
    }

    if (permission == LocationPermission.deniedForever) { // 허용 안함 
      print('위치 권한이 영구적으로 거부되었습니다.');
      isLoading.value = false;
      return;
    }

    try {
      // 현재 위치 구하기
      Position position = await Geolocator.getCurrentPosition();
      
      latitude.value = position.latitude.toString();
      longitude.value = position.longitude.toString();
      
      print('현재 위치: ${latitude.value}, ${longitude.value}');
    } catch (e) {
      print('위치 가져오기 실패: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 위도를 double로 반환
  double get latitudeDouble => double.tryParse(latitude.value) ?? 37.5666102;
  
  // 경도를 double로 반환  
  double get longitudeDouble => double.tryParse(longitude.value) ?? 126.9783881;
  
  // 위치가 있는지 확인
  bool get hasLocation => latitude.value.isNotEmpty && longitude.value.isNotEmpty;
}

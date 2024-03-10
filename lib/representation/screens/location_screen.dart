


import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:vrb_client/core/constants/assets_path.dart';

import '../../core/constants/dimension_constants.dart';
import '../../models/point.dart';
import '../../models/province.dart';
import '../../network/netword_request.dart';
import '../widgets/address_form_widget.dart';


import '../widgets/select_local_widget.dart';

import 'loading_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Map<String, Province> locations = {};
  List<Map<String, Point>> address = [];
  String? provinceChose;
  String? districtChose;
  Set<Marker> markers = {};
  bool _isLoading = false;
  final Location _locationController = Location();
  LatLng? _currentLocation;
  @override
  void initState() {
    super.initState();
    fetchData(); // Gọi fetchData khi trang được khởi tạo
    getLocationUpdate();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true; // Kích hoạt màn hình chờ
    });

    try {
      locations = await DioTest.postProviceInfoList();
    } catch (error) {
      // Xử lý lỗi ở đây
    }

    setState(() {
      _isLoading = false; // Tắt màn hình chờ
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    int markerIdCounter = 0;
    Set<Marker> _setMarkers(){
      return address.map((data) {

        String markerId = 'marker_$markerIdCounter'; // Tạo markerId tự tăng

        markerIdCounter++; // Tăng biến đếm cho lần tạo marker tiếp theo

        return Marker(
          markerId: MarkerId(markerId),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(double.parse(data.values.first.latitude), double.parse(data.values.first.longitude)),
        );
      }).toSet();
    }

    return  Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Vị trí ATM, chi nhánh')),
      ),
      body:_isLoading == true ? LoadingScreen() : Stack(
        children: [

          Positioned.fill(
              child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(21.005536, 105.8180681),
              zoom: 5,
            ),
                markers: markers,
          )),




          Positioned(
            top: kMinPadding,
            left: kMinPadding,
            child: Container(
              width: size.width -
                  (2 *
                      kMinPadding), // Sử dụng chiều rộng của màn hình trừ đi khoảng cách mép trái và phải
              child: SelectLocalWidget(
                defaultHint: "Tỉnh/ Thành Phố",
                selectedValue: provinceChose,
                items: locations.keys.toList(),
                onChanged: (value) {
                  setState(() {
                    provinceChose = value;
                  });
                },
                onValueChanged: (value) {
                  setState(() {
                    districtChose = null; // Reset giá trị của dropdown thứ hai khi dropdown thứ nhất thay đổi
                  });
                },
              ),

            ),
          ),
          Positioned(
            top: kDefaultPadding * 2 +
                40, // Đặt vị trí của SelectLocalWidget tiếp theo
            left: kMinPadding,
            width: size.width -
                (2 * kMinPadding), // Đặt chiều rộng cho SelectLocalWidget
            child: SelectLocalWidget(
              defaultHint: "Quận/ Huyện",
              selectedValue: districtChose,
              // items: VietNamLocation.district,
              items: provinceChose != null ? locations[provinceChose]!.Ddistrict.keys.toList() : [],
              onChanged: (value) {
                setState(() {
                  districtChose = value;
                });
              },
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            maxChildSize: 0.8,
            minChildSize: 0.3,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(kDefaultPadding * 2),
                    topRight: Radius.circular(kDefaultPadding * 2),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: kDefaultPadding),
                      child: Container(
                        height: 5,
                        width: 60,
                        decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(kItemPadding)),
                          color: Colors.black,
                        ),
                      ),
                    ),

                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF19226D).withOpacity(0.9),
                          const Color(0xFFED1C24).withOpacity(0.8),
                        ],
                        stops: [0.5, 1],
                      )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Expanded(child: _buildButton('Gần Nhất', () async{
                          List<Map<String, Point>> newAddresses = await DioTest.postBranchATMTypeOne();
                          setState(() {
                            address = newAddresses;
                            markers = _setMarkers(); // Cập nhật lại markers khi danh sách address được cập nhật
                          });
                        })),
                        Expanded(child: _buildButton('ATM', () async {
                          List<Map<String, Point>> newAddresses = await DioTest.postBranchATMTypeTwo(locations[provinceChose]!.regionCode1);
                          setState(() {
                            address = newAddresses;
                            markers = _setMarkers(); // Cập nhật lại markers khi danh sách address được cập nhật
                          });
                        })),
                        Expanded(child: _buildButton('Chi Nhánh', () async {
                          List<Map<String, Point>> newAddresses = await DioTest.postBranchATMTypeThree(locations[provinceChose]!.regionCode1,
                              locations[provinceChose]!.Ddistrict.values.first.districtCode);
                          setState(() {
                            address = newAddresses;
                            markers = _setMarkers(); // Cập nhật lại markers khi danh sách address được cập nhật
                          });
                        })),
                      ],
                    ),
                ),

                    Expanded(
                        child: ListView(
                      controller: scrollController,
                  children: address.map((e) => AddressFormWidget(icon: AssetPath.icoSo, title: 'Chi nhánh VRB sở giao dich', description: e.keys.toString())).toList(),

                    ))
                  ],

                ),
              );
            },
          )
        ],
      ),
    );
  }
  Widget _buildButton(String title, VoidCallback onPressed){
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white70.withOpacity(0.2), // Đổi màu nền ở đây
        padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10), // Có thể thêm các thuộc tính khác nếu cần
        shape: RoundedRectangleBorder(
          // Tạo hình dạng chữ nhật
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 12, color: Colors.white,),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> getLocationUpdate() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if(_serviceEnabled){
      _serviceEnabled = await _locationController.requestService();
    }else{
      return;
    }
    _permissionGranted = await _locationController.hasPermission();
    if(_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await _locationController.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return;
      }
    }
    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if(currentLocation.latitude != null && currentLocation.longitude != null){
        setState(() {
          _currentLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          print('toa ho hien tai la $_currentLocation');
        });
      }
    }
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vrb_client/core/constants/dimension_constants.dart';
import 'package:vrb_client/representation/widgets/select_item_widget.dart';

import '../../core/constants/assets_path.dart';

class AccountBalanceWidget extends StatefulWidget {
  const AccountBalanceWidget({super.key, required this.accountNumber});
  final String accountNumber;
  @override
  State<AccountBalanceWidget> createState() => _AccountBalanceWidgetState();
}

class _AccountBalanceWidgetState extends State<AccountBalanceWidget> {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height / 12,
      decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5), // Màu và độ trong suốt của bóng
          spreadRadius: 5, // Độ rộng của bóng
          blurRadius: 7, // Độ mờ của bóng
          offset: Offset(0, 3),
        )
          ]
      ),

      child: Row(
        children: [
          const SizedBox(
            width: kDefaultPadding,
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tài khoản",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              SelectItemWidget(selectedValue: '100068890')
            ],
          ),
          // SizedBox(width: size.width / 5.5,),
          Spacer(),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(10), // Độ cong của các góc
            ),

            child: ElevatedButton(
              onPressed: () {
                // Xử lý khi button được nhấn
              },
              style: ElevatedButton.styleFrom(
                elevation: 0, // Loại bỏ bóng đổ
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Độ cong của các góc
                ),
              ),
              child: Text(
                'Danh Sách',
                style: TextStyle(
                  color: Colors.blue.shade900, // Màu chữ của button
                  fontSize: 14,
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}

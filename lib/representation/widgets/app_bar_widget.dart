import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vrb_client/generated/locale_keys.g.dart';
import 'package:vrb_client/representation/widgets/search_widget.dart';

import '../../core/constants/assets_path.dart';
import '../../models/user_model.dart';
import '../../provider/dialog_provider.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget(
      {super.key,
      required this.fullName,
      required this.avatar,
      required this.child});
  final String fullName;
  final String avatar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: false,
      body: Stack(
        children: [
          SafeArea(
            child: SizedBox(
              height: size.height / 2.8,
              child: AppBar(
                flexibleSpace: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF19226D).withOpacity(0.9),
                          Color(0xFFED1C24).withOpacity(0.8),
                        ],
                        stops: [0.5, 1],
                      )),
                    ),
                    Positioned(
                      right: 0,
                      child: Image.asset(AssetPath.icoBlockWhite,
                          color: Colors.grey.withOpacity(0.3)),
                    ),

                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        AssetPath.hv,
                        width: double
                            .infinity, // Đặt chiều rộng của hình ảnh là đủ rộng để tràn hết container
                        height: size.height / 3.2, fit: BoxFit.fill,
                      ),
                    ),

                    Positioned(
                      child: Row(
                        children: [
                          Image.asset(AssetPath.logoBankVRB),
                          Spacer(),
                          SizedBox(
                            width: size.width * 0.57,
                            child: SearchWidget(),
                          )

                          // Spacer(),
                          // SearchWidget()
                        ],
                      ),
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                           Text(
                            LocaleKeys.hi.tr(),
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          Text(
                            fullName,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: 80, // Đảm bảo kích thước của ảnh bằng nhau
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white, // Màu nền của hình tròn
                            ),
                            child: ClipOval(
                              child: InkWell(
                                onTap: () async {
                                  Provider.of<UserModel>(context, listen: false).pickAndSetAvatar(context);
                                },
                                child: (avatar == AssetPath.avatar) ? Image.asset(avatar) : Image.file(File(avatar)),
                              ),
                            ),
                          )

                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height / 3),
            padding: const EdgeInsets.all(10),
            child: child,
          )
        ],
      ),
    );
  }
}

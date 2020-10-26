import 'package:cal4u/Screens/AddEventScreen.dart';
import 'package:cal4u/helpers/CartHelper.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ChoosePics extends StatefulWidget {
  @override
  _ChoosePicsState createState() => _ChoosePicsState();
}

class _ChoosePicsState extends State<ChoosePics> {
  final dataSource = [
    ChooseNameImage('Google', 'images/googleWhite.png'),
    ChooseNameImage('Icloud', 'images/icloudIcon.png'),
    ChooseNameImage('ONE', 'images/oneDriveIcon.png'),
    ChooseNameImage('דרופובקס', 'images/dropboxIcon.png'),
    ChooseNameImage('מכשיר', 'images/phoneIcon.png'),
  ];
  var _isLoading = false;
  List<Asset> choosedImages = [];
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: commonAppbar(context),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'בחירת תמונות',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w800,
                          fontSize: 70.sp),
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Expanded(
                      child: ListView.separated(
                    itemCount: dataSource.length,
                    separatorBuilder: (a, v) => SizedBox(height: 50.h),
                    itemBuilder: (c, i) => RaisedButton(
                      color: Theme.of(context).buttonColor,
                      shape: StadiumBorder(),
                      onPressed: () async {
                        if (i == 4) {
                          choosedImages = await MultiImagePicker.pickImages(
                            maxImages: 13,
                            enableCamera: false,
                            selectedAssets: choosedImages,
                            cupertinoOptions:
                                CupertinoOptions(takePhotoIcon: "chat"),
                            materialOptions: MaterialOptions(
                              actionBarColor: "#f0ae34",
                              actionBarTitle: "",
                              allViewTitle: "All Photos",
                              useDetailsView: false,
                              selectCircleStrokeColor: "#f03434",
                              textOnNothingSelected: '',
                            ),
                          );
                          if (choosedImages.length == 13) {
                            carthelper.choosedImages.clear();
                            choosedImages.forEach((e) async {
                              final data = await e.getByteData();
                              carthelper.choosedImages
                                  .add(data.buffer.asUint8List());
                            });

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (c) => AddEventScreen()));
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Please select 13 images');
                          }
                        }
                      },
                      child: SizedBox(
                        height: 180.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dataSource[i].title,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 50.sp),
                            ),
                            SizedBox(width: 50.w),
                            Image.asset(
                              dataSource[i].image,
                              width: 100.w,
                              height: 100.w,
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
                  AppTabBar()
                ],
              ),
            ),
    );
  }
}

class ChooseNameImage {
  final String title;
  final String image;

  ChooseNameImage(this.title, this.image);
}

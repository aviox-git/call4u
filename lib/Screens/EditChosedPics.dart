import 'dart:io';
import 'dart:typed_data';
import 'package:cal4u/Screens/CalendarPreviewScreen.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cal4u/helpers/CartHelper.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditChosedPic extends StatefulWidget {
  @override
  _EditChosedPicState createState() => _EditChosedPicState();
}

class _EditChosedPicState extends State<EditChosedPic> {
  final _picker = ImagePicker();
  var chooseImages =
      List.generate(13, (index) => carthelper.choosedImages[index]);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
        appBar: commonAppbar(context),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              TitleRedText(text: 'עריכת תמונות'),
              SizedBox(height: 50.h),
              SizedBox(
                width: 1.wp,
                height: 1.2.wp,
                child: CachedNetworkImage(
                  placeholder: (a, b) => ImagePlaceholder(),
                  errorWidget: (a, b, c) => ImagePlaceholder(),
                  fit: BoxFit.fill,
                  imageUrl: carthelper.calenderTemplate.image,
                  imageBuilder: (c, p) => Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).buttonColor, width: 2)),
                      child: Image(image: p)),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.centerRight,
                child: Text(
                  'תבנית של חוף הים',
                  textAlign: TextAlign.end,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 50.sp),
                ),
              ),
              GridView.builder(
                  shrinkWrap: true,
                  itemCount: chooseImages.length,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  itemBuilder: (c, i) {
                    if (chooseImages[i] == null) {
                      return addImage(i);
                    } else {
                      return editChosedPicCell(
                          image: chooseImages[i], index: i);
                    }
                  }),
              SizedBox(height: 50.h),
              AppRaisedButton(
                title: 'הבא',
                onTap: chooseImages.contains(null)
                    ? null
                    : () {
                        carthelper.choosedImages = chooseImages;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (c) => CalendarPreviewScreen()));
                      },
              ),
            ],
          ),
        ));
  }

  Widget editChosedPicCell({@required Uint8List image, @required int index}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Stack(
        children: [
          SizedBox.expand(
            child: Image.memory(image, fit: BoxFit.cover),
          ),
          Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _editImageTapped(image, index),
                  icon: Image.asset(
                    'images/picEdit.png',
                    width: 40,
                    height: 40,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    this.chooseImages.replaceRange(index, index + 1, [null]);
                    setState(() {});
                  },
                  icon: Image.asset(
                    'images/picDelete.png',
                    width: 40,
                    height: 40,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _editImageTapped(Uint8List image, int index) async {
    final directory = await path.getTemporaryDirectory();
    final myImagePath = '${directory.path}/cal/1' + ".jpg";
    final imageFile = await File(myImagePath).create(recursive: true);
    imageFile.writeAsBytesSync(image);
    final croppedImageFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cal4U',
            toolbarColor: Color(0xfff0ae34),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedImageFile != null) {
      final image1 = await croppedImageFile.readAsBytes();
      this.chooseImages.replaceRange(index, index + 1, [image1]);
      setState(() {});
    }
  }

  InkWell addImage(int index) {
    return InkWell(
      onTap: () async {
        final imageGot = await _picker.getImage(source: ImageSource.gallery);
        final image = await imageGot.readAsBytes();
        this.chooseImages.replaceRange(index, index + 1, [image]);
        setState(() {});
      },
      child: Container(
        color: Colors.blue[100],
        child: Container(
          padding: const EdgeInsets.all(20),
          color: Colors.black12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'תמונה ברזולוציה נמוכה',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.sp,
                    fontWeight: FontWeight.w500),
              ),
              Image.asset('images/imageUpload.png', width: 40, height: 40)
            ],
          ),
        ),
      ),
    );
  }
}

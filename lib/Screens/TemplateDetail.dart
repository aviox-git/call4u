import 'package:cached_network_image/cached_network_image.dart';
import 'package:cal4u/Models/GetCalenderModel.dart';
import 'package:cal4u/Screens/AddEventScreen.dart';
import 'package:cal4u/Screens/ChooseTemplate.dart';
import 'package:cal4u/helpers/CartHelper.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TemplateDetail extends StatefulWidget {
  @override
  _TemplateDetailState createState() => _TemplateDetailState();
}

class _TemplateDetailState extends State<TemplateDetail> {
  int _selectedIndex;
  List<Calender> data;
  Future<GetCalender> getCal;
  bool _isLoading = false;
  @override
  void initState() {
    getCal = GetCalender.get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Image.asset('images/backArrow.png'),
              onPressed: () => Navigator.of(context).pop())
        ],
        automaticallyImplyLeading: false,
        title: Text(
          'תבנית של חוף הים',
          textAlign: TextAlign.end,
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 80.sp),
        ),
        bottom: PreferredSize(
            child: Container(
                height: 15.h,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color(0xffFAB61F),
                  Color(0xffE1241F),
                ]))),
            preferredSize: Size.fromHeight(15.h)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    'גולר מונפרר סוברט לורם שבצק יהול, לכנוץ בעריר גק ליץ, ושבעגט ליבם סולגק. בראיט ולחת צורק מונחף, בגורמי מגמש. תרבנך וסתעד לכנו סתשם השמה - לתכי מורגם בורק? לתיג ישבעס.',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 45.sp),
                  ),
                  SizedBox(height: 50.h),
                  CachedNetworkImage(
                    imageUrl: carthelper.calenderTemplate.image,
                    placeholder: (a, b) => ImagePlaceholder(),
                    imageBuilder: (c, p) => Container(
                        width: 1.wp,
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).buttonColor,
                                width: 2)),
                        child: Image(
                          image: p,
                          fit: BoxFit.fill,
                        )),
                  ),
                  SizedBox(height: 50.h),
                  AppRaisedButton(
                    title: 'בחירה',
                    onTap: () => _choosePics(),
                  ),
                  SizedBox(height: 50.h),
                  FutureBuilder<GetCalender>(
                      future: getCal,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        data = snapshot.data?.data ?? [];
                        return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 2,
                                    childAspectRatio: 3 / 5),
                            itemCount: data.length,
                            itemBuilder: (c, i) => InkWell(
                                  onTap: () =>
                                      setState(() => _selectedIndex = i),
                                  child: CalTemplate(
                                    calender: data[i],
                                    isselected: i == _selectedIndex,
                                  ),
                                ));
                      }),
                  SizedBox(height: 50.h),
                  AppRaisedButton(
                    title: 'בחירה',
                    onTap: () {
                      if (_selectedIndex == null) {
                        Fluttertoast.showToast(msg: 'please select a calendar');
                      }
                      carthelper.calenderTemplate = data[_selectedIndex];
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (c) => TemplateDetail()));
                    },
                  ),
                  SizedBox(height: 50.h),
                ],
              )),
    );
  }

  void _choosePics() async {
    setState(() => _isLoading = true);
    final files = await FilePicker.getMultiFile(type: FileType.image);
    if (files?.length == 13) {
      carthelper.choosedImages.clear();
      files.forEach((e) async {
        final data = await e.readAsBytes();
        carthelper.choosedImages.add(data.buffer.asUint8List());
      });
      setState(() => _isLoading = false);

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (c) => AddEventScreen()));
    } else {
      setState(() => _isLoading = false);
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              content: Text('אנא בחר 13 תמונות'),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('בסדר',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold)))
              ],
            );
          });
    }
  }
}

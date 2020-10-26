import 'package:cached_network_image/cached_network_image.dart';
import 'package:cal4u/Models/GetCalenderModel.dart';
import 'package:cal4u/Screens/TemplateDetail.dart';
import 'package:cal4u/helpers/CartHelper.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChooseTemplate extends StatefulWidget {
  @override
  _ChooseTemplateState createState() => _ChooseTemplateState();
}

class _ChooseTemplateState extends State<ChooseTemplate> {
  var data = GetCalender.get();
  List<Calender> list = [];
  int selectedIndex;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: commonAppbar(context),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              TitleRedText(text: 'בחירת תבנית'),
              FutureBuilder<GetCalender>(
                  future: data,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    list = snapshot.data?.data ?? [];
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 5),
                        itemCount: list.length,
                        itemBuilder: (c, i) => InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = i;
                              });
                            },
                            child: CalTemplate(
                              calender: list[i],
                              isselected: selectedIndex == i,
                            )));
                  }),
              SizedBox(height: 50.h),
              AppRaisedButton(
                title: 'בחירה',
                onTap: () {
                  if (selectedIndex == null) {
                    Fluttertoast.showToast(msg: 'Please select a template');
                    return;
                  }
                  carthelper.calenderTemplate = list[selectedIndex];
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (c) => TemplateDetail()));
                },
              ),
              SizedBox(height: 50.h),
              AppTabBar()
            ],
          )),
    );
  }
}

class CalTemplate extends StatelessWidget {
  final Calender calender;
  final bool isselected;
  const CalTemplate({Key key, this.calender, this.isselected = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: CachedNetworkImage(
          placeholder: (a, b) => ImagePlaceholder(),
          fit: BoxFit.fill,
          imageUrl: calender.image,
          imageBuilder: (c, p) => Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: isselected
                          ? Theme.of(context).buttonColor
                          : Colors.transparent,
                      width: 2)),
              child: Image(image: p, fit: BoxFit.fill)),
        )),
        Row(
          children: [
            Expanded(
              child: Text(
                calender.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.sp),
              ),
            ),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1)]),
                width: 100.w,
                height: 100.w,
                child: IconButton(
                    icon: Image.asset('images/viewIcon.png'),
                    onPressed: () {
                      carthelper.calenderTemplate = calender;
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (c) => TemplateDetail()));
                    })),
          ],
        )
      ],
    );
  }
}

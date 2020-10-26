import 'package:cached_network_image/cached_network_image.dart';
import 'package:cal4u/Models/GetCouponsModel.dart';
import 'package:cal4u/Models/GetProductModel.dart';
import 'package:cal4u/Screens/ChooseTemplate.dart';
import 'package:cal4u/Screens/ChooseTemplateCompany.dart';
import 'package:cal4u/helpers/CartHelper.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<GetProduct> data;
  int selectedIndex;
  List<Product> products;
  var _isLoading = false;

  @override
  void initState() {
    data = GetProduct.get(context);
    super.initState();
    carthelper.calenderType = null;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [topHeader(), buildMainContent(context)],
              ),
            ),
    );
  }

  Padding buildMainContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 30.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'בחירת סוג אלבום',
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w800,
                  fontSize: 70.sp),
            ),
          ),
          SizedBox(height: 10.h),
          FutureBuilder<GetProduct>(
              future: data,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(snapshot.error.toString()),
                    ),
                  );
                }
                products = snapshot.data.data;
                return GridView.builder(
                  itemCount: products?.length ?? 0,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3 / 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2),
                  itemBuilder: (c, i) => InkWell(
                    onTap: () => setState(() => selectedIndex = i),
                    child: buildSizeOption(
                        products.reversed.toList()[i], selectedIndex == i),
                  ),
                );
              }),
          SizedBox(height: 50.h),
          AppRaisedButton(
            title: 'הבא',
            onTap: () {
              if (selectedIndex == null) {
                Fluttertoast.showToast(msg: 'Please select a size');
                return;
              }
              Carthelper().calenderType =
                  products.reversed.toList()[selectedIndex];
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => ChooseTemplate()));
            },
          ),
          SizedBox(height: 50.h),
          AppTabBar()
        ],
      ),
    );
  }

  Widget buildSizeOption(Product product, bool isSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CachedNetworkImage(
            placeholder: (c, a) => ImagePlaceholder(),
            imageUrl: product.image,
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
            imageBuilder: (c, p) => Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: isSelected
                            ? Theme.of(context).buttonColor
                            : Colors.transparent,
                        width: 2)),
                child: Image(
                  image: p,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                )),
          ),
        ),
        Text(
          "מחיר ${product.price} ₪",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 50.sp,
          ),
        )
      ],
    );
  }

  Widget topHeader() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Image.asset(
            'images/homeTopBackground.png',
            height: 0.5.hp,
            width: 1.wp,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Column(
            children: [
              SafeArea(
                child: Image.asset('images/headerLogoWhite.png',
                    height: 140.w, fit: BoxFit.fitHeight),
              ),
              Expanded(
                  child: Row(
                children: [
                  SizedBox(width: 70.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'לורם איפסום דולור סיט אמט',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 80.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'לורם איפסום דולור סיט אמט, צש בליא, מנסוטו צמלח לביקו ננבי, צמוקו בלוקריה שיצמה ברורק.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8, right: 150.w),
                    child: Image.asset('images/homeheaderCal.png'),
                  ),
                ],
              )),
              RaisedButton(
                  shape: StadiumBorder(),
                  color: Colors.red,
                  padding:
                      EdgeInsets.symmetric(vertical: 50.w, horizontal: 180.w),
                  onPressed: () async {
                    if (selectedIndex == null) {
                      Fluttertoast.showToast(msg: 'Please select a size');
                      return;
                    }

                    setState(() => _isLoading = true);
                    final coupons = await GetFreeTemplate.get();
                    setState(() => _isLoading = false);
                    final coupon = coupons.data?.first?.calender;
                    if (coupon == null) {
                      Fluttertoast.showToast(
                          msg: "No Coupon available",
                          toastLength: Toast.LENGTH_LONG);
                    } else {
                      Carthelper().calenderType =
                          products.reversed.toList()[selectedIndex];
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) =>
                              ChooseTemplateCompany(calender: coupon)));
                    }
                  },
                  child: Text(
                    'קופן חברה',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 60.sp),
                  )),
            ],
          ),
        )
      ],
    );
  }
}

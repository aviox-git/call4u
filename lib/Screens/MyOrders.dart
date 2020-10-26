import 'package:cached_network_image/cached_network_image.dart';
import 'package:cal4u/Models/GetCalenderModel.dart' as cal;
import 'package:cal4u/Models/MyOrdersModel.dart';
import 'package:cal4u/Screens/CartScreen.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

class MyOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(context),
      body: Column(
        children: [
          TitleRedText(text: 'ההזמנות שלי'),
          Expanded(
            child: FutureBuilder<MyOrdersModel>(
                future: MyOrdersModel.getOrders(),
                builder: (context, ordersSnapshot) {
                  if (ordersSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (ordersSnapshot.hasError) {
                    return ErrorTextWithBack(
                        errorMessage: ordersSnapshot.error.toString());
                  } else if (ordersSnapshot.data?.order?.isEmpty ?? true) {
                    return ErrorTextWithBack(errorMessage: 'לא נמצאה הזמנה');
                  }
                  return ListView.separated(
                      padding: EdgeInsets.all(8),
                      itemCount: ordersSnapshot.data.order.length,
                      separatorBuilder: (c, i) => Divider(thickness: 2),
                      itemBuilder: (c, i) {
                        final order = ordersSnapshot.data.order[i];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (order.calender.isNotEmpty)
                            SizedBox(
                                height: 150,
                                width: 100,
                                child: CachedNetworkImage(
                                    placeholder: (a, b) => ImagePlaceholder(),
                                    fit: BoxFit.fill,
                                    imageUrl:
                                        order.calender.first.template?.image ?? "")),
                            SizedBox(width: 50.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (order.calender.isNotEmpty)
                                Text(order.calender.first.template.name),
                                if (order.createdAt != null)
                                  Text(intl.DateFormat('dd/MM/yyyy')
                                      .format(order.createdAt)),
                                Text('הזמנה ${order.id}'),
                                RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5)),
                                    color: Theme.of(context).buttonColor,
                                    disabledColor: Theme.of(context)
                                        .buttonColor
                                        .withAlpha(100),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20.w, horizontal: 50.w),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (c) => CartScreen(
                                                      repeatOrder: order)),
                                              (route) => false);
                                    },
                                    child: Text(
                                      'הזמנה חוזרת',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 60.sp),
                                    ))
                              ],
                            )
                          ],
                        );
                      });
                }),
          ),
          AppTabBar(selectedIndex: 2)
        ],
      ),
    );
  }
}

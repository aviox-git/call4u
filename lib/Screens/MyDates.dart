import 'package:cal4u/Models/MydatesModel.dart';
import 'package:cal4u/Models/SavedEvent.dart';
import 'package:cal4u/helpers/CartHelper.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

class MyDatesScreen extends StatelessWidget {
  final bool isEventNeed;

  const MyDatesScreen({Key key, this.isEventNeed = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(context),
      body: FutureBuilder<MyDatesModel>(
          future: MyDatesModel.getEvent(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return ErrorTextWithBack(errorMessage: snapshot.error.toString());
            } else if (snapshot.data?.event?.isEmpty ?? true) {
              return ErrorTextWithBack(errorMessage: 'טרם נוסף תאריך אירוע');
            }
            final events = snapshot.data.event;
            return Column(
              children: [
                TitleRedText(text: 'התאריכים שלי'),
                Text(
                  events.first.date == null
                      ? ""
                      : intl.DateFormat('yyyy').format(events.first.date),
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w800,
                      fontSize: 100.sp),
                ).rightAligned(),
                Expanded(
                  child: ListView.separated(
                      padding: EdgeInsets.all(8),
                      itemCount: events.length,
                      separatorBuilder: (c, i) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(thickness: 2),
                          ),
                      itemBuilder: (c, i) => ListTile(
                            title: Text(
                                events[i].date == null
                                    ? ""
                                    : intl.DateFormat('MMM', 'he')
                                        .format(events[i].date),
                                style: TextStyle(
                                    color: Theme.of(context).buttonColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 60.sp)),
                            subtitle: Row(
                              children: [
                                Stack(
                                  children: [
                                    Image.asset('images/calendarYellow.png',
                                        width: 25, height: 25),
                                    Text(
                                            events[i].date == null
                                                ? ""
                                                : intl.DateFormat('d')
                                                    .format(events[i].date),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .buttonColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 40.sp))
                                        .padding(
                                            EdgeInsets.only(right: 8, top: 6)),
                                  ],
                                ),
                                SizedBox(width: 12),
                                Text(events[i].title ?? ""),
                                Spacer(),
                                if (isEventNeed)
                                  InkWell(
                                    onTap: () {
                                      final event = SavedEvent(
                                          title: events[i].title,
                                          date: events[i].date);
                                      carthelper.events.add(event);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('בחר',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).buttonColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 60.sp)),
                                  ),
                              ],
                            ),
                          )),
                ),
                if (!isEventNeed) AppTabBar(selectedIndex: 2)
              ],
            );
          }),
    );
  }
}

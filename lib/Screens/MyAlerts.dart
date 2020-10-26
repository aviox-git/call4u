import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter/material.dart';

class MyAlerts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(context),
      body: Column(
        children: [
          TitleRedText(text: 'ההזמנות שלי').padding(EdgeInsets.all(10)),
          Expanded(
            child: ListView.separated(
                padding: EdgeInsets.all(8),
                itemCount: 5,
                separatorBuilder: (c, i) => Divider(thickness: 2),
                itemBuilder: (c, i) => ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey, blurRadius: 1)
                          ],
                        ),
                        child: Image.asset('images/shippingVan.png',
                            width: 25, height: 25),
                      ),
                      title: Text('בעוד XX ימים הלוח השנה יגיע אליך'),
                      subtitle: Text('14/05/2020, 18:57'),
                    )),
          ),
          AppTabBar(selectedIndex: 2)
        ],
      ),
    );
  }
}

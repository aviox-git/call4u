import 'dart:io';
import 'package:cal4u/Models/SavedEvent.dart';
import 'package:cal4u/Models/getNewEventData.dart';
import 'package:cal4u/Screens/EditChosedPics.dart';
import 'package:cal4u/Screens/MyDates.dart';
import 'package:cal4u/helpers/CartHelper.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  var _isLoading = false;
  List<AnnualDate> annualDate = [];
  List<Category> cities = [];
  List<Category> categories = [];
  var _showEvents = false;
  var _isSelectCityEnable = true;
  var _isHebrewDates = true;
  File _pickedImageFile;
  final _imagePicker = ImagePicker();
  final _selectedDateTextController = TextEditingController();
  int _selectedCityIndex;
  final _selectedCityTextController = TextEditingController();
  final _aniversaryTextController = TextEditingController();
  final _categoryTextController = TextEditingController();
  int _selectedCatIndex;
  var _isEventAdded = false;

  final _titleTextControler = TextEditingController();
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    setState(() => _isLoading = true);
    final data = await GetNewEventData.get().catchError((onError) {
      print(onError);
      setState(() => _isLoading = false);
    });
    annualDate = data?.annualDate ?? [];
    cities = data?.city ?? [];
    cities.removeWhere((element) => element.id == 7);
    categories = data?.category ?? [];
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: commonAppbar(context),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : buildMainContent(),
    );
  }

  SingleChildScrollView buildMainContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          TitleRedText(text: 'בחירת אירועים'),
          buildTitleStripe(),
          fieldTitle('תאריכים עבריים'),
          SizedBox(height: 50.h),
          Row(
            children: [
              InkWell(
                  onTap: () {
                    setState(() => _isHebrewDates = true);
                  },
                  child:
                      RadioButtonTitle(selected: _isHebrewDates, title: 'כן')),
              SizedBox(width: 300.w),
              InkWell(
                  onTap: () {
                    setState(() => _isHebrewDates = false);
                  },
                  child:
                      RadioButtonTitle(selected: !_isHebrewDates, title: 'לא')),
            ],
          ),
          SizedBox(height: 50.h),
          Divider(thickness: 1),
          SizedBox(height: 50.h),
          fieldTitle('כניסת יציאת שבת'),
          SizedBox(height: 50.h),
          Row(
            children: [
              InkWell(
                  onTap: () => setState(() => _isSelectCityEnable = true),
                  child: RadioButtonTitle(
                      selected: _isSelectCityEnable, title: 'כן')),
              SizedBox(width: 300.w),
              InkWell(
                  onTap: () {
                    setState(() => _isSelectCityEnable = false);
                  },
                  child: RadioButtonTitle(
                      selected: !_isSelectCityEnable, title: 'לא')),
            ],
          ),
          if (_isSelectCityEnable) SizedBox(height: 50.h),
          if (_isSelectCityEnable)
            DropDownTextField(
                hintText: 'בחירת לפי עיר',
                controller: _selectedCityTextController,
                onTap: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (c) => ListDropDown(
                            nameList: cities.map((e) => e.name).toList(),
                            ontap: (i) {
                              _selectedCityIndex = i;
                              _selectedCityTextController.text =
                                  cities.map((e) => e.name).toList()[i];
                              Navigator.of(context).pop();
                            },
                          ));
                }),
          SizedBox(height: 50.h),
          Divider(thickness: 1),
          fieldTitle('רשימת ימי שנה'),
          SizedBox(height: 50.h),
          DropDownTextField(
            hintText: 'רשימת ימי שנה',
            controller: _aniversaryTextController,
            onTap: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (c) => ListDropDown(
                        nameList: annualDate.map((e) => e.title).toList(),
                        ontap: (i) {
                          annualDate[i].isSelected = !annualDate[i].isSelected;
                          _aniversaryTextController.text = annualDate
                              .where((element) => element.isSelected)
                              .map((e) => e.title)
                              .toList()
                              .join(", ");
                          Navigator.of(context).pop();
                        },
                      ));
            },
          ),
          SizedBox(height: 50.h),
          Divider(thickness: 1),
          SizedBox(height: 100.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              fieldTitle('משיכת ימי הולדת מפייסבוק'),
              yelloButton(text: 'לפתוח', onTap: () {
                
              }),
            ],
          ),
          SizedBox(height: 100.h),
          Divider(thickness: 1),
          SizedBox(height: 50.h),
          fieldTitle('הוספת אירוע ידני'),
          if (_showEvents) addedEvent(),
          fieldSubtitle('קטגוריה'),
          DropDownTextField(
            hintText: 'יום הולדת',
            controller: _categoryTextController,
            onTap: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (c) => ListDropDown(
                        nameList: categories.map((e) => e.name).toList(),
                        ontap: (i) {
                          _selectedCatIndex = i;
                          _categoryTextController.text =
                              categories.map((e) => e.name).toList()[i];
                          Navigator.of(context).pop();
                        },
                      ));
            },
          ),
          SizedBox(height: 50.h),
          fieldSubtitle('כותרת'),
          AppTextField(hintText: 'יום הולדת', controller: _titleTextControler),
          SizedBox(height: 50.h),
          if (carthelper.calenderType.name == "A3") fieldSubtitle('תמונה'),
          if (carthelper.calenderType.name == "A3") browseImage(),
          SizedBox(height: 50.h),
          fieldSubtitle('תאריך'),
          DropDownTextField(
            controller: _selectedDateTextController,
            hintText: '28/02/2021',
            onTap: () async {
              final now = DateTime.now();
              final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: DateTime(now.year, 1, 1),
                  lastDate: DateTime(now.year, 12, 31));
              final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd');
              _selectedDateTextController.text = formatter.format(selectedDate);
            },
            icon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'images/calendarYellow.png',
                  width: 10.w,
                  height: 10.w,
                )),
          ),
          SizedBox(height: 50.h),
          Row(
            children: [
              yelloButton(
                  text: 'אישור',
                  onTap: _isEventAdded ? null : () => _saveEvent()),
              SizedBox(width: 10),
              if (_isEventAdded)
                Text(
                  'האירוע הוסף בהצלחה',
                  style: TextStyle(
                      color: Color(0xff2D82E6),
                      fontSize: 45.sp,
                      fontWeight: FontWeight.w600),
                ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () => _addNewEvent(),
                  child: AddCalendarImageText(text: 'הוסף חדש')),
              InkWell(
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (c) => MyDatesScreen(isEventNeed: true)));
                    _addNewEvent();
                  },
                  child:
                      AddCalendarImageText(text: 'הוסף מהאירועים השמורים שלי')),
            ],
          ),
          SizedBox(height: 50.h),
          AppRaisedButton(
            title: 'הבא',
            onTap: () => _saveDataAndMove(),
          ),
          SizedBox(height: 50.h),
          AppTabBar()
        ],
      ),
    );
  }

  void _addNewEvent() {
    _showEvents = true;
    _isEventAdded = false;
    _titleTextControler.clear();
    _selectedDateTextController.clear();
    _pickedImageFile = null;
    _selectedCatIndex = null;
    _categoryTextController.clear();
    setState(() {});
  }

  void _saveEvent() async {
    if (_selectedCatIndex == null) {
      Fluttertoast.showToast(msg: 'Please select a category');
      return;
    }
    if (_titleTextControler.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter the title');
      return;
    }
    if (_selectedDateTextController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select a date');
      return;
    }
    if (_isSelectCityEnable && _selectedCityIndex == null) {
      Fluttertoast.showToast(msg: 'Please select city');
      return;
    }

    final event = SavedEvent(
        selectedCategory: categories[_selectedCatIndex],
        title: _titleTextControler.text,
        date: DateTime.parse(_selectedDateTextController.text),
        selectedImage: _pickedImageFile);
    carthelper.events.add(event);
    _isEventAdded = true;
    setState(() {});
  }

  void _saveDataAndMove() {
    if (_isSelectCityEnable && _selectedCityIndex == null) {
      Fluttertoast.showToast(msg: 'Please select a city');
      return;
    }
    if (annualDate.where((element) => element.isSelected).isEmpty) {
      Fluttertoast.showToast(msg: 'Please select Annual');
      return;
    }
    carthelper.annualDates =
        annualDate.where((element) => element.isSelected).toList();
    carthelper.isHebrew = _isHebrewDates;
    carthelper.isSelectedCity = _isSelectCityEnable;
    carthelper.selectedCity =
        _isSelectCityEnable ? cities[_selectedCityIndex] : null;

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (c) => EditChosedPic()));
  }

  Widget browseImage() {
    return InkWell(
      onTap: () async {
        final pick = await _imagePicker.getImage(source: ImageSource.gallery);
        _pickedImageFile = File(pick.path);
        setState(() {});
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          DropDownTextField(hintText: 'יום הולדת'),
          Container(
            height: 160.w,
            width: 300.w,
            decoration: BoxDecoration(
                color: Color(0xFFF7F6F6),
                boxShadow: [
                  BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: 2),
                ],
                borderRadius: BorderRadius.circular(150.w)),
            child: Center(child: Text('Browse')),
          ),
        ],
      ),
    );
  }

  Widget addedEvent() {
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: carthelper.events.length,
        separatorBuilder: (c, i) => SizedBox(height: 50.h),
        itemBuilder: (context, i) {
          final event = carthelper.events[i];
          final formatter = intl.DateFormat("MMMM");
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).buttonColor, width: 2),
              borderRadius: BorderRadius.circular(50.w),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatter.format(event.date) ?? "",
                  style: TextStyle(
                      color: Theme.of(context).buttonColor,
                      fontSize: 50.sp,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      event.title,
                      style: TextStyle(fontSize: 50.sp),
                    ),
                    SizedBox(width: 10),
                    Image.asset(
                      'images/calendarYellow.png',
                      width: 80.w,
                      height: 80.w,
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  RaisedButton yelloButton({String text, Function onTap}) {
    return RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.w),
        ),
        color: Theme.of(context).buttonColor,
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 60.sp),
        ));
  }

  Widget fieldTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(text,
            style: TextStyle(fontSize: 55.sp, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget fieldSubtitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(text, style: TextStyle(fontSize: 55.sp)),
      ),
    );
  }

  Widget buildTitleStripe() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('images/yellowStripe.png', height: 200.h),
        Container(
          padding: EdgeInsets.fromLTRB(150.w, 10.h, 20.w, 10.h),
          height: 200.h,
          child: Row(
            children: [
              Image.asset('images/heartWhite.png', height: 150.w, width: 150.w),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.w),
                  width: 2,
                  height: 150.w,
                  color: Colors.white),
              Expanded(
                  child: Text(
                "ניתן להוסיף אירועים מיוחדים שחשוב לזכור\n כמו יומהולדת לאמא, פרחים לאשתך או\n"
                "סתם יום שנחמד להיזכר בו",
                style: TextStyle(color: Colors.white, fontSize: 40.sp),
              )),
            ],
          ),
        )
      ],
    );
  }
}

class DropDownTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function onTap;
  final Widget icon;
  const DropDownTextField(
      {Key key,
      @required this.hintText,
      this.controller,
      this.onTap,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: 2)
      ], borderRadius: BorderRadius.circular(100.w), color: Colors.white),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 40.w),
        child: TextField(
          readOnly: true,
          onTap: onTap,
          controller: controller,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              suffixIcon: icon ??
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'images/yellowDownArrow.png',
                      width: 10.w,
                      height: 10.w,
                    ),
                  )),
        ),
      ),
    );
  }
}

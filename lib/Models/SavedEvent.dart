import 'dart:io';

import 'package:cal4u/Models/getNewEventData.dart';

class SavedEvent {
  final Category selectedCategory;
  final String title;
  final DateTime date;
  final File selectedImage;

  SavedEvent(
      {
      this.selectedCategory,
      this.title,
      this.date,
      this.selectedImage});
}

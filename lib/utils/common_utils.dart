import 'dart:io';
import 'dart:math';

import 'package:dailyexpenses/language/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'file:///D:/Development/Live-Project%20Flutter/daily_expenses/lib/data/preferences/preference_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'constants/app_constants.dart';

class CommonUtils {
  static bool isAndroidPlatform() {
    return Platform.isAndroid ? true : false;
  }

  static closeKeyboard(context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Route createRoute(page) {
    /// Open page with default behaviour
    return MaterialPageRoute(builder: (context) => page);

    /// Open page with Animated from bottom.
//    return PageRouteBuilder(
//      transitionDuration: Duration(milliseconds: 700),
//      pageBuilder: (context, animation, secondaryAnimation) => page,
//      transitionsBuilder: (context, animation, secondaryAnimation, child) {
//        var begin = Offset(0.0, 1.0);
//        var end = Offset.zero;
//        var curve = Curves.ease;
//
//        var tween =
//            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//        return SlideTransition(
//          position: animation.drive(tween),
//          child: child,
//        );
//      },
//    );
  }

  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  static Future<File> compressImage(File originalImage) async {
    var decodedImage =
        await decodeImageFromList(originalImage.readAsBytesSync());
    print("Original Image W :: ${decodedImage.width}");
    print("Original Image H :: ${decodedImage.height}");

    print(
        "Original Image size :: ${formatBytes(originalImage.lengthSync(), 3).toString()}");

    File compressedFile = await FlutterNativeImage.compressImage(
        originalImage.path,
        percentage: 30);

    var decodedImageCompress =
        await decodeImageFromList(compressedFile.readAsBytesSync());
    print("Compress Image W :: ${decodedImageCompress.width}");
    print("Compress Image H :: ${decodedImageCompress.height}");

    print(
        "Compress Image size :: ${formatBytes(compressedFile.lengthSync(), 3).toString()}");
    return compressedFile;
  }

  static Future<File> selectImageFromCameraWithCompress() async {
    File selectedImage = await ImagePicker.pickImage(source: ImageSource.camera);

    File compressedFile = await compressImage(selectedImage);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: compressedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
//          CropAspectRatioPreset.ratio3x2,
//          CropAspectRatioPreset.original,
//          CropAspectRatioPreset.ratio4x3,
//          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.lightGreen,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );
    return croppedFile;
  }

  static Future<File> selectImageFromGalleryWithCompress() async {
    File selectedImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    File compressedFile = await compressImage(selectedImage);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: compressedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
//          CropAspectRatioPreset.ratio3x2,
//          CropAspectRatioPreset.original,
//          CropAspectRatioPreset.ratio4x3,
//          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.lightGreen,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );

    return croppedFile;
  }

  static void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  static String getStringFormatDate(DateTime selectedDate) {
    var suffix = "th";
    var digit = selectedDate.day % 10;
    if ((digit > 0 && digit < 4) &&
        (selectedDate.day < 11 || selectedDate.day > 13)) {
      suffix = ["st", "nd", "rd"][digit - 1];
    }

    var formatter = DateFormat("d'$suffix' MMM, yyyy");
    String formatted = formatter.format(selectedDate);
    return formatted;
  }

  static DateTime getDateFromTimestamp(String timestamp) {
    DateTime date =
        new DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);

    return date;
  }

  static String getOnlyDateFromTimestamp(String timestamp) {
    var date = DateFormat('dd').format(
        DateTime.fromMicrosecondsSinceEpoch(int.parse(timestamp) * 1000));
    return date;
  }

  static DateTime getDateTimeFromTimestamp(String timestamp) {
    return DateTime.fromMicrosecondsSinceEpoch(int.parse(timestamp) * 1000);
  }

  static DateTime getDateTimeFromString(String savedDateString) {
    DateTime tempDate =
        new DateFormat("yyyy-MM-dd hh:mm:ss").parse(savedDateString);
    return tempDate;
  }

  static bool isLastMonth(DateTime selectedDateTime) {
    DateTime currentDate = DateTime.now();

    if (currentDate.year == selectedDateTime.year) {
      if (currentDate.year == selectedDateTime.year &&
          currentDate.month > selectedDateTime.month) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  static String getText(context, key) {
    return AppTranslations.of(context).text(key);
  }
}

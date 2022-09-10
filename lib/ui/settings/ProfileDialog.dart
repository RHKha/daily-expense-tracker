import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailyexpenses/app_theme/input_decoration_theme.dart';
import 'package:dailyexpenses/custom_widget/dialogs.dart';
import 'package:dailyexpenses/data/network/network_check.dart';
import 'package:dailyexpenses/utils/app_translate.dart';
import 'package:dailyexpenses/utils/common_utils.dart';
import 'package:dailyexpenses/utils/constants/icon_constants.dart';
import 'package:dailyexpenses/utils/size_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../custom_widget/image_view.dart';

class ProfileDialog extends StatefulWidget {
  final Function updateList;

  final String profilePic;
  final String userName;

  const ProfileDialog(
      {Key key, this.updateList, this.profilePic, this.userName})
      : super(key: key);

  @override
  _ProfileDialogState createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  TextEditingController _controllerValue = TextEditingController();
  TextEditingController _controllerUsername = TextEditingController();

  ThemeData themeData;
  final _formKey = GlobalKey<FormState>();

  String _profilePic = "";
  String _userName = "";
  File _selectedProfilePicFile;

  bool _autoValidate = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore firestoreInstance = Firestore.instance;

  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    _controllerUsername.text = widget.userName;
    _profilePic = widget.profilePic;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeUtils.get(20))),
        title: Text(
          CommonUtils.getText(context, AppTranslate.PROFILE),
          textAlign: TextAlign.center,
          style: themeData.textTheme.display1.copyWith(color: Colors.white),
        ),
        backgroundColor: themeData.primaryColor,
        content: Container(
          width: SizeUtils.screenWidth,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  profileImage(),
                  SizedBox(height: SizeUtils.get(20)),
                  descriptionWidget(),
                  SizedBox(height: SizeUtils.get(20)),
                  buttonOptionsWidget(context)
                ],
              ),
            ),
          ),
        ));
  }

  Widget profileImage() {
    return GestureDetector(
      onTap: () {
        selectImage();
      },
      child: ClipRRect(
        child: Container(
          child: ImageView(
            height: SizeUtils.get(150),
            width: SizeUtils.get(150),
            placeholder: IconConstants.PROFILE_PLACEHOLDER,
            image: _profilePic,
          ),
        ),
        borderRadius: BorderRadius.circular(75),
      ),
    );
  }

  Widget descriptionWidget() {
    return InputTextFieldUtils.inputTextField(
      controller: _controllerUsername,
      label: CommonUtils.getText(context, AppTranslate.USERNAME),
      capsText: true,
      maxLength: 40,
      style:
          TextStyle(fontSize: SizeUtils.getFontSize(18), color: Colors.black),
      onSaved: (value) => _userName = value,
      validator: (value) {
        if (value.isEmpty) {
          return CommonUtils.getText(
              context, AppTranslate.PLEASE_ENTER_USERNAME);
        }
        return null;
      },
    );
  }

  Widget buttonOptionsWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            CommonUtils.getText(context, AppTranslate.CANCEL),
            style: TextStyle(color: Colors.white),
          ),
        ),
        showLoading
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: SizeUtils.get(30)),
                child: CupertinoActivityIndicator(),
              )
            : GestureDetector(
                onTap: () {
                  onClickConfirm(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeUtils.get(10),
                    vertical: SizeUtils.get(5),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      CommonUtils.getText(context, AppTranslate.UPDATE),
                      style: TextStyle(
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeUtils.getFontSize(16)),
                    ),
                  ),
                ),
              )
      ],
    );
  }

  void selectImage() {
    final act = CupertinoActionSheet(
        title: Text(CommonUtils.getText(context, AppTranslate.IMAGE_PICK_TEXT)),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child:
                Text(CommonUtils.getText(context, AppTranslate.OPTION_CAMERA)),
            onPressed: () {
              Navigator.pop(context);
              selectImageFromCamera();
            },
          ),
          CupertinoActionSheetAction(
            child:
                Text(CommonUtils.getText(context, AppTranslate.OPTION_GALLERY)),
            onPressed: () {
              Navigator.pop(context);
              selectImageFromGallery();
            },
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(CommonUtils.getText(context, AppTranslate.CANCEL)),
          onPressed: () {
            Navigator.pop(context);
          },
        ));

    showCupertinoModalPopup(
        context: context, builder: (BuildContext context) => act);
  }

  void selectImageFromGallery() async {
    var selectedImage = await CommonUtils.selectImageFromGalleryWithCompress();
    setState(() {
      _profilePic = selectedImage.path;
      _selectedProfilePicFile = selectedImage;
    });
  }

  void selectImageFromCamera() async {
    var selectedImage = await CommonUtils.selectImageFromCameraWithCompress();
    setState(() {
      _profilePic = selectedImage.path;
      _selectedProfilePicFile = selectedImage;
    });
  }

  Future<void> onClickConfirm(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        showLoading = true;
      });

      NetworkCheck networkCheck = new NetworkCheck();
      final bool isConnect = await networkCheck.check();
      if (!isConnect) {
        Dialogs.showInfoDialog(
            context, CommonUtils.getText(context, AppTranslate.INTERNET_ERROR));
        return;
      }

      FirebaseUser user = await _auth.currentUser();
      String url = widget.profilePic;
      if (_selectedProfilePicFile != null) {
        url = await _uploadFile(_selectedProfilePicFile, user.uid);
      }

      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.photoUrl = url;
      userUpdateInfo.displayName = _userName;
      user.updateProfile(userUpdateInfo);

      firestoreInstance.collection("Users").document(user.uid).updateData({
        "username": _userName,
        "photoUrl": url,
      }).then((_) {
        print("success!");
      });

      setState(() {
        showLoading = false;
      });

      Navigator.pop(context);
      widget.updateList(url, _userName);
    } else {
      _autoValidate = true;
    }
  }

  Future<String> _uploadFile(File file, filename) async {
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance.ref().child("images/$filename");

    final StorageUploadTask uploadTask = storageReference.putFile(file);

    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      // You can use this to notify yourself or your user in any kind of way.
      // For example: you could use the uploadTask.events stream in a StreamBuilder instead
      // to show your user what the current status is. In that case, you would not need to cancel any
      // subscription as StreamBuilder handles this automatically.

      // Here, every StorageTaskEvent concerning the upload is printed to the logs.
      print('EVENT ${event.type}');
      print('EVENT ${event.type.index}');

      print('EVENT bytesTransferred :: ${event.snapshot.bytesTransferred}');
      print('EVENT totalByteCount :: ${event.snapshot.totalByteCount}');
    });

    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    streamSubscription.cancel();
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
    return url;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dailyexpenses/utils/constants/color_constants.dart';
import 'package:dailyexpenses/utils/size_utils.dart';

inputDecorationThemeLight() {
  return InputDecorationTheme(
      border: UnderlineInputBorder(
    borderSide: BorderSide(color: ColorConstants.APP_THEME_COLOR, width: 0.0),
  ));
}

class InputTextFieldUtils {
  static Widget inputTextField(
      {label,
      FocusNode focusNode,
      onFieldSubmitted,
      validator,
      onSaved,
      keyboardType,
      bool isTextInputActionDone = false,
      bool isObscureText = false,
      bool isPasswordType = false,
      onTapVisiblePassword,
      controller,
      maxLength,
      capsText = false,
      style,
      enabled}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeUtils.get(15), vertical: SizeUtils.get(3)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))
//                color: Colors.grey[400], blurRadius: 5, offset: Offset(0, 2))
          ]),
      child: TextFormField(
        enabled: enabled,
        style: style ?? TextStyle(color: Colors.black),
        controller: controller,
        textCapitalization:
            capsText ? TextCapitalization.words : TextCapitalization.none,
        obscureText: isObscureText,
        validator: (value) => validator(value),
        focusNode: focusNode,
        maxLength: maxLength,
        keyboardType: keyboardType,
        cursorColor: ColorConstants.APP_THEME_COLOR,
        onFieldSubmitted: onFieldSubmitted,
        textInputAction:
            isTextInputActionDone ? TextInputAction.done : TextInputAction.next,
        onSaved: (value) {
          onSaved(value);
        },
        decoration: InputDecoration(
            labelText: label,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
            ),
            suffixIcon: isPasswordType
                ? GestureDetector(
                    onTap: onTapVisiblePassword,
                    child: Icon(isObscureText
                        ? Icons.visibility_off
                        : Icons.visibility))
                : Container(width: 0),
            counterText: ''),
      ),
    );
  }
}

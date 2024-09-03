import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remindits/utils/app_colors.dart';

class RoundTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final String icon;
  final TextInputType textInputType;
  final bool isObsecureText;
  final Widget? rightIcon;

  const RoundTextField(
      {super.key,
      this.textEditingController,
      this.validator,
      this.onChanged,
      required this.hintText,
      required this.icon,
      required this.textInputType,
      this.isObsecureText = false,
      this.rightIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.lightGreyColor,
          borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: textInputType,
        obscureText: isObsecureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintText,
          prefixIcon: Container(
            alignment: Alignment.center,
            width: 20,
            height: 20,
            child: SvgPicture.asset(
              "assets/svg/$icon.svg",
              height: 20,
              width: 20,
              fit: BoxFit.contain,
              color: AppColors.textColor1,
            ),
          ),
          suffixIcon: rightIcon,
          hintStyle: TextStyle(
              fontSize: 12,
              color: AppColors.textColor1,
              fontFamily: 'SFProText',
              fontWeight: FontWeight.w400),
        ),
        validator: validator,
      ),
    );
  }
}

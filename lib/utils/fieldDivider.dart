import 'package:expen/utils/size_config.dart';
import 'package:flutter/material.dart';

class FieldDivider extends StatelessWidget {
  final bool superMini;
  final bool mini;
  final bool normal;
  final bool isHorizontal;
  final bool large;
  const FieldDivider(
      {Key key,
      this.superMini = false,
      this.mini = false,
      this.normal = false,
      this.large = false,
      this.isHorizontal = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (superMini)
      return SizedBox(
        width: isHorizontal ? SizeConfig.blockSizeHorizontal * 0.7 : 0,
        height: SizeConfig.blockSizeVertical * 0.7,
      );
    else if (mini) {
      return SizedBox(
        width: isHorizontal ? SizeConfig.blockSizeHorizontal * 1.5 : 0,
        height: SizeConfig.blockSizeVertical * 1.5,
      );
    } else if (normal) {
      return SizedBox(
        width: isHorizontal ? SizeConfig.blockSizeHorizontal * 2 : 0,
        height: SizeConfig.blockSizeVertical * 2,
      );
    } else if (large) {
      return SizedBox(
        width: isHorizontal ? SizeConfig.blockSizeHorizontal * 3.5 : 0,
        height: SizeConfig.blockSizeVertical * 3.5,
      );
    } else {
      return SizedBox(
        width: isHorizontal ? SizeConfig.blockSizeHorizontal * 3 : 0,
        height: SizeConfig.blockSizeVertical * 3,
      );
    }
  }
}

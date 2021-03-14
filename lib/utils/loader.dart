import 'dart:async';

import 'package:expen/utils/size_config.dart';
import 'package:flutter/material.dart';

class ExpenLoader extends StatefulWidget {
  @override
  _ExpenLoaderState createState() => _ExpenLoaderState();
}

class _ExpenLoaderState extends State<ExpenLoader>
    with SingleTickerProviderStateMixin {
  Timer timer;
  bool opacityState = true;
  double height = SizeConfig.blockSizeVertical * 20;

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        opacityState = !opacityState;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("tickeing state = ${timer.tick}");
    height = opacityState
        ? SizeConfig.blockSizeVertical * 25
        : SizeConfig.blockSizeVertical * 20;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Stack(
        children: [
          Container(
            height: SizeConfig.blockSizeVertical * 100,
            width: SizeConfig.blockSizeHorizontal * 100,
            color: Color.fromRGBO(0, 0, 0, 0.3),
          ),
          Center(
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: opacityState ? 1 : 0.6,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: height,
                child: RotationTransition(
                  turns: _animation,
                  child: Image.asset(
                    "assets/images/logo_coin_removed.png",
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

BuildContext expenLoaderContext;

void showExpenLoader(BuildContext context) {
  showDialog(
      context: context,
      builder: (ctx) {
        expenLoaderContext = ctx;
        return ExpenLoader();
      });
}

void popExpenLoader() {
  Navigator.of(expenLoaderContext).pop();
  expenLoaderContext = null;
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:liaou/consts.dart';

class SignalTypeParts extends StatefulWidget {
  SignalTypeParts({Key? key}) : super(key: key);
  @override
  _SignalTypeParts createState() => _SignalTypeParts();
}

class _SignalTypeParts extends State<SignalTypeParts> {
  //   with SingleTickerProviderStateMixin {
  // late final AnimationController _animateController = AnimationController(
  //   duration: const Duration(seconds: 2),
  //   vsync: this,
  // )..repeat(reverse: true);
  // late final Animation<Offset> _offsetAnimation = Tween<Offset>(
  //   begin: Offset.zero,
  //   end: const Offset(0.0, 0.3),
  // ).animate(CurvedAnimation(
  //   parent: _animateController,
  //   curve: Curves.elasticIn,
  // ));

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final Icon _audio = Icon(Icons.volume_up_sharp, size: 60, color: Colors.blue);
  final Icon _flash = Icon(Icons.flash_on, size: 60, color: Colors.red);
  int _signaltypeidx = SignalType.Audio.index;
  var _signaltype;

  @override
  void initState() {
    super.initState();
    _setInitData(); //set stored info
  }

  void _setInitData() async {
    _signaltypeidx = await readSignalTypeParts();
    if (_signaltypeidx <= 0) _signaltypeidx = SignalType.Audio.index;
    _signaltype = getSignalTypeIcon(_signaltypeidx);
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       AnimatedSwitcher(
    //         duration: const Duration(milliseconds: 500),
    //         transitionBuilder: (Widget child, Animation<double> animation) {
    //           return ScaleTransition(child: child, scale: animation);
    //           // final offsetAnimation = TweenSequence([
    //           //   TweenSequenceItem(
    //           //       tween: Tween<Offset>(begin:  Offset.zero, end: Offset(0.0, 1.0)),
    //           //       weight: 1),
    //           //   TweenSequenceItem(tween: ConstantTween(Offset.zero), weight: 3),
    //           //   TweenSequenceItem(
    //           //       tween: Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero),
    //           //       weight: 1)
    //           // ]).animate(animation);
    //           // final offsetAnimation = Tween<Offset>(
    //           //   begin: Offset.zero,
    //           //   end: const Offset(0.0, 0.3),
    //           // ).animate(animation);
    //           // return ClipRect(
    //           //   child: SlideTransition(
    //           //     position: offsetAnimation,
    //           //     child: child,
    //           //   ),
    //           // );
    //         },
    //         child: GestureDetector(
    //           onVerticalDragEnd: (detail) => SignalTypePartsSwiped(detail),
    //           child: _signaltype,
    //           key: ValueKey<int>(_signaltypeidx),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    return Container(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(child: child, scale: animation);
        },
        child: TextButton(
          child: _signaltype,
          onPressed: () => SignalTypePartsSwiped(),
          key: ValueKey<int>(_signaltypeidx),
        ),
      ),
    );
  }

  Widget getSignalTypeIcon(int signaltypeidx) {
    Icon signaltype = _audio;
    if (signaltypeidx == SignalType.Flash.index) signaltype = _flash;
    // return signaltype;
    return Container(
      child: signaltype,
      //child: SlideTransition(position: _offsetAnimation, child: signaltype),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        border: Border.all(
          color: Colors.black,
          // width: 3,
        ),
        borderRadius: BorderRadius.circular(45),
      ),
    );
  }

  //signal type swipped
  // SignalTypePartsSwiped(DragEndDetails detail) {
  SignalTypePartsSwiped() {
    setState(() {
      //   int sensitivity = 8;
      //   if (details.delta.dy > sensitivity) {
      //     // Down Swipe
      //   } else if(details.delta.dy < -sensitivity){
      //     // Up Swipe
      //   }
      // }
      if (_signaltypeidx == SignalType.Audio.index) {
        _signaltypeidx = SignalType.Flash.index;
      } else if (_signaltypeidx == SignalType.Flash.index) {
        _signaltypeidx = SignalType.Audio.index;
      }
      saveSignalTypeParts(_signaltypeidx);
      _signaltype = getSignalTypeIcon(_signaltypeidx);
    }); //save data
  }

  Future<void> saveSignalTypeParts(int signaltypeidx) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(PrefKey.SignalType.toString(), signaltypeidx);
  }

  Future<int> readSignalTypeParts() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(PrefKey.SignalType.toString()) ?? -1;
  }
}

// import 'package:flutter/material.dart';

// class Bouncing extends StatefulWidget {
//   final Widget? child;
//   final VoidCallback? onPress;

//   const Bouncing({@required this.child, Key? key, this.onPress})
//       : assert(child != null),
//         super(key: key);

//   @override
//   _BouncingState createState() => _BouncingState();
// }

// class _BouncingState extends State<Bouncing>
//     with SingleTickerProviderStateMixin {
//   double? _scale;
//   AnimationController? _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 100),
//       lowerBound: 0.0,
//       upperBound: 0.1,
//     );
//     _controller!.addListener(() {
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller!.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _scale = 1 - _controller!.value;
//     return Listener(
//       onPointerDown: (PointerDownEvent event) {
//         if (widget.onPress != null) {
//           _controller!.forward();
//         }
//       },
//       onPointerUp: (PointerUpEvent event) {
//         if (widget.onPress != null) {
//           _controller!.reverse();
//           widget.onPress!();
//         }
//       },
//       child: Transform.scale(
//         scale: _scale!,
//         child: widget.child,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class Bouncing extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget? child;
  final Duration? duration;

  // This will get the data from the pages
  // Makes sure child won't be passed as null
  Bouncing({@required this.child, this.duration, @required this.onTap});

  @override
  BouncingState createState() => BouncingState();
}

class BouncingState extends State<Bouncing>
    with SingleTickerProviderStateMixin {
  late double _scale;

  // This controller is responsible for the animation
  late AnimationController _animate;

  //Getting the VoidCallack onPressed passed by the user
  VoidCallback? get onTap => widget.onTap;

  // This is a user defined duration, which will be responsible for
  // what kind of Bouncing he/she wants
  Duration get userDuration => widget.duration ?? Duration(milliseconds: 100);

  @override
  void initState() {
    //defining the controller
    _animate = AnimationController(
        vsync: this,
        duration: const Duration(
            milliseconds: 200), //This is an inital controller duration
        lowerBound: 0.0,
        upperBound: 0.1)
      ..addListener(() {
        setState(() {});
      }); // Can do something in the listener, but not required
    super.initState();
  }

  @override
  void dispose() {
    // To dispose the contorller when not required
    _animate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _animate.value;
    return GestureDetector(
        onTap: _onTap,
        child: Transform.scale(
          scale: _scale,
          child: widget.child,
        ));
  }

  //This is where the animation works out for us
  // Both the animation happens in the same method,
  // but in a duration of time, and our callback is called here as well
  void _onTap() {
    //Firing the animation right away
    _animate.forward();

    //Now reversing the animation after the user defined duration
    Future.delayed(userDuration, () {
      _animate.reverse();

      //Calling the callback
      onTap!();
    });
  }
}

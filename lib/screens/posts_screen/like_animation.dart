// // import 'package:flutter/material.dart';

// // class LikeAnimation extends StatefulWidget {
// //   final Widget child;
// //   final bool isAnimating;
// //   final Duration duration;
// //   final VoidCallback? onEnd;
// //   final bool smallLike;
// //   const LikeAnimation({
// //     Key? key,
// //     required this.child,
// //     required this.isAnimating,
// //     this.duration = const Duration(milliseconds: 150),
// //     this.onEnd,
// //     this.smallLike = false,
// //   }) : super(key: key);

// //   @override
// //   State<LikeAnimation> createState() => _LikeAnimationState();
// // }

// // class _LikeAnimationState extends State<LikeAnimation>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController controller;
// //   late Animation<double> scale;

// //   @override
// //   void initState() {
// //     super.initState();
// //     controller = AnimationController(
// //       vsync: this,
// //       duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
// //     );
// //     scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
// //   }

// //   @override
// //   void didUpdateWidget(covariant LikeAnimation oldWidget) {
// //     super.didUpdateWidget(oldWidget);

// //     if (widget.isAnimating != oldWidget.isAnimating) {
// //       startAnimation();
// //     }
// //   }

// //   startAnimation() async {
// //     if (widget.isAnimating || widget.smallLike) {
// //       await controller.forward();
// //       await controller.reverse();
// //       await Future.delayed(
// //         const Duration(milliseconds: 200),
// //       );
// //       if (widget.onEnd != null) {
// //         widget.onEnd!();
// //       }
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     super.dispose();
// //     controller.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return ScaleTransition(
// //       scale: scale,
// //       child: widget.child,
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';

// class LikeAnimation extends StatefulWidget {
//   final Widget child;
//   final bool isAnimating;
//   final Duration duration;
//   final VoidCallback? onEnd;
//   final bool smallLike;
//   const LikeAnimation({
//     Key? key,
//     required this.child,
//     required this.isAnimating,
//     this.duration = const Duration(milliseconds: 150),
//     this.onEnd,
//     this.smallLike = false,
//   }) : super(key: key);

//   @override
//   State<LikeAnimation> createState() => _LikeAnimationState();
// }

// class _LikeAnimationState extends State<LikeAnimation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController controller;
//   late Animation<double> scale;
//   late Animation<Color?> colorAnimation;

//   @override
//   void initState() {
//     super.initState();
//     controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
//     );
//     scale = Tween<double>(begin: 1, end: 1.2).animate(controller);

//     // Color animation from grey to red
//     colorAnimation = ColorTween(
//       begin: Colors.grey,
//       end: Colors.red,
//     ).animate(controller);
//   }

//   @override
//   void didUpdateWidget(covariant LikeAnimation oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     if (widget.isAnimating != oldWidget.isAnimating) {
//       startAnimation();
//     }
//   }

//   startAnimation() async {
//     if (widget.isAnimating || widget.smallLike) {
//       await controller.forward();
//       await controller.reverse();
//       await Future.delayed(
//         const Duration(milliseconds: 200),
//       );
//       if (widget.onEnd != null) {
//         widget.onEnd!();
//       }
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     controller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: colorAnimation,
//       builder: (context, child) {
//         return ScaleTransition(
//           scale: scale,
//           child: IconTheme(
//             data: IconThemeData(color: colorAnimation.value), // Change icon color
//             child: widget.child,
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLike;
  final bool isLiked; // Add an isLiked flag to control the color

  const LikeAnimation({
    Key? key,
    required this.child,
    required this.isAnimating,
    this.duration = const Duration(milliseconds: 150),
    this.onEnd,
    this.smallLike = false,
    this.isLiked = false, // Default to not liked
  }) : super(key: key);

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
    );
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isAnimating || widget.smallLike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(
        const Duration(milliseconds: 200),
      );
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: IconTheme(
        data: IconThemeData(
          // If liked or animating, change the color to red, otherwise keep it grey
          color: widget.isLiked || widget.isAnimating ? Colors.red : Colors.grey,
        ),
        child: widget.child,
      ),
    );
  }
}
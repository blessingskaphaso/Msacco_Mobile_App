import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.3,
          child: ModalBarrier(
            dismissible: false,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            // color: Theme.of(context).primaryColor,
            color: Colors.green,
            size: 50, // Adjust size if necessary
          ),
        ),
      ],
    );
  }
}

// lib/widgets/loading_widget.dart

// import 'package:flutter/material.dart';

// class LoadingWidget extends StatelessWidget {
//   const LoadingWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: WillPopScope(
//         onWillPop: () async => false,
//         child: AlertDialog(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           content: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(),
//               const SizedBox(width: 20),
//               const Text(
//                 'Loading...',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

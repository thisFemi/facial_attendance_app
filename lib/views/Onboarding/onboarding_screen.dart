// import 'package:flutter/material.dart';

// import '../../models/slider.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//               child: PageView.builder(
//                   scrollDirection: Axis.horizontal,
//                   onPageChanged: (value) {
//                     setState(() {
//                       currentIndex = value;
//                     });
//                   },
//                   itemCount: slides.length,
//                   itemBuilder: (context, index) {
//                     return Slider(
//                       image: slides[index].getImage(),
//                       title: slides[index].getTitle(),
//                       description: slides[index].getDescription(),
//                     );
//                   })),
//           Container(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                   slides.length, (index) => buildDot(index, context)),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Container buildDot(int index, BuildContext context) {
//     // Another Container returned
//     return Container(
//       height: 10,
//       width: currentIndex == index ? 25 : 10,
//       margin: EdgeInsets.only(right: 5),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: Colors.green,
//       ),
//     );
//   }


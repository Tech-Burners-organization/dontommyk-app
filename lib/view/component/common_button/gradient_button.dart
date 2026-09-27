// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:venue/utils/app_color.dart';

// class GradientButton extends StatelessWidget {
//   final String text;
//   final Color textColor;
//   final VoidCallback onPressed;
//   final String? prefixIcon;
//   final String? sufixIcon;

//   const GradientButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     this.prefixIcon,
//     this.sufixIcon,
//     this.textColor = AppColors.black,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         height: 60.h,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16.r), // Rounded corners
//           gradient: LinearGradient(
//             colors: [AppColors.brown500, AppColors.brown400],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               offset: Offset(0, 4),
//               blurRadius: 6.0.r,
//             ),
//           ],
//         ),
//         child: Center(
//           child: prefixIcon == null
//               ? Text(text,
//                   style: GoogleFonts.fanwoodText(
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.bold,
//                     color: textColor,
//                   ))
//               : prefixIcon != null
//                   ? Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SvgPicture.asset(prefixIcon!),
//                         Text(text,
//                             style: GoogleFonts.fanwoodText(
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.bold,
//                               color: textColor,
//                             )),
//                       ],
//                     )
//                   : Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(text,
//                             style: GoogleFonts.fanwoodText(
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.bold,
//                               color: textColor,
//                             )),
//                         Image.asset(sufixIcon!,height: 30.h,width: 30.w,)
//                       ],
//                     ),
//         ),
//       ),
//     );
//   }
// }

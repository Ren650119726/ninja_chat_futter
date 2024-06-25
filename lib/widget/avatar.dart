import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ninja_chat/styles/colors.dart';

class Avatar extends StatelessWidget {
  final String faceUrl;
  final String localPortrait;
  final bool isOnline;

  const Avatar({super.key,
    required this.isOnline,
    required this.faceUrl,
    required this.localPortrait});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: ImageFiltered(
            imageFilter: const ColorFilter.mode(
              Colors.grey,
              BlendMode.color,
            ),
            enabled: !isOnline,
            child: Image.asset(
              faceUrl!,
              fit: BoxFit.cover,
              width: 52.w,
              height: 50.w,
              cacheWidth: 200,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 52.w,
                  height: 50.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(6.r),
                    color: Theme.of(context)
                        .colorScheme
                        .surface,
                  ),
                  child: Text(
                    localPortrait ?? "",
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          right: 2,
          bottom: 2,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isOnline ? AlColors.greenColor : AlColors.greyColor,
            ),
          ),
        )
      ],
    );
  }

}
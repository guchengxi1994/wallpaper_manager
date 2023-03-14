import 'package:flutter/material.dart';
import 'package:wallpaper_manager/app_style.dart';

class AddOneImageCard extends StatelessWidget {
  const AddOneImageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: const Card(
        elevation: 4,
        child: SizedBox(
            width: AppStyle.cardWidth,
            height: AppStyle.cardHeight,
            child: Center(
              child: Icon(
                Icons.add,
                size: AppStyle.plusIconSize,
                color: Colors.black,
              ),
            )),
      ),
    );
  }
}

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class GifPreviewWidget extends StatefulWidget {
  const GifPreviewWidget({super.key, required this.filePath});
  final String filePath;
  @override
  State<GifPreviewWidget> createState() => _GifPreviewWidgetState();
}

class _GifPreviewWidgetState extends State<GifPreviewWidget>
    with TickerProviderStateMixin {
  late final GifController controller;

  @override
  void initState() {
    super.initState();
    controller = GifController(vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 800,
          height: 600,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.white),
          child: Gif(
              controller: controller, image: FileImage(File(widget.filePath))),
        ),
        Positioned(
            right: 10,
            top: 10,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.close,
                color: Colors.red,
              ),
            )),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Container(
                // the size where the blurring starts
                height: 50,
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 10,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {
                    controller.repeat();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () {
                    controller.stop();
                  },
                ),
                AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget? child) {
                    return Slider(
                      label: 'Timeline',
                      value: controller.value,
                      onChanged: (v) => setState(() {
                        controller.value = v;
                      }),
                    );
                  },
                ),
              ],
            ))
      ],
    );
  }
}

import 'package:flutter/material.dart';

class SkeltonLoadingIndicator extends StatelessWidget {
  const SkeltonLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Skelton(
            height: 80,
            width: 80,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Skelton(
                  width: double.infinity,
                  height: 20,
                ),
                SizedBox(height: 4),
                Skelton(
                  width: 100,
                  height: 12,
                ),
                SizedBox(height: 4),
                Skelton(
                  width: double.infinity,
                  height: 12,
                ),
                SizedBox(height: 4),
                Skelton(
                  width: double.infinity,
                  height: 12,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Skelton extends StatelessWidget {
  final double? height, width;
  const Skelton({Key? key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
      ),
    );
  }
}
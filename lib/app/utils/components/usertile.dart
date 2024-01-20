import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final String image;
  final void Function()? onTap;

  const UserTile({
    Key? key,
    required this.text,
    required this.image,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: Image.network(
                image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 20),
            Text(text),
          ],
        ),
      ),
    );
  }
}

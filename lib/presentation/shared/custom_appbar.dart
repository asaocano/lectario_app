import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
      bottom: false,
      child: Padding(padding: const EdgeInsetsGeometry.fromLTRB(10, 5, 10, 0), child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Icon(Icons.book, color: colors.primary,),
            const SizedBox(width: 5,),
            Text("Lectario", style: titleStyle,),
            const Spacer()
          ],
        ),
      ),),
    );
  }
}

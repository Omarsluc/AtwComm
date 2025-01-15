import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

class ArrowBackCustom extends StatelessWidget {
  final void Function()? onTap;

  const ArrowBackCustom({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap : (){
        Navigator.of(context).pop();
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: const GradientBoxBorder(
            gradient: RadialGradient(
              center: Alignment(0.49, 0.50),
              radius: 0.39,
              colors: [
                // const LinearGradient(colors: [Colors.blue, Colors.green]),
                Colors.green,
                Colors.blue,
              ],
            ),
            width: 2, // Adjust the border width as needed
          ),
        ),
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.grey,
        ),
      ),
    );
  }
}

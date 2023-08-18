import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key, required this.text})
      : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Image.asset(
'assets/empty.png'
            ),
          ),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.adamina(fontSize: 12,color: Colors.deepPurple.shade900,fontWeight: FontWeight.normal)
            ),
          ),
        ],
      ),
    );
  }
}

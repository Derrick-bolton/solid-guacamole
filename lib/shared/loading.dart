import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent,
      child: Center(
        child: Column(
          children: [
            SpinKitHourGlass(
                color: Colors.white,
                    size: 100.0,
            ),
            SizedBox(height: 5.0,),
            Text(
                "",
              style: TextStyle(

              ),
            )
          ],
        ),
      ),
    );
  }
}

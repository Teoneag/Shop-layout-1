import 'package:flutter/material.dart';
import '/utils/consts.dart';
// import 'package:flutter_svg/svg.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SvgPicture.asset(
            //   'assets/logo_CoinSky_1_2.svg',
            //   height: 90,
            // ),
            Text(appName),
            SizedBox(height: 30),
            Text('Hold on, almost there...'),
            SizedBox(height: 30),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

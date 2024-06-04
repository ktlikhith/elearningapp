// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';

// class CheckInternetConnectionWidget extends StatelessWidget {
//   final AsyncSnapshot<ConnectivityResult> snapshot;
//   final Widget child;

//   const CheckInternetConnectionWidget({
//     Key? key,
//     required this.snapshot,
//     required this.child,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     switch (snapshot.connectionState) {
//       case ConnectionState.active:
//         final state = snapshot.data!;
//         switch (state) {
//           case ConnectivityResult.none:
//             return Center(child: const Text('No Internet connection'));
//           default:
//             return child;
//         }
//       default:
//         return const Text('');
//     }
//   }
// }

// class InternetConnectivityScreen extends StatefulWidget {
//   final Widget child;

//   InternetConnectivityScreen({Key? key, required this.child}) : super(key: key);

//   @override
//   _InternetConnectivityScreenState createState() =>
//       _InternetConnectivityScreenState();
// }

// class _InternetConnectivityScreenState
//     extends State<InternetConnectivityScreen> {
//   bool _isConnected = true;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize connectivity check
//     _checkInternetConnection();
//     // Listen for connectivity changes
//     Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//       setState(() {
//         _isConnected = result != ConnectivityResult.none;
//       });
//     });
//   }

//   Future<void> _checkInternetConnection() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     setState(() {
//       _isConnected = connectivityResult != ConnectivityResult.none;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CheckInternetConnectionWidget(
//       snapshot: AsyncSnapshot<ConnectivityResult>.withData(
//           ConnectionState.active,
//           _isConnected ? ConnectivityResult.mobile : ConnectivityResult.none),
//       child: widget.child,
//     );
//   }
// }

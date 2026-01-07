import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final User? user;
  final double money;
  const PaymentScreen({super.key, required this.user, required this.money});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late WebViewController _webcontroller;
  late double screenHeight, screenWidth, resWidth;
  late String userName, userEmail, userPhone, userID;

  @override
  void initState() {
    userEmail = widget.user!.userEmail.toString();
    userPhone = widget.user!.userPhone.toString();
    userName = widget.user!.userName.toString();
    userID = widget.user!.userId.toString();
    super.initState();
    _webcontroller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
          '${MyConfig.server}/pawpal/server/api/payment.php?email=$userEmail&phone=$userPhone&userid=$userID&name=$userName&money=${widget.money}',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Colors.blue,
      ),
      body: WebViewWidget(controller: _webcontroller),
    );
  }
}
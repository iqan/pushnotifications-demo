import 'package:flutter/material.dart';
import 'package:azure_notificationhubs_flutter/azure_notificationhubs_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iqans Push Notification Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Notification Demo'),
        ),
        body: Center(
          child: Text('Notifications Demo Home Page'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AzureNotificationhubsFlutter().configure(
              onLaunch: (Map<String, dynamic> notification) async {
                print('anh onLaunch: $notification');
              },
              onResume: (Map<String, dynamic> notification) async {
                print('anh onResume: $notification');
              },
              onMessage: (Map<String, dynamic> notification) async {
                print('anh onMessage: $notification');
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(notification['message']),
                ));
              },
              onToken: (dynamic notification) async {
                print('anh onToken: $notification');
              },
            );
          },
          child: Icon(
            Icons.notifications_active,
          ),
        ),
      ),
    );
  }
}

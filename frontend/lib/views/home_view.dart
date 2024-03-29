import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/services/notitfication_service.dart';
import 'package:flutter_application_1/views/broadcast_view.dart';
import 'create_webinar_view.dart';
import 'signin_view.dart';
import '../widgets/stream_widget.dart';

class HomeViewWrapper extends StatefulWidget {
  String? token;
  late String? selectedRole = '';

  HomeViewWrapper({Key? key, required this.selectedRole, required this.token})
      : super(
          key: key,
        );

  @override
  _HomeViewWrapperState createState() => _HomeViewWrapperState();
}

class _HomeViewWrapperState extends State<HomeViewWrapper> {
  var loading = true; // Indicates whether data is loading
  late List<StreamItem> streams; // List to store webinar streams

  @override
  void initState() {
    super.initState();
    listenToNotifications(); // Start listening to notifications
    fetchWebinars(); // Fetch webinars data
  }

  // Listen to notifications for new webinars
  listenToNotifications() {
    LocalNotifications.onClickNotification.stream.listen((event) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BroadcastPage(
            channelName: event,
            isBroadcaster: true,
            userName: '${widget.selectedRole}_${widget.token}',
          ),
        ),
      );
    });
  }

  // Fetch webinars data from the API
  void fetchWebinars() {
    ApiService.getWebinars().then((value) {
      setState(() {
        if (value != null) {
          // If data is available, map it to StreamItem objects
          streams = value
              .map((e) => StreamItem(
                  channelId: e['_id'] ?? '',
                  image: e['image'] ?? '',
                  author: e['authorUsername'] ?? '',
                  authorId: e['authorId'] ?? '',
                  date: e['date'] ?? '',
                  title: e['title'] ?? ''))
              .toList();
        }

        loading = false; // Data loading is complete
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webinars'),
        actions: [
          if (widget.selectedRole == Roles.doctor)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Create webinar',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateWebinarView(fetchWebinars: fetchWebinars),
                  ),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              AuthService.clearCache(); // Clear user authentication data

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const SigninView(),
                ),
                ModalRoute.withName('/signin/'), // Route to remove until
              );
            },
          ),
        ],
      ),
      body: Center(
        child: loading
            ? const CircularProgressIndicator() // Show loading indicator while data is loading
            : streams.isNotEmpty
                ? StreamListWidget(
                    streams: streams) // Show webinar streams if available
                : const Text(
                    'There is no webinars'), // Show message if no webinars available
      ),
    );
  }
}

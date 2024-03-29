import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../views/broadcast_view.dart';

// Define a class to represent each stream item
class StreamItem {
  final String image;
  final String author;
  final String authorId;
  final String title;
  final String date;
  final String channelId;

  StreamItem({
    required this.image,
    required this.author,
    required this.authorId,
    required this.title,
    required this.date,
    required this.channelId,
  });

  // Factory method to create a StreamItem from a JSON object
  factory StreamItem.fromJson(Map<String, dynamic> json) {
    return StreamItem(
      author: json['author'] ?? '',
      authorId: json['authorId'] ?? '',
      image: json['image'] ??
          'https://t4.ftcdn.net/jpg/04/70/29/97/360_F_470299797_UD0eoVMMSUbHCcNJCdv2t8B2g1GVqYgs.jpg',
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      channelId: json['channelId'] ?? '',
    );
  }
}

class StreamListWidget extends StatefulWidget {
  final List<StreamItem> streams;

  const StreamListWidget({Key? key, required this.streams}) : super(key: key);

  @override
  State<StreamListWidget> createState() => _StreamListWidgetState();
}

class _StreamListWidgetState extends State<StreamListWidget> {
  String? token = '';
  String? role = '';

  @override
  void initState() {
    super.initState();
    getRoleAndToken();
  }

  // Fetches user role and token from AuthService
  Future<void> getRoleAndToken() async {
    final fetchedToken = await AuthService.getToken();
    final fetchedRole = await AuthService.getRole();

    setState(() {
      token = fetchedToken;
      role = fetchedRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.streams.length,
      itemBuilder: (context, index) {
        final bool isMe = widget.streams[index].authorId == token;
        return GestureDetector(
          onTap: () {
            // Navigate to broadcast page when a stream item is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BroadcastPage(
                  channelName: widget.streams[index].channelId,
                  isBroadcaster: isMe,
                  userName: '${role}_$token',
                ),
              ),
            );
          },
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Display stream image
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15.0)),
                  child: Image.network(
                    widget.streams[index].image,
                    fit: BoxFit.cover,
                    height: 200, // Set the height as per your requirement
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display stream title
                      Text(
                        widget.streams[index].title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Display stream author
                      Text(
                        'by ${isMe ? 'you' : widget.streams[index].author}',
                        style: TextStyle(
                          fontSize: 14,
                          color: isMe ? Colors.red[600] : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Display relative time since stream date
                      Text(
                        timeago
                            .format(DateTime.parse(widget.streams[index].date)),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

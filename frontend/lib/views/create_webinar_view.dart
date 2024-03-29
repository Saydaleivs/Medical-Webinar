import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/notitfication_service.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/views/broadcast_view.dart';
import 'package:flutter_application_1/widgets/custom_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateWebinarView extends StatefulWidget {
  final VoidCallback fetchWebinars;

  const CreateWebinarView({Key? key, required this.fetchWebinars})
      : super(key: key);

  @override
  _CreateWebinarViewState createState() => _CreateWebinarViewState();
}

class _CreateWebinarViewState extends State<CreateWebinarView> {
  final TextEditingController _titleController = TextEditingController();
  File? _imageFile;
  DateTime? _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime = TimeOfDay.now();
  late String? _token;

  @override
  void initState() {
    super.initState();
    AuthService.getToken().then((value) => _token = value);
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
        });
      }
    }
  }

  String _formatDateTime() {
    final formattedDate = DateFormat.yMMMd().format(_selectedDate!);
    final formattedTime = _selectedTime!.format(context);
    return '$formattedDate $formattedTime';
  }

  void _createNewWebinar() async {
    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    ).toIso8601String();

    final image =
        _imageFile != null ? await ApiService.uploadImage(_imageFile!) : '';

    final response = await ApiService.createWebinar(
        authorId: _token!,
        date: dateTime,
        image: image,
        title: _titleController.text);

    widget.fetchWebinars();

    if (response is Map && response.containsKey('error')) {
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              errorTitle: 'Error',
              errorMessage: response['message'][0],
              onOkPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            );
          },
        );
      });
    } else {
      final notificationSeconds = response['notificationSeconds'];

      // If notification is less than 3 seconds, navigate to broadcast directly
      if (notificationSeconds < 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BroadcastPage(
              channelName: response['webinar']['_id'],
              isBroadcaster: true,
              userName: 'Doctor_$_token',
            ),
          ),
        );
      } else {
        Navigator.pop(context);
        LocalNotifications.showScheduleNotification(
            title: "It is time to start the webinar",
            body: "Your scheduled webinar is waiting for you....",
            payload: response['webinar']['_id'],
            seconds: notificationSeconds);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Webinar'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context)
                  .pop(); // Navigate back when the button is pressed
            },
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.photo_camera),
                                  title: const Text('Take a picture'),
                                  onTap: () {
                                    _pickImage(ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Choose from gallery'),
                                  onTap: () {
                                    _pickImage(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _imageFile == null
                            ? const Icon(Icons.add_photo_alternate, size: 60)
                            : Image.file(_imageFile!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Selected time: ${_formatDateTime()}'),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _selectDateTime(context),
                          icon: const Icon(Icons.calendar_today),
                          label: const Text(
                            'Select Date & Time',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                  Column(children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: _createNewWebinar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          textStyle: const TextStyle(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.schedule,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text('Schedule Webinar',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}

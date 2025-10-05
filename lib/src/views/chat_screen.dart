import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/widgets/custom_app_bar.dart';
import 'package:file_picker/file_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'مرحباً، لدي سؤال حول كورس بايثون',
      'sent': false,
      'time': 'منذ 3 ساعات',
    },
    {
      'text': 'أهلاً بك، تفضل بطرح سؤالك',
      'sent': true,
      'time': 'منذ 3 ساعات',
    },
    {
      'text': 'كيف يمكنني التعامل مع القوائم في بايثون؟',
      'sent': false,
      'time': 'منذ ساعتين',
    },
    {
      'text':
          'يمكنك استخدام الدوال append(), extend(), و insert() للتعامل مع القوائم',
      'sent': true,
      'time': 'منذ ساعتين',
    },
    {
      'text': 'شكراً لك على المساعدة',
      'sent': false,
      'time': 'منذ ساعتين',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'سارة أحمد',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        return Column(
          children: [
            // Chat header
            Container(
              padding: EdgeInsets.all(isTablet ? 24.w : 16.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.w,
                  ),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: isTablet ? 30.r : 20.r,
                    backgroundImage: const NetworkImage(
                      'https://randomuser.me/api/portraits/women/1.jpg',
                    ),
                    onBackgroundImageError: (exception, stackTrace) {
                      // Handle image load error
                    },
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'سارة أحمد',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet ? 20.sp : 16.sp,
                            color: AppColors.dark,
                          ),
                        ),
                        Text(
                          'متصل الآن',
                          style: TextStyle(
                            fontSize: isTablet ? 16.sp : 12.sp,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Messages list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(isTablet ? 24.w : 16.w),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(
                    text: message['text'],
                    isSent: message['sent'],
                    time: message['time'],
                    isTablet: isTablet,
                  );
                },
              ),
            ),
            // Message input
            Container(
              padding: EdgeInsets.all(isTablet ? 24.w : 16.w),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.w,
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.attach_file,
                      size: isTablet ? 32.sp : 24.sp,
                      color: AppColors.primary,
                    ),
                    onPressed: () async {
                      // TODO: Attach file
                      await _attachFile();
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالة...',
                        hintStyle: TextStyle(
                          fontSize: isTablet ? 20.sp : 16.sp,
                          color: Colors.grey[500],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(isTablet ? 30.r : 24.r),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1.w,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(isTablet ? 30.r : 24.r),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1.w,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(isTablet ? 30.r : 24.r),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 1.w,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: isTablet ? 16.h : 12.h,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: isTablet ? 20.sp : 16.sp,
                        color: AppColors.dark,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    width: isTablet ? 50.w : 40.w,
                    height: isTablet ? 50.h : 40.h,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        size: isTablet ? 28.sp : 20.sp,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // TODO: Send message
                        _sendMessage();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMessageBubble({
    required String text,
    required bool isSent,
    required String time,
    bool isTablet = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 16.w : 12.w),
            decoration: BoxDecoration(
              color: isSent ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(isTablet ? 24.r : 18.r),
              border: Border.all(
                color: isSent ? AppColors.primary : Colors.grey[300]!,
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: isTablet ? 18.sp : 14.sp,
                color: isSent ? Colors.white : AppColors.dark,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            time,
            style: TextStyle(
              fontSize: isTablet ? 16.sp : 12.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _attachFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        // Show a snackbar with file info
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم اختيار الملف: ${file.name}'),
            duration: const Duration(seconds: 2),
          ),
        );

        // TODO: Implement actual file sending logic here
        // This would typically involve uploading the file to a server
        // and then sending a message with the file reference
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء اختيار الملف'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _messageController.text,
          'sent': true,
          'time': 'الآن',
        });
      });

      // Clear the text field
      _messageController.clear();

      // Scroll to the bottom to show the new message
      // TODO: Implement scrolling to bottom

      // Show a snackbar to indicate the message was sent
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال الرسالة'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}
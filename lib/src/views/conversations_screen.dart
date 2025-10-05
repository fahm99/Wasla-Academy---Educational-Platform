import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/views/chat_screen.dart';
import 'package:waslaacademy/src/widgets/custom_app_bar.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  final List<Map<String, dynamic>> _conversations = [
    {
      'name': 'سارة أحمد',
      'avatar': 'https://randomuser.me/api/portraits/women/1.jpg',
      'lastMessage': 'شكراً لك على المساعدة',
      'time': 'منذ ساعتين',
      'unread': 0,
    },
    {
      'name': 'د. محمد السعيد',
      'avatar': 'https://randomuser.me/api/portraits/men/5.jpg',
      'lastMessage': 'هل لديك أي أسئلة أخرى؟',
      'time': 'منذ يوم',
      'unread': 2,
    },
    {
      'name': 'فريق الدعم الفني',
      'avatar': 'https://randomuser.me/api/portraits/men/6.jpg',
      'lastMessage': 'تم حل المشكلة بنجاح',
      'time': 'منذ 3 أيام',
      'unread': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'المحادثات',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        return ListView.builder(
          padding: EdgeInsets.all(isTablet ? 24.w : 16.w),
          itemCount: _conversations.length,
          itemBuilder: (context, index) {
            final conversation = _conversations[index];
            return _buildConversationItem(
              name: conversation['name'],
              avatar: conversation['avatar'],
              lastMessage: conversation['lastMessage'],
              time: conversation['time'],
              unread: conversation['unread'],
              isTablet: isTablet,
            );
          },
        );
      }),
    );
  }

  Widget _buildConversationItem({
    required String name,
    required String avatar,
    required String lastMessage,
    required String time,
    required int unread,
    bool isTablet = false,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(isTablet ? 20.w : 12.w),
        leading: CircleAvatar(
          radius: isTablet ? 35.r : 25.r,
          backgroundImage: NetworkImage(avatar),
          onBackgroundImageError: (exception, stackTrace) {
            // Handle image load error
          },
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 20.sp : 16.sp,
            color: AppColors.dark,
          ),
        ),
        subtitle: Text(
          lastMessage,
          style: TextStyle(
            fontSize: isTablet ? 18.sp : 14.sp,
            color: Colors.grey[600],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: isTablet ? 16.sp : 12.sp,
                color: Colors.grey[500],
              ),
            ),
            if (unread > 0)
              Container(
                margin: EdgeInsets.only(top: 4.h),
                padding: EdgeInsets.all(isTablet ? 6.w : 4.w),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(
                  minWidth: isTablet ? 28.w : 20.w,
                  minHeight: isTablet ? 28.h : 20.h,
                ),
                child: Text(
                  unread.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 16.sp : 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
        onTap: () {
          // TODO: Navigate to chat screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatScreen(),
            ),
          );
        },
      ),
    );
  }
}
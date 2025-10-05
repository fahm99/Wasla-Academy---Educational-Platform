import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/widgets/custom_app_bar.dart';
import 'package:file_picker/file_picker.dart';

class FilesScreen extends StatefulWidget {
  const FilesScreen({super.key});

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';
  final List<Map<String, dynamic>> _files = [
    {
      'name': 'مقدمة في بايثون.pdf',
      'type': 'pdf',
      'size': '2.4 ميجابايت',
      'date': '01/01/2023',
      'courseId': 1,
    },
    {
      'name': 'الكود المصدري.zip',
      'type': 'zip',
      'size': '1.2 ميجابايت',
      'date': '01/01/2023',
      'courseId': 1,
    },
    {
      'name': 'تمرين المتغيرات.docx',
      'type': 'document',
      'size': '0.8 ميجابايت',
      'date': '05/01/2023',
      'courseId': 1,
    },
    {
      'name': 'الحروف الإنجليزية.mp4',
      'type': 'video',
      'size': '45.2 ميجابايت',
      'date': '10/01/2023',
      'courseId': 3,
    },
    {
      'name': 'قائمة الكلمات.xlsx',
      'type': 'spreadsheet',
      'size': '0.5 ميجابايت',
      'date': '10/01/2023',
      'courseId': 3,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _uploadFile() async {
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

        // TODO: Implement actual file upload logic here
        // This would typically involve uploading the file to a server
        // and then adding it to the local file list

        // For now, we'll just add it to the local list as a mock
        setState(() {
          _files.add({
            'name': file.name,
            'type': _getFileType(file.name),
            'size': _formatFileSize(file.size),
            'date': DateTime.now().toString().split(' ')[0],
            'courseId': 1, // Default course ID
          });
        });
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

  String _getFileType(String fileName) {
    String extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'pdf';
      case 'mp4':
      case 'avi':
      case 'mov':
        return 'video';
      case 'mp3':
      case 'wav':
        return 'audio';
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return 'image';
      case 'doc':
      case 'docx':
        return 'document';
      case 'xls':
      case 'xlsx':
        return 'spreadsheet';
      case 'zip':
      case 'rar':
        return 'zip';
      default:
        return 'document';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes بايت';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} كيلوبايت';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} ميجابايت';
    }
  }

  void _downloadFile(Map<String, dynamic> file) {
    // Show a snackbar to indicate the download has started
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تحميل الملف: ${file['name']}'),
        duration: const Duration(seconds: 2),
      ),
    );

    // TODO: Implement actual file download logic
    // This would typically involve downloading the file from a server
    // and saving it to the device

    // For now, we'll just show a success message
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تحميل الملف بنجاح: ${file['name']}'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  void _shareFile(Map<String, dynamic> file) {
    // Show a snackbar to indicate the sharing has started
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري مشاركة الملف: ${file['name']}'),
        duration: const Duration(seconds: 2),
      ),
    );

    // TODO: Implement actual file sharing logic
    // This would typically involve using the share_plus package
    // to share the file via system share sheet

    // For now, we'll just show a success message
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تمت مشاركة الملف بنجاح: ${file['name']}'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  void _openFile(Map<String, dynamic> file) {
    // Show a snackbar to indicate the file is being opened
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري فتح الملف: ${file['name']}'),
        duration: const Duration(seconds: 2),
      ),
    );

    // TODO: Implement actual file opening logic
    // This would typically involve using a package like open_file
    // to open the file with the appropriate application

    // For now, we'll just show a success message
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم فتح الملف بنجاح: ${file['name']}'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'ملفاتي',
        onBack: () {
          Navigator.pop(context);
        },
        actions: [
          IconButton(
            icon: Icon(
              Icons.upload,
              size: 24.sp,
              color: Colors.white,
            ),
            onPressed: () async {
              // TODO: Upload file
              await _uploadFile();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن ملف...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                hintStyle: TextStyle(fontSize: 14.sp),
              ),
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
          // Filter section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'التصفية',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = 'all';
                          _searchController.clear();
                        });
                      },
                      child: Text(
                        'مسح الكل',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    _buildFilterChip(
                      label: 'الكل',
                      isSelected: _selectedFilter == 'all',
                      onSelected: () => setState(() => _selectedFilter = 'all'),
                    ),
                    _buildFilterChip(
                      label: 'PDF',
                      isSelected: _selectedFilter == 'pdf',
                      onSelected: () => setState(() => _selectedFilter = 'pdf'),
                    ),
                    _buildFilterChip(
                      label: 'فيديو',
                      isSelected: _selectedFilter == 'video',
                      onSelected: () =>
                          setState(() => _selectedFilter = 'video'),
                    ),
                    _buildFilterChip(
                      label: 'صوت',
                      isSelected: _selectedFilter == 'audio',
                      onSelected: () =>
                          setState(() => _selectedFilter = 'audio'),
                    ),
                    _buildFilterChip(
                      label: 'صورة',
                      isSelected: _selectedFilter == 'image',
                      onSelected: () =>
                          setState(() => _selectedFilter = 'image'),
                    ),
                    _buildFilterChip(
                      label: 'مستند',
                      isSelected: _selectedFilter == 'document',
                      onSelected: () =>
                          setState(() => _selectedFilter = 'document'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // Files list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _files.length,
              itemBuilder: (context, index) {
                final file = _files[index];
                // Apply filter
                if (_selectedFilter != 'all' &&
                    file['type'] != _selectedFilter) {
                  return Container();
                }
                return _buildFileItem(file);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          color: isSelected ? Colors.white : AppColors.dark,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        onSelected();
      },
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.light,
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 8.h,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
    );
  }

  Widget _buildFileItem(Map<String, dynamic> file) {
    IconData iconData;
    Color iconColor;

    switch (file['type']) {
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        iconColor = AppColors.danger;
        break;
      case 'video':
        iconData = Icons.video_file;
        iconColor = AppColors.info;
        break;
      case 'audio':
        iconData = Icons.audiotrack;
        iconColor = AppColors.warning;
        break;
      case 'image':
        iconData = Icons.image;
        iconColor = AppColors.success;
        break;
      case 'document':
        iconData = Icons.description;
        iconColor = AppColors.primary;
        break;
      case 'spreadsheet':
        iconData = Icons.table_chart;
        iconColor = AppColors.success;
        break;
      case 'zip':
        iconData = Icons.archive;
        iconColor = Colors.grey;
        break;
      default:
        iconData = Icons.insert_drive_file;
        iconColor = Colors.grey;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(12.w),
        leading: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppColors.light,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(iconData, color: iconColor),
        ),
        title: Text(
          file['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
            color: AppColors.dark,
          ),
        ),
        subtitle: Text(
          '${file['size']} • ${file['date']}',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.download,
                size: 20.sp,
                color: AppColors.primary,
              ),
              onPressed: () {
                // TODO: Download file
                _downloadFile(file);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.share,
                size: 20.sp,
                color: AppColors.primary,
              ),
              onPressed: () {
                // TODO: Share file
                _shareFile(file);
              },
            ),
          ],
        ),
        onTap: () {
          // TODO: Open file
          _openFile(file);
        },
      ),
    );
  }
}

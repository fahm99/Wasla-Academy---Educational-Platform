import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_profile_model.dart';

/// مصدر البيانات البعيد للملف الشخصي
abstract class ProfileRemoteDataSource {
  /// الحصول على الملف الشخصي
  Future<UserProfileModel> getProfile(String userId);

  /// تحديث الملف الشخصي
  Future<UserProfileModel> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? bio,
  });

  /// رفع صورة الملف الشخصي
  Future<String> uploadAvatar(String userId, XFile imageFile);

  /// حذف صورة الملف الشخصي
  Future<void> deleteAvatar(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;

  ProfileRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserProfileModel> getProfile(String userId) async {
    try {
      final response =
          await supabaseClient.from('users').select().eq('id', userId).single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserProfileModel> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? bio,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;
      if (bio != null) updateData['bio'] = bio;

      final response = await supabaseClient
          .from('users')
          .update(updateData)
          .eq('id', userId)
          .select()
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> uploadAvatar(String userId, XFile imageFile) async {
    try {
      final fileExt = imageFile.path.split('.').last;
      final fileName =
          '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = fileName;

      // Read image bytes
      final Uint8List bytes = await imageFile.readAsBytes();

      // Upload to Supabase Storage - Cross-platform
      await supabaseClient.storage.from('avatars').uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(
              cacheControl: '3600',
              upsert: false,
              contentType: 'image/$fileExt',
            ),
          );

      // Get public URL
      final imageUrl =
          supabaseClient.storage.from('avatars').getPublicUrl(filePath);

      // Update user profile with new avatar URL
      await supabaseClient.from('users').update({
        'avatar_url': imageUrl,
        'profile_image_url': imageUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      return imageUrl;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteAvatar(String userId) async {
    try {
      // Get current avatar URL
      final response = await supabaseClient
          .from('users')
          .select('avatar_url')
          .eq('id', userId)
          .single();

      final avatarUrl = response['avatar_url'] as String?;

      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        // Extract file path from URL
        final uri = Uri.parse(avatarUrl);
        final filePath = uri.pathSegments.last;

        // Delete from storage
        await supabaseClient.storage.from('avatars').remove([filePath]);
      }

      // Update user profile to remove avatar URL
      await supabaseClient.from('users').update({
        'avatar_url': null,
        'profile_image_url': null,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}

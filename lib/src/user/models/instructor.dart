import 'package:equatable/equatable.dart';

class Instructor extends Equatable {
  final int id;
  final String name;
  final String specialty;
  final double rating;
  final int students;
  final String experience;
  final String bio;
  final String image;
  final List<int> courses;

  const Instructor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.students,
    required this.experience,
    required this.bio,
    required this.image,
    required this.courses,
  });

  Instructor copyWith({
    int? id,
    String? name,
    String? specialty,
    double? rating,
    int? students,
    String? experience,
    String? bio,
    String? image,
    List<int>? courses,
  }) {
    return Instructor(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      rating: rating ?? this.rating,
      students: students ?? this.students,
      experience: experience ?? this.experience,
      bio: bio ?? this.bio,
      image: image ?? this.image,
      courses: courses ?? this.courses,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        specialty,
        rating,
        students,
        experience,
        bio,
        image,
        courses,
      ];
}

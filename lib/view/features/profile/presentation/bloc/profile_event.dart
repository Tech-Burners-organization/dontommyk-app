part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchProfile extends ProfileEvent {
  const FetchProfile();
}

class UpdateProfileSubmitted extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String designation;
  final int? age;
  final String? location;
  final String? imagePath;
  final String? token;

  const UpdateProfileSubmitted({
    required this.firstName,
    required this.lastName,
    required this.designation,
    this.age,
    this.location,
    this.imagePath,
    this.token,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    designation,
    age,
    location,
    imagePath,
    token,
  ];
}

class DeleteAccountSubmitted extends ProfileEvent {
  const DeleteAccountSubmitted();
}


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tommy/core/utils/prefs_helper.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/custom_snacbar.dart';
import 'package:tommy/view/component/custom_text_field/custom_text_field.dart';
import 'package:tommy/view/features/profile/data/models/employee_profile_model.dart';
import 'package:tommy/view/features/profile/presentation/bloc/profile_bloc.dart';

class EditProfilePage extends StatefulWidget {
  final EmployeeProfile? profile;

  const EditProfilePage({super.key, this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _roleController;
  late final TextEditingController _ageController;
  late final TextEditingController _locationController;

  String? _selectedImagePath;
  String _existingPhotoUrl = '';

  @override
  void initState() {
    super.initState();
    final p = widget.profile;

    final initialName = (p?.fullName.isNotEmpty == true)
        ? p!.fullName
        : PrefsHelper.name;

    final initialRole = (p?.designation.isNotEmpty == true)
        ? p!.designation
        : PrefsHelper.role;

    final initialEmail = PrefsHelper.email;

    final initialAge = p?.age != null ? p!.age.toString() : '';

    final initialLocation = p?.location ?? '';

    _existingPhotoUrl = (p?.profilePhoto.isNotEmpty == true)
        ? p!.profilePhoto
        : PrefsHelper.profileImage;

    _nameController = TextEditingController(text: initialName);
    _emailController = TextEditingController(text: initialEmail);
    _roleController = TextEditingController(text: initialRole);
    _ageController = TextEditingController(text: initialAge);
    _locationController = TextEditingController(text: initialLocation);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _selectedImagePath = picked.path;
      });
    }
  }

  void _onSave() {
    final name = _nameController.text.trim();
    final role = _roleController.text.trim();

    if (name.isEmpty) {
      showAppSnackBar(
        context,
        message: 'Please enter your full name',
        isSuccess: false,
      );
      return;
    }

    if (role.isEmpty) {
      showAppSnackBar(
        context,
        message: 'Please enter your role/designation',
        isSuccess: false,
      );
      return;
    }

    final parts = name.split(RegExp(r'\s+'));
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    final ageText = _ageController.text.trim();
    final age = int.tryParse(ageText);

    final location = _locationController.text.trim();

    context.read<ProfileBloc>().add(
          UpdateProfileSubmitted(
            firstName: firstName,
            lastName: lastName,
            designation: role,
            age: age,
            location: location.isNotEmpty ? location : null,
            imagePath: _selectedImagePath,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white38),
                      ),
                      child: IconButton(
                        icon:
                            const Icon(Icons.chevron_left, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: CommonText(
                          text: 'Edit Profile Details',
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 48.w),
                  ],
                ),
                SizedBox(height: 30.h),

                // Avatar / Image Picker
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFD48B3B),
                              width: 2,
                            ),
                            color: Colors.white.withValues(alpha: 0.08),
                            image: _selectedImagePath != null
                                ? DecorationImage(
                                    image: FileImage(File(_selectedImagePath!)),
                                    fit: BoxFit.cover,
                                  )
                                : (_existingPhotoUrl.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(_existingPhotoUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : null),
                          ),
                          child: _selectedImagePath == null &&
                                  _existingPhotoUrl.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  color: Colors.white54,
                                  size: 50,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD48B3B),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32.h),

                const CommonText(
                  text: 'Full Name',
                  color: Colors.white,
                  fontSize: 14,
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Enter your full name',
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  fieldBorderColor: Colors.white12,
                  fieldBorderRadius: 14,
                  textStyle: const TextStyle(color: Colors.white),
                  hintStyle: const TextStyle(color: Colors.white38),
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.name,
                ),
                SizedBox(height: 20.h),

                const CommonText(
                  text: 'Email',
                  color: Colors.white,
                  fontSize: 14,
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _emailController,
                  readOnly: true,
                  hintText: 'Enter your email',
                  fillColor: Colors.white.withValues(alpha: 0.03),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 14,
                  textStyle: const TextStyle(color: Colors.white70),
                  hintStyle: const TextStyle(color: Colors.white38),
                  cursorColor: Colors.white,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Colors.white38,
                    size: 20,
                  ),
                ),
                SizedBox(height: 20.h),

                const CommonText(
                  text: 'Your Role',
                  color: Colors.white,
                  fontSize: 14,
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _roleController,
                  hintText: 'Enter your role',
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  fieldBorderColor: Colors.white12,
                  fieldBorderRadius: 14,
                  textStyle: const TextStyle(color: Colors.white),
                  hintStyle: const TextStyle(color: Colors.white38),
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 20.h),

                const CommonText(
                  text: 'Your Age',
                  color: Colors.white,
                  fontSize: 14,
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _ageController,
                  hintText: 'Enter your age',
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  fieldBorderColor: Colors.white12,
                  fieldBorderRadius: 14,
                  textStyle: const TextStyle(color: Colors.white),
                  hintStyle: const TextStyle(color: Colors.white38),
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20.h),

                const CommonText(
                  text: 'Location',
                  color: Colors.white,
                  fontSize: 14,
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _locationController,
                  hintText: 'Enter your location',
                  suffixIcon: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.white38,
                  ),
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  fieldBorderColor: Colors.white12,
                  fieldBorderRadius: 14,
                  textStyle: const TextStyle(color: Colors.white),
                  hintStyle: const TextStyle(color: Colors.white38),
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.streetAddress,
                ),
                SizedBox(height: 36.h),

                BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileSuccess) {
                      showAppSnackBar(
                        context,
                        message: state.message,
                        isSuccess: true,
                      );
                      Navigator.pop(context, true);
                    } else if (state is ProfileFailure) {
                      showAppSnackBar(
                        context,
                        message: state.message,
                        isSuccess: false,
                      );
                    }
                  },
                  builder: (context, state) {
                    return CommonButton(
                      isLoading: state is ProfileLoading,
                      titleText: 'Save & Changes',
                      titleColor: Colors.black,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFC77926), Color(0xFFFBE1A6)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      onTap: _onSave,
                    );
                  },
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';
import 'dart:io';
import 'package:blog_app/features/blog/presentation/blocs/bloc.dart';
import 'package:blog_app/features/user/presentation/blocs/get_user.dart/user_state.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

// import 'package:blog_app/core/utils/imagePickerCroper.dart';
import 'package:blog_app/features/user/domain/usecases/change_profile.dart';
import 'package:blog_app/features/user/domain/usecases/get_user.dart';
import 'package:blog_app/features/user/domain/usecases/login_user.dart';
import 'package:blog_app/features/user/domain/usecases/register_user.dart';
import 'package:blog_app/features/user/domain/usecases/update_user.dart';
import 'package:blog_app/features/user/presentation/blocs/bloc.dart';
import 'package:blog_app/features/user/presentation/blocs/bloc_state.dart';
import 'package:blog_app/features/user/presentation/blocs/get_user.dart/change_profile_pic/profile_pic_event.dart';
import 'package:blog_app/features/user/presentation/blocs/get_user.dart/change_profile_pic/profile_pic_state.dart';
import 'package:blog_app/injection.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/features/user/domain/entities/user.dart' as UserEntity;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/get_user.dart/user_event.dart';
import '../pages/user_profile_screen.dart';

class Aboutme extends StatefulWidget {
  final Function(String) onActivitySelected;
  final UserEntity.User user;
  const Aboutme(
      {super.key, required this.onActivitySelected, required this.user});

  @override
  State<Aboutme> createState() => _AboutmeState();
}

class _AboutmeState extends State<Aboutme> {
  // ignore: non_constant_identifier_names
  late String profile_photo;
  File photo = File('');
  late String? profile;
  String? updated = '';
  final bool _isDisposed = false;

  @override
  void initState() {
    super.initState();

    // Get User
    context.read<UserBloc>().add(const GetUserEvent());
    context.read<UserBloc>().stream.listen((state) {
      // Check if widget is disposed before using setState
      if (!_isDisposed) {
        if (state is LoadedGetUserState) {
          setState(() {
            profile_photo = state.user.image ?? "no_profile.png";
          });
        } else if (state is UserLoading) {
          log("Loading on User Profile Page");
        }
      }
    });
  }

  Future<void> updateProfileImage() async {
    final picker = ImagePicker();
    try {
      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage != null) {
        final croppedImage = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Color.fromARGB(255, 223, 223, 223),
                toolbarWidgetColor: const Color(0xff212121),
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
            ),
            // ignore: use_build_context_synchronously
            WebUiSettings(
              context: context,
            ),
          ],
        );

        if (croppedImage != null) {
          if (!_isDisposed) {
            setState(() {
              photo = File(croppedImage.path);
            });
          }

          // context.read<UserBloc>().add(GetUser());

          // successfully updated alert
          // ignore: use_build_context_synchronously
        } else {
          log('Image cropping canceled.');
        }
      } else {
        log('No image selected.');
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  bool showEditButton = false;

  void _showEditButton() {
    if (!_isDisposed) {
      setState(() {
        showEditButton = true;
      });
    }
    Timer(const Duration(seconds: 10), () {
      if (!_isDisposed) {
        setState(() {
          showEditButton = false;
        });
      }
    });
  }

  int selectedIndex = 1; // Initialize selectedIndex here

  Widget buildCustomMetricRow(String value, String title, int index) {
    final color = index == selectedIndex
        ? const Color.fromARGB(255, 8, 85, 148)
        : const Color.fromARGB(255, 33, 150, 243);

    return GestureDetector(
      onTap: () {
        if (!_isDisposed) {
          setState(() {
            selectedIndex = index; // Update selected index for each row
          });
        }
        widget.onActivitySelected(title);
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Urbanist',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Urbanist',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    profile_photo = widget.user.image ?? "no_profile.png";

    return BlocProvider(
        create: (context) => UserBloc(
              registerUser: sl<RegisterUserUseCase>(),
              loginUser: sl<LoginUserUseCase>(),
              getUser: sl<GetUserUseCase>(),
              updateProfilePhoto: sl<ChangeProfileUseCase>(),
            ),
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is ChangingProfileState) {
              // Navigator.pushNamed(context, '/home', arguments: state.user.id);
              log('profile state');
            }
            // loading state
            else if (state is ChangedProfileState) {
              context.read<UserBloc>().add(const GetUserEvent());
              print('changed profile state');
              if (!_isDisposed) {
                setState(() {
                  profile_photo = state.user.image!;
                });
              }

              // Show a SnackBar at the top
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Your profile has been updated.'),
                  duration: Duration(seconds: 5),
                  behavior: SnackBarBehavior.floating, // Display at the top
                ),
              );
            }
          },
          builder: (context, state) {
            return buildBody(context);
          },
        ));
  }

  Widget buildBody(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Widget buildCustomMetricRow(String title, String value, int isSelected) {
      return GestureDetector(
        onTap: () {
          if (!_isDisposed) {
            setState(() {
              selectedIndex = isSelected; // Update selected index for each row
            });
          }
          final color = isSelected == selectedIndex
              ? const Color.fromARGB(255, 8, 85, 148)
              : const Color.fromARGB(255, 33, 150, 243);
          widget.onActivitySelected(title);
        },
        child: Container(
          width: screenWidth * 0.2,
          height: screenWidth * 0.2, // Adjust the height as needed
          decoration: BoxDecoration(
            color: isSelected == selectedIndex
                ? const Color.fromARGB(255, 8, 85, 148)
                : const Color.fromARGB(255, 33, 150, 243),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Urbanist',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Urbanist',
                      fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Center(
      child: SizedBox(
        // width: screenWidth * 0.8,
        height: screenHeight * 0.4,
        // color: Colors.red,f
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: screenWidth * 0.85,
              height: screenHeight * 0.37,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(149, 157, 165, 0.2),
                    offset: Offset(0, 8),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    if (showEditButton)
                      // ... Positioning of the edit button ...

                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: const Color(0xFF376AED),
                          onSurface: Colors.grey,
                        ),
                        onPressed: () async {
                          await updateProfileImage();
                          // ignore: use_build_context_synchronously
                          context
                              .read<UserBloc>()
                              .add(ChangeProfileEvent(id: 2, image: photo));
                        },

                        // Trigger the file picker
                        child: const Text("change profile picture"),
                      ),
                    Container(
                      width: double.infinity,
                      height: 120,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 0.23 *
                                screenWidth, // Adjust the width based on screen width
                            height: 0.3 * screenHeight,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFF376AED)),
                                borderRadius: BorderRadius.circular(35),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: _showEditButton,
                                child: Container(
                                  width: 0.1 *
                                      screenWidth, // Adjust the width based on screen width
                                  height: 0.2 * screenHeight,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 0,
                                          color:
                                              Color.fromARGB(0, 55, 107, 237)),
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    image: DecorationImage(
                                      image: profile_photo != null &&
                                              Uri.parse(profile_photo)
                                                  .isAbsolute
                                          ? NetworkImage(profile_photo)
                                              as ImageProvider // Non-null assertion operator
                                          : const AssetImage(
                                              "assets/images/no_profile.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "@${widget.user.fullName}",
                                style: const TextStyle(
                                  color: Color(0xFF2D4379),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.24,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "${widget.user.fullName}",
                                style: const TextStyle(
                                  color: Color(0xFF0D253C),
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'UX Designer',
                                style: TextStyle(
                                  color: Color(0xFF376AED),
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: Text(
                            'About me',
                            style: TextStyle(
                              color: Color(0xFF0D253C),
                              fontSize: 17,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Text(
                            "${widget.user.bio}",
                            style: const TextStyle(
                              color: Color(0xFF2D4379),
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w100,
                              height: 1.43,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: screenWidth * 0.6, // Adjust the width
                height: screenHeight * 0.08,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 33, 150, 243),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(149, 157, 165, 0.2),
                      offset: Offset(0, 8),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: buildCustomMetricRow(
                          "Posts",
                          '4.5K',
                          1,
                        ),
                      ),
                      Expanded(
                        child: buildCustomMetricRow(
                          "Following",
                          '4.5K',
                          2,
                        ),
                      ),
                      Expanded(
                        child: buildCustomMetricRow(
                          "Follower",
                          '4.5K',
                          3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

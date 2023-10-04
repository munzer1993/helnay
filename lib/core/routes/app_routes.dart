import 'package:get/get.dart';
import 'package:project/core/routes/router.dart';
import 'package:project/view/screen/caht_screen/chat_screen.dart';
import 'package:project/view/screen/edit_profile_screen/edit_profile_screen.dart';
import 'package:project/view/screen/forget_password_screen/forget_password_screen.dart';
import 'package:project/view/screen/home_screen/home_screen.dart';
import 'package:project/view/screen/login_screen/login_screen.dart';
import 'package:project/view/screen/on_boarding_screen/on_boarding_screen.dart';
import 'package:project/view/screen/option_screen/option_screen.dart';
import 'package:project/view/screen/register_screen/register_screen.dart';
import 'package:project/view/screen/report_user_screen/report_user_screen.dart';
import 'package:project/view/screen/selec_photo_screen/select_photo_screen.dart';
import 'package:project/view/screen/start_data_user_intery/start_data_user_intery_screen.dart';
import 'package:project/view/screen/start_screen/start_screen.dart';
import 'package:project/view/screen/user_detailes_screen/user_details_screen.dart';
import 'package:project/view/screen/vedio_player_screen/vedio_player_screen.dart';
import 'package:project/view/screen/vedio_preview_screen/vedio_preview_screen.dart';

List<GetPage<dynamic>>? routes = [
  //================= STARTSCREEN =============//
  GetPage(
    name: AppRoutes.startScreen,
    page: () => const StartScreen(),
    //middlewares: [MyMiddleWare()],
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.onBoarding,
    page: () => const OnBoarding(),
    transition: Transition.fadeIn,
  ),
  //================= AUTH SCREEN =============//
  GetPage(
    name: AppRoutes.loginScreen,
    page: () => const LoginScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.registerScreen,
    page: () => const RegisterScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.forgetPasswordScreen,
    page: () => const ForgetPasswordScreen(),
    transition: Transition.fadeIn,
  ),
  //================= HOME SCREEN =============//
  GetPage(
    name: AppRoutes.homeScreen,
    page: () => const HomeScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.userDetailsScreen,
    page: () => const UserDetailsScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.chatScreen,
    page: () => const ChatScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.vedioPerivewScreen,
    page: () => const VedioPerivewScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.videoPlayerScreen,
    page: () => const VideoPlayerScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.reportUsersScreen,
    page: () => const ReportUsersScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.editProfileScreen,
    page: () => const EditProfileScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.optionScreen,
    page: () => const OptionScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.selectPhotoScreen,
    page: () => const SelectPhotoScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.startDataUserInteryScreen,
    page: () => const StartDataUserInteryScreen(),
    transition: Transition.fadeIn,
  ),
];

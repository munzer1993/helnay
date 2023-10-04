import 'package:project/core/constant/app_photo.dart';
import 'package:project/data/models/on_boarding_model.dart';

List<OnBoardingModel> onBoardingList = [
  OnBoardingModel(
    title: "About Helnay",
    body:
        "Helnay was established to give the Somali community a platform to find their spouse.\n We have had so many requests over the last couple of years and have come up with Helnay \nto direct those who are ready to step into the marital stage of their lives.",
    image: AppPhotoLink.aboutHelnay,
  ),
  OnBoardingModel(
    title: "CONNECT WITH PEOPLE \nNEAR YOU",
    body:
        "You can now find individuals looking for their soulmates nearby you within the guideline of our safety policy.",
    image: AppPhotoLink.connectPeople,
  ),
  OnBoardingModel(
    title: "WHY HELNAY",
    body:
        "As one of the largest Islamic matrimonial sites around, \nHelnay boasts a membership of over 3.6 million singles worldwide. \nFor Muslim singles searching for soulmate and Muslim divorcees looking to get back out there, this is a welcoming place.",
    image: AppPhotoLink.whyHeleny,
  ),
];

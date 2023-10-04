class AppLink {
  // =================== base URL ================//
  static int aUserId = -1;
  static const String base = 'https://helnay.com/orange/';
  static const String aBaseUrl = '${base}api/';
  static const String authKey =
      'AAAAbPTHzOo:APA91bGoU5lhkc8p-VbEbcGt6px4elIXRazIe92lK1_TJryQgjjpEb9kuJrtRARVn8jTVaWeHReUTYm00yRsOHxF4kqE4TCn8UJrR8i0ag0hR8_6XeBGqPxKXGhS5XeYSiIus9BqM0hX';

  /// image base url
  static const String aImageBaseUrl = '${base}public/storage/';

  /// api credential
  static const String aApiKeyName = 'apikey';
  static const String aApiKey = '123';

  static const String registerAPI = '${aBaseUrl}register';
  static const String getExplorePageProfileList =
      '${aBaseUrl}getExplorePageProfileList';
  static const String getProfile = '${aBaseUrl}getProfile';
  static const String updateSavedProfile = '${aBaseUrl}updateSavedProfile';
  static const String updateLikedProfile = '${aBaseUrl}updateLikedProfile';
  static const String notifyLikedUser = '${aBaseUrl}notifyLikedUser';
  static const String updateBlockList = '${aBaseUrl}updateUserBlockList';
  static const String storageFileGivePath = '${aBaseUrl}storeFileGivePath';
  static const String minusCoinsFromWallet = '${aBaseUrl}minusCoinsFromWallet';
  static const String getAdminNotification = '${aBaseUrl}getAdminNotifications';
  static const String getUserNotification = '${aBaseUrl}getUserNotifications';
  static const String addReport = '${aBaseUrl}addReport';
  static const String getInterests = '${aBaseUrl}getInterests';
  static const String updateProfile = '${aBaseUrl}updateProfile';
  static const String deleteMyAccount = '${aBaseUrl}deleteMyAccount';
  static const String logoute = '${aBaseUrl}logOutUser';
}

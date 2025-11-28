import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/models/place_model.dart';
import '../../../data/models/checkin_model.dart';
import '../../../data/models/review_model.dart';
import '../../../data/repositories/checkin_repository_impl.dart';
import '../../../data/repositories/review_repository_impl.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/constants/food_type.dart';
import '../../../core/constants/place_value.dart';
import '../../../core/services/location_service.dart';

/// Mission Step Enum
enum MissionStep {
  photo, // Step 1: Ambil foto (Check-in)
  review, // Step 2: Tulis ulasan
  survey, // Step 3: Isi kuesioner
}

/// Mission Controller
class MissionController extends GetxController {
  // Repositories
  late final CheckinRepository _checkinRepository;
  late final ReviewRepository _reviewRepository;

  // Current place for mission
  PlaceModel? currentPlace;

  // Current mission step
  final Rx<MissionStep> currentStep = MissionStep.photo.obs;

  // Photo capture state
  final Rx<String?> capturedImagePath = Rx<String?>(null);
  final Rx<String?> uploadedImageUrl = Rx<String?>(null); // URL after upload

  // Review state
  final reviewController = TextEditingController();
  final Rx<int> rating = 0.obs; // Start with 0 (no rating selected)
  final RxList<String> reviewMediaPaths = <String>[].obs; // Photos/videos for review
  final RxList<FoodType> selectedFoodTypes = <FoodType>[].obs; // Selected food types
  final RxList<PlaceValue> selectedPlaceValues = <PlaceValue>[].obs; // Selected place values

  // Survey state
  final RxMap<String, dynamic> surveyAnswers = <String, dynamic>{}.obs;

  // Settings from confirm modal
  final RxBool hideUsername = false.obs;

  // Loading state
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  // Error message
  final Rx<String?> errorMessage = Rx<String?>(null);

  // Results
  final Rx<CheckinModel?> checkinResult = Rx<CheckinModel?>(null);
  final Rx<ReviewModel?> reviewResult = Rx<ReviewModel?>(null);

  // Points from place
  int get expReward => currentPlace?.expReward ?? 50;
  int get coinReward => currentPlace?.coinReward ?? 25;

  @override
  void onInit() {
    super.onInit();
    _checkinRepository = Get.find<CheckinRepository>();
    _reviewRepository = Get.find<ReviewRepository>();
  }

  @override
  void onClose() {
    reviewController.dispose();
    super.onClose();
  }

  /// Initialize mission with place
  void initMission(PlaceModel place, {bool hideUsername = false}) {
    currentPlace = place;
    currentStep.value = MissionStep.photo;
    capturedImagePath.value = null;
    uploadedImageUrl.value = null;
    reviewController.clear();
    rating.value = 0; // No rating selected initially
    reviewMediaPaths.clear();
    selectedFoodTypes.clear();
    selectedPlaceValues.clear();
    surveyAnswers.clear();
    this.hideUsername.value = hideUsername;
    errorMessage.value = null;
    checkinResult.value = null;
    reviewResult.value = null;
  }

  /// Set captured image path
  void setCapturedImage(String path) {
    capturedImagePath.value = path;
  }

  /// Clear captured image
  void clearCapturedImage() {
    capturedImagePath.value = null;
  }

  /// Set hide username preference
  void setHideUsername(bool value) {
    hideUsername.value = value;
  }

  /// Add media to review
  void addReviewMedia(String path) {
    if (!reviewMediaPaths.contains(path)) {
      reviewMediaPaths.add(path);
    }
  }

  /// Remove media from review
  void removeReviewMedia(String path) {
    reviewMediaPaths.remove(path);
  }

  /// Toggle food type selection
  void toggleFoodType(FoodType foodType) {
    if (selectedFoodTypes.contains(foodType)) {
      selectedFoodTypes.remove(foodType);
    } else {
      selectedFoodTypes.add(foodType);
    }
  }

  /// Toggle place value selection
  void togglePlaceValue(PlaceValue placeValue) {
    if (selectedPlaceValues.contains(placeValue)) {
      selectedPlaceValues.remove(placeValue);
    } else {
      selectedPlaceValues.add(placeValue);
    }
  }

  /// Get current location using LocationService
  Future<Position?> _getCurrentLocation() async {
    final locationService = Get.find<LocationService>();
    final position = await locationService.getCurrentPosition(
      showSnackbars: false,
      accuracy: LocationAccuracy.high,
    );
    
    if (position == null) {
      errorMessage.value = 'Failed to get location';
    }
    
    return position;
  }

  /// Submit photo mission (Check-in)
  Future<bool> submitPhoto() async {
    if (capturedImagePath.value == null || currentPlace == null) {
      errorMessage.value = 'No photo captured or place not set';
      return false;
    }

    isSubmitting.value = true;
    errorMessage.value = null;

    try {
      // Get current location
      final position = await _getCurrentLocation();
      if (position == null) {
        isSubmitting.value = false;
        return false;
      }

      // TODO: Upload image to Cloudinary first, then get URL
      // For now, use placeholder URL
      final imageUrl = 'https://placeholder.com/mission_${DateTime.now().millisecondsSinceEpoch}.jpg';
      uploadedImageUrl.value = imageUrl;

      print('position: ${position.latitude}, ${position.longitude}');
      print('Uploaded image URL: $imageUrl');

      // Create checkin
      final checkin = await _checkinRepository.createCheckin(
        placeId: currentPlace!.id!,
        latitude: position.latitude,
        longitude: position.longitude,
        imageUrl: imageUrl,
        additionalInfo: {
          'device': GetPlatform.isAndroid ? 'android' : 'ios',
        },
      );

      checkinResult.value = checkin;
      return true;
    } on NetworkException catch (e) {
      errorMessage.value = e.message;
      return false;
    } on ServerException catch (e) {
      errorMessage.value = e.message;
      return false;
    } on ValidationException catch (e) {
      errorMessage.value = e.message;
      return false;
    } catch (e) {
      errorMessage.value = 'Unexpected error: $e';
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Submit review mission (includes survey in additional_info)
  Future<bool> submitReview() async {
    if (reviewController.text.trim().isEmpty || currentPlace == null) {
      errorMessage.value = 'Review content is empty or place not set';
      return false;
    }

    isSubmitting.value = true;
    errorMessage.value = null;

    try {
      // Prepare image URLs (from checkin photo + review media)
      final imageUrls = <String>[];
      if (uploadedImageUrl.value != null) {
        imageUrls.add(uploadedImageUrl.value!);
      }
      // Add review media URLs
      imageUrls.addAll(reviewMediaPaths);

      // Prepare additional info
      final additionalInfo = <String, dynamic>{
        'hide_username': hideUsername.value,
      };

      // Add selected food types
      if (selectedFoodTypes.isNotEmpty) {
        additionalInfo['food_types'] = 
            selectedFoodTypes.map((e) => e.label).toList();
      }

      // Add selected place values
      if (selectedPlaceValues.isNotEmpty) {
        additionalInfo['place_values'] = 
            selectedPlaceValues.map((e) => e.label).toList();
      }

      // Add survey answers if available
      if (surveyAnswers.isNotEmpty) {
        additionalInfo['survey'] = Map<String, dynamic>.from(surveyAnswers);
      }

      // Create review
      final review = await _reviewRepository.createReview(
        placeId: currentPlace!.id!,
        content: reviewController.text.trim(),
        rating: rating.value,
        imageUrls: imageUrls.isNotEmpty ? imageUrls : null,
        additionalInfo: additionalInfo,
      );

      reviewResult.value = review;
      return true;
    } on NetworkException catch (e) {
      errorMessage.value = e.message;
      return false;
    } on ServerException catch (e) {
      errorMessage.value = e.message;
      return false;
    } on ValidationException catch (e) {
      errorMessage.value = e.message;
      return false;
    } catch (e) {
      errorMessage.value = 'Unexpected error: $e';
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Submit survey mission (data goes to review's additional_info)
  /// This just marks survey as complete, actual data is sent with review
  Future<bool> submitSurvey() async {
    if (surveyAnswers.length < 3) {
      errorMessage.value = 'Please answer all survey questions';
      return false;
    }

    isSubmitting.value = true;
    errorMessage.value = null;

    try {
      // Survey data is already in surveyAnswers
      // It will be included in the review's additional_info
      // If review was already submitted, we need to update it
      // For now, we assume survey is submitted together with review

      // Simulate processing
      await Future.delayed(const Duration(milliseconds: 500));

      return true;
    } catch (e) {
      errorMessage.value = 'Unexpected error: $e';
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Move to next step
  void nextStep() {
    switch (currentStep.value) {
      case MissionStep.photo:
        currentStep.value = MissionStep.review;
        break;
      case MissionStep.review:
        currentStep.value = MissionStep.survey;
        break;
      case MissionStep.survey:
        // Mission complete
        break;
    }
  }

  /// Reset mission
  void resetMission() {
    currentPlace = null;
    currentStep.value = MissionStep.photo;
    capturedImagePath.value = null;
    uploadedImageUrl.value = null;
    reviewController.clear();
    rating.value = 0;
    reviewMediaPaths.clear();
    selectedFoodTypes.clear();
    selectedPlaceValues.clear();
    surveyAnswers.clear();
    hideUsername.value = false;
    errorMessage.value = null;
    checkinResult.value = null;
    reviewResult.value = null;
  }

  /// Save survey answers from modal
  void saveSurveyAnswers(Map<int, bool> answers) {
    surveyAnswers.clear();
    answers.forEach((questionIndex, isPositive) {
      surveyAnswers['q${questionIndex + 1}'] = isPositive;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/tokens.dart';

/// Where a cover image came from.
enum CoverSource { camera, gallery }

/// The shape covers are drawn in. Offered as the starting point because it
/// makes a cover fill its slot exactly, but never imposed — books are not all
/// the same shape, and neither are photographs of them.
class _CoverRatio implements CropAspectRatioPresetData {
  const _CoverRatio();

  @override
  String get name => '2:3';

  @override
  (int, int)? get data => (2, 3);
}

/// Picking and framing a cover.
///
/// The crop is free: width and height are dragged independently, starting from
/// the 2:3 a cover is displayed at. Whatever shape comes back is shown whole —
/// see [BookCover] — so nothing the user framed is quietly cropped again.
class CoverPicker {
  const CoverPicker();

  /// The ratio a cover slot is drawn at, offered first among the presets.
  static const coverRatio = _CoverRatio();

  /// Picks an image and then frames it. Returns the cropped file's path, or
  /// null if the user backed out of either step.
  Future<String?> pickAndCrop({
    required CoverSource source,
    double devicePixelRatio = 3,
  }) async {
    final picked = await ImagePicker().pickImage(
      source: source == CoverSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      // Generous: the crop happens after this, and cropping a shrunken image
      // would throw away detail the user chose to keep.
      maxWidth: 2400,
      imageQuality: 92,
    );
    if (picked == null) return null;

    return crop(picked.path);
  }

  /// Re-frames an image already on file.
  Future<String?> crop(String sourcePath) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: sourcePath,
      // No aspectRatio here: passing one pins the crop box and takes the
      // handles away.
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      // A cover is never shown larger than a phone screen; anything beyond
      // this is storage spent on pixels nobody sees. Both bounds are generous
      // enough that a wide or a tall crop still keeps its detail.
      maxWidth: 1800,
      maxHeight: 1800,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Frame the cover',
          toolbarColor: AppColors.ink,
          toolbarWidgetColor: AppColors.paper,
          backgroundColor: AppColors.darkScene,
          activeControlsWidgetColor: AppColors.accent,
          cropFrameColor: AppColors.highlightBright,
          cropGridColor: const Color(0x55E9C79A),
          // Dark toolbar, so the status bar needs light icons.
          statusBarLight: false,
          // Free-form: every edge is draggable. The ratios below are there as
          // shortcuts, not as a cage.
          lockAspectRatio: false,
          hideBottomControls: false,
          initAspectRatio: coverRatio,
          aspectRatioPresets: const [
            coverRatio,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio3x2,
          ],
        ),
        IOSUiSettings(
          title: 'Frame the cover',
          aspectRatioLockEnabled: false,
          aspectRatioPickerButtonHidden: false,
          resetAspectRatioEnabled: true,
          rotateClockwiseButtonHidden: false,
          doneButtonTitle: 'Use',
          cancelButtonTitle: 'Cancel',
        ),
      ],
    );

    return cropped?.path;
  }
}

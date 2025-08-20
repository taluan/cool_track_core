
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:base_code_flutter/base_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:file_picker/file_picker.dart';
export 'package:image_picker/image_picker.dart';

import '../../utils/app_const.dart';
import '../generated/l10n.dart';

enum PickerSoureType {
  camera, gallery, files;

  String get title => switch(this) {
    camera => S.current.chup_anh,
    gallery => S.current.chon_tu_thu_vien,
    files => S.current.chon_tep
  };

  static const List<PickerSoureType> all = [PickerSoureType.files, PickerSoureType.camera, PickerSoureType.gallery];
}

mixin FilePickerMixin {
  final String fileExtension = ".xls, .xlsx, .doc, .docx, .pdf, .txt, .mpp, .mppx, .ppt, .pptx, .jpg, .jpeg, .png, .gif, .zip, .rar, .7z, .msg";
  List<String> get extensionList => fileExtension.split(", ");
  Future<PickerSoureType?> showSelectActionSheet(BuildContext context, {List<PickerSoureType> sources = PickerSoureType.all}) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black26,
        builder: (ctx) {
          return CupertinoActionSheet(
            actions: PickerSoureType.all.map((e) => CupertinoActionSheetAction(
              child: Text(e.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              onPressed: () {
                Navigator.of(ctx).maybePop(e);
              },
            )).toList(),
            cancelButton: CupertinoActionSheetAction(
              child: Text(S.current.cancel,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(ctx).maybePop();
              },
            ),
          );
        });
  }

  void showPicker(BuildContext context, {required PickerSoureType source, bool allowMultiple = false, List<String> allowedExtensions= const [".doc", ".docx", ".pdf"]}) {
    {
      switch(source) {
        case PickerSoureType.files: {
          FilePickerHandler(context).showFilePicker(allowMultiple: allowMultiple,
              allowedExtensions: allowedExtensions,
              onFilesSelected: onFilesSelected);
          break;
        }
        case PickerSoureType.camera: {
          FilePickerHandler(context).showTakePhoto(onSelected: onImagesSelected);
          break;
        }
        case PickerSoureType.gallery: {
          FilePickerHandler(context).showGalleryPhoto(
              allowMultiple: allowMultiple,
              onSelected: onImagesSelected);
          break;
        }
      }
    }
  }

  void onFilesSelected(List<PlatformFile> lsFiles);
  void onImagesSelected(List<XFile> images);
}

class FilePickerHandler {

  bool _allowMultiple = false;
  Function(List<XFile>)? _onImagesSelected;
  final BuildContext context;
  FilePickerHandler(this.context);

  void showFilePicker({bool allowMultiple = false, List<String> allowedExtensions = const [".doc", ".docx", ".pdf"], required Function(List<PlatformFile>) onFilesSelected}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: allowMultiple, // Cho phép chọn nhiều tệp
        allowedExtensions: allowedExtensions.isNotEmpty
            ? allowedExtensions
            .map((e) => e.replaceAll(".", ""))
            .toList()
            : null,
        type: allowedExtensions.isNotEmpty
            ? FileType.custom
            : FileType.any);

    if (result != null) {
      onFilesSelected(result.files);
    } else {
      print("Không có tệp nào được chọn.");
    }
  }

  void showTakePhoto({required Function(List<XFile>) onSelected}) {
    _onImagesSelected = onSelected;
    if (Platform.isAndroid) {
      _checkCameraPermission();
    } else {
      _takePhoto();
    }
  }

  void showGalleryPhoto({bool allowMultiple = false, required Function(List<XFile>) onSelected}) {
    _allowMultiple = allowMultiple;
    _onImagesSelected = onSelected;
    if (Platform.isAndroid) {
      _checkPhotoPermission();
    } else {
      _selectPhotoFromGallery();
    }
  }


  void _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied ) {
      bool shouldShowRequestRationale = await Permission.camera.shouldShowRequestRationale;
      final index = await appCoreConfig.showConfirm(
          context: context,
          message:
          "Bạn cần cho phép ứng dụng truy cập máy ảnh để ứng dụng có thể giúp bạn cập nhật ảnh đại diện và đính kèm hình ảnh nhé.",);
      if (index == 1) {
        final Map<Permission, PermissionStatus> permissions = await [
          Permission.camera,
        ].request();
        if (permissions[Permission.camera] ==
            PermissionStatus.granted) {
          _takePhoto();
        } else if (permissions[Permission.camera] ==
            PermissionStatus.permanentlyDenied && !shouldShowRequestRationale) {
          AppSettings.openAppSettings();
        }
      }
      return;
    }
    _takePhoto();
  }

  void _takePhoto() async {
    try {
      await _getImage(ImageSource.camera);
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == "camera_access_denied") {
          final index = await appCoreConfig.showConfirm(
              context: context,
              message:
              "Ứng dụng không có quyền truy cập camera, vui lòng cho phép ứng dụng truy cập hình camera.",
              okTitle: S.current.settings,);
          if (index == 1) {
            AppSettings.openAppSettings();
          }
        }
      }
      debugPrint("get image error: ${e.toString()}");
    }
  }

  void _checkPhotoPermission() async {
    final status = await getPhotoPermission();
    if (!status) {
      final index = await appCoreConfig.showConfirm(
          context: context,
          message:
          "Bạn cần cho phép ứng dụng truy cập hình ảnh để có thể giúp bạn cập nhật ảnh đại diện và đính kèm hình ảnh nhé.",);
      if (index == 1) {
        setPhotoPermission(true);
        _selectPhotoFromGallery();
      }
    } else {
      _selectPhotoFromGallery();
    }
  }

  void _selectPhotoFromGallery() async {
    try {
      await _getImage(ImageSource.gallery);
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == "photo_access_denied") {
          final index = await appCoreConfig.showConfirm(
              context: context,
              message:
              "Ứng dụng không có quyền truy cập hình ảnh, vui lòng cho phép ứng dụng truy cập hình ảnh trên thiết bị của bạn.",
              okTitle: S.current.settings);
          if (index == 1) {
            AppSettings.openAppSettings();
          }
          return;
        }
      }
      debugPrint("get image error: ${e.toString()}");
    }
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      if (_allowMultiple && source == ImageSource.gallery) {
        final result = await ImagePicker().pickMultiImage(maxWidth: 1024, maxHeight: 1024);
        if (_onImagesSelected != null) {
          _onImagesSelected!(result);
        }
      } else {
        final pickedFile = await ImagePicker().pickImage(
            source: source, maxWidth: 1024, maxHeight: 1024);
        if (pickedFile != null && _onImagesSelected != null) {
          _onImagesSelected!([pickedFile]);
        }
      }

    } catch (e) {
      debugPrint("picker image error: ${e.toString()}");
      rethrow;
    }
  }

  static Future<File?> showCropImage(File image, {CropAspectRatio? cropRatio}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path, maxWidth: 1024, maxHeight: 1024,
      aspectRatio: cropRatio,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cắt hình',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: cropRatio != null),
        IOSUiSettings(
            title: 'Cắt hình',
            aspectRatioLockEnabled: cropRatio != null,
            doneButtonTitle: S.current.done,
            cancelButtonTitle: S.current.cancel,
            aspectRatioLockDimensionSwapEnabled: true,
            resetAspectRatioEnabled: true
        ),
      ],
    );
    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return image;
  }

  void setPhotoPermission(bool isEnabled) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("KEY_PHOTO_PERMISSION", isEnabled);
  }

  Future<bool> getPhotoPermission() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool("KEY_PHOTO_PERMISSION") ?? false;
  }
}
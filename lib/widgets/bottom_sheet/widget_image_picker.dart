import 'package:base_code_flutter/base_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:app_settings/app_settings.dart';

import '../../generated/l10n.dart';

class ImagePickerBottomSheet extends StatefulWidget {
  final bool enableCrop;
  final CropAspectRatio? cropRatio;
  final List<CupertinoActionSheetAction> extraMenus;
  const ImagePickerBottomSheet({super.key, this.enableCrop = false, this.cropRatio, required this.extraMenus});

  static Future<dynamic> show(BuildContext context,
      {bool cropImage = false, CropAspectRatio? cropRatio, List<CupertinoActionSheetAction>? extraMenus}) async {
    return await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black26,
        builder: (context) {
          return ImagePickerBottomSheet(
              enableCrop: cropImage, cropRatio: cropRatio, extraMenus: extraMenus ?? [],);
        });
  }

  @override
  _ImagePickerBottomSheetState createState() => _ImagePickerBottomSheetState();
}

class _ImagePickerBottomSheetState extends State<ImagePickerBottomSheet> {
  final ImagePicker _picker = ImagePicker();
  bool canBack = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          child: Text(
            S.current.chup_anh,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          onPressed: () async {
            canBack = false;
            try {
              final image = await getImage(ImageSource.camera);
              canBack = true;
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop(image);
              }
            }catch(e) {
              canBack = true;
              if (e is PlatformException) {
                if (e.code == "camera_access_denied") {
                  Navigator.of(context).pop();
                  final result = await appCoreConfig.showConfirm(context: context, message: "Ứng dụng không có quyền truy cập camera, vui lòng cho phép ứng dụng truy cập hình camera.", okTitle: "Cài đặt");
                  if (result == 1) {
                    AppSettings.openAppSettings();
                  }
                  return;
                }
              }
              debugPrint("get image error: ${e.toString()}");
            }
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Chọn từ photo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
          onPressed: () async {
            canBack = false;
            try {
              final image = await getImage(ImageSource.gallery);
              canBack = true;
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop(image);
              }
            }catch(e) {
              canBack = true;
              if (e is PlatformException) {
                if (e.code == "photo_access_denied") {
                  Navigator.of(context).pop();
                  final result = await appCoreConfig.showConfirm(context: context, message: "Ứng dụng không có quyền truy cập hình ảnh, vui lòng cho phép ứng dụng truy cập hình ảnh trên thiết bị của bạn.", okTitle: "Cài đặt");
                  if (result == 1) {
                    AppSettings.openAppSettings();
                  }
                  return;
                }
              }
              debugPrint("get image error: ${e.toString()}");
            }
          },
        ),
        ...widget.extraMenus
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(S.current.cancel,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.redAccent)),
        onPressed: () {
          if (canBack) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  Future<dynamic> getImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
          source: source, maxWidth: 1000, maxHeight: 1000);
      if (pickedFile != null) {
        final image = File(pickedFile.path);
        if (widget.enableCrop) {
          return await _cropImage(image);
        } else {
          return image;
        }
      } else {
        return null;
      }
    } catch (e) {

      debugPrint("picker image error: ${e.toString()}");
      rethrow;
    }
  }

  Future<File?> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();

    if (response.file != null) {
      final image = File(response.file!.path);
      if (widget.enableCrop) {
        return await _cropImage(image);
      } else {
        return image;
      }
    }
    return null;
  }

  Future<File?> _cropImage(File image) async {
    CroppedFile? croppedFile =  await ImageCropper().cropImage(
        sourcePath: image.path, maxWidth: 2048, maxHeight: 2048,
      aspectRatio: widget.cropRatio,
        compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cắt hình',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: widget.cropRatio != null),
        IOSUiSettings(
          title: 'Cắt hình',
          aspectRatioLockEnabled: widget.cropRatio != null,
              doneButtonTitle: "Xong",
              cancelButtonTitle: "Hủy",
              aspectRatioLockDimensionSwapEnabled: true,
            resetAspectRatioEnabled: true
        ),
      ],
    );
    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }
}

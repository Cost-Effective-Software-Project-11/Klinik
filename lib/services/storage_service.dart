import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  /// Uploads a file to Firebase Storage and returns the download URL
  Future<String?> uploadFileAndReturnDownloadURL(String filePath, String chatRoomId) async {
    File file = File(filePath);
    try {
      // Create a reference to the location in Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('chat_files/$chatRoomId/${path.basename(filePath)}');

      // Upload the file
      final uploadTask = storageRef.putFile(file);

      // Wait for the upload to complete
      final snapshot = await uploadTask;

      // Get the download URL of the uploaded file
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print("Error uploading file: $e");
      return null;
    }
  }

  /// Picks a file from the device using FilePicker
  Future<String?> pickFilePath() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc'],
      );

      if (result != null && result.files.single.path != null) {
        return result.files.single.path!;
      } else {
        return null;
      }
    } catch (e) {
      print("Error picking file: $e");
      return null;
    }
  }

  /// Picks an image from the gallery using ImagePicker and uploads it to Firebase Storage
  Future<String?> pickImageFromGallery(String chatRoomId) async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        return await uploadFileAndReturnDownloadURL(image.path, chatRoomId);
      } else {
        print('No image selected.');
        return null;
      }
    } catch (e) {
      print("Error picking image: $e");
      return null;
    }
  }

  /// Picks a video from the gallery using ImagePicker and uploads it to Firebase Storage
  Future<String?> pickVideoFromGallery(String chatRoomId) async {
    try {
      final XFile? video = await _imagePicker.pickVideo(source: ImageSource.gallery);

      if (video != null) {
        return await uploadFileAndReturnDownloadURL(video.path, chatRoomId);
      } else {
        print('No video selected.');
        return null;
      }
    } catch (e) {
      print("Error picking video: $e");
      return null;
    }
  }

  /// Takes a photo using the camera and uploads it to Firebase Storage
  Future<String?> takePhotoWithCamera(String chatRoomId) async {
    try {
      final XFile? photo = await _imagePicker.pickImage(source: ImageSource.camera);

      if (photo != null) {
        return await uploadFileAndReturnDownloadURL(photo.path, chatRoomId);
      } else {
        print('No photo captured.');
        return null;
      }
    } catch (e) {
      print("Error taking photo: $e");
      return null;
    }
  }

  /// Takes a video using the camera and uploads it to Firebase Storage
  Future<String?> takeVideoWithCamera(String chatRoomId) async {
    try {
      final XFile? video = await _imagePicker.pickVideo(source: ImageSource.camera);

      if (video != null) {
        return await uploadFileAndReturnDownloadURL(video.path, chatRoomId);
      } else {
        print('No video captured.');
        return null;
      }
    } catch (e) {
      print("Error capturing video: $e");
      return null;
    }
  }

  /// Downloads a file from Firebase Storage and saves it to the Downloads folder
  Future<void> downloadFile(String fileName, String chatRoomId) async {
    // Request storage permission before downloading
    await requestStoragePermission();
    try {
      // Create a reference to the file in Firebase Storage
      Reference ref = FirebaseStorage.instance.ref().child('chat_files/$chatRoomId/$fileName');

      // Hardcoded path to the "Downloads" directory on Android
      String downloadsDir = '/storage/emulated/0/Download';

      // Create the full file path in the Downloads directory
      String localPath = path.join(downloadsDir, fileName);

      File file = File(localPath);

      // Ensure the Downloads directory exists
      if (!file.parent.existsSync()) {
        await file.parent.create(recursive: true);
      }
      // Download the file to the local path
      await ref.writeToFile(file);

      print("File successfully downloaded to: $localPath");
    } catch (e) {
      print('Error downloading file: $e');
    }
  }



  Future<void> requestStoragePermission() async {
    // Check the current status of manage external storage permission
    var status = await Permission.manageExternalStorage.status;

    if (status.isDenied || status.isRestricted) {
      // If the permission is denied or restricted, request it
      var result = await Permission.manageExternalStorage.request();

      if (result.isGranted) {
        print("Manage External Storage permission granted");
      } else if (result.isPermanentlyDenied) {
        print("Manage External Storage permission permanently denied");
        // Optionally: Open app settings if permission is permanently denied
        await openAppSettings();
      } else {
        print("Manage External Storage permission denied");
      }
    } else if (status.isGranted) {
      print("Manage External Storage permission already granted");
    } else if (status.isPermanentlyDenied) {
      print("Manage External Storage permission permanently denied");
      // Optionally: Open app settings if permission is permanently denied
      await openAppSettings();
    }
  }


}

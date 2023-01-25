import 'package:flutter_ml_text/text_recognaiton.dart';
import 'package:image_picker/image_picker.dart';

class PickImage {
  XFile? imageFile;

  Future<XFile?> getImage(ImageSource imgSource) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: imgSource);
      if (pickedImage != null) {
        imageFile = pickedImage;
        //TextRecognation().getRecognisedText(pickedImage);
        return imageFile;
      }
    } catch (err) {
      imageFile = null;
    }
  }
}

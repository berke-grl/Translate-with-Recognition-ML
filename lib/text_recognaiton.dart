import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class TextRecognation {
  Future<String> getRecognisedText(XFile? file) async {
    if (file != null) {
      String scannedText = "";
      final inputImage = InputImage.fromFilePath(file.path);
      final textDetector = GoogleMlKit.vision.textRecognizer();
      RecognizedText recognizedText =
          await textDetector.processImage(inputImage);
      await textDetector.close();
      scannedText = "";
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          scannedText = scannedText + line.text + "\n";
        }
      }
      return scannedText;
    }
    return "";
  }
}

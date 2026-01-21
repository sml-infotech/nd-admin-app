import 'package:nammadaiva_dashboard/model/login_model/mantra_model/mantra_model.dart';

class UpdateMantraArguments {
  final String mantraName;
  final String mantra;
  final String image;
  final String mantraID;
  final List<MantraTranslation> translations;
  UpdateMantraArguments({
    required this.mantraName,
    required this.mantra,
    required this.image,
    required this.mantraID,
    required this.translations
  });
}

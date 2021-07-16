
import 'package:casia/BrainAnswer/form_data.dart';

class Seizure {

  String duration;
  String location;
  String type;
  List<String> triggers;
  List<String> auras;
  List<String> postSeizure;
  List<String> duringSeizure;
  bool emergencyTreatment;
  String comments;

  Seizure.fromFieldData(List<FieldData> form) {
    form.forEach((entry) {
      if (entry.hidden) {
        if (entry.label == 'type') type = entry.question;
        if (entry.label == 'duringSeizure') duringSeizure = entry.options;
      }
    });
  }

}
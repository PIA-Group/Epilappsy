class FormData {
  String id;
  DateTime createdAt;
  String fileID;
  String sessionID;
  String title;
  bool interactiveFeedback;
  List<FieldData> fields;

  FormData.fromMap(Map<String, dynamic> data) {
    this.id = data["id"];
    this.createdAt =
        DateTime.tryParse(data["datetime_created"]) ?? DateTime.now();
    this.fileID = data["id_file"];
    this.sessionID = data["id_session"];
    this.title = data["title"];
    this.interactiveFeedback = data["interactive_feedback"] != 0;
    //this.fields = List<FieldData>.from(
    //data["fields"].map(
    //(data) {
    //print(data);
    //return FieldData.fromMap(data);
    //},
    //),
    //);
  }

  int getNrFields() {
    return fields.length;
  }

  FieldData getField(int index) {
    if (index >= 0 && index <= fields.length) {
      return fields[index];
    } else {
      return null;
    }
  }
}

class FieldData {
  bool demographic = false;
  String demographicType;
  String expectedAnswer;
  String formModuleID;
  num max;
  num min;
  bool optional = false;
  String question;
  String label;
  String templateFieldID;
  String templateName;
  String type;
  String unit;

  FieldData.fromMap(Map<String, dynamic> data) {
    if (data["demographic"] != null && data["demographic"].isNotEmpty) {
      demographic = true;
      demographicType = data["demographic_type"];
    }
    if (data["expected_answer"] != null &&
        (data["expected_answer"].isNotEmpty || data["expected_answer"] != [])) {
      expectedAnswer = data["expected_answer"];
    }

    if (data["form_module_id"] != null && data["form_module_id"].isNotEmpty) {
      formModuleID = data["form_module_id"];
    }
    max = num.tryParse(data["max"]);
    min = num.tryParse(data["min"]);
    if (data["optional"] != null && data["optional"].isNotEmpty) {
      optional = true;
    }
    question = data["question"];
    label = data["report_label"];
    if (data["template_field_id"] != null &&
        data["template_field_id"].isNotEmpty) {
      templateFieldID = data["template_field_id"];
    }
    if (data["template_name"] != null && data["template_name"].isNotEmpty) {
      templateName = data["template_name"];
    }
    type = data["type"];
    if (data["unit"] != null && data["unit"].isNotEmpty) {
      unit = data["unit"];
    }
  }
}
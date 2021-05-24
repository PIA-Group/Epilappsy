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
    this.fields = List<FieldData>.from(
      data["fields"].map(
        (data) {
          return FieldData.fromMap(data);
        },
      ),
    );
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
  dynamic expectedAnswer;
  bool optional = false;
  String question;
  String label;
  List<dynamic> options;
  String type;
  bool horizontal = false;
  bool hidden = false;

  FieldData.fromMap(Map<String, dynamic> data) {

    type = data["type"];

    question = data["question"];

    label = data["report_label"];

    if (data["options"] != null && data["options"].isNotEmpty) {
      options = List<String>.from(data["options"].map((option) {return option["label"];}));
      print('options: $options');
    }

    if (data["expected_answer"] != null &&
        (data["expected_answer"].isNotEmpty || data["expected_answer"] != [])) {
      expectedAnswer = data["expected_answer"];
    }

    if (data["optional"] != null && data["optional"].isNotEmpty) {
      optional = true;
    }
    
    if (data["horizontal"] != null && data["horizontal"].isNotEmpty) {
      horizontal = true;
    }

    if (data["hidden"] != null && data["hidden"].isNotEmpty) {
      hidden = true;
    }

  }
  
}

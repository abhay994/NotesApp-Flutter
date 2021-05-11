

class NotesModel{
  final String id;     // Notes ID
  final String title;// Notes Title
  final String description; // Notes Description
  final String image;       //Notes Image
  final String timeStamp;    //created TimeStamp
  String onlineBackup;      // Notes Backup  yes || no


  NotesModel({
      this.id,
      this.title,
      this.description,
      this.onlineBackup,
      this.timeStamp,
      this.image
  });


  factory NotesModel.fromData(Map<String, dynamic> data) {
    return NotesModel(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        image: data['image'],
        onlineBackup: data['onlineBackup'],
        timeStamp: data['timeStamp']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'onlineBackup': onlineBackup,
      'image':image,
      'timeStamp': timeStamp

    };
  }







}
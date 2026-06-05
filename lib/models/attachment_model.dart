class AttachmentModel {
  final String filename;
  final String assignId;
  final String uploadedBy;

  AttachmentModel({
    required this.filename,
    required this.assignId,
    required this.uploadedBy,
  });

  Map<String, dynamic> toMap() => {
        'Filename': filename,
        'assignid': assignId,
        'uploadby': uploadedBy,
      };
}

import 'dart:convert';

class MemberModel {
    int id;
    String name, email, createdAt, updatedAt;

    MemberModel({
        required this.id,
        required this.name,
        required this.email,
        required this.createdAt,
        required this.updatedAt,
    });

    factory MemberModel.fromJson(Map<String, dynamic> json) => MemberModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

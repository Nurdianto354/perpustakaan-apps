import 'dart:convert';

class BukuModel {
  int? id, categoryId, stok;
  String? kodeBuku,
      judul,
      slug,
      penerbit,
      pengarang,
      tahun,
      path,
      createdAt,
      updatedAt;

  BukuModel({
    required this.id,
    required this.kodeBuku,
    required this.categoryId,
    required this.judul,
    required this.slug,
    required this.penerbit,
    required this.pengarang,
    required this.tahun,
    required this.stok,
    required this.path,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BukuModel.fromJson(Map<String, dynamic> json) => BukuModel(
        id: json["id"],
        kodeBuku: json["kode_buku"],
        categoryId: json["category_id"],
        judul: json["judul"],
        slug: json["slug"],
        penerbit: json["penerbit"],
        pengarang: json["pengarang"],
        tahun: json["tahun"],
        stok: json["stok"],
        path: json["path"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode_buku": kodeBuku,
        "category_id": categoryId,
        "judul": judul,
        "slug": slug,
        "penerbit": penerbit,
        "pengarang": pengarang,
        "tahun": tahun,
        "stok": stok,
        "path": path,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class KategoriModel {
    int id;
    String namaKategori, createdAt, updatedAt;

    KategoriModel({
        required this.id,
        required this.namaKategori,
        required this.createdAt,
        required this.updatedAt,
    });

    factory KategoriModel.fromJson(Map<String, dynamic> json) => KategoriModel(
        id: json["id"],
        namaKategori: json["nama_kategori"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama_kategori": namaKategori,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
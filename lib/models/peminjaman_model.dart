class PeminjamanModel {
    int? id, idBuku;
    String? judulBuku, kategoriBuku, tanggalPeminjaman, tanggalPengembalian, createdAt, updatedAt;

    PeminjamanModel({
        required this.id,
        required this.idBuku,
        required this.judulBuku,
        required this.kategoriBuku,
        this.tanggalPeminjaman,
        this.tanggalPengembalian,
        required this.createdAt,
        required this.updatedAt,
    });

    factory PeminjamanModel.fromJson(Map<String, dynamic> json) => PeminjamanModel(
        id: json["id"],
        idBuku: json["id_buku"],
        judulBuku: json["judul_buku"],
        kategoriBuku: json["kategori_buku"],
        tanggalPeminjaman: json["tanggal_peminjaman"],
        tanggalPengembalian: json["tanggal_pengembalian"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_buku": idBuku,
        "judul_buku": judulBuku,
        "kategori_buku": kategoriBuku,
        "tanggal_peminjaman": tanggalPeminjaman,
        "tanggal_pengembalian": tanggalPengembalian,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
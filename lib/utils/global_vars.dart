class GlobalVars {
  /* Development */
  static final String baseUrl = "http://192.168.50.173:8000/";
  /* Development Local */
  static final String apiUrl = "${baseUrl}api/";
  static final String apiUrlKategori = "${baseUrl}api/category/";

/* ========================================================================== */
  static final int LIMIT_MAX_CONNECTION_TIMEOUT = 2 * 10000; //2 menit

  /* Shared Preferences */
  static final String isLoginKey = "LOGIN";
  static final String idKey = "ID";
  static final String nameKey = "name";
  static final String emailKey = "EMAIL";
  static final String roleKey = "ROLE";
  static final String accessTokenKey = "ACCESSTOKEN";

  /*==========================================================================*/

  static int idCylinder = 0;
  static int idCylinderBrand = 0;
  static final String TIMEOUT = "TIMEOUT";
}

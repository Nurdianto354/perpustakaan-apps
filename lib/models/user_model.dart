class UserModel {
  String? _id,
      _name,
      _email,
      _role,
      _accessToken;

  UserModel? _userModel;
  
  UserModel(
      this._id,
      this._name,
      this._email,
      this._role,
      this._accessToken);

  UserModel? get userModel => _userModel;

  set userModel(UserModel? value) {
    _userModel = value;
  }

  get accessToken => _accessToken;

  set accessToken(value) {
    _accessToken = value;
  }

  get role => _role;

  set role(value) {
    _role = value;
  }

  get email => _email;

  set email(value) {
    _email = value;
  }

  get name => _name;

  set name(value) {
    _name = value;
  }

  String? get id => _id;

  set id(String? value) {
    _id = value;
  }

  @override
  String toString() {
    return 'UserModel{_id: $_id, _name: $_name, _email: $_email, _role: $_role, _accessToken: $_accessToken, _userModel: $_userModel}';
  }

  Map<String, dynamic> toJson() {
    //angel json encode
    return {
      "id": this._id,
      "name": this._name,
      "email": this._email,
      "role": this._role,
      "access_token": this._accessToken,
    };
  }
}

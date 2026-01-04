class User {
  String? userId;
  String? userAvatar;
  String? userName;
  String? userEmail;
  String? userPassword;
  String? userPhone;
  String? userWallet;
  String? userRegdate;

  User(
      {this.userId,
      this.userAvatar,
      this.userName,
      this.userEmail,
      this.userPassword,
      this.userPhone,
      this.userWallet,
      this.userRegdate});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userAvatar = json['avatar'];
    userName = json['name'];
    userEmail = json['email'];
    userPassword = json['password'];
    userPhone = json['phone'];
    userWallet = json['wallet'];
    userRegdate = json['user_regdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['avatar'] = userAvatar;
    data['name'] = userName;
    data['email'] = userEmail;
    data['password'] = userPassword;
    data['phone'] = userPhone;
    data['wallet'] = userWallet;
    data['user_regdate'] = userRegdate;
    return data;
  }
}
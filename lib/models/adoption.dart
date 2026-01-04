class Adoption{
  String? adoptionId;
  String? petId;
  String? userId;
  String? houseType;
  String? owned;
  String? reason;
  String? requestDate;

  Adoption({
    this.adoptionId,
    this.petId,
    this.userId,
    this.houseType,
    this.owned,
    this.reason,
    this.requestDate
  });

  Adoption.fromJson(Map<String, dynamic> json){
    adoptionId = json['adoption_id'];
    petId = json['pet_id'];
    userId = json['user_id'];
    houseType = json['house_type'];
    owned = json['owned'];
    reason = json['reason'];
    requestDate = json['requested_date'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adoption_id'] = adoptionId;
    data['pet_id'] = petId;
    data['user_id'] = userId;
    data['house_type'] = houseType;
    data['owned'] = owned;
    data['reason'] = reason;
    data['requested_data'] = requestDate;

    return data;
  }
}
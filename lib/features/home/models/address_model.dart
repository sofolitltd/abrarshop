class AddressModel {
  String name;
  String mobile;
  String email;
  String address;

  AddressModel({
    required this.name,
    required this.mobile,
    required this.email,
    required this.address,
  });

  // Factory method to create an AddressModel from JSON
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
    );
  }

  // Method to convert an
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile': mobile,
      'email': email,
      'address': address,
    };
  }
}

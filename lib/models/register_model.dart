import 'dart:io';

class RegisterModel {
  // Personal Info
  final String name;
  final String phoneNumber;
  final String cnicNumber;
  final File cnicFrontImage;
  final File cnicBackImage;
  final String address;
  final File billFrontImage;
  final File billBackImage;

  // Guarantor Info
  final String gName;
  final String gPhoneNumber;
  final String gCnicNumber;
  final File gCnicFrontImage;
  final File gCnicBackImage;
  final String gAddress;
  final File gBillFrontImage;
  final File gBillBackImage;

  // Optional / Additional
  final File? paymentImage;
  final String? serviceId;

  RegisterModel({
    required this.name,
    required this.phoneNumber,
    required this.cnicNumber,
    required this.cnicFrontImage,
    required this.cnicBackImage,
    required this.address,
    required this.billFrontImage,
    required this.billBackImage,
    required this.gName,
    required this.gPhoneNumber,
    required this.gCnicNumber,
    required this.gCnicFrontImage,
    required this.gCnicBackImage,
    required this.gAddress,
    required this.gBillFrontImage,
    required this.gBillBackImage,
    this.paymentImage,
    this.serviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone_number": phoneNumber,
      "cnic_number": cnicNumber,
      "address": address,
      "g_name": gName,
      "g_phone_number": gPhoneNumber,
      "g_cnic_number": gCnicNumber,
      "g_address": gAddress,
      "service_id": serviceId,
    };
  }

  Map<String, File> filesToMap() {
    final map = {
      "cnic_front_image": cnicFrontImage,
      "cnic_back_image": cnicBackImage,
      "bill_front_image": billFrontImage,
      "bill_back_image": billBackImage,
      "g_cnic_front_image": gCnicFrontImage,
      "g_cnic_back_image": gCnicBackImage,
      "g_bill_front_image": gBillFrontImage,
      "g_bill_back_image": gBillBackImage,
    };

    if (paymentImage != null) {
      map["payment_image"] = paymentImage!;
    }

    return map;
  }
}

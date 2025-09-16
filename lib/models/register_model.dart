import 'dart:io';

class RegisterModel {
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
  final int? serviceId;

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
    required this.paymentImage,
    required this.serviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone_number": "+92$phoneNumber",
      "cnic_number": cnicNumber,
      "cnic_front_image": cnicFrontImage.path,
      "cnic_back_image": cnicBackImage.path,
      "address": address,
      "bill_front_image": billFrontImage.path,
      "bill_back_image": billBackImage.path,
      "g_name": gName,
      "g_phone_number": "+92$gPhoneNumber",
      "g_cnic_number": gCnicNumber,
      "g_cnic_front_image": gCnicFrontImage.path,
      "g_cnic_back_image": gCnicBackImage.path,
      "g_address": gAddress,
      "g_bill_front_image": gBillFrontImage.path,
      "g_bill_back_image": gBillBackImage.path,
      "payment_image": paymentImage?.path,
      "service_id": serviceId,
    };
  }
}

import 'package:employee_portal/models/register_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

Future<void> submitRegister(RegisterModel data) async {
  final uri = Uri.parse(
    "https://irex.pk/ustaadjiweb/public/api/provider/register",
  );

  var request = http.MultipartRequest("POST", uri);

  // Add text fields
  request.fields['name'] = data.name;
  request.fields['phone_number'] = "+92${data.phoneNumber}";
  request.fields['cnic_number'] = data.cnicNumber;
  request.fields['address'] = data.address;
  request.fields['g_name'] = data.gName;
  request.fields['g_phone_number'] = "+92${data.gPhoneNumber}";
  request.fields['g_cnic_number'] = data.gCnicNumber;
  request.fields['g_address'] = data.gAddress;
  if (data.serviceId != null)
    request.fields['service_id'] = data.serviceId.toString();

  // Add files
  request.files.add(
    await http.MultipartFile.fromPath(
      'cnic_front_image',
      data.cnicFrontImage.path,
      filename: basename(data.cnicFrontImage.path),
    ),
  );
  request.files.add(
    await http.MultipartFile.fromPath(
      'cnic_back_image',
      data.cnicBackImage.path,
      filename: basename(data.cnicBackImage.path),
    ),
  );
  request.files.add(
    await http.MultipartFile.fromPath(
      'bill_front_image',
      data.billFrontImage.path,
      filename: basename(data.billFrontImage.path),
    ),
  );
  request.files.add(
    await http.MultipartFile.fromPath(
      'bill_back_image',
      data.billBackImage.path,
      filename: basename(data.billBackImage.path),
    ),
  );

  request.files.add(
    await http.MultipartFile.fromPath(
      'g_cnic_front_image',
      data.gCnicFrontImage.path,
      filename: basename(data.gCnicFrontImage.path),
    ),
  );
  request.files.add(
    await http.MultipartFile.fromPath(
      'g_cnic_back_image',
      data.gCnicBackImage.path,
      filename: basename(data.gCnicBackImage.path),
    ),
  );
  request.files.add(
    await http.MultipartFile.fromPath(
      'g_bill_front_image',
      data.gBillFrontImage.path,
      filename: basename(data.gBillFrontImage.path),
    ),
  );
  request.files.add(
    await http.MultipartFile.fromPath(
      'g_bill_back_image',
      data.gBillBackImage.path,
      filename: basename(data.gBillBackImage.path),
    ),
  );

  if (data.paymentImage != null) {
    request.files.add(
      await http.MultipartFile.fromPath(
        'payment_image',
        data.paymentImage!.path,
        filename: basename(data.paymentImage!.path),
      ),
    );
  }

  try {
    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    print(respStr);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Success: $respStr");
    } else {
      print("Failed (${response.statusCode}): $respStr");
    }
  } catch (e) {
    print("Error: $e");
  }
}

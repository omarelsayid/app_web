import 'dart:convert';
import 'dart:developer';
import 'package:app_web/global_varibales.dart';
import 'package:app_web/models/subcategory.dart';
import 'package:app_web/service/manage_http_respoond.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubcategoryController {
  uploadSubCategory(
      {required String categoryId,
      required String categoryName,
      required dynamic pickedImage,
      required String subCategoryName,
      required BuildContext context}) async {
    try {
      final cloudinary = CloudinaryPublic('dr7uizj8z', 'i6j2zmec');

      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedImage,
            identifier: 'pickedImage', folder: 'categoryImages'),
      );
      String image = imageResponse.secureUrl; // to get the url
      Subcategory subcategory = Subcategory(
          id: '',
          categoryId: categoryId,
          categoryName: categoryName,
          image: image,
          subCategoryName: subCategoryName);

      http.Response response = await http.post(
        Uri.parse("$uri/api/subcategories"),
        body: subcategory.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Subcategory Uploaded');
          });
    } catch (e) {
      log('eroor${e.toString()}');
    }
  }

  Future<List<Subcategory>> loadSubCategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/subcategories'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );
      log('...................');
      log(response.body.toString() +
          '            sub categroy body ...............');
      if (response.statusCode == 200) {
        // the response will be a list when we decode it we just need to use from map
        final List<dynamic> data = jsonDecode(response.body);
        List<Subcategory> subCategories =
            data.map((category) => Subcategory.fromMap(category)).toList();
        return subCategories;
      } else {
        throw Exception('Failed to load Subcategories');
      }
    } catch (e) {
      log('Error: ' + e.toString());
      // Returning an empty list to handle errors gracefully
      return [];
    }
  }
}

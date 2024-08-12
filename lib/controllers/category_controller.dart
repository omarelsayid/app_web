import 'dart:convert';
import 'dart:developer';

import 'package:app_web/global_varibales.dart';
import 'package:app_web/models/category.dart';
import 'package:app_web/service/manage_http_respoond.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryController {
  upLoadCategory({
    required dynamic pickedImage,
    required pickedBanner,
    required String name,
    required BuildContext context,
  }) async {
    try {
      final cloudinary = CloudinaryPublic('dr7uizj8z', 'i6j2zmec');

      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedImage,
            identifier: 'pickedImage', folder: 'categoryImages'),
      );

      String image = imageResponse.secureUrl; // to get the url

      CloudinaryResponse bannerResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedBanner,
            identifier: 'pickedBanner', folder: 'categoryImages'),
      );
      String banner = bannerResponse.secureUrl;

      Category category =
          Category(id: '', name: name, image: image, banner: banner);

      http.Response response = await http.post(
        Uri.parse("$uri/api/categories"),
        body: category.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Uploaded Category');
          });
    } catch (e) {
      log('Error uploading to cloudinary' + e.toString());
    }
  }

// load uploaded category

  Future<List<Category>> loadcategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/categories'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );
      log(response.body.toString());
      if (response.statusCode == 200) {
        // the response will be a list when we decode it we just need to use from map
        final List<dynamic> data = jsonDecode(response.body);
        List<Category> categories =
            data.map((category) => Category.fromMap(category)).toList();
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      log('Error: ' + e.toString());
      // Returning an empty list to handle errors gracefully
      return [];
    }
  }
}

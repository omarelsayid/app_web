import 'dart:convert';
import 'dart:developer';
import 'package:app_web/global_varibales.dart';
import 'package:app_web/models/banner.dart';
import 'package:app_web/service/manage_http_respoond.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BannerController {
  
  // this to upload banners to cloudniary then get the url and then post it in the DB
  uploadBanner(
      {required dynamic pickedImage, required BuildContext context}) async {
    try {
      final cloudinary = CloudinaryPublic('dr7uizj8z', 'i6j2zmec');
      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedImage,
            identifier: 'pickedImage', folder: 'banners'),
      );

      String image = imageResponse.secureUrl;
      BannerModel bannerModel = BannerModel(id: '', image: image);
      http.Response response = await http.post(
        Uri.parse('$uri/api/banner'),
        body: bannerModel.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Banner Uploaded');
          });
    } catch (e) {
      log('Error in uploading banner' + e.toString());
    }
  }

//fetch banners
  Future<List<BannerModel>> loadBanners() async {
    try {
      // send an http get reuest to fetch banners
      http.Response response = await http.get(
        Uri.parse('$uri/api/banner'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );
      log(response.body.toString());
      if (response.statusCode == 200) {
        // ok
        List<dynamic> data = jsonDecode(response.body);
        List<BannerModel> banners =
            data.map((banner) => BannerModel.fromJson(banner)).toList(); // convert each map to a Banner object 
        return banners;
      } else {
        // throw an exception if the server respond with an error status code
        throw Exception('Failed to load banners');
      }
    } catch (e) {
      throw Exception('Error loading Banners $e');
    }
  }
}

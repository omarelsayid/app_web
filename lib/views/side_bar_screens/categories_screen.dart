import 'dart:typed_data';
import 'package:app_web/controllers/category_controller.dart';
import 'package:app_web/views/side_bar_screens/widgets/categroy_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});
  static const String id = '\categories-screen';
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  Uint8List? _image;
  dynamic _bannerImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String name;
  final CategoryController _categoryController = CategoryController();

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
      });
    }
  }

  pickBannerImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _bannerImage = result.files.first.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(4.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                  ),
                  child: _image != null
                      ? Image.memory(
                          _image!,
                          fit: BoxFit.fill,
                        )
                      : const Center(
                          child: Text('Category Image'),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 200,
                    child: TextFormField(
                      onChanged: (value) {
                        name = value;
                      },
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return 'PLase Enter the category name';
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: 'Enter Category Name'),
                    ),
                  ),
                ),
                TextButton(
                  style: const ButtonStyle(
                      side: WidgetStatePropertyAll(
                    BorderSide(color: Colors.blue, width: 2.0),
                  )),
                  onPressed: () {},
                  child: const Text(
                    'cancel',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _categoryController.upLoadCategory(
                        pickedImage: _image,
                        pickedBanner: _bannerImage,
                        name: name,
                        context: context,
                      );

                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  pickImage();
                },
                child: const Text(
                  'Pick image',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(
                  5,
                ),
              ),
              child: _bannerImage != null
                  ? Image.memory(_bannerImage)
                  : const Center(
                      child: Text(
                        'Category Banners',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  pickBannerImage();
                },
                child: const Text(
                  'Pick image',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const Divider(),
            CategroyWidget()
          ],
        ),
      ),
    );
  }
}

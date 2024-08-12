import 'dart:developer';
import 'dart:typed_data';

import 'package:app_web/controllers/category_controller.dart';
import 'package:app_web/controllers/subcategory_controller.dart';
import 'package:app_web/models/category.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SubcategoryScreen extends StatefulWidget {
  const SubcategoryScreen({super.key});
  static const String id = '\subCategories-screen';

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  late Future<List<Category>> futureCategories;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SubcategoryController subcategoryController = SubcategoryController();
  Uint8List? _image;
  late String name;
  Category? selectedCategory;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCategories = CategoryController().loadcategories();
  }

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



  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: const Text(
                'SubCategories',
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
          FutureBuilder(
            future: futureCategories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('NO category'),
                );
              } else {
                return DropdownButton<Category>(
                    value: selectedCategory,
                    hint: const Text('Select Category'),
                    items: snapshot.data!.map((Category category) {
                      return DropdownMenuItem(
                          value: category, child: Text(category.name));
                    }).toList(),
                    onChanged: (vale) {
                      setState(() {
                        selectedCategory = vale;
                      });
                      log(selectedCategory!.toString());
                    });
              }
            },
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
                        child: Text('SubCategory Image'),
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
                        return 'PLase Enter the SubCategory name';
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: 'Enter SubCategory Name'),
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    subcategoryController.uploadSubCategory(
                        categoryId: selectedCategory!.id,
                        categoryName: selectedCategory!.name,
                        pickedImage: _image,
                        subCategoryName: name,
                        context: context);

                    setState(() {
                      _formKey.currentState!.reset();
                      _image = null;
                    });
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
        ],
      ),
    );
  }
}

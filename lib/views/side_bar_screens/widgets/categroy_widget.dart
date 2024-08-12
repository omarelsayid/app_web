import 'package:app_web/controllers/category_controller.dart';
import 'package:app_web/models/category.dart';
import 'package:flutter/material.dart';

class CategroyWidget extends StatefulWidget {
  const CategroyWidget({super.key});

  @override
  State<CategroyWidget> createState() => _CategroyWidgetState();
}

class _CategroyWidgetState extends State<CategroyWidget> {
  // A future that Will hold the list of categories once loaded from API

  late Future<List<Category>> futureCategory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCategory = CategoryController().loadcategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureCategory,
      builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  } else if (snapshot.hasError) {
    return Center(  // Add return statement here
      child: Text('Error: ${snapshot.error}'),
    );
  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
    return const Center(
      child: Text('No Categories'),
    );
  } else {
    final categories = snapshot.data;
    return GridView.builder(
      shrinkWrap: true,
      itemCount: categories!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return Column(  // Add return statement here
          children: [
            Image.network(
              category.image,
            ),
            Text(category.name),
          ],
        );
      },
    );
  }
}
    );
  }
}

import 'dart:html';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _searchController=TextEditingController();

  List<ProductModel> items = [];
  List<ProductModel> filteredItems = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    List<ProductModel> itemList=[];
    final response = await http.get(Uri.parse('https://api.escuelajs.co/api/v1/categories?fbclid=IwAR0NSIEzyJbH49dGBxBoD7hnVQQfkKOQDVuTEEzq8noiftLR2DdVsRbr61Q'));
    if (response.statusCode == 200) {
      var decode = json.decode(response.body);
     for (var i in decode){
       itemList.add(ProductModel.fromJson(i));
       setState(() {
         items = itemList;
         filteredItems = itemList;
       });
     }

    } else {
      throw Exception('Failed to load items');
    }
  }

  void filterItems(String query) {
    setState(() {
      items = filteredItems
          .where((item) => item.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Search'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged:
                filterItems
              ,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search items...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
       filteredItems.isEmpty ?Center(child: CircularProgressIndicator()):   Expanded(
         child: GridView.builder(
           itemCount: items.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    itemBuilder: (context,index){
     return SizedBox(
       height: 200,
       child: Card(
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(15)
         ),
         color: Colors.green,
         child: Padding(
           padding: const EdgeInsets.all(8.0),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                   Expanded(child: Text("Product Name:${items[index].name.toString()}")),
                   Text("Product Id : ${items[index].id.toString()}")
                 ],
               ),
               SizedBox(height: 5,),
               Image.network(items[index].image.toString(),height: 150,width: 150,),
               SizedBox(height: 5,),
             Expanded(child: Text("Create : ${items[index].creationAt.toString()}")),

             Text("Update : ${items[index].updatedAt.toString()}" ),
               SizedBox(height: 5,)


             ],
           ),
         ),
       ),
     );
           },
         ),
       ),
        ],
      ),
    );
  }
}


List<ProductModel> searchResults = [];

class ProductModel {
  int? id;
  String? name;
  String? image;
  String? creationAt;
  String? updatedAt;

  ProductModel(
      {this.id, this.name, this.image, this.creationAt, this.updatedAt});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    creationAt = json['creationAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['creationAt'] = this.creationAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}






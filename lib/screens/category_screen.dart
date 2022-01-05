import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja/datas/product_data.dart';
import 'package:loja/helpers/Theme.dart';
import 'package:loja/helpers/loader.dart';
import 'package:loja/tiles/product_tile.dart';

//Classe responsavel pela tela das categorias de produtos
class CategoryScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;
  CategoryScreen(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: MaterialColors.active,
        appBar: AppBar(
          title: Text(snapshot.data()["title"]),
          centerTitle: true,
          backgroundColor: MaterialColors.signStartGradient,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.grid_on),
              ),
              Tab(
                icon: Icon(Icons.list),
              ),
            ],
          ),
        ),
        //Obtem os dados da coleção produtos do firebase e exibe na tela
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection("products")
              .doc(snapshot.id)
              .collection("itens")
              .orderBy("title")
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: Loader(),
              );
            else
              return TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  GridView.builder(
                    padding: EdgeInsets.all(4.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      ProductData data =
                          ProductData.fromDocument(snapshot.data.docs[index]);
                      data.category = this.snapshot.id;
                      return Container(child: ProductTile("grid", data));
                    },
                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(4.0),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      ProductData data =
                          ProductData.fromDocument(snapshot.data.docs[index]);
                      data.category = this.snapshot.id;
                      return ProductTile("list", data);
                    },
                  )
                ],
              );
          },
        ),
      ),
    );
  }
}

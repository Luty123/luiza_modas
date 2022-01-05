import 'package:flutter/material.dart';
import 'package:loja/datas/product_data.dart';
import 'package:loja/screens/product_screen.dart';

//Classe responsavel pelos elementos que serão exibidos na tela do produto
class ProductTile extends StatelessWidget {
  final String type;
  final ProductData product;

  ProductTile(this.type, this.product);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProductScreen(product)));
      },
      child: Container(
        child: Card(
            child: type == "grid"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 0.8,
                        child: Container(
                          child: Image.network(
                            product.images[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              product.title,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "R\$ ${product.price.toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ))
                    ],
                  )
                : Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Image.network(
                          product.images[0],
                          fit: BoxFit.cover,
                          height: 250.0,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                product.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.0),
                              ),
                              Text(
                                "R\$ ${product.price.toStringAsFixed(2)}",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:loja/helpers/Theme.dart';
import 'package:loja/helpers/loader.dart';
import 'package:loja/models/cart_model.dart';
import 'package:loja/models/user_model.dart';
import 'package:loja/screens/login_screen.dart';
import 'package:loja/screens/order_screen.dart';
import 'package:loja/tiles/cart_tile.dart';
import 'package:loja/widgets/cart_price.dart';
import 'package:loja/widgets/discount_card.dart';
import 'package:scoped_model/scoped_model.dart';

//Classe responsavel pela tela do carrinho de compras
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MaterialColors.signStartGradient,
        title: Text("Meu carrinho"),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10.0),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                /* Variavel para pegar o tamanho da lista
                Se p for nulo retorn 0, caso contrario, retorna p
                Se p = 1, mostra ITEM, se for maior que 1, retorna ITENS*/
                int p = model.products.length;
                return Text(
                  "${p ?? 0}  ${p == 1 ? "ITEM" : "ITENS"}",
                  style: TextStyle(fontSize: 17.0),
                );
              },
            ),
          )
        ],
      ),
      //Verifica se o usuario esta logado ao acessar o carrinho
      body: ScopedModelDescendant<CartModel>(builder: (context, child, model) {
        if (model.isLoading && UserModel.of(context).isLoggedIn()) {
          return Center(
            child: Loader(),
          );
          //Caso não esteja logado, solicita que o usuario faça login para acessar os itens do carrinho
        } else if (!UserModel.of(context).isLoggedIn()) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.remove_shopping_cart,
                  size: 80.0,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Faça login para adicionar os produtos!",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "ENTRAR",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        primary: Colors.white,
                        backgroundColor: MaterialColors.label)),
              ],
            ),
          );
          //Caso não exista nenhum produto no carrinho do usuario logado
        } else if (model.products == null || model.products.length == 0) {
          return Center(
            child: Text(
              "NENHUM PRODUTO ENCONTRADO NO CARRINHO!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return ListView(
            children: <Widget>[
              Column(
                children: model.products.map((product) {
                  return CartTile(product);
                }).toList(),
              ),
              DiscountCard(),
              //TODO - CEP Habilita o botão do frete no carrinho de compras - Em construção -
              //ShipCard(),
              CartPrice(() async {
                String orderId = await model.finishOrder();
                if (orderId != null)
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => OrderScreen(orderId),
                    ),
                  );
              }),
            ],
          );
        }
      }),
    );
  }
}

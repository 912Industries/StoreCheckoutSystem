import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../services/pedido_compra/cadastro_produto_service.dart';
import '../estoque_modal/estoque.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:elegant_notification/elegant_notification.dart';

class PedidoCompraPage extends StatefulWidget {
  @override
  _PedidoCompra createState() => _PedidoCompra();
}

class _PedidoCompra extends State<PedidoCompraPage> {
  final nomeProdutoController = TextEditingController();
  final descricaoProdutoController = TextEditingController();
  final precoProdutoController = TextEditingController();
  final categoriaProdutoController = TextEditingController();

  void limpaCampos() {
    nomeProdutoController.clear();
    descricaoProdutoController.clear();
    precoProdutoController.clear();
    categoriaProdutoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextFormField(
                        controller: nomeProdutoController,
                        decoration: InputDecoration(
                          labelText: 'Nome do Produto',
                          prefixIcon: Padding(
                            child: Icon(Icons.shopping_bag),
                            padding: EdgeInsets.all(5),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextFormField(
                        controller: precoProdutoController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          CurrencyTextInputFormatter(
                            locale: 'pt-BR',
                            decimalDigits: 2,
                            symbol: 'R\$ ',
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Preço do Produto',
                          prefixIcon: Padding(
                            child: Icon(Icons.attach_money),
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextFormField(
                        controller: categoriaProdutoController,
                        decoration: InputDecoration(
                          labelText: 'Categoria do Produto',
                          prefixIcon: Padding(
                            child: Icon(Icons.category_rounded),
                            padding: EdgeInsets.all(5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.top,
                        controller: descricaoProdutoController,
                        maxLines: null,
                        maxLength: 255,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        decoration: InputDecoration(
                          labelText: 'Descrição do Produto',
                          prefixIcon: Padding(
                            child: Icon(Icons.description),
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
                        buildCounter: (
                          context, {
                          required int currentLength,
                          required int? maxLength,
                          required bool isFocused,
                        }) {
                          return DefaultTextStyle(
                            style: TextStyle(color: Colors.grey),
                            child: Text(
                              '$currentLength/$maxLength caracteres',
                              semanticsLabel: 'contador caracteres',
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.060,
                        child: ElevatedButton(
                          onPressed: () async {
                            CadastroProdutoService service =
                                CadastroProdutoService();

                            String precoProdutoText =
                                precoProdutoController.text;
                            precoProdutoText =
                                precoProdutoText.replaceAll('R\$', '');
                            precoProdutoText =
                                precoProdutoText.replaceAll(',', '.');

                            double precoProduto;
                            try {
                              precoProduto = double.parse(precoProdutoText);
                            } catch (e) {
                              print(
                                  'Não foi possível converter a string para um double: $e');
                              return;
                            }

                            bool? isValid = await service.cadastroProduto(
                              nomeProdutoController.text,
                              precoProduto,
                              categoriaProdutoController.text,
                              descricaoProdutoController.text,
                            );

                            setState(() {
                              limpaCampos();
                            });

                            if (isValid != null && isValid) {
                              EstoquePage.shouldRefreshData.value =
                                  !EstoquePage.shouldRefreshData.value;
                              ElegantNotification.success(
                                title: Text("Pedido de Compra de Produto"),
                                description: Text(
                                    "O pedido de compra foi contabilizado com sucesso"),
                              ).show(context);
                            } else {
                              ElegantNotification.error(
                                      title:
                                          Text("Pedido de Compra de Produto"),
                                      description: Text(
                                          "Ocorreu algum erro ao contabilizar o pedido de compra"))
                                  .show(context);
                            }
                          },
                          child: Text('Pedido de Compra de Produto'),
                        )),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
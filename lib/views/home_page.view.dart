import 'package:busca_cep_desafio_flutter/controllers/home.controller.dart';
import 'package:busca_cep_desafio_flutter/globals/style.globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../stores/home.store.dart';

class HomePage extends StatelessWidget {
  final _cepController = MaskedTextController(mask: '00000-000');
  final _formKey = GlobalKey<FormState>();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    final _homeStore = Provider.of<HomeStore>(context);
    final _homeController = HomeController();
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: GlobalsStyles().colorPrimary,
          title: const Text(
            'BUSCADOR DE CEP',
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: [
              const SizedBox(
                height: 25,
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      boxShadow: [
                        GlobalsWidgets().sombreado(),
                      ],
                      color: GlobalsStyles().colorBackground,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: TextFormField(
                    controller: _cepController,
                    validator: (_val) {
                      if (_val.toString().length != 9) return 'cep inválido';
                      return null;
                    },
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      alignLabelWithHint: false,
                      labelText: 'Informe o CEP',
                      labelStyle: TextStyle(
                        color: GlobalsStyles().colorTextFraco,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            _homeStore.setIsLoading(true);
                            await _homeController.buscaCep(
                                _cepController.text, context).then((value){
                                  if(!value) {
                                    _messangerKey.currentState?.showSnackBar(
                                      SnackBar(content: Text('CEP Inválido')),
                                    );
                                  }
                                }).catchError((_){
                                  _messangerKey.currentState?.showSnackBar(
                                    const SnackBar(content: Text('Erro: Verifique sua conexão com a internet e tente novamente')),
                                  );
                                });

                                
                            _cepController.clear();
                            _homeStore.setIsLoading(false);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: GlobalsStyles().colorBackground,
                              boxShadow: [
                                GlobalsWidgets().sombreado(),
                              ]),
                          child: Icon(Icons.search,
                              color: GlobalsStyles().colorTextForte),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Observer(
                builder: (_) {
                  return Visibility(
                    visible: _homeStore.isLoading,
                    child: _loadingNewCEP(),
                  );
                },
              ),
              _listaCepWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadingNewCEP() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _listaCepWidget(context) {
    final _homeStore = Provider.of<HomeStore>(context);
    return Observer(builder: (_) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _homeStore.dadosCepList.length,
        shrinkWrap: true,
        itemBuilder: (_, _index) {
          var _cepIndex = _homeStore.dadosCepList[_index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  child: Image.asset(
                    'assets/images/correios-logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 15
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_cepIndex.cep}",
                        style: TextStyle(
                          color: GlobalsStyles().colorTextForte,
                          fontSize: GlobalsStyles().sizeSubTitle,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${_cepIndex.localidade}",
                        style: TextStyle(
                          color: GlobalsStyles().colorTextForte,
                          fontSize: GlobalsStyles().sizeText,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 15),

                GestureDetector(
                        onTap: () async {
                            _homeStore.setIsLoading(true);
                            _homeStore.deleteDadosCepList(_index);
                            _homeStore.setIsLoading(false);
                          
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              
                              color: Colors.red,
                              boxShadow: [
                                GlobalsWidgets().sombreado(),
                              ]),
                          child: Icon(Icons.delete,
                              color: Colors.white),
                        ),
                      ),
              ],
            ),
          );
        },
      );
    });
  }
}

import 'package:busca_cep_desafio_flutter/models/dados_cep.model.dart';
import 'package:mobx/mobx.dart';

part 'home.store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store{
  ObservableList<DadosCepModel> dadosCepList = ObservableList<DadosCepModel>();

  @observable
  bool isLoading = false;

  @action 
  void addDadosCepList(_jsonCep){
    dadosCepList.add(DadosCepModel.fromJson(_jsonCep));
    print("dadosCepList: $dadosCepList");
  }

  @action 
  void deleteDadosCepList(_index){
    dadosCepList.removeAt(_index);
    print("dadosCepList: $dadosCepList");
  }

  @action
  void setIsLoading(_value) => isLoading = _value;
}

import 'dart:convert';

import 'package:busca_cep_desafio_flutter/stores/home.store.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeController {
  Future buscaCep(String _cepInformado, BuildContext _context) async {
    final _homeStore = Provider.of<HomeStore>(_context, listen: false);
    
    var _data = await http
        .get(Uri.parse("https://viacep.com.br/ws/$_cepInformado/json/"));
    var _result = jsonDecode(_data.body);
    
    if (_result['erro'] != null) {
      
      return false;
    }

    _homeStore.addDadosCepList(_result);
    return true;
  }
}

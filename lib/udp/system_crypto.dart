import 'dart:convert';

import 'crc16.dart';

class Crypto {
  Crypto({
    this.out,
    this.validaNumer,
  });

  Function out;
  int validaNumer;

  ///[------------------------------------------------------------ DESCRIPTOGRAFAR ------------------------------------------------------------]
  ///
  Future decrypt(data) async {
    Crc16 crc16 = Crc16();
    var buffer = data;

    int dadosL = buffer.length;
    int endDados = dadosL - 4; // ***** <<<< ERA 4

    //Realizar XOR para verificar check
    var check = crc16.check(buffer);

    int initCrc = endDados + 1;
    int endCrc = initCrc + 1;

    // Descriptografar
    var inicio = buffer[initCrc];
    for (int i = 0; i < initCrc; i++) {
      buffer[i] = buffer[i] ^ (crc16.crc16Table[inicio] & 0xFF00) >> 8;
      inicio += 1;
      if (inicio > 255) {
        inicio = 0;
      }
    }

    //[************** VERIFICAR RANDOM NUMBER ************** ]

    //Numero aleatorio
    var random = buffer[1];

    if (random == validaNumer) {
      //APROVADO!
    } else {
      //REPROVADO! A funcao retorna
      return;
    }

    //[************* VERIFICAR TAMANHO BUFFER ************* ]

    // Calcular se o tamanho do buffer é correspondente com o número de itens
    int qtdInfo = buffer[2];

    if (qtdInfo * 5 == dadosL - 5) {
      // * Quantidade corresponde
    } else {
      // * Quantidade não corresponde
      //return;
    }

    //[****************** VERIFICAR CHECK ****************** ]

    //Se o check for aprovado
    if (check == 0) {
      List<int> listaDados = [];
      String crcConfirm = "";

      //----- PERCORRER BYTES DO BUFFER ------
      int i = 0;
      for (var item in buffer) {
        //montar lista contendo apenas os dados ( sem os bytes de verificacao )
        if (i <= endDados) {
          listaDados.add(item);
        }
        i++;
      }

      //[******************* VERIFICAR CRC ******************* ]

      //Calcular CRC que sera usado para verificacao
      String listaDados64 = base64.encode(listaDados);
      var crc16val = crc16.calc(listaDados64);
      var crcHi = (crc16val & 0xFF00) >> 8;
      var crcLo = (crc16val & 0xff);

      //Verificar autenticidade do CRC recebido pelo servidor
      if ((buffer[initCrc] == crcHi) && (buffer[endCrc] == crcLo)) {
        //Funcao de retorno chamada apos finalizar a descriptografia
        out(listaDados, endDados);
      }
    }
  }

  ///[-------------------------------------------------------------- CRIPTOGRAFAR --------------------------------------------------------------]

  Future encrypt(dados) async {
    String data64 = base64.encode(dados);

    var crc16 = Crc16();

    var dataCrc = crc16.calc(data64);
    var crcHi = (dataCrc & 0xFF00) >> 8;
    var crcLo = (dataCrc & 0xff);

    // Criptografar
    var inicio = crcHi;
    var conta = 0;
    for (var itemDados in dados) {
      dados[conta] = itemDados ^ (crc16.crc16Table[inicio] & 0xFF00) >> 8;
      conta += 1;
      inicio += 1;
      if (inicio > 255) {
        inicio = 0;
      }
    }
    dados.add(crcHi);
    dados.add(crcLo);
    dados.add(
      crc16.check(dados),
    );

    return dados;
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'udp_receive.dart';
import 'udp_config.dart';

class UdpActions {
  ///[#########################]
  ///        [ CONFIG ]
  ///
  int udpTimeOut = 2; //// ( Segundos )
  int udpDebugTimeOut = 500; ////( Millisegundos )
  //
  ///[#########################]

  ///[==================== VARIAVEIS ====================]
  ///
  UdpReceive udpReceive;
  UdpConfig udpConfig;
  var udpSocket;
  var addressUDP;
  var porta;

  //Numero aleatorio de segurança
  var validaNumber = 0;

  //Funcao chamada ao receber um udp ( Utilizada para tratar o udp recebido )
  Function udpOut;

  ///[==================== CONSTRUTOR ====================]
  ///
  UdpActions({
    @required this.udpConfig,
    @required this.udpOut,
  }) {
    udpSocket = udpConfig.udpSocket;
    addressUDP = udpConfig.addressUDP;
    porta = udpConfig.porta;

    udpReceive = UdpReceive(
      addressUDP: udpConfig.addressUDP,
      porta: udpConfig.porta,
      udpSocket: udpSocket,
      validaNumber: validaNumber,
      onReceive: udpOut,
    );
  }

  ///[--------------------------------- ENVIAR UDP ---------------------------------]

  Future sendUdp(dados, validaNumberRef) async {
    ///
    //Iniciar socket
    await initSocket();

    validaNumber = validaNumberRef;
    udpReceive.validaNumber = validaNumberRef;

    // Iniciar recebimento do udp
    await udpReceive.receive();

    //Enviar udp
    udpSocket.send(dados, addressUDP, porta);

    //Fechar socket
    Timer(Duration(seconds: udpTimeOut), () {
      udpSocket.close();
    });
  }

  ///[--------------------------------- ENVIAR DEBUG ---------------------------------]

  Future sendUdpDebug(dadosRef) async {
    ///

    //Conversao dos dados para poder ser enviado por debug
    List<int> dados = utf8.encode("***** " + dadosRef);

    //Iniciar socket
    await initSocket();

    //Enviar udp
    udpSocket.send(dados, addressUDP, porta);

    //Fechar socket
    Timer(Duration(milliseconds: udpDebugTimeOut), () {
      udpSocket.close();
    });
  }

  ///[-------------------------------- METODOS BASE --------------------------------]
  ///
  Future initSocket() async {
    RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      0,
      // reusePort: true,
    ).then(
      (RawDatagramSocket udpSocketRef) {
        //udpSocket.broadcastEnabled = true;
        udpSocket = udpSocketRef;
        udpReceive.udpSocket = udpSocketRef;
      },
    );
  }
}

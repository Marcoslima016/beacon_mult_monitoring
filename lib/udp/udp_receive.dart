import 'dart:io';

import 'package:beacon_mult_monitoring/udp/system_crypto.dart';
import 'package:flutter/material.dart';


class UdpReceive {
  var udpSocket;
  var addressUDP;
  var porta;
  Function onReceive;

  //Numero aleatorio de segurança
  var validaNumber;

  ///[========= CONSTRUTOR =========]

  UdpReceive({
    @required this.validaNumber,
    @required this.udpSocket,
    @required this.addressUDP,
    @required this.porta,
    @required this.onReceive,
  });

  ///[------------------- METODO RECEIVE ------------------]

  Future receive() async {
    //
    udpSocket.listen(
      (e) {
        Datagram dg = udpSocket.receive();
        if (dg != null) {
          // return dg.data;
          // print("received ${dg.data}");
          if (onReceive != null) {
            // print("UDP RECEBIDO !!!!!!!!!!!!!!!!! ");
            //onReceive(dg.data);
            var crypto = Crypto(
              out: onReceive,
              validaNumer: validaNumber,
            );
            crypto.decrypt(dg.data);
          }
        }
      },
    );
  }
}

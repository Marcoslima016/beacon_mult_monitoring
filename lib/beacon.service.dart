import 'dart:async';

import 'package:flutter_beacon/flutter_beacon.dart';

import 'udp/udp.service.dart';

class BeaconService {
  StreamSubscription<RangingResult> streamRanging;
  StreamSubscription<MonitoringResult> streamMonitoring1;
  StreamSubscription<MonitoringResult> streamMonitoring2;

  ///[================================================== METODOS ==================================================]
  ///[=============================================================================================================]
  ///
  Future initScanBeacon() async {
    try {
      await flutterBeacon.initializeScanning;
      var point;
    } catch (e) {
      var point = e;
    }

    setMonitoring1();
    setMonitoring2();
    //
  }

  ///[------- MONITORING 1 --------]

  Future setMonitoring1() async {
    //
    var regions1 = <Region>[];
    regions1.add(
      Region(
        identifier: "1",
        proximityUUID: "D8059B77-F19A-4D6C-9048-47AE09F1C7E0",
      ),
    );
    streamMonitoring1 = flutterBeacon.monitoring(regions1).listen((MonitoringResult result) async {
      var resultJson = result.toJson;
      UdpService().sendUdpDebug(" from monitoring 1" + resultJson.toString());
    });
  }

  ///[------- MONITORING 2 --------]

  Future setMonitoring2() async {
    //
    var regions2 = <Region>[];
    regions2.add(
      Region(
        identifier: "2",
        proximityUUID: "C265713D-93F8-4BD1-B798-EEE9B2ECEE59",
      ),
    );
    streamMonitoring2 = flutterBeacon.monitoring(regions2).listen((MonitoringResult result) async {
      var teste = result;

      var resultJson = result.toJson;
      UdpService().sendUdpDebug(" from monitoring 2" + resultJson.toString());
    });
  }
}

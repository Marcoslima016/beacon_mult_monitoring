import 'udp_actions.dart';
import 'udp_config.dart';

class UdpService {
  UdpConfig udpConfig = UdpConfig();
  UdpActions udpActions;
  //Funcao chamada ao receber um udp ( Utilizada para tratar o udp recebido )
  Function udpOut;

  ///[============= CONSTRUTOR =============]
  ///
  UdpService({
    this.udpOut,
  }) {
    udpActions = UdpActions(
      udpConfig: udpConfig,
      udpOut: udpOut,
    );
  }

  ///[------------- ENVIAR UDP -------------]
  ///
  Future sendUdp(dados, validaNumberRef) async {
    udpActions.sendUdp(dados, validaNumberRef);
  }

  ///[---------- ENVIAR DEBUG UDP ----------]

  // Descricao: Envia udp de debug ( Nao aguarda um retorno )
  Future sendUdpDebug(dados) async {
    udpActions.sendUdpDebug(dados);
  }
}

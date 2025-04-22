import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class HistoriaScreen extends StatefulWidget {
  const HistoriaScreen({super.key});

  @override
  State<HistoriaScreen> createState() => _HistoriaScreenState();
}

class _HistoriaScreenState extends State<HistoriaScreen> {
  late YoutubePlayerController _videoController;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    const videoUrl = 'https://youtu.be/eMXgS_U3p9g';
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    
    _videoController = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        captionLanguage: 'es',
        forceHD: true,
      ),
    )..addListener(() {
        if (_isPlayerReady && mounted) {
          setState(() {});
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historia de la Defensa Civil'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: YoutubePlayerBuilder(
        player: YoutubePlayer( // Widget YoutubePlayer directo
          controller: _videoController,
          showVideoProgressIndicator: true,
          onReady: () => setState(() => _isPlayerReady = true),
        ),
        builder: (context, player) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4), 
                      ),
                    ],
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: player, // Usamos el player del builder
                  ),
                ),
                _buildHistoryText(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SelectionArea(
        child: Text(
          'Antes del año 1966, cuando llegaba la temporada de huracanes, '
          'un grupo de radioaficionados se reunía en la Cruz Roja para estar '
          'atentos por si surgía algún tipo de emergencia, inmediatamente '
          'ponerse a disposición y ayudar en todo lo posible, inclusive, '
          'usando sus propios equipos de comunicación para así tener contacto '
          'con el exterior en caso de que las redes telefónicas resultaran afectadas.\n\n'
          
          'Al surgir el triunvirato fue designado el Dr. Rafael Cantizano Arias, '
          'como presidente de la Cruz Roja y al mismo tiempo nombraron al Ing. '
          'Carlos D´ Franco como director de la Defensa Civil, quien con un grupo '
          'compuesto por seis personas, se instaló en la calle Francia esquina Galván, '
          'siendo esa la primera oficina de la Defensa Civil.\n\n'
          
          'Al surgir el Gobierno Provisional, presidido por el Dr. Héctor García Godoy, '
          'a los diecisiete días del mes de junio de 1966, fue promulgada la Ley 257, '
          'mediante la cual fue creada la Defensa Civil, institución dependiente de la '
          'Secretaría Administrativa de la Presidencia (ahora Ministerio de la Presidencia) '
          'y quien en la actualidad preside la Comisión Nacional de Emergencias.\n\n'
          
          'Más adelante, el local fue trasladado a la calle Dr. Delgado No. 164 y luego '
          'en la gestión del Contralmirante Radhamés Lora Salcedo se reubicó a la Plaza '
          'de la Salud, donde aún permanece.',
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }
}
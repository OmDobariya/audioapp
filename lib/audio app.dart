import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:baps_apps/productdatamodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

class PositionData {
  const PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class audioapp extends StatefulWidget {
  const audioapp({Key? key}) : super(key: key);

  @override
  State<audioapp> createState() => _audioappState();
}

class _audioappState extends State<audioapp> {
  static late Stream<int> datastream;
  static StreamController<int> mediaitem = StreamController();
  late AudioPlayer _audioPlayer;
  static int position_number = 0;
  List<String> imageUrl = [
    "https://pbs.twimg.com/media/E6o5XbLXsAAxAXz.jpg",
    "https://pbs.twimg.com/media/DWIa_fzVwAA01Nw.jpg",
    "assets/swam.jpg",
    "assets/thal.jpg",
    "https://www.baps.org/Data/Sites/1/Media/GalleryImages/1900/WebImages/05f.jpg"
  ];
  List<String> title = [
    "Jay Swaminarayan Aarti for Morning",
    "Jay Swaminarayan Aarti for Evening",
    "Swaminarayan Dhun",
    "Jamo Thal Jivan Javu Vari",
    "Chesta Gaan",
  ];
  List<String> artist = [
    "Sant Vrund",
    "Sant Vrund",
    "Sant-Haribhakto Vrund",
    "Sant Vrund",
    "Pramukh Swami Maharaj and Sant Vrund",
  ];
  final _playlist = ConcatenatingAudioSource(
    children: [
      AudioSource.uri(
        Uri.parse(
            'https://download.baps.org/Data/Sites/1/Media/DownloadableFile/Rituals/Shri_Swaminarayan_Arti_with_Ashtak_for_Morning_001.mp3'),
        tag: MediaItem(
          id: "0",
          title: "Jay Swaminarayan Aarti for Morning",
          artist: "Sant Vrund",
          artUri: Uri.parse("https://pbs.twimg.com/media/E6o5XbLXsAAxAXz.jpg"),
        ),
      ),
      AudioSource.uri(
        Uri.parse(
            'https://download.baps.org/Data/Sites/1/Media/DownloadableFile/Rituals/Shri_Swaminarayan_Arti_with_Ashtak_for_Evening_001.mp3'),
        tag: MediaItem(
          id: "1",
          title: "Jay Swaminarayan Aarti for Evening",
          artist: "Sant Vrund",
          artUri: Uri.parse("https://pbs.twimg.com/media/E6o5XbLXsAAxAXz.jpg"),
        ),
      ),
      AudioSource.uri(
        Uri.parse(
            'https://download.baps.org/Data/Sites/1/Media/DownloadableFile/Rituals/BAPS_Swaminarayan_Dhun.mp3'),
        tag: MediaItem(
          id: "2",
          title: "Swaminarayan Dhun",
          artist: "Sant Vrund",
          artUri: Uri.parse("https://pbs.twimg.com/media/E6o5XbLXsAAxAXz.jpg"),
        ),
      ),
      AudioSource.uri(
        Uri.parse(
            'https://download.baps.org/Data/Sites/1/Media/DownloadableFile/Rituals/BAPS_Swaminarayan_Thal.mp3'),
        tag: MediaItem(
          id: "3",
          title: "Jamo Thal Jivan Javu Vari",
          artist: "Sant Vrund",
          artUri: Uri.parse("https://pbs.twimg.com/media/E6o5XbLXsAAxAXz.jpg"),
        ),
      ),
      AudioSource.uri(
        Uri.parse(
            'https://download.baps.org/Data/Sites/1/Media/DownloadableFile/Rituals/cheshta.mp3'),
        tag: MediaItem(
          id: "4",
          title: "Chesta",
          artist: "Sant Vrund",
          artUri: Uri.parse("https://pbs.twimg.com/media/E6o5XbLXsAAxAXz.jpg"),
        ),
      ),
    ],
  );

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  void initState() {
    // TODO: implement initState
    super
        .initState(); // assets/Juvo_Chhabi_Shyam_Sundar.mp3 assets/Shat_Shat_Varsh_Sare_1.mp3
    datastream = mediaitem.stream.asBroadcastStream();
    _audioPlayer = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(_playlist);
  }

  Future<List<ProductDataModel>> ReadJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString("assets/audiodata.json");
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => ProductDataModel.fromJson(e)).toList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_horiz_rounded),
            )
          ],
          backgroundColor: Colors.black,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<SequenceState?>(
                stream: _audioPlayer.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state!.currentSource!.tag as MediaItem;
                  return MediaMetadata(
                    imageUrl: metadata.artUri.toString(),
                    artist: metadata.artist ?? '',
                    title: metadata.title,
                  );
                }),
            const SizedBox(height: 20),
            DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(2, 4),
                    blurRadius: 4,
                  )
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: StreamBuilder<int>(
                stream: datastream,
                builder: (context, snapshot) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl[snapshot.data ?? 0],
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  );
                }
              ),
            ),
            const SizedBox(height: 20),
            StreamBuilder<int>(
                stream: datastream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      padding: EdgeInsets.only(left: 3, right: 3),
                      child: Text(
                        title[snapshot.data ?? 0],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    return Text(
                      title[0],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }
                }),
            StreamBuilder<int>(
                stream: datastream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      artist[snapshot.data ?? 0],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    );
                  } else {
                    return Text(
                      artist[0],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }
                }),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return Container(
                  padding: const EdgeInsets.only(left: 17, right: 17, top: 17),
                  child: ProgressBar(
                    barHeight: 8,
                    baseBarColor: Colors.grey,
                    bufferedBarColor: Colors.grey,
                    progressBarColor: Colors.black,
                    thumbColor: Colors.black,
                    timeLabelTextStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    progress: positionData?.position ?? Duration.zero,
                    buffered: positionData?.bufferedPosition ?? Duration.zero,
                    total: positionData?.duration ?? Duration.zero,
                    onSeek: _audioPlayer.seek,
                  ),
                );
              },
            ),
            Controls(audioPlayer: _audioPlayer),
          ],
        ));
  }
}

class MediaMetadata extends StatelessWidget {
  const MediaMetadata({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.artist,
  });

  final String imageUrl;
  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return const Column(children: []);
  }
}

class Controls extends StatelessWidget {
  const Controls({super.key, required this.audioPlayer});

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            audioPlayer.seekToPrevious();
            if (_audioappState.position_number == 0) {
              _audioappState.position_number = 4;
            } else {
              _audioappState.position_number--;
            }
            _audioappState.mediaitem.add(_audioappState.position_number);
          },
          icon: const Icon(Icons.skip_previous_rounded),
          color: Colors.black,
          iconSize: 60,
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (!(playing ?? false)) {
              return IconButton(
                onPressed: audioPlayer.play,
                iconSize: 80,
                color: Colors.black,
                icon: const Icon(Icons.play_arrow_rounded),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                onPressed: audioPlayer.pause,
                iconSize: 80,
                color: Colors.black,
                icon: const Icon(Icons.pause_rounded),
              );
            }
            return const Icon(
              Icons.play_arrow_rounded,
              size: 80,
              color: Colors.black,
            );
          },
        ),
        IconButton(
          onPressed: () {
            audioPlayer.seekToNext();
            if (_audioappState.position_number == 4) {
              _audioappState.position_number = 0;
            } else {
              _audioappState.position_number++;
            }
            _audioappState.mediaitem.add(_audioappState.position_number);
          },
          icon: const Icon(Icons.skip_next_rounded),
          color: Colors.black,
          iconSize: 60,
        ),
      ],
    );
  }
}

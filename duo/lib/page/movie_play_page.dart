import 'dart:async';

import 'package:duo/model/movie_model.dart';
import 'package:duo/model/subtitle_item_model.dart';
import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

enum PlayerState { stopped, playing, paused }

class MoviePlayPage extends StatefulWidget {
  final MovieModel movieModel;

  MoviePlayPage({Key key, @required this.movieModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new MoviePlayPageState(movieModel: this.movieModel);
  }
}

class MoviePlayPageState extends State<MoviePlayPage> {
  final MovieModel movieModel;

  Duration duration = Duration(seconds: 0);
  Duration position = Duration(seconds: 0);

  AudioPlayer audioPlayer;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText => duration.toString().split('.').first;
  get positionText => position.toString().split('.').first;

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  MoviePlayPageState({@required this.movieModel}) : super();

  bool _featchSubtitlFlag = false;
  List<SubtitleItemModel> subtitleItemList = new List();
  List<SubtitleItemModel> displaySubtitleItemList = new List();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchSubtitleList(this.movieModel.subtitles);
    initAudioPlayer();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  Future fetchSubtitleList(String subtitleUrl) async {
    String subtitleResponse = await http.read(subtitleUrl);
    List<String> subtitleStringList = subtitleResponse.split('\n');

    this.subtitleItemList.clear();
    for (int i = 0; i < subtitleStringList.length - 4; i += 4) {
      SubtitleItemModel subtitleItemModel = new SubtitleItemModel();
      subtitleItemModel.index = int.parse(subtitleStringList[i]);
      String startStr = subtitleStringList[i + 1].split('-->')[0].trim();
      String endStr = subtitleStringList[i + 1].split('-->')[1].trim();

      subtitleItemModel.start = _parseDuration(startStr);
      subtitleItemModel.end = _parseDuration(endStr);
      subtitleItemModel.content = subtitleStringList[i + 2];
      this.subtitleItemList.add(subtitleItemModel);
    }

    _featchSubtitlFlag = true;
  }

  Duration _parseDuration(String timeStr) {
    List<String> items = timeStr.replaceAll(',', ':').split(':');
    return new Duration(
        hours: int.parse(items[0]),
        minutes: int.parse(items[1]),
        seconds: int.parse(items[2]),
        milliseconds: int.parse(items[3]));
  }

  bool _isHtml(String content) {
    int leftIndex = content.indexOf('<');
    int rightIndex = content.indexOf('>');
    return leftIndex != -1 && rightIndex != -1 && leftIndex < rightIndex;
  }

  bool _isNowPlaying(Duration position, Duration start, Duration end) {
    return position >= start && position <= end;
  }

  // display 5 items
  _getDisplaySubtitleItemList() {
    if (!this._featchSubtitlFlag) {
      return;
    }

    int totalLength = this.subtitleItemList.length;
    int targetIndex = -1;

    // find from nearby
    for (int i = _currentIndex; i < _currentIndex + 2; i++) {
      // first one
      if (i == 0 && this.position <= this.subtitleItemList[i].end) {
        targetIndex = 0;
        break;
      }
      // last one
      if (i >= totalLength - 1) {
        targetIndex = i;
        break;
      }

      SubtitleItemModel current = this.subtitleItemList[i];
      SubtitleItemModel next = this.subtitleItemList[i + 1];

      if (position >= current.start && position < next.start) {
        targetIndex = i;
        break;
      }
    }

    // find from all
    if (targetIndex == -1) {
      for (int i = 0; i < totalLength - 1; i++) {
        // first one
        if (i == 0 && this.position <= this.subtitleItemList[i].end) {
          targetIndex = 0;
          break;
        }
        // last one
        if (i >= totalLength - 1) {
          targetIndex = i;
          break;
        }

        SubtitleItemModel current = this.subtitleItemList[i];
        SubtitleItemModel next = this.subtitleItemList[i + 1];

        if (position >= current.start && position < next.start) {
          targetIndex = i;
          break;
        }
      }
    }

    this.displaySubtitleItemList.clear();
    for (int i = targetIndex - 3; i <= targetIndex + 3; i++) {
      if (i < 0 || i >= totalLength) {
        this.displaySubtitleItemList.add(new SubtitleItemModel(
            index: -1,
            start: new Duration(seconds: 0),
            end: new Duration(seconds: 0),
            content: ' '));
      } else {
        this.displaySubtitleItemList.add(this.subtitleItemList[i]);
      }
    }

    this._currentIndex = targetIndex;
  }

  List<Widget> getSubtitleWidgetList(BuildContext context) {
    List<Widget> widgetList = new List();

    this.displaySubtitleItemList.forEach((item) {
      widgetList.add(new ListTile(
          title: _isHtml(item.content)
              ? Text(parse(item.content).body.text,
                  style: new TextStyle(
                      color: _isNowPlaying(position, item.start, item.end)
                          ? Colors.lightGreen
                          : Colors.black,
                      fontSize: _isNowPlaying(position, item.start, item.end)
                          ? 16
                          : 14,
                      fontWeight: _isNowPlaying(position, item.start, item.end)
                          ? FontWeight.bold
                          : FontWeight.normal))
              : Text(item.content,
                  style: new TextStyle(
                      color: (position >= item.start && position <= item.end)
                          ? Colors.lightGreen
                          : Colors.black,
                      fontSize: _isNowPlaying(position, item.start, item.end)
                          ? 16
                          : 14,
                      fontWeight: _isNowPlaying(position, item.start, item.end)
                          ? FontWeight.bold
                          : FontWeight.normal) //文字颜色
                  )));
    });
    return widgetList;
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
    _positionSubscription =
        audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              position = p;
              this._getDisplaySubtitleItemList();
            }));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
    play();
  }

  Future play() async {
    await audioPlayer.play(this.movieModel.audio);
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration(seconds: 0);
    });
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Movie Play',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text(this.movieModel.name),
          ),
          body: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(flex: 1, child: new Material(child: _buildSubtitle())),
                new Material(child: _buildPlayer()),
              ]),
        ));
  }

  Widget _buildSubtitle() => new Container(
        padding: new EdgeInsets.all(16.0),
        child: new ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: getSubtitleWidgetList(context)),
      );

  Widget _buildPlayer() => new Container(
      padding: new EdgeInsets.all(16.0),
      child: new Column(mainAxisSize: MainAxisSize.min, children: [
        new Row(
          children: <Widget>[
            new Text(positionText, style: new TextStyle(fontSize: 12.0)),
            new Expanded(
              flex: 1,
              child: new Slider(
                  value: position.inMilliseconds.toDouble(),
                  onChanged: (double value) =>
                      audioPlayer.seek((value / 1000).roundToDouble()),
                  min: 0.0,
                  max: duration.inMilliseconds.toDouble()),
            ),
            new Text(durationText, style: new TextStyle(fontSize: 12.0))
          ],
        ),
        new Row(mainAxisSize: MainAxisSize.min, children: [
          new IconButton(
              onPressed: isPlaying ? () => pause() : () => play(),
              iconSize: 48.0,
              icon: new Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              color: Colors.cyan),
          new IconButton(
              onPressed: isPlaying || isPaused ? () => stop() : null,
              iconSize: 48.0,
              icon: new Icon(Icons.stop),
              color: Colors.cyan),
        ]),
      ]));
}

class MovieModel {
  final int movieId;
  final String name;
  final String audio;
  final String subtitles;

  MovieModel({this.movieId, this.name, this.audio, this.subtitles});

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return new MovieModel(
      movieId: json['movie_id'],
      name: json['name'],
      audio: json['audio'],
      subtitles: json['subtitles'],
    );
  }
}

import 'dart:async';

import 'package:movie_app/data/models/movie_model_impl.dart';
import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';

import '../data/models/movie_model.dart';

class HomeBloc{
  /// Reactive Streams
  StreamController<List<MovieVO>> mNowPlayingStreamController = StreamController();
  StreamController<List<MovieVO>> mPopularMoviesListStreamController = StreamController();
  StreamController<List<GenreVO>> mGenreListStreamController = StreamController();
  StreamController<List<ActorVO>> mActorsStreamController = StreamController();
  StreamController<List<MovieVO>> mShowCaseMovieListStreamController = StreamController();
  StreamController<List<MovieVO>> mMoviesByGenreListStreamController = StreamController() ;

  /// Models
  MovieModel mMovieModel = MovieModelImpl();

  HomeBloc(){
    mMovieModel.getNowPlayingMoviesFromDatabase().listen((movieList) {
      mNowPlayingStreamController.sink.add(movieList);
    }).onError((error){
      print(error.toString());
    });

    mMovieModel.getPopularMoviesFromDatabase().listen((movieList) {
      mPopularMoviesListStreamController.sink.add(movieList);
    }).onError((error){
      print(error.toString());
    });

    mMovieModel.getGenres().then((genreList){
      mGenreListStreamController.sink.add(genreList);
      getMoviesByGenreAndRefresh(genreList.first.id);
    }).catchError((error){
      print(error.toString());
    });


    mMovieModel.getGenresFromDatabase().then((genreList){
      mGenreListStreamController.sink.add(genreList);
      getMoviesByGenreAndRefresh(genreList.first.id);
    }).catchError((error){
      print(error.toString());
    });

    mMovieModel.getTopRatedMoviesFromDatabase().listen((movieList) {
      mShowCaseMovieListStreamController.sink.add(movieList);
    }).onError((error){
      print(error.toString());
    });

    mMovieModel.getActors(1).then((actorList){
      mActorsStreamController.sink.add(actorList);
    }).catchError((error){
      print(error.toString());
    });

    mMovieModel.getAllActorsFromDatabase().then((actorList){
      mActorsStreamController.sink.add(actorList);
    }).catchError((error){
      print(error.toString());
    });

  }

  void onTapGenre(int genreId){
    getMoviesByGenreAndRefresh(genreId);
  }

  void getMoviesByGenreAndRefresh(int genreId){
    mMovieModel.getMoviesByGenre(genreId).then((moviesByGenre) {
      mMoviesByGenreListStreamController.sink.add(moviesByGenre??[]);
    }).catchError((error){
      print(error.toString());
    });
  }

  void dispose(){
    mNowPlayingStreamController.close();
    mPopularMoviesListStreamController.close();
    mGenreListStreamController.close();
    mActorsStreamController.close();
    mShowCaseMovieListStreamController.close();
    mMoviesByGenreListStreamController.close();

  }


}
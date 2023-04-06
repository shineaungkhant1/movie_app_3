import 'dart:async';

import 'package:movie_app/data/models/movie_model_impl.dart';
import 'package:movie_app/data/vos/actor_vo.dart';

import '../data/models/movie_model.dart';
import '../data/vos/movie_vo.dart';

class MovieDetailsBLoc{
  /// Stream Controllers
  StreamController<MovieVO> movieStreamController = StreamController();
  StreamController<List<ActorVO>?> castStreamController = StreamController();
  StreamController<List<ActorVO>?> crewStreamController = StreamController();


  /// Models
   MovieModel mMovieModel = MovieModelImpl();

   MovieDetailsBLoc(int movieId){
     /// Movie Details
     mMovieModel.getMovieDetails(movieId).then((movie) {
       movieStreamController.sink.add(movie);
     });

     /// Movie Details From Database
     mMovieModel.getMovieDetailsFromFromDatabase(movieId).then((movie){
       movieStreamController.sink.add(movie);
     });

     mMovieModel.getCreditsByMovie(movieId).then((castAndCrew){
     castStreamController.sink.add(castAndCrew.first);
     crewStreamController.sink.add(castAndCrew.first);
     });

   }



   void dispose(){
     movieStreamController.close();
     castStreamController.close();
     crewStreamController.close();
   }

}
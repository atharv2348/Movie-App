import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_app/features/movies/pages/home_page.dart';

import '../services/rapid_api.dart';
import 'movie_details.dart';

final topRatedMoviesProvider =
    FutureProvider((ref) => MovieServicesRapidAPI().getTopRatedMovies());

class TopRatedPage extends ConsumerWidget {
  const TopRatedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: ref.watch(topRatedMoviesProvider).when(
        data: (snapshot) {
          return ListView.builder(
            itemCount: snapshot.length,
            itemBuilder: (context, index) {
              debugPrint("-----> " + snapshot[index]["rating"]);
              return GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MovieDetails(
                              IMDBid: snapshot[index]["imdbid"],
                              isHome: true)));
                },
                child: customMovieTile(
                    snapshot[index]["title"],
                    snapshot[index]["image"],
                    "Movie",
                    snapshot[index]["year"].toString(),
                    snapshot[index]["rating"]),
              );
            },
          );
        },
        error: (error, stackTrace) {
          return Text("Error : $error");
        },
        loading: () {
          return const Center(
            child: SpinKitFadingCircle(color: Colors.white),
          );
        },
      ),
    );
  }
}

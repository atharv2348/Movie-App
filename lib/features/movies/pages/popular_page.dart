import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_app/features/movies/pages/home_page.dart';

import '../services/rapid_api.dart';
import 'movie_details.dart';

final popularMoviesProvider =
    FutureProvider((ref) => MovieServicesRapidAPI().getPopularMovies());

class PopularPage extends ConsumerWidget {
  const PopularPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: ref.watch(popularMoviesProvider).when(
        data: (snapshot) {
          List data = snapshot["data"]["movies"]["edges"];
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetails(
                          IMDBid: data[index]["node"]["id"], isHome: true),
                    ),
                  );
                },
                child: customMovieTile(
                  data[index]["node"]["titleText"]["text"],
                  data[index]["node"]["primaryImage"]["url"],
                  data[index]["node"]["titleType"]["text"],
                  data[index]["node"]["releaseYear"]["year"].toString(),
                  data[index]["node"]["ratingsSummary"]["aggregateRating"]
                      .toString(),
                ),
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_app/features/movies/pages/home_page.dart';
import 'package:movie_app/features/movies/pages/movie_details.dart';
import 'package:movie_app/features/movies/services/omdb_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteList extends StatelessWidget {
  const FavouriteList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Favourite List"),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: FutureBuilder(
          future: getFouriteList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.isEmpty
                  ? const Center(
                      child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "No favorites yet? Explore movies and discover your new favorites!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Avenir_light",
                            color: Colors.grey,
                            fontSize: 20),
                      ),
                    ))
                  : ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        List<String> IMDBids = snapshot.data!;
                        return FutureBuilder(
                          future: MovieServiceOmdbapi()
                              .getMoviesByIMDBid(IMDBids[index]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MovieDetails(
                                              IMDBid: IMDBids[index],
                                              isHome: false)));
                                },
                                child: customMovieTile(
                                  snapshot.data[0]["Title"],
                                  snapshot.data[0]["Poster"],
                                  snapshot.data[0]["Type"],
                                  snapshot.data[0]["Year"],
                                  snapshot.data[0]["imdbRating"],
                                ),
                              );
                            } else {
                              return const SpinKitCircle(color: Colors.white);
                            }
                          },
                        );
                      },
                    );
            } else {
              return const Center(child: SpinKitCircle(color: Colors.white));
            }
          },
        ),
      ),
    );
  }
}

Future<List<String>> getFouriteList() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> favoriteList = prefs.getStringList('favourites') ?? [];
  return favoriteList;
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_app/components/my_text_field.dart';
import 'package:movie_app/features/auth/pages/login_or_register.dart';
import 'package:movie_app/features/movies/pages/favourite_list.dart';
import 'package:movie_app/features/movies/pages/movie_details.dart';
import 'package:movie_app/features/movies/pages/popular_page.dart';
import 'package:movie_app/features/movies/pages/top_rated_page.dart';
import 'package:movie_app/features/movies/services/favourites.dart';
import 'package:movie_app/features/movies/services/omdb_api.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController movieSearchController = TextEditingController();
  String filter = "Top Rated";

  void storeAllFavouritesToLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favs = await FavouriteServices().getAllFavourites();

    prefs.setStringList("favourites", favs);
  }

  @override
  void initState() {
    super.initState();
    storeAllFavouritesToLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: Column(
          children: [
            Container(
              height: 300,
              color: Colors.grey,
              child: const Center(
                  child: Icon(Icons.movie_rounded,
                      size: 150, color: Colors.black)),
            ),
            Card(
              child: ListTile(
                tileColor: Colors.black,
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const FavouriteList(),
                      type: PageTransitionType.rightToLeftWithFade,
                      curve: Curves.easeInOutBack,
                      duration: const Duration(milliseconds: 500),
                    ),
                  );
                },
                leading: const Icon(Icons.favorite_rounded),
                title: const Text("Favourites"),
              ),
            ),
            Card(
              child: ListTile(
                tileColor: Colors.black,
                onTap: () => logout(),
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Movie Hub"),
        centerTitle: true,
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const FavouriteList()));
          //   },
          //   icon: const Icon(Icons.favorite_rounded),
          // ),
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                filter = value;
              });
            },
            icon: const Icon(Icons.filter_alt),
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: "Popular",
                  child: Text("Popular"),
                ),
                const PopupMenuItem(
                    value: "Top Rated", child: Text("Top Rated")),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              MyTextField(
                controller: movieSearchController,
                hintText: 'Search a movie...',
                obsecureText: false,
                prefixIcon: const Icon(Icons.search),
                onChanged: (content) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),
              if (movieSearchController.text.isEmpty)
                Text(filter, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              if (movieSearchController.text.isNotEmpty)
                Expanded(
                  child: FutureBuilder(
                    future: MovieServiceOmdbapi()
                        .getMoviesBySearch(movieSearchController.text.trim()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: MovieDetails(
                                      IMDBid: snapshot.data![index]["imdbID"],
                                      isHome: true,
                                    ),
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    curve: Curves.easeInOutBack,
                                    duration: const Duration(milliseconds: 500),
                                  ),
                                );
                              },
                              child: customMovieTile(
                                snapshot.data![index]["Title"],
                                snapshot.data![index]["Poster"],
                                snapshot.data![index]["Type"],
                                snapshot.data![index]["Year"],
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                            child: SpinKitFadingCircle(color: Colors.white));
                      }
                    },
                  ),
                )
              else if (filter == "Popular")
                const PopularPage()
              else
                const TopRatedPage()
            ],
          ),
        ),
      ),
    );
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favMovies = prefs.getStringList("favourites");
    await FavouriteServices().addAllFavourites(favMovies!);

    prefs.remove('favourites');
    prefs.remove("userInfo");
    prefs.remove('token');
    Navigator.pushReplacement(
      context,
      PageTransition(
        child: LoginOrRegister(),
        type: PageTransitionType.leftToRightWithFade,
        curve: Curves.easeInOutBack,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }
}

Widget customMovieTile([
  String? movieName,
  String? imageUrl,
  String? type,
  String? year,
  String? rating,
]) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: Colors.grey.shade900,
      boxShadow: const [
        BoxShadow(
            color: Colors.white,
            blurStyle: BlurStyle.inner,
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 1)),
      ],
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 2,
            child: imageUrl!.isEmpty
                ? const Icon(Icons.movie)
                : Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20)),
                      child: imageUrl != "N/A"
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              placeholder: (context, url) {
                                return const SpinKitCircle(color: Colors.white);
                              },
                            )
                          : const Center(
                              child: Icon(
                              Icons.movie,
                              size: 60,
                            )),
                    ),
                  )),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customInfoWidget("Name : ", movieName ?? " "),
                  const SizedBox(height: 5),
                  customInfoWidget("Type   : ", type ?? " "),
                  const SizedBox(height: 5),
                  customInfoWidget("Year    : ", year ?? " "),
                  const SizedBox(height: 5),
                  rating != null
                      ? customInfoWidget("Rating : ", rating)
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget customInfoWidget(String text1, String text2) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(text1, style: const TextStyle(fontSize: 16, color: Colors.grey)),
      Expanded(
        child: Text(text2,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
      )
    ],
  );
}

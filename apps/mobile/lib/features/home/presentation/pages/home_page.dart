import 'package:flutter/material.dart';
import 'package:ticketa/core/data/dummy_data.dart';
import 'package:ticketa/core/models/movie.dart';
import 'package:ticketa/features/home/presentation/pages/movie_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _heroController = PageController(viewportFraction: 0.6, initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final movies = DummyData.movies;

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Fixed Search Bar
            SliverAppBar(
              pinned: true,
              floating: true,
              backgroundColor: Colors.black.withOpacity(0.9),
              elevation: 0,
              expandedHeight: 90,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildSearchBar(),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            
            // Hero Section
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 380,
                    child: PageView.builder(
                      controller: _heroController,
                      itemCount: movies.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: _heroController,
                          builder: (context, child) {
                            double value = 1.0;
                            if (_heroController.position.haveDimensions) {
                              value = _heroController.page! - index;
                              value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                            }
                            return Center(
                              child: Transform.scale(
                                scale: value,
                                child: child,
                              ),
                            );
                          },
                          child: _HeroCard(movie: movies[index]),
                        );
                      },
                    ),
                  ),

                  // Dynamic Movie Details
                  const SizedBox(height: 10),
                  Text(
                    movies[_currentPage].showTimes[0].year.toString(),
                    style: const TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      movies[_currentPage].title.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white, 
                        fontSize: 24, 
                        fontWeight: FontWeight.bold, 
                        letterSpacing: 1.2
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTag(movies[_currentPage].genre.split('|')[0]),
                      _buildTag("${movies[_currentPage].duration}m"),
                      _buildTag("⭐ ${movies[_currentPage].rating}", color: Colors.orange.withOpacity(0.2)),
                    ],
                  ),
                ],
              ),
            ),

            // Movie Lists (Now Showing & Coming Soon)
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildHorizontalList("Now Showing", movies),
                  _buildHorizontalList("Coming Soon", movies.reversed.toList(), showRating: false),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _HeroCard({required Movie movie}) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
      ),
      child: Hero(
        tag: 'poster_${movie.id}',
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            image: DecorationImage(
              image: NetworkImage(movie.posterUrl),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10)
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08), 
                borderRadius: BorderRadius.circular(25)
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search movies...", 
                  hintStyle: TextStyle(color: Colors.white30), 
                  prefixIcon: Icon(Icons.search, color: Colors.white30), 
                  border: InputBorder.none
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          _buildCircleIcon(Icons.tune),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(String title, List<Movie> movies, {bool showRating = true}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const Text("See All", style: TextStyle(color: Colors.white30, fontSize: 12)),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 20),
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) => _SmallMovieCard(movie: movies[index], showRating: showRating),
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String label, {Color? color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color ?? Colors.white.withOpacity(0.08), 
        borderRadius: BorderRadius.circular(15)
      ),
      child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
    );
  }

  Widget _buildCircleIcon(IconData icon, {double size = 45}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle, 
        border: Border.all(color: Colors.white10)
      ),
      child: Icon(icon, color: Colors.white30, size: size * 0.5),
    );
  }
}

class _SmallMovieCard extends StatefulWidget {
  final Movie movie;
  final bool showRating;
  const _SmallMovieCard({required this.movie, this.showRating = true});

  @override
  State<_SmallMovieCard> createState() => _SmallMovieCardState();
}

class _SmallMovieCardState extends State<_SmallMovieCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MovieDetailPage(movie: widget.movie)),
      ),
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: 140,
          margin: const EdgeInsets.only(right: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: NetworkImage(widget.movie.posterUrl),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                    ),
                    if (widget.showRating)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.orange, size: 14),
                              const SizedBox(width: 2),
                              Text(
                                widget.movie.rating.toString(),
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  widget.movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 14, 
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  widget.movie.genre.split('|')[0],
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
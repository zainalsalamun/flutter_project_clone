import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import '../bloc/photo_bloc.dart';
import '../bloc/photo_event.dart';
import '../bloc/photo_state.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/loading_indicator_footer.dart';
import '../widgets/photo_card.dart';

class PhotoGalleryPage extends StatefulWidget {
  const PhotoGalleryPage({super.key});

  @override
  State<PhotoGalleryPage> createState() => _PhotoGalleryPageState();
}

class _PhotoGalleryPageState extends State<PhotoGalleryPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Pemuatan data batch pertama
    context.read<PhotoBloc>().add(const FetchPhotos());
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Listener untuk infinite scroll pagination
  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Trigger fetch berikutnya ketika scroll berada dalam radius 300px dari bawah
    if (currentScroll >= (maxScroll - 300)) {
      context.read<PhotoBloc>().add(const FetchMorePhotos());
    }

    // Tampilkan tombol scroll-to-top jika sudah scroll lebih dari 500px
    final shouldShowTop = currentScroll > 500;
    if (shouldShowTop != _showScrollToTop) {
      setState(() {
        _showScrollToTop = shouldShowTop;
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 450), () {
      context.read<PhotoBloc>().add(SearchPhotos(query));
    });
  }

  void _onSelectCategory(String query) {
    _searchController.text = query;
    context.read<PhotoBloc>().add(SearchPhotos(query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(context),
      body: BlocConsumer<PhotoBloc, PhotoState>(
        listener: (context, state) {
          if (state.errorMessage != null && state.photos.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: const Color(0xFFEF4444),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            color: const Color(0xFF6366F1),
            backgroundColor: Colors.white,
            onRefresh: () async {
              context.read<PhotoBloc>().add(const RefreshPhotos());
              // Berikan jeda kecil agar animasi pull-to-refresh terasa natural
              await Future.delayed(const Duration(milliseconds: 600));
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                // Filter Category Chips
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: CategoryFilterChips(
                      selectedCategory: state.activeCategory,
                      onSelectCategory: _onSelectCategory,
                    ),
                  ),
                ),

                // Sub-header Info (Total items & Active Page)
                if (state.photos.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.photo_library_outlined,
                                  size: 13,
                                  color: Color(0xFF6366F1),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${state.photos.length} Foto dimuat',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF4F46E5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• Halaman ${state.page}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            state.query.isEmpty
                                ? 'Koleksi Picsum Curated'
                                : 'Pencarian: "${state.query}"',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Main Content
                _buildMainContent(state),

                // Infinite Scroll Bottom Indicator
                if (state.photos.isNotEmpty)
                  SliverToBoxAdapter(
                    child: LoadingIndicatorFooter(
                      isLoadingMore: state.isLoadingMore,
                      hasReachedMax: state.hasReachedMax,
                      onRetry: () {
                        context.read<PhotoBloc>().add(const FetchMorePhotos());
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: AnimatedScale(
        scale: _showScrollToTop ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: FloatingActionButton.small(
          onPressed: _scrollToTop,
          backgroundColor: const Color(0xFF6366F1),
          foregroundColor: Colors.white,
          elevation: 4,
          tooltip: 'Scroll ke atas',
          child: const Icon(Icons.keyboard_arrow_up_rounded, size: 22),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF1E293B)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Container(
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          textInputAction: TextInputAction.search,
          onSubmitted: (val) {
            context.read<PhotoBloc>().add(SearchPhotos(val));
          },
          style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
          decoration: InputDecoration(
            hintText: 'Cari gambar (misal: Nature, Anime, Coffee)...',
            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF64748B)),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 16, color: Color(0xFF94A3B8)),
                    onPressed: () {
                      _searchController.clear();
                      context.read<PhotoBloc>().add(const SearchPhotos(''));
                      setState(() {});
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: Color(0xFF475569)),
          tooltip: 'Refresh feed',
          onPressed: () {
            context.read<PhotoBloc>().add(const RefreshPhotos());
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildMainContent(PhotoState state) {
    // Initial Loading Skeleton
    if (state.isLoading) {
      return SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverMasonryGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          itemBuilder: (context, index) {
            final double height = (index % 3 == 0) ? 220 : (index % 2 == 0 ? 170 : 250);
            return Shimmer.fromColors(
              baseColor: const Color(0xFFE2E8F0),
              highlightColor: const Color(0xFFF8FAFC),
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          },
          childCount: 8,
        ),
      );
    }

    // Error State
    if (state.isFailure && state.photos.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cloud_off_rounded,
                    color: Color(0xFFEF4444),
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Gagal Memuat Galeri',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.errorMessage ?? 'Pastikan perangkat terhubung ke internet.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<PhotoBloc>().add(FetchPhotos(query: state.query));
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Coba Lagi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Empty Results State
    if (state.photos.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.image_search_rounded,
                    color: Color(0xFF6366F1),
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada foto untuk "${state.query}"',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Coba gunakan kata kunci umum lain dalam bahasa Inggris atau klik kategori di atas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () {
                    _searchController.clear();
                    context.read<PhotoBloc>().add(const SearchPhotos(''));
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6366F1),
                    side: const BorderSide(color: Color(0xFF6366F1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Kembali ke Feed Curated'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Photo Grid
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemBuilder: (context, index) {
          final photo = state.photos[index];
          return PhotoCard(
            photo: photo,
            onFavoriteToggle: () {
              context.read<PhotoBloc>().add(ToggleFavoritePhoto(photo.id));
            },
          );
        },
        childCount: state.photos.length,
      ),
    );
  }
}

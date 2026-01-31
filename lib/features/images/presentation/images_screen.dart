import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../l10n/app_localizations.dart';
import '../../../main.dart';
import '../../auth/login_screen.dart';
import '../data/image_api_service.dart';
import '../data/image_model.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({super.key});

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

enum GalleryViewMode { grid2, grid3, list }

class _ImagesScreenState extends State<ImagesScreen> {
  final _service = ImageApiService();
  final List<ImageModel> _images = [];

  int _page = 1;
  bool _loading = false;
  bool _hasMore = true;

  final ScrollController _controller = ScrollController();

  GalleryViewMode _viewMode = GalleryViewMode.grid2;

  @override
  void initState() {
    super.initState();
    _loadImages();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleLanguage() {
    final isArabic = appLocale.value.languageCode == 'ar';
    appLocale.value = Locale(isArabic ? 'en' : 'ar');
    setState(() {});
  }

  void _onScroll() {
    if (_controller.position.pixels >= _controller.position.maxScrollExtent - 200 &&
        !_loading &&
        _hasMore) {
      _loadImages();
    }
  }

  Future<void> _loadImages() async {
    setState(() => _loading = true);
    try {
      final newImages = await _service.fetchImages(page: _page);
      setState(() {
        _page++;
        _images.addAll(newImages);
        if (newImages.isEmpty) _hasMore = false;
      });
    } catch (_) {}
    setState(() => _loading = false);
  }

  String _displayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final name = FirebaseAuth.instance.currentUser?.displayName?.trim();
    if (name != null && name.isNotEmpty) return name;

    return l10n.userFallback;
  }

  Future<void> _confirmLogout() async {
    final l10n = AppLocalizations.of(context)!;

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(
          l10n.confirmLogoutTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(l10n.confirmLogoutBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context, true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [Color(0xFF5B7CFF), Color(0xFF7C4DFF)],
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                    color: Colors.black.withOpacity(0.12),
                  ),
                ],
              ),
              child: Text(
                l10n.logout,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (ok != true) return;

    await FirebaseAuth.instance.signOut();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
    );
  }

  void _openImage(ImageModel img) {
    final tag = img.preview;
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (_) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(12),
            child: Hero(
              tag: tag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Image.network(
                    img.preview,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _cycleView() {
    setState(() {
      if (_viewMode == GalleryViewMode.grid2) {
        _viewMode = GalleryViewMode.grid3;
      } else if (_viewMode == GalleryViewMode.grid3) {
        _viewMode = GalleryViewMode.list;
      } else {
        _viewMode = GalleryViewMode.grid2;
      }
    });
  }

  IconData _viewIcon() {
    switch (_viewMode) {
      case GalleryViewMode.grid2:
        return Icons.grid_view_rounded;
      case GalleryViewMode.grid3:
        return Icons.apps_rounded;
      case GalleryViewMode.list:
        return Icons.view_list_rounded;
    }
  }

  Widget _buildTopBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final name = _displayName(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.06),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: l10n.helloUser(name),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black.withOpacity(0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.gallery,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.black.withOpacity(0.55),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            tooltip: l10n.changeView,
            onPressed: _cycleView,
            icon: Icon(_viewIcon(), color: const Color(0xFF5B7CFF)),
          ),
          const SizedBox(width: 2),

          _LangSwitch(
            isArabic: isArabic,
            onTap: _toggleLanguage,
          ),

          const SizedBox(width: 4),

          IconButton(
            tooltip: l10n.logoutTooltip,
            onPressed: _confirmLogout,
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF7C4DFF)),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_viewMode == GalleryViewMode.list) {
      return ListView.builder(
        controller: _controller,
        padding: const EdgeInsets.all(12),
        itemCount: _images.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _images.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final img = _images[index];
          final tag = img.preview;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => _openImage(img),
              borderRadius: BorderRadius.circular(16),
              child: Hero(
                tag: tag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Image.network(
                      img.preview,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    final crossAxisCount = _viewMode == GalleryViewMode.grid3 ? 3 : 2;

    return GridView.builder(
      controller: _controller,
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: _images.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _images.length) {
          return const Center(child: CircularProgressIndicator());
        }
        final img = _images[index];
        final tag = img.preview;

        return InkWell(
          onTap: () => _openImage(img),
          borderRadius: BorderRadius.circular(16),
          child: Hero(
            tag: tag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                img.preview,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE7F3FF),
              Color(0xFFFFF0FA),
              Color(0xFFF3F0FF),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: _buildTopBar(context),
              ),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangSwitch extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onTap;

  const _LangSwitch({
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = isArabic ? 'EN' : 'AR';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language_rounded, size: 18, color: Color(0xFF5B7CFF)),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}
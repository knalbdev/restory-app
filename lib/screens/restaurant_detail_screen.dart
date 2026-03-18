import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/restaurant.dart';
import '../providers/favorite_provider.dart';
import '../providers/restaurant_detail_provider.dart';
import '../services/api_service.dart';
import '../widgets/gradient_app_bar.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final Restaurant restaurant;
  final String heroTag;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurant,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestaurantDetailProvider()..fetchDetail(restaurant.id),
      child: _DetailView(restaurant: restaurant, heroTag: heroTag),
    );
  }
}

class _DetailView extends StatelessWidget {
  final Restaurant restaurant;
  final String heroTag;

  const _DetailView({required this.restaurant, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantDetailProvider>(
      builder: (context, provider, _) {
        return switch (provider.state) {
          RestaurantDetailInitial() => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          RestaurantDetailLoading() => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          RestaurantDetailSuccess(restaurant: final detail) =>
            _buildContent(context, detail),
          RestaurantDetailError(message: final message) =>
            _buildError(context, message, provider),
        };
      },
    );
  }

  Widget _buildError(
    BuildContext context,
    String message,
    RestaurantDetailProvider provider,
  ) {
    return Scaffold(
      appBar: const GradientAppBar(title: Text('')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Gagal Memuat Detail',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => provider.fetchDetail(restaurant.id),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, RestaurantDetail detail) {
    return Scaffold(
      floatingActionButton: Consumer<FavoriteProvider>(
        builder: (context, favProvider, _) {
          final isFav = favProvider.isFavorite(detail.id);
          return FloatingActionButton(
            onPressed: () => favProvider.toggleFavorite(
              Restaurant(
                id: detail.id,
                name: detail.name,
                description: detail.description,
                pictureId: detail.pictureId,
                city: detail.city,
                rating: detail.rating,
              ),
            ),
            child: Icon(isFav ? Icons.favorite : Icons.favorite_border),
          );
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: heroTag,
                child: Image.network(
                  ApiService.imageUrl(detail.pictureId),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.restaurant,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, detail),
                  const SizedBox(height: 12),
                  _buildCategories(context, detail),
                  const SizedBox(height: 16),
                  _buildDescription(context, detail),
                  const SizedBox(height: 24),
                  _buildMenuSection(context, 'Makanan', detail.menus.foods),
                  const SizedBox(height: 20),
                  _buildMenuSection(context, 'Minuman', detail.menus.drinks),
                  const SizedBox(height: 24),
                  _buildReviewSection(context, detail),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, RestaurantDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detail.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${detail.address}, ${detail.city}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(
              detail.rating.toString(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategories(BuildContext context, RestaurantDetail detail) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: detail.categories
          .map(
            (cat) => Chip(
              label: Text(
                cat.name,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          )
          .toList(),
    );
  }

  Widget _buildDescription(BuildContext context, RestaurantDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deskripsi',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        _ExpandableText(text: detail.description),
      ],
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    String title,
    List<MenuItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) => _MenuCard(item: items[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewSection(BuildContext context, RestaurantDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ulasan Pelanggan',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        ...detail.customerReviews.map((r) => _ReviewCard(review: r)),
        const SizedBox(height: 16),
        _AddReviewForm(restaurantId: detail.id),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  final MenuItem item;

  const _MenuCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: SizedBox(
        width: 110,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.fastfood,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                item.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final CustomerReview review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    review.name.isNotEmpty ? review.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        review.date,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(review.review, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _AddReviewForm extends StatefulWidget {
  final String restaurantId;

  const _AddReviewForm({required this.restaurantId});

  @override
  State<_AddReviewForm> createState() => _AddReviewFormState();
}

class _AddReviewFormState extends State<_AddReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submit(RestaurantDetailProvider provider) async {
    if (!_formKey.currentState!.validate()) return;
    await provider.addReview(
      id: widget.restaurantId,
      name: _nameController.text.trim(),
      review: _reviewController.text.trim(),
    );
    if (!mounted) return;
    if (provider.reviewError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.reviewError!),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    } else {
      _nameController.clear();
      _reviewController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ulasan berhasil ditambahkan!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantDetailProvider>(
      builder: (context, provider, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tulis Ulasan',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Nama wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _reviewController,
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Ulasan',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.rate_review_outlined),
                      alignLabelWithHint: true,
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Ulasan wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: provider.isSubmittingReview
                          ? null
                          : () => _submit(provider),
                      icon: provider.isSubmittingReview
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.send),
                      label: Text(
                        provider.isSubmittingReview
                            ? 'Mengirim...'
                            : 'Kirim Ulasan',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ExpandableText extends StatefulWidget {
  final String text;

  const _ExpandableText({required this.text});

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  final _expanded = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _expanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _expanded,
      builder: (context, isExpanded, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              maxLines: isExpanded ? null : 4,
              overflow:
                  isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            GestureDetector(
              onTap: () => _expanded.value = !_expanded.value,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  isExpanded ? 'Lebih sedikit' : 'Selengkapnya',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

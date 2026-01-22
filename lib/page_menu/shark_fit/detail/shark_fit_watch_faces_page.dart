import 'package:flutter/material.dart';

class SharkFitWatchFacesPage extends StatefulWidget {
  const SharkFitWatchFacesPage({super.key});

  @override
  State<SharkFitWatchFacesPage> createState() => _SharkFitWatchFacesPageState();
}

class _SharkFitWatchFacesPageState extends State<SharkFitWatchFacesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Watch Faces',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [Tab(text: 'Online'), Tab(text: 'Mine')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildOnlineFaces(), _buildMyFaces()],
      ),
    );
  }

  Widget _buildOnlineFaces() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('New Arrivals'),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return _buildWatchFaceCard(
                  'New ${index + 1}',
                  color: Colors.primaries[index % Colors.primaries.length],
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Popular'),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              return _buildWatchFaceCard(
                'Face ${index + 1}',
                color: Colors.primaries[(index + 5) % Colors.primaries.length],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMyFaces() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Current Watch Face'),
        const SizedBox(height: 12),
        Center(
          child: SizedBox(
            width: 150,
            height: 150,
            child: _buildWatchFaceCard(
              'Default',
              color: Colors.black,
              isSelected: true,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionHeader('My Collection'),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: 3,
          itemBuilder: (context, index) {
            return _buildWatchFaceCard(
              'My Face ${index + 1}',
              color: Colors.accents[index % Colors.accents.length],
              showDelete: true,
            );
          },
        ),
        const SizedBox(height: 12),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.grey),
                SizedBox(height: 4),
                Text('Custom Watch Face', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildWatchFaceCard(
    String title, {
    Color color = Colors.blue,
    bool isSelected = false,
    bool showDelete = false,
  }) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border:
                      isSelected
                          ? Border.all(color: Colors.green, width: 3)
                          : null,
                ),
                child: Center(
                  child: Text(
                    "10:09",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              if (showDelete)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              if (isSelected)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

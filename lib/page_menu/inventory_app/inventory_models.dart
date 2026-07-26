class InventoryItem {
  final String id;
  final String name;
  final String sku;
  final String category;
  final double price;
  final int stock;
  final int lowStockThreshold;
  final String imageUrl;

  InventoryItem({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.price,
    required this.stock,
    required this.lowStockThreshold,
    required this.imageUrl,
  });

  bool get isLowStock => stock <= lowStockThreshold && stock > 0;
  bool get isOutOfStock => stock == 0;
}

// Dummy Data
final List<InventoryItem> dummyInventory = [
  InventoryItem(
    id: '1',
    name: 'Wireless Mechanical Keyboard',
    sku: 'KB-WL-001',
    category: 'Electronics',
    price: 129.99,
    stock: 45,
    lowStockThreshold: 10,
    imageUrl: 'https://images.unsplash.com/photo-1595225476474-87563907a212?auto=format&fit=crop&q=80&w=200&h=200',
  ),
  InventoryItem(
    id: '2',
    name: 'Ergonomic Office Chair',
    sku: 'CH-ER-002',
    category: 'Furniture',
    price: 249.99,
    stock: 8,
    lowStockThreshold: 15,
    imageUrl: 'https://images.unsplash.com/photo-1505843490538-5133c6c7d0e1?auto=format&fit=crop&q=80&w=200&h=200',
  ),
  InventoryItem(
    id: '3',
    name: 'USB-C Hub 8-in-1',
    sku: 'AC-HB-003',
    category: 'Accessories',
    price: 45.00,
    stock: 120,
    lowStockThreshold: 20,
    imageUrl: 'https://images.unsplash.com/photo-1616423640778-28d1b53229bd?auto=format&fit=crop&q=80&w=200&h=200',
  ),
  InventoryItem(
    id: '4',
    name: 'UltraWide Monitor 34"',
    sku: 'MN-UW-004',
    category: 'Electronics',
    price: 499.00,
    stock: 2,
    lowStockThreshold: 5,
    imageUrl: 'https://images.unsplash.com/photo-1527443154391-507e9dc6c5cc?auto=format&fit=crop&q=80&w=200&h=200',
  ),
  InventoryItem(
    id: '5',
    name: 'Noise Cancelling Headphones',
    sku: 'HD-NC-005',
    category: 'Audio',
    price: 199.99,
    stock: 0,
    lowStockThreshold: 10,
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&q=80&w=200&h=200',
  ),
];

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _ChainInfo {
  final String id;
  final String name;
  final String symbol;
  final Color color;
  final int gasGwei;
  final IconData icon;

  const _ChainInfo({
    required this.id,
    required this.name,
    required this.symbol,
    required this.color,
    required this.gasGwei,
    required this.icon,
  });
}

class _TokenAsset {
  final String symbol;
  final String name;
  final double balance;
  final double priceUsd;
  final double change24h;
  final Color color;
  final IconData icon;

  const _TokenAsset({
    required this.symbol,
    required this.name,
    required this.balance,
    required this.priceUsd,
    required this.change24h,
    required this.color,
    required this.icon,
  });

  double get totalValueUsd => balance * priceUsd;
}

class Web3WalletConnectSheetShowcase extends StatefulWidget {
  const Web3WalletConnectSheetShowcase({super.key});

  @override
  State<Web3WalletConnectSheetShowcase> createState() =>
      _Web3WalletConnectSheetShowcaseState();
}

class _Web3WalletConnectSheetShowcaseState
    extends State<Web3WalletConnectSheetShowcase> {
  final String _walletAddress = '0x84A2C4089cE393d251B5A9678e2D9179AcF339F1';
  final String _ensDomain = 'alex.eth';

  final List<_ChainInfo> _chains = const [
    _ChainInfo(
      id: 'eth',
      name: 'Ethereum Mainnet',
      symbol: 'ETH',
      color: Color(0xFF627EEA),
      gasGwei: 18,
      icon: Icons.diamond_rounded,
    ),
    _ChainInfo(
      id: 'arb',
      name: 'Arbitrum One',
      symbol: 'ARB',
      color: Color(0xFF28A0F0),
      gasGwei: 2,
      icon: Icons.layers_rounded,
    ),
    _ChainInfo(
      id: 'poly',
      name: 'Polygon PoS',
      symbol: 'POL',
      color: Color(0xFF8247E5),
      gasGwei: 32,
      icon: Icons.hexagon_rounded,
    ),
    _ChainInfo(
      id: 'base',
      name: 'Base Layer 2',
      symbol: 'BASE',
      color: Color(0xFF0052FF),
      gasGwei: 1,
      icon: Icons.circle_rounded,
    ),
    _ChainInfo(
      id: 'sol',
      name: 'Solana Network',
      symbol: 'SOL',
      color: Color(0xFF14F195),
      gasGwei: 1,
      icon: Icons.bolt_rounded,
    ),
  ];

  late _ChainInfo _selectedChain;

  final List<_TokenAsset> _tokens = const [
    _TokenAsset(
      symbol: 'ETH',
      name: 'Ethereum',
      balance: 4.852,
      priceUsd: 3480.50,
      change24h: 3.42,
      color: Color(0xFF627EEA),
      icon: Icons.diamond_rounded,
    ),
    _TokenAsset(
      symbol: 'USDC',
      name: 'USD Coin',
      balance: 6240.00,
      priceUsd: 1.00,
      change24h: 0.01,
      color: Color(0xFF2775CA),
      icon: Icons.monetization_on_rounded,
    ),
    _TokenAsset(
      symbol: 'SOL',
      name: 'Solana',
      balance: 38.40,
      priceUsd: 154.20,
      change24h: -1.85,
      color: Color(0xFF14F195),
      icon: Icons.bolt_rounded,
    ),
    _TokenAsset(
      symbol: 'ARB',
      name: 'Arbitrum',
      balance: 1450.00,
      priceUsd: 0.98,
      change24h: 5.12,
      color: Color(0xFF28A0F0),
      icon: Icons.layers_rounded,
    ),
  ];

  bool _isCopied = false;
  bool _isBalanceVisible = true;

  @override
  void initState() {
    super.initState();
    _selectedChain = _chains.first;
  }

  double get _totalPortfolioUsd {
    return _tokens.fold(0.0, (sum, token) => sum + token.totalValueUsd);
  }

  String _formatCurrency(double val) {
    return '\$${val.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String get _truncatedAddress {
    if (_walletAddress.length <= 12) return _walletAddress;
    return '${_walletAddress.substring(0, 6)}...${_walletAddress.substring(_walletAddress.length - 4)}';
  }

  void _copyAddress() {
    Clipboard.setData(ClipboardData(text: _walletAddress));
    HapticFeedback.mediumImpact();
    setState(() => _isCopied = true);

    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF10B981),
              size: 18,
            ),
            SizedBox(width: 8),
            Text('Alamat dompet Web3 berhasil disalin!'),
          ],
        ),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isCopied = false);
    });
  }

  void _showChainSelectorSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (ctx) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih Jaringan Blockchain:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                ..._chains.map((chain) {
                  final isSelected = _selectedChain.id == chain.id;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? chain.color.withValues(alpha: 0.15)
                              : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? chain.color : Colors.white10,
                      ),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: chain.color.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(chain.icon, color: chain.color, size: 20),
                      ),
                      title: Text(
                        chain.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        'Gas: ${chain.gasGwei} Gwei • Fast Finality',
                        style: TextStyle(color: Colors.grey[400], fontSize: 11),
                      ),
                      trailing:
                          isSelected
                              ? Icon(
                                Icons.check_circle_rounded,
                                color: chain.color,
                              )
                              : null,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedChain = chain);
                        Navigator.pop(ctx);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
    );
  }

  void _showQrDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => Dialog(
            backgroundColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Receive Web3 Assets',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: CustomPaint(painter: _QrCodePlaceholderPainter()),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _ensDomain,
                    style: const TextStyle(
                      color: Color(0xFF38BDF8),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _truncatedAddress,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: () {
                      _copyAddress();
                      Navigator.pop(ctx);
                    },
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    label: const Text('Salin Alamat Dompet'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
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

  void _showSwapSimulationModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (ctx) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quick Token Swap',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.tune_rounded, color: Colors.grey, size: 20),
                  ],
                ),
                const SizedBox(height: 16),
                // Pay Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'You Pay',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '1.0',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Chip(
                        avatar: Icon(
                          Icons.diamond_rounded,
                          color: Color(0xFF627EEA),
                          size: 18,
                        ),
                        label: Text(
                          'ETH',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Color(0xFF334155),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFF6366F1),
                    child: Icon(
                      Icons.arrow_downward_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // Receive Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'You Receive (Est.)',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '3,480.50',
                            style: TextStyle(
                              color: Color(0xFF10B981),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Chip(
                        avatar: Icon(
                          Icons.monetization_on_rounded,
                          color: Color(0xFF2775CA),
                          size: 18,
                        ),
                        label: Text(
                          'USDC',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Color(0xFF334155),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    Navigator.pop(ctx);
                    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(
                              Icons.lock_open_rounded,
                              color: Color(0xFF10B981),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text('Transaksi ditandatangani via Web3 Provider!'),
                          ],
                        ),
                        backgroundColor: const Color(0xFF1E293B),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Sign & Swap Tokens',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. WEB3 HEADER & NETWORK SELECTOR
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    isDark
                        ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                        : [const Color(0xFF1E293B), const Color(0xFF0F172A)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Chain Badge & ENS Address
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Network Switch Button
                    GestureDetector(
                      onTap: _showChainSelectorSheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedChain.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _selectedChain.color.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _selectedChain.icon,
                              color: _selectedChain.color,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _selectedChain.name.split(' ').first,
                              style: TextStyle(
                                color: _selectedChain.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.5,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: _selectedChain.color,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Copy Address Pill
                    GestureDetector(
                      onTap: _copyAddress,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _ensDomain,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 11.5,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              _isCopied
                                  ? Icons.check_rounded
                                  : Icons.copy_rounded,
                              color:
                                  _isCopied
                                      ? const Color(0xFF10B981)
                                      : Colors.white70,
                              size: 13,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Total Portfolio Balance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Total Net Worth',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap:
                                  () => setState(
                                    () =>
                                        _isBalanceVisible = !_isBalanceVisible,
                                  ),
                              child: Icon(
                                _isBalanceVisible
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                color: Colors.white38,
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isBalanceVisible
                              ? _formatCurrency(_totalPortfolioUsd)
                              : '•••••••••',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: _showQrDialog,
                      icon: const Icon(
                        Icons.qr_code_rounded,
                        color: Colors.white70,
                        size: 24,
                      ),
                      tooltip: 'Show QR Code',
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Quick Action Buttons (Send, Receive, Swap, Buy)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(
                      icon: Icons.arrow_upward_rounded,
                      label: 'Send',
                      color: const Color(0xFF38BDF8),
                      onTap: () {},
                    ),
                    _buildActionButton(
                      icon: Icons.arrow_downward_rounded,
                      label: 'Receive',
                      color: const Color(0xFF10B981),
                      onTap: _showQrDialog,
                    ),
                    _buildActionButton(
                      icon: Icons.swap_horiz_rounded,
                      label: 'Swap',
                      color: const Color(0xFF6366F1),
                      onTap: _showSwapSimulationModal,
                    ),
                    _buildActionButton(
                      icon: Icons.add_card_rounded,
                      label: 'Buy',
                      color: const Color(0xFFF59E0B),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. TOKEN ASSET LIST HEADER
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Crypto Assets',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Portfolio Allocations',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 3. ASSET HOLDINGS LIST
          ..._tokens.map((token) {
            final isPositive = token.change24h >= 0;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.black12,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: token.color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(token.icon, color: token.color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          token.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              '\$${token.priceUsd.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${isPositive ? '+' : ''}${token.change24h}%',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color:
                                    isPositive
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _isBalanceVisible
                            ? _formatCurrency(token.totalValueUsd)
                            : '••••',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isBalanceVisible
                            ? '${token.balance} ${token.symbol}'
                            : '•••',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// CustomPainter: Decorative QR Code Matrix
// -------------------------------------------------------------
class _QrCodePlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF0F172A);
    const int grid = 7;
    final cellSize = size.width / grid;

    // Corner Finder Patterns
    void drawCorner(double left, double top) {
      canvas.drawRect(
        Rect.fromLTWH(left, top, cellSize * 2, cellSize * 2),
        paint,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          left + cellSize * 0.5,
          top + cellSize * 0.5,
          cellSize,
          cellSize,
        ),
        Paint()..color = Colors.white,
      );
    }

    drawCorner(0, 0);
    drawCorner(size.width - cellSize * 2, 0);
    drawCorner(0, size.height - cellSize * 2);

    // Some decorative data pixels
    canvas.drawRect(
      Rect.fromLTWH(cellSize * 3, cellSize * 1, cellSize, cellSize),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cellSize * 4, cellSize * 2, cellSize, cellSize),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cellSize * 2, cellSize * 3, cellSize, cellSize),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cellSize * 3, cellSize * 3, cellSize, cellSize),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cellSize * 4, cellSize * 4, cellSize, cellSize),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cellSize * 5, cellSize * 3, cellSize, cellSize),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cellSize * 3, cellSize * 5, cellSize, cellSize),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cellSize * 4, cellSize * 5, cellSize, cellSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

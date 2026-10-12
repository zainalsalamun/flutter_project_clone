import 'package:flutter/material.dart';

class ExpandableTreeViewHierarchyShowcase extends StatefulWidget {
  const ExpandableTreeViewHierarchyShowcase({super.key});

  @override
  State<ExpandableTreeViewHierarchyShowcase> createState() =>
      _ExpandableTreeViewHierarchyShowcaseState();
}

class _TreeNode {
  final String id;
  final String name;
  final bool isFolder;
  final String extension;
  final String size;
  bool isExpanded;
  final List<_TreeNode> children;

  _TreeNode({
    required this.id,
    required this.name,
    required this.isFolder,
    this.extension = '',
    this.size = '',
    this.isExpanded = false,
    List<_TreeNode>? children,
  }) : children = children ?? [];
}

class _ExpandableTreeViewHierarchyShowcaseState
    extends State<ExpandableTreeViewHierarchyShowcase> {
  late List<_TreeNode> _rootNodes;
  _TreeNode? _selectedNode;
  String _breadcrumbPath = 'project_root/lib';

  @override
  void initState() {
    super.initState();
    _initTreeData();
  }

  void _initTreeData() {
    _rootNodes = [
      _TreeNode(
        id: '1',
        name: 'lib',
        isFolder: true,
        isExpanded: true,
        children: [
          _TreeNode(
            id: '1-1',
            name: 'core',
            isFolder: true,
            isExpanded: true,
            children: [
              _TreeNode(
                id: '1-1-1',
                name: 'app_constants.dart',
                isFolder: false,
                extension: 'dart',
                size: '2.4 KB',
              ),
              _TreeNode(
                id: '1-1-2',
                name: 'app_theme.dart',
                isFolder: false,
                extension: 'dart',
                size: '4.8 KB',
              ),
              _TreeNode(
                id: '1-1-3',
                name: 'api_client.dart',
                isFolder: false,
                extension: 'dart',
                size: '6.1 KB',
              ),
            ],
          ),
          _TreeNode(
            id: '1-2',
            name: 'features',
            isFolder: true,
            isExpanded: true,
            children: [
              _TreeNode(
                id: '1-2-1',
                name: 'auth',
                isFolder: true,
                isExpanded: false,
                children: [
                  _TreeNode(
                    id: '1-2-1-1',
                    name: 'login_view.dart',
                    isFolder: false,
                    extension: 'dart',
                    size: '8.2 KB',
                  ),
                  _TreeNode(
                    id: '1-2-1-2',
                    name: 'register_view.dart',
                    isFolder: false,
                    extension: 'dart',
                    size: '7.5 KB',
                  ),
                  _TreeNode(
                    id: '1-2-1-3',
                    name: 'auth_cubit.dart',
                    isFolder: false,
                    extension: 'dart',
                    size: '3.9 KB',
                  ),
                ],
              ),
              _TreeNode(
                id: '1-2-2',
                name: 'dashboard',
                isFolder: true,
                isExpanded: true,
                children: [
                  _TreeNode(
                    id: '1-2-2-1',
                    name: 'dashboard_screen.dart',
                    isFolder: false,
                    extension: 'dart',
                    size: '12.0 KB',
                  ),
                  _TreeNode(
                    id: '1-2-2-2',
                    name: 'analytics_card.dart',
                    isFolder: false,
                    extension: 'dart',
                    size: '5.1 KB',
                  ),
                ],
              ),
            ],
          ),
          _TreeNode(
            id: '1-3',
            name: 'widgets',
            isFolder: true,
            isExpanded: false,
            children: [
              _TreeNode(
                id: '1-3-1',
                name: 'custom_button.dart',
                isFolder: false,
                extension: 'dart',
                size: '3.2 KB',
              ),
              _TreeNode(
                id: '1-3-2',
                name: 'glass_card.dart',
                isFolder: false,
                extension: 'dart',
                size: '2.9 KB',
              ),
              _TreeNode(
                id: '1-3-3',
                name: 'tree_view.dart',
                isFolder: false,
                extension: 'dart',
                size: '4.5 KB',
              ),
            ],
          ),
          _TreeNode(
            id: '1-4',
            name: 'main.dart',
            isFolder: false,
            extension: 'dart',
            size: '1.8 KB',
          ),
          _TreeNode(
            id: '1-5',
            name: 'app_routes.dart',
            isFolder: false,
            extension: 'dart',
            size: '3.1 KB',
          ),
        ],
      ),
      _TreeNode(
        id: '2',
        name: 'assets',
        isFolder: true,
        isExpanded: false,
        children: [
          _TreeNode(
            id: '2-1',
            name: 'images',
            isFolder: true,
            children: [
              _TreeNode(
                id: '2-1-1',
                name: 'logo_hero.png',
                isFolder: false,
                extension: 'png',
                size: '142 KB',
              ),
              _TreeNode(
                id: '2-1-2',
                name: 'avatar_default.jpg',
                isFolder: false,
                extension: 'jpg',
                size: '88 KB',
              ),
            ],
          ),
          _TreeNode(
            id: '2-2',
            name: 'config',
            isFolder: true,
            children: [
              _TreeNode(
                id: '2-2-1',
                name: 'settings.json',
                isFolder: false,
                extension: 'json',
                size: '1.2 KB',
              ),
              _TreeNode(
                id: '2-2-2',
                name: 'locales.json',
                isFolder: false,
                extension: 'json',
                size: '8.4 KB',
              ),
            ],
          ),
        ],
      ),
      _TreeNode(
        id: '3',
        name: 'pubspec.yaml',
        isFolder: false,
        extension: 'yaml',
        size: '2.1 KB',
      ),
      _TreeNode(
        id: '4',
        name: 'README.md',
        isFolder: false,
        extension: 'md',
        size: '5.6 KB',
      ),
    ];
  }

  void _toggleNode(_TreeNode node) {
    setState(() {
      if (node.isFolder) {
        node.isExpanded = !node.isExpanded;
      }
      _selectedNode = node;
      _updateBreadcrumb(node);
    });
  }

  void _updateBreadcrumb(_TreeNode target) {
    List<String> pathSegments = [];

    bool findPath(_TreeNode current, List<String> currentPath) {
      currentPath.add(current.name);
      if (current.id == target.id) {
        pathSegments = List.from(currentPath);
        return true;
      }
      for (var child in current.children) {
        if (findPath(child, currentPath)) return true;
      }
      currentPath.removeLast();
      return false;
    }

    for (var root in _rootNodes) {
      if (findPath(root, [])) break;
    }

    setState(() {
      _breadcrumbPath = 'project_root/${pathSegments.join('/')}';
    });
  }

  void _expandAll(bool expand) {
    setState(() {
      void recurse(_TreeNode n) {
        if (n.isFolder) {
          n.isExpanded = expand;
          for (var child in n.children) {
            recurse(child);
          }
        }
      }

      for (var root in _rootNodes) {
        recurse(root);
      }
    });
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
          // BREADCRUMBS & EXPAND ALL BUTTONS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.terminal_rounded,
                  color: Color(0xFF38BDF8),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _breadcrumbPath,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontFamily: 'monospace',
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _expandAll(true),
                      tooltip: 'Buka Semua Folder',
                      icon: Icon(
                        Icons.unfold_more_rounded,
                        color: isDark ? Colors.white70 : Colors.black54,
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _expandAll(false),
                      tooltip: 'Tutup Semua Folder',
                      icon: Icon(
                        Icons.unfold_less_rounded,
                        color: isDark ? Colors.white70 : Colors.black54,
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // TREE VIEW EXPLORER CONTAINER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  _rootNodes
                      .map(
                        (node) =>
                            _buildTreeNode(node, depth: 0, isDark: isDark),
                      )
                      .toList(),
            ),
          ),

          // SELECTED FILE DETAILS PANEL
          if (_selectedNode != null && !_selectedNode!.isFolder) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  _buildFileIcon(_selectedNode!.extension),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedNode!.name,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Ukuran: ${_selectedNode!.size} • Format: ${_selectedNode!.extension.toUpperCase()}',
                          style: TextStyle(
                            color: isDark ? Colors.white54 : Colors.black54,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Read-Only',
                      style: TextStyle(
                        color: Color(0xFF38BDF8),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTreeNode(
    _TreeNode node, {
    required int depth,
    required bool isDark,
  }) {
    final isSelected = _selectedNode?.id == node.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _toggleNode(node),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.only(
              left: (depth * 18.0) + 6,
              top: 5,
              bottom: 5,
              right: 8,
            ),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.15)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Expand / Collapse Arrow Caret
                if (node.isFolder)
                  AnimatedRotation(
                    turns: node.isExpanded ? 0.25 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.arrow_right_rounded,
                      color: isDark ? Colors.white60 : Colors.black45,
                      size: 20,
                    ),
                  )
                else
                  const SizedBox(width: 20),

                const SizedBox(width: 4),

                // Icon (Folder vs File)
                if (node.isFolder)
                  Icon(
                    node.isExpanded
                        ? Icons.folder_open_rounded
                        : Icons.folder_rounded,
                    color: const Color(0xFFF59E0B),
                    size: 18,
                  )
                else
                  _buildFileIcon(node.extension),

                const SizedBox(width: 8),

                // Name
                Expanded(
                  child: Text(
                    node.name,
                    style: TextStyle(
                      color:
                          isSelected
                              ? const Color(0xFF38BDF8)
                              : (node.isFolder
                                  ? (isDark ? Colors.white : Colors.black87)
                                  : (isDark ? Colors.white70 : Colors.black54)),
                      fontSize: 12,
                      fontWeight:
                          node.isFolder ? FontWeight.bold : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Size info (for files)
                if (!node.isFolder && node.size.isNotEmpty)
                  Text(
                    node.size,
                    style: TextStyle(
                      color: isDark ? Colors.white24 : Colors.black26,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Recursive Children Nodes with animated visibility
        if (node.isFolder && node.isExpanded)
          ...node.children.map(
            (child) => _buildTreeNode(child, depth: depth + 1, isDark: isDark),
          ),
      ],
    );
  }

  Widget _buildFileIcon(String ext) {
    Color iconColor = Colors.grey;
    IconData iconData = Icons.insert_drive_file_rounded;

    switch (ext) {
      case 'dart':
        iconColor = const Color(0xFF38BDF8);
        iconData = Icons.code_rounded;
        break;
      case 'json':
      case 'yaml':
        iconColor = const Color(0xFFFACC15);
        iconData = Icons.settings_rounded;
        break;
      case 'md':
        iconColor = const Color(0xFFA78BFA);
        iconData = Icons.article_rounded;
        break;
      case 'png':
      case 'jpg':
        iconColor = const Color(0xFFF472B6);
        iconData = Icons.image_rounded;
        break;
    }

    return Icon(iconData, color: iconColor, size: 16);
  }
}

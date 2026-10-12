import 'package:flutter/material.dart';

class ExpandableAccordionShowcase extends StatefulWidget {
  const ExpandableAccordionShowcase({super.key});

  @override
  State<ExpandableAccordionShowcase> createState() =>
      _ExpandableAccordionShowcaseState();
}

class _ExpandableAccordionShowcaseState
    extends State<ExpandableAccordionShowcase> {
  int? _expandedIndex = 0;

  final List<Map<String, dynamic>> _faqItems = [
    {
      'title': 'How do I export or copy code snippets?',
      'subtitle': 'Developer features',
      'icon': Icons.code_rounded,
      'content':
          'Each widget showcase page includes a dedicated "Code Viewer" modal or tab. Click the copy icon to instantly grab the production-ready source code.',
    },
    {
      'title': 'Is Material 3 design supported?',
      'subtitle': 'Theming & UI compatibility',
      'icon': Icons.color_lens_rounded,
      'content':
          'Yes! All widgets are built natively for Flutter with full Material 3 dynamic color and Theme support out of the box.',
    },
    {
      'title': 'Can I contribute new widget examples?',
      'subtitle': 'Extensibility',
      'icon': Icons.add_circle_outline_rounded,
      'content':
          'Simply create a new showcase widget inside the relevant domain folder and register it in widget_catalog_registry.dart.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_faqItems.length, (index) {
        final item = _faqItems[index];
        final isExpanded = _expandedIndex == index;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ExpandableAccordionCard(
            title: item['title'] as String,
            subtitle: item['subtitle'] as String,
            icon: item['icon'] as IconData,
            isExpanded: isExpanded,
            onToggle: () {
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
            },
            child: Text(
              item['content'] as String,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13.5,
                height: 1.5,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class ExpandableAccordionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget child;

  const ExpandableAccordionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.isExpanded,
    required this.onToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6366F1);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isExpanded
                  ? primaryColor.withValues(alpha: 0.5)
                  : Colors.grey.shade200,
          width: isExpanded ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isExpanded
                    ? primaryColor.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (isExpanded
                                ? primaryColor
                                : Colors.grey.shade600)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        color: isExpanded ? primaryColor : Colors.grey.shade700,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isExpanded ? primaryColor : Colors.black87,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle!,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isExpanded ? primaryColor : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox(width: double.infinity),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 14, left: 40),
                    child: child,
                  ),
                  crossFadeState:
                      isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 250),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

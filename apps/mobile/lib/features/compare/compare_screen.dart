import 'package:flutter/material.dart';
import 'package:mobile/features/compare/widget/empty_state.dart';
import 'package:provider/provider.dart';
import 'package:mobile/theme/theme_context.dart';
import '../../providers/compare_provider.dart';
import 'widget/overall_build_card.dart';
import 'widget/product_compare_view.dart';
import 'widget/build_compare_view.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  bool _onlyShowDifferences = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CompareProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Compare Specifications',
          style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Show the "Only Show Differences" filter toggle only if we are comparing products
          if (provider.mode == CompareMode.products && provider.count > 1)
            IconButton(
              icon: Icon(
                _onlyShowDifferences ? Icons.difference : Icons.difference_outlined,
                color: _onlyShowDifferences ? context.colorScheme.primary : null,
              ),
              tooltip: 'Only Show Differences',
              onPressed: () => setState(() => _onlyShowDifferences = !_onlyShowDifferences),
            ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () => provider.clear(),
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: provider.isEmpty
          ? const EmptyState()
          : provider.mode == CompareMode.products
              ? ProductCompareView(
                  products: provider.selectedProducts,
                  onlyShowDifferences: _onlyShowDifferences,
                )
              : BuildCompareView(
                  builds: provider.selectedBuilds,
                ),
    );
  }
}
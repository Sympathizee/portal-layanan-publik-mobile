import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/app_header.dart';
import '../../../../shared/widgets/app_pagination.dart';
import '../../../../shared/widgets/filter_chips_row.dart';
import '../../../../shared/widgets/filter_sort_row.dart';
import '../widgets/search_header.dart';
import '../widgets/search_result_card.dart';
import '../../../../shared/widgets/app_footer.dart';

class SearchPage extends StatefulWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onLoginTap;
  final bool isLoggedIn;

  const SearchPage({
    super.key,
    this.onMenuTap,
    this.onLoginTap,
    this.isLoggedIn = false,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';
  String _selectedSort = 'terbaru';
  int _currentPage = 1;
  final int _totalPages = 5;

  // Mock data
  final List<Map<String, dynamic>> _allResults = [
    {
      'category': 'Layanan Nasional',
      'title': 'Pengurusan Akta Kelahiran',
      'location': 'DKI Jakarta',
      'lastUpdated': '13 Feb 2026',
      'description':
          'Layanan Pembuatan Akta Kelahiran adalah pencatatan resmi kelahiran anak oleh negara. Akta K...',
      'type': 'layanan',
    },
    {
      'category': 'Informasi',
      'title': 'Pengurusan Akta Kelahiran Kini Bisa 100% Online',
      'location': 'Nasional',
      'lastUpdated': '13 Feb 2026',
      'description':
          'Direktorat Jenderal Kependudukan dan Pencatatan Sipil (Dukcapil) Kementerian Dalam Negeri meluncur...',
      'type': 'informasi',
    },
    {
      'category': 'Informasi',
      'title': 'Arti Stbld pada Akta Kelahiran, Ini Asal-u',
      'location': 'Nasional',
      'lastUpdated': '13 Feb 2026',
      'description':
          'Pernahkah kamu memperhatikan pada Akta Kelahiran terdapat keterangan yang ditulis dengan kode "Stbl...',
      'type': 'informasi',
    },
  ];

  List<Map<String, dynamic>> get _filteredResults {
    if (_selectedFilter == 'all') return _allResults;
    return _allResults
        .where((item) => item['type'] == _selectedFilter)
        .toList();
  }

  int get _layananCount =>
      _allResults.where((item) => item['type'] == 'layanan').length;
  int get _informasiCount =>
      _allResults.where((item) => item['type'] == 'informasi').length;

  List<FilterChipItem> get _chips => [
        FilterChipItem(key: 'all', label: 'Semua', count: _allResults.length),
        FilterChipItem(key: 'layanan', label: 'Layanan', count: _layananCount),
        FilterChipItem(
            key: 'informasi', label: 'Informasi', count: _informasiCount),
      ];

  @override
  void initState() {
    super.initState();
    _searchController.text = 'Akta kelahiran';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AppHeader(
            onMenuTap: widget.onMenuTap,
            onLoginTap: widget.onLoginTap,
            isLoggedIn: widget.isLoggedIn,
          ),
          const SearchHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question Title
                        const Text(
                          'Apa yang ingin Anda cari?',
                          style: TextStyle(
                            color: AppColors.brandPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Search Input
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Akta kelahiran',
                                  hintStyle: const TextStyle(
                                    color: AppColors.contentSecondary,
                                    fontSize: 14,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: AppColors.strokePrimary,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: AppColors.strokePrimary,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: AppColors.brandPrimary,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: AppColors.contentSecondary,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.brandPrimary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // Perform search
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Result Count
                        Text(
                          'Menampilkan hasil pencarian untuk',
                          style: const TextStyle(
                            color: AppColors.contentSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _searchController.text,
                          style: const TextStyle(
                            color: AppColors.brandPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Filter and Sort
                        FilterSortRow(
                          sortLabel: _selectedSort == 'terbaru'
                              ? 'Terbaru'
                              : 'Terlama',
                          onSortTap: () {
                            setState(() {
                              _selectedSort = _selectedSort == 'terbaru'
                                  ? 'terlama'
                                  : 'terbaru';
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        // Filter Chips
                        FilterChipsRow(
                          chips: _chips,
                          selectedKey: _selectedFilter,
                          onSelected: (key) {
                            setState(() {
                              _selectedFilter = key;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        // Search Results
                        ..._filteredResults.map((result) {
                          return SearchResultCard(
                            category: result['category'],
                            title: result['title'],
                            location: result['location'],
                            lastUpdated: result['lastUpdated'],
                            description: result['description'],
                            onTap: () {
                              // Navigate to detail
                            },
                          );
                        }),
                        const SizedBox(height: 24),
                        // Pagination
                        AppPagination(
                          currentPage: _currentPage,
                          totalPages: _totalPages,
                          onPageChanged: (page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                  const AppFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

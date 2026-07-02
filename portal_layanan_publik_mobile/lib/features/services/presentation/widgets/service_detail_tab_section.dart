import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class ServiceDetailTabSection extends StatefulWidget {
  final Map<String, dynamic>? detailData;

  const ServiceDetailTabSection({
    super.key,
    this.detailData,
  });

  @override
  State<ServiceDetailTabSection> createState() {
    return _ServiceDetailTabSectionState();
  }
}

class _ServiceDetailTabSectionState
    extends State<ServiceDetailTabSection> {
  int _selectedTabIndex = 0;

  static const List<String> _tabs = [
    'Persyaratan',
    'Cara Mengakses',
    'Informasi Tambahan',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(
            _tabs.length,
                (index) {
              final isSelected = _selectedTabIndex == index;

              return Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 4,
                      right: 4,
                      top: 10,
                      bottom: 11,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected
                              ? AppColors.brandPrimary
                              : AppColors.strokePrimary,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                    ),
                    child: Text(
                      _tabs[index],
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.brandPrimary
                            : AppColors.contentSecondary,
                        fontSize: 12.5,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: KeyedSubtree(
            key: ValueKey(_selectedTabIndex),
            child: _DynamicTabContent(
              detailData: widget.detailData,
              tabIndex: _selectedTabIndex,
              onAccessGuideTap: () {
                setState(() {
                  _selectedTabIndex = 1;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _DynamicTabContent extends StatelessWidget {
  final VoidCallback onAccessGuideTap;
  final Map<String, dynamic>? detailData;
  final int tabIndex;

  const _DynamicTabContent({
    required this.onAccessGuideTap,
    this.detailData,
    required this.tabIndex,
  });

  static const List<String> _defaultItems = [
    'NIK orang tua.',
    'Kartu Keluarga (KK).',
    'Buku nikah atau akta perkawinan orang tua.',
    'Surat keterangan lahir dari rumah sakit, puskesmas, atau bidan.',
    'Jika NIK orang tua belum tersedia, sertakan Surat Pernyataan '
        'Tanggung Jawab Mutlak (SPTJM).',
  ];

  @override
  Widget build(BuildContext context) {
    if (detailData == null) {
      return _buildListContent(context, _defaultItems);
    }

    if (tabIndex == 0) {
      final reqs = detailData!['layanan_persyaratan'] as List?;
      if (reqs != null && reqs.isNotEmpty) {
        final items = reqs.map((e) => (e as Map)['deskripsi'] as String).toList();
        return _buildListContent(context, items);
      }
      return _buildEmpty(context);
    } else if (tabIndex == 1) {
      final steps = detailData!['layanan_cara_mengakses'] as List?;
      if (steps != null && steps.isNotEmpty) {
        final items = steps.map((e) => (e as Map)['deskripsi'] as String).toList();
        return _buildListContent(context, items, hideButton: true);
      }
      return _buildEmpty(context);
    } else if (tabIndex == 2) {
      final info = detailData!['layanan_informasi_tambahan'] as Map?;
      if (info != null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: info.entries.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.key.toString().replaceAll('_', ' ').toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.contentSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    e.value.toString(),
                    style: const TextStyle(
                      color: AppColors.contentPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      }
      return _buildEmpty(context);
    }

    return _buildEmpty(context);
  }

  Widget _buildEmpty(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          'Tidak ada data tersedia',
          style: TextStyle(
            color: AppColors.contentSecondary,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildListContent(BuildContext context, List<String> items, {bool hideButton = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Berikut adalah informasi yang wajib diperhatikan:',
          style: TextStyle(
            color: AppColors.contentPrimary,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(
          items.length,
          (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == items.length - 1 ? 0 : 14,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F3F5),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: AppColors.contentSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      items[index],
                      style: const TextStyle(
                        color: AppColors.contentPrimary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (!hideButton) const SizedBox(height: 18),
        if (!hideButton)
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: onAccessGuideTap,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.brandPrimary,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Lihat cara mengakses',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
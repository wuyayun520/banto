import 'package:flutter/material.dart';

class TopOptionsBar extends StatefulWidget {
  final Function(int)? onSelectionChanged;
  
  const TopOptionsBar({
    super.key,
    this.onSelectionChanged,
  });

  @override
  State<TopOptionsBar> createState() => _TopOptionsBarState();
}

class _TopOptionsBarState extends State<TopOptionsBar> {
  int _selectedIndex = 0; // 默认选中第一个选项

  final List<String> _normalImages = [
    'assets/images/top_1/banto_home_top_1_nor.png',
    'assets/images/top_1/banto_home_top_2_nor.png',
    'assets/images/top_1/banto_home_top_3_nor.png',
    'assets/images/top_1/banto_home_top_4_nor.png',
  ];

  final List<String> _selectedImages = [
    'assets/images/top_2/banto_home_top_1_pre.png',
    'assets/images/top_2/banto_home_top_2_pre.png',
    'assets/images/top_2/banto_home_top_3_pre.png',
    'assets/images/top_2/banto_home_top_4_pre.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(4, (index) {
            final bool isSelected = _selectedIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                // 通知父组件选项已改变
                if (widget.onSelectionChanged != null) {
                  widget.onSelectionChanged!(index);
                }
              },
              child: Container(
                margin: EdgeInsets.only(
                  left: index == 0 ? 0 : 16, // 第一个选项左边距为0，其他为16
                  right: index == 3 ? 0 : 0, // 最后一个选项右边距为0
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  isSelected ? _selectedImages[index] : _normalImages[index],
                  height: 44,
                  fit: BoxFit.fitHeight,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading option image: $error');
                    print('Image path: ${isSelected ? _selectedImages[index] : _normalImages[index]}');
                    return Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
} 
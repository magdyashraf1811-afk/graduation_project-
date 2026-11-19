import 'package:material_ui/material_ui.dart';

class MuseumImageGallery extends StatefulWidget {
  final List<String> images;

  const MuseumImageGallery({
    super.key,
    required this.images,
  });

  @override
  State<MuseumImageGallery> createState() =>
      _MuseumImageGalleryState();
}

class _MuseumImageGalleryState extends State<MuseumImageGallery> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 270,
          width: double.infinity,
          child: PageView.builder(
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    widget.images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 15),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.images.length,
                (index) {
              final isSelected = currentIndex == index;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 7,
                width: isSelected ? 22 : 7,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFD4AF37)
                      : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

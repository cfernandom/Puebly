import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:puebly/config/theme/color_manager.dart';
import 'package:puebly/features/towns/domain/entities/town.dart';
import 'package:puebly/features/towns/presentation/providers/sections_providers.dart';

class TownCard extends ConsumerWidget {
  final Town town;
  const TownCard({super.key, required this.town});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (!town.enabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Próximamente en Puebly'),
              backgroundColor: ColorManager.pueblySecundary1,
            ),
          );
          return;
        }
        ref.read(showTownSectionsViewProvider.notifier).state = true;
        ref.read(sectionIndexProvider.notifier).state = 0;
        context.push('/app/town/${town.categoryId}');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ImageViewer(imagePath: town.featuredImgUrl, enabled: town.enabled),
            const SizedBox(height: 8),
            _HeaderText(text: town.name, enabled: town.enabled),
            //_Content(text: town.description),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ImageViewer extends StatelessWidget {
  final String imagePath;
  final bool enabled;

  const _ImageViewer({
    Key? key,
    required this.imagePath,
    required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final width = constraints.maxWidth;

        if (imagePath == '') {
          return ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.asset('assets/images/puebly-loader.gif',
                width: width, height: width, fit: BoxFit.cover),
          );
        }

        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              enabled ? Colors.transparent : Colors.grey.withOpacity(0.8),
              enabled ? BlendMode.multiply : BlendMode.saturation,
            ),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                enabled
                    ? Colors.transparent
                    : Colors.white.withOpacity(0.2), // Aclarar los negros
                enabled ? BlendMode.multiply : BlendMode.colorDodge,
              ),
              child: CachedNetworkImage(
                imageUrl: imagePath,
                width: width,
                height: width,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: ClipRRect(
                    child: Image.asset('assets/images/puebly-loader.gif',
                        width: width, height: width, fit: BoxFit.cover),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;
  final bool enabled;

  const _HeaderText({
    required this.text,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: enabled
                  ? ColorManager.colorSeed
                  : ColorManager.colorSeed.withOpacity(0.6),
            ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final String text;

  const _Content({required this.text});

  @override
  Widget build(BuildContext context) {
    return text != ''
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.black38,
                  ),
            ),
          )
        : const SizedBox();
  }
}

import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puebly/config/theme/color_manager.dart';
import 'package:puebly/features/towns/domain/entities/category.dart';
import 'package:puebly/features/towns/presentation/providers/town_provider.dart';

class CustomFilterList extends ConsumerWidget {
  final int townCategoryId;
  final int sectionIndex;
  const CustomFilterList({
    super.key,
    required this.townCategoryId,
    required this.sectionIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref
        .watch(townProvider(townCategoryId))
        .townSections[sectionIndex]
        .childCategories;
    final selectedData = ref.watch(selectedFiltersProvider);
    final List<Category> selectedListData =
        selectedData.values.expand((e) => e).toList();
    final bool isLoading =
        ref.watch(townProvider(townCategoryId)).isChildCategoriesLoading;

    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          FilterListWidget(
            listData: filters,
            selectedListData: selectedListData,
            hideSelectedTextCount: true,
            hideHeader: true,
            hideSearchField: true,
            allButtonText: "Todos",
            resetButtonText: "Limpiar",
            applyButtonText: "Buscar",
            themeData: _filterListThemeData(context),
            hideCloseIcon: true,
            onApplyButtonClick: (list) {
              if (ref
                  .read(townProvider(townCategoryId))
                  .townSections[sectionIndex]
                  .isLoading) {
                return;
              }
    
              ref.read(selectedFiltersProvider.notifier).update((state) {
                state.clear();
                if (list != null) {
                  for (final element in list) {
                    state[element.id] = [element];
                  }
                }
                return state;
              });
              ref
                  .read(townProvider(townCategoryId).notifier)
                  .resetSection(sectionIndex);
              ref.read(townProvider(townCategoryId).notifier).getSectionPosts(
                    sectionIndex,
                    childCategories: list?.map((e) => e.id).toList(),
                  );
            },
            validateSelectedItem: (list, item) {
              if (list == null) return false;
              return list.contains(item);
            },
            choiceChipLabel: (item) {
              return item!.name;
            },
            onItemSearch: (item, query) {
              return item.name.toLowerCase().contains(query.toLowerCase());
            },
            choiceChipBuilder: (context, item, isSelected) => _ChoiceChip(
              item: item,
              isSelected: isSelected ?? false,
            ),
          ),
          if (isLoading) const _LoadingProgress(),
        ],
      ),
    );
  }

  _filterListThemeData(BuildContext context) {
    return FilterListThemeData.raw(
      borderRadius: 0,
      wrapAlignment: WrapAlignment.start,
      wrapCrossAxisAlignment: WrapCrossAlignment.start,
      wrapSpacing: 0,
      backgroundColor: Colors.white,
      headerTheme: const HeaderThemeData(
        searchFieldHintText: "Buscar",
        searchFieldTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        searchFieldHintTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
      ),
      choiceChipTheme: const ChoiceChipThemeData(),
      controlBarButtonTheme: ControlButtonBarThemeData.raw(
        backgroundColor: ColorManager.magenta,
        height: 56,
        buttonSpacing: 8,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 16, left: 0, right: 0, top: 0),
        controlButtonTheme: ControlButtonThemeData(
          backgroundColor: Colors.white,
          borderRadius: 8,
          textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
              ),
          primaryButtonTextStyle:
              Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
          primaryButtonBackgroundColor: ColorManager.brightYellow,
        ),
        controlContainerDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: ColorManager.blueOuterSpaceTint1
          )
          // boxShadow: const [
          //   BoxShadow(
          //     color: ColorManager.blueOuterSpace,
          //     spreadRadius: -2,
          //     blurRadius: 2,
          //     blurStyle: BlurStyle.normal,
          //     offset: Offset(0, 1),
          //   ),
          // ],
        ),
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  final Category item;
  final bool isSelected;
  const _ChoiceChip({
    required this.item,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color:
            isSelected ? ColorManager.brightYellowTint2 : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        item.name,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: isSelected
                  ? ColorManager.brightYellowShade2
                  : ColorManager.blueOuterSpace,
            ),
      ),
    );
  }
}

final selectedFiltersProvider =
    StateProvider<Map<int, List<Category>>>((ref) => {});

class _LoadingProgress extends StatelessWidget {
  const _LoadingProgress();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LinearProgressIndicator(
          color: ColorManager.colorSeed,
          backgroundColor: Colors.white,
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/puebly-loader.gif',
                width: double.infinity,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

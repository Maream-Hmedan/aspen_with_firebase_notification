import 'package:aspen_project/configuration/app_images.dart';
import 'package:aspen_project/model/popular_model.dart';
import 'package:aspen_project/model/recommended_model.dart';
import 'package:aspen_project/screens/details/place_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:sizer/sizer.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final List<TabModel> _tab = [];
  List<Popular> _popularLocation = [];
  List<Recommended> _recommendedLocation = [];
  List<Popular> _popularData = [];
  List<Recommended> _recommendedData = [];
  final List _searchResult = ["aa"];

  @override
  void initState() {
    _fillPopularLocation();
    _fillRecommendedLocation();
    _fillTab();
    _popularData = List.of(_popularLocation);
    _recommendedData = List.of(_recommendedLocation);
    super.initState();
  }

  int current = 0;
  PageController pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 85.h,
      child: Column(
        children: [
          SizedBox(
            width: 90.w,
            height: 60,
            child: TextFormField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onEditingComplete: () {
                FocusManager.instance.primaryFocus!.unfocus();
              },
              onChanged: (v) {
                _searchResult.add("aa");
                _recommendedLocation = List.of(_recommendedData);
                _popularLocation = List.of(_popularData);
                if (v.isNotEmpty) {
                  _searchResult.clear();
                  _searchResult.addAll(_popularLocation = _popularLocation
                      .where((element) =>
                          element.name.toLowerCase().contains(v.toLowerCase()))
                      .toList());
                  _searchResult.addAll(_recommendedLocation =
                      _recommendedLocation
                          .where((element) => element.name
                              .toLowerCase()
                              .contains(v.toLowerCase()))
                          .toList());
                }
                _tab.clear();
                _fillTab();
                setState(() {});
              },
              decoration: InputDecoration(
                filled: true,
                fillColor:Theme.of(context).colorScheme.onPrimaryContainer,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xffB8B8B8),
                  size: 25,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none),
                hintText: "Find things to do",
                hintStyle:
                    const TextStyle(color: Color(0xffB8B8B8), fontSize: 13),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 60,
            margin: const EdgeInsets.only(left: 15),
            padding: const EdgeInsets.only(top: 9),
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _tab.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      _changeTab(index);
                    },
                    child: _tab[index].isSelected
                        ? Container(
                            width: 89,
                            height: 41,
                            decoration: BoxDecoration(
                                color:  Theme.of(context).colorScheme.onPrimaryContainer,
                                borderRadius: BorderRadius.circular(32)),
                            child: Center(
                              child: Text(
                                _tab[index].name,
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff176FF2)),
                              ),
                            ),
                          )
                        : Container(
                            width: 89,
                            height: 41,
                            decoration: const BoxDecoration(
                              color: null,
                              borderRadius: null,
                            ),
                            child: Center(
                              child: Text(
                                _tab[index].name,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xffB8B8B8),
                                ),
                              ),
                            ),
                          ),
                  );
                }),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: _searchResult.isNotEmpty
                ? _tab.firstWhere((element) => element.isSelected).view
                : Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        Text(
                          "No matching results",
                          style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _fillPopularLocation() {
    _popularLocation.addAll(
      [
        Popular(
          image: alleyPalacePopular,
          name: "Alley Palace",
          rate: "4.1",
          description: 'Aspen is as close as one can get to'
              ' a storybook alpine town in America. The '
              'choose-your-own-adventure possibilities—skiing, hiking, dining shopping and ....',
          id: 'Alley_Palace',
        ),
        Popular(
          image: coeurdesAlpesPopular,
          name: "Coeurdes Alpes",
          rate: "4.5",
          description: 'Coeurdes Alpes is as close as one '
              'can get to a storybook alpine town in America. The choose-your-own-adventure'
              ' possibilities—skiing, hiking, dining shopping.',
          id: 'Coeurdes_Alpes',
        ),
      ],
    );
  }

  void _fillRecommendedLocation() {
    _recommendedLocation.addAll([
      Recommended(
          image: alleyPalaceRecommend, name: "Alley Palace", rate: "4N/5D"),
      Recommended(
          image: coeurdesAlpesRecommend, name: "Coeurdes Alpes", rate: "2N/3D"),
    ]);
  }

  void _fillTab() {
    _tab.addAll([
      TabModel(name: ' Location', isSelected: true, view: _locationView()),
      TabModel(
          name: ' Hotels',
          view: const Center(
            child: Icon(Icons.hotel),
          )),
      TabModel(
          name: ' Food',
          view: const Center(
            child: Icon(
              Icons.apple_sharp,
            ),
          )),
      TabModel(
          name: 'Adventure',
          view: const Center(
            child: Icon(Icons.skateboarding_rounded),
          )),
      TabModel(
          name: 'Activity',
          view: const Center(
            child: Icon(Icons.local_activity),
          )),
      TabModel(
          name: 'Profile',
          view: const Center(
            child: Icon(Icons.person),
          )),
    ]);
  }

  Column _locationView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Popular",
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0XFF232323))),
              Text(
                "See all",
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff176FF2)),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30.h,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: _popularLocation.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, int index) {
              final popular = _popularLocation[index];
              return GestureDetector(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: PlaceDetailsScreen(
                      model: popular,
                    ),
                    withNavBar: false,
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      width: 45.w,
                      height: 28.h,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        image: DecorationImage(
                            image: AssetImage(popular.image),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      top: 18.h,
                      left: 30,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        height: 5.h,
                        decoration: const BoxDecoration(
                          color: Color(0XFF4D5652),
                          borderRadius: BorderRadius.all(Radius.circular(59)),
                        ),
                        child: Center(
                          child: Text(popular.name,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 24.h,
                      left: 30,
                      child: Container(
                        width: 52,
                        height: 3.h,
                        decoration: const BoxDecoration(
                          color: Color(0XFF4D5652),
                          borderRadius: BorderRadius.all(Radius.circular(59)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.star,
                                color: Color(0XFFF8D675), size: 16),
                            Text(
                              popular.rate,
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 24.h,
                      right: 30,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffB8B8B8),
                              spreadRadius: 0,
                              blurRadius: 19,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.favorite,
                            size: 17, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 10),
          child: Text("Recommended",
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0XFF232323))),
        ),
        SizedBox(
          height: 21.h,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: _recommendedLocation.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, int index) {
              final recommend = _recommendedLocation[index];
              return Container(
                width: 44.w,
                margin: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 5, top: 5),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.secondary,
                      spreadRadius: 0,
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xffF4F4F4),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(recommend.image, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 13.h,
                      left: 20,
                      right: 20,
                      child: Center(
                        child: Text(
                          recommend.name,
                          style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0XFF232323)),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10.h,
                      right: 13,
                      child: Container(
                        width: 20.w,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0XFF4D5652),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(59),
                          ),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            recommend.rate,
                            style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0XFFFFFFFF)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _changeTab(int index) {
    for (var element in _tab) {
      element.isSelected = false;
    }
    _tab[index].isSelected = true;
    setState(() {});
  }
}

class TabModel {
  String name;
  bool isSelected;
  Widget view;

  TabModel({required this.name, this.isSelected = false, required this.view});
}

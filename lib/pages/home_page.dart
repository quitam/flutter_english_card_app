import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:learn_english_app/models/english_today.dart';
import 'package:learn_english_app/packages/quote/quote.dart';
import 'package:learn_english_app/packages/quote/quote_model.dart';
import 'package:learn_english_app/pages/control_page.dart';
import 'package:learn_english_app/values/shared_pref.dart';
import 'package:learn_english_app/widgets/toast.dart';
import 'package:learn_english_app/values/app_assets.dart';
import 'package:learn_english_app/values/app_colors.dart';
import 'package:learn_english_app/values/app_styles.dart';
import 'package:learn_english_app/widgets/app_button.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //get current index of page view
  int _currentIndex = 0;

  //page controller
  late PageController _pageController;

  List<EnglishToday> words = [];
  String topQuote = Quotes().getRandom().content!;

  List<int> fixedListRandom({int len = 1, int max = 120, int min = 1}) {
    if (len > max || len < min) {
      return [];
    }
    List<int> newList = [];
    Random random = Random();
    int count = 1;
    while (count <= len) {
      int val = random.nextInt(max);
      if (newList.contains(val)) {
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  getEnglishToday() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int len = sharedPreferences.getInt(SharedPref.word) ?? 5;

    List<String> newList = [];
    List<int> rans = fixedListRandom(len: len, max: nouns.length);

    for (var index in rans) {
      newList.add(nouns[index]);
    }

    setState(() {
      words = newList.map((e) => getQuote(e)).toList();
    });
  }

  EnglishToday getQuote(String noun) {
    Quote? quote;
    quote = Quotes().getByWord(noun);
    return EnglishToday(
        noun: noun,
        quote: quote?.content,
        id: quote?.id,
        author: quote?.author);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9);
    super.initState();
    getEnglishToday();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondColor,
        //remove bottom line of app bar
        elevation: 0,
        title: Text(
          'English today',
          style:
              AppStyles.h3.copyWith(color: AppColors.textColor, fontSize: 36),
        ),
        leading: InkWell(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Image.asset(AppAssets.menu),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(children: [
          Container(
            height: size.height * 1.2 / 10,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(24),
            child: Text(
              '"$topQuote"',
              style: AppStyles.h5
                  .copyWith(color: AppColors.textColor, fontSize: 16),
            ),
          ),
          SizedBox(
            height: size.height * 2 / 3,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                //set index of indicator when pageview index change
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: words.length,
              itemBuilder: (context, index) {
                //get first letter of word
                String firstLetter = words[index].noun!.substring(0, 1);

                //get remaining letter
                String remainingLetter =
                    words[index].noun!.substring(1, words[index].noun!.length);

                String quoteDefault =
                    'Think of all the beauty still left around you and be happy.';

                //if quote is null, return default quote
                String quote = words[index].quote != null
                    ? words[index].quote!
                    : quoteDefault;

                String authorDefault = 'Anne Frank';
                String quoteAuthor = words[index].author != null
                    ? words[index].author!
                    : authorDefault;

                //Card
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    color: AppColors.primaryColor,
                    elevation: 6,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      splashColor: Colors.transparent,
                      onDoubleTap: () {
                        setState(() {
                          words[index].isFavorite = !words[index].isFavorite;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //heart icon
                            LikeButton(
                              onTap: (bool isLiked) async {
                                setState(() {
                                  words[index].isFavorite =
                                      !words[index].isFavorite;
                                });
                                return words[index].isFavorite;
                              },
                              isLiked: words[index].isFavorite,
                              mainAxisAlignment: MainAxisAlignment.end,
                              size: 42,
                              circleColor: const CircleColor(
                                  start: Color(0xffff0000),
                                  end: Color(0xffffcbd1)),
                              bubblesColor: const BubblesColor(
                                dotPrimaryColor: Color(0xffff0000),
                                dotSecondaryColor: Color(0xffffcbd1),
                              ),
                              likeBuilder: (bool isLiked) {
                                return ImageIcon(
                                  const AssetImage(AppAssets.heart),
                                  color: isLiked ? Colors.red : Colors.white,
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: RichText(
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                        style: AppStyles.h3.copyWith(
                                            fontSize: 96,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              const BoxShadow(
                                                  color: AppColors.lightGray,
                                                  offset: Offset(6, 8),
                                                  blurRadius: 8)
                                            ]),
                                        text: firstLetter.toUpperCase(),
                                        children: [
                                          TextSpan(
                                              text:
                                                  remainingLetter.toLowerCase(),
                                              style: AppStyles.h3
                                                  .copyWith(fontSize: 64))
                                        ])),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: SizedBox(
                                height: size.height * 0.3,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(
                                    '"$quote"',
                                    style: AppStyles.h3.copyWith(
                                        fontSize: 28,
                                        color: AppColors.textColor,
                                        letterSpacing: 1),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '__${quoteAuthor}__',
                                    style: AppStyles.h5.copyWith(
                                        color: AppColors.black,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 18),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          //Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 14),
              height: 10,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) =>
                    buildIndicator(index == _currentIndex, size),
              ),
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          setState(() {
            getEnglishToday();
          });
          toast('Successfully!!!');
        },
        child: Image.asset(AppAssets.exchange),
      ),

      // DRAWER
      drawer: Drawer(
          child: Container(
        color: AppColors.lightBlue,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 22),
            child: Text(
              'Your mind',
              style: AppStyles.h3
                  .copyWith(fontSize: 36, color: AppColors.textColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: AppButton(
              label: 'Favorites',
              onTap: () {
                // ignore: avoid_print
                print('Favorites');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: AppButton(
              label: 'Your control',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ControlPage(),
                    ));
              },
            ),
          )
        ]),
      )),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
        margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
        width: isActive ? size.width * 0.3 : size.width * 0.1,
        decoration: BoxDecoration(
            color: isActive ? AppColors.lightBlue : AppColors.lightGray,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black38, offset: Offset(2, 3), blurRadius: 3),
            ]));
  }
}

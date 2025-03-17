import 'package:blood_pressure/data/repositories/profile_repository.dart';
import 'package:blood_pressure/presentation/home/home_page.dart';
import 'package:blood_pressure/presentation/profiles/add_profile_screen.dart';
import 'package:blood_pressure/presentation/profiles/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  final VoidCallback onProfileAdded;
  const WelcomeScreen({super.key, required this.onProfileAdded});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenStage();
}

class _WelcomeScreenStage extends State<WelcomeScreen> {
  var selectedIndex = 0;
  static const int lastPageIndex = 3;

  final _controller = PageController();

  _onPageViewChange(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final profileRepository = ProfileRepository();

    return BlocProvider(
        create: (context) => ProfileBloc(profileRepository),
        child: Scaffold(body:
            BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
          return (Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SafeArea(
                  child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: selectedIndex != lastPageIndex
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                final profileBloc =
                                    BlocProvider.of<ProfileBloc>(context);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (newContext) => BlocProvider.value(
                                        value: profileBloc,
                                        child: const AddProfile())
                                )
                                ).then((_){
                                  widget.onProfileAdded();
                                });
                                },
                              child: const Text(
                                'Skip',
                              )),
                        ],
                      )
                    : const SizedBox(),
              )),
              SizedBox(
                height: size.height * 0.7,
                child: PageView(
                  controller: _controller,
                  onPageChanged: _onPageViewChange,
                  children: [
                    OnBoardingPage(
                      size: size,
                      title: 'Welcome to the Blood Pressure Monitor',
                      description:
                          'Record, analyze & track your blood pressure like never before',
                      imageUrl: 'assets/images/welcome_screen_1.jpg',
                    ),
                    OnBoardingPage(
                      size: size,
                      title: 'Manage Your Data and Track Your Progress',
                      description:
                          'Keep track of your blood pressure to ensure a healthy lifestyle',
                      imageUrl: 'assets/images/welcome_screen_2.jpg',
                    ),
                    OnBoardingPage(
                      size: size,
                      title: 'Share Analytics with Doctor from Your Phone',
                      description:
                          'Share your blood pressure with your doctor with just a few taps',
                      imageUrl: 'assets/images/welcome_screen_1.jpg',
                    ),
                    OnBoardingPage(
                      size: size,
                      title: 'Access Everything for Free of Cost',
                      description:
                          'We care your wellbeing. Enjoy the app for free. No Ads, No Subscription',
                      imageUrl: 'assets/images/welcome_screen_2.jpg',
                    ),
                  ],
                ),
              ),
              selectedIndex == lastPageIndex
                  ? ElevatedButton(
                      onPressed: () {
                        final profileBloc =
                            BlocProvider.of<ProfileBloc>(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (newContext) => BlocProvider.value(
                                value: profileBloc,
                                child: const AddProfile()))
                        ).then((_){
                          widget.onProfileAdded();
                        });
                      },
                      style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.deepPurple)),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : SmoothPageIndicator(
                      controller: _controller,
                      count: 4,
                      effect: ExpandingDotsEffect(
                          activeDotColor: Colors.deepPurple,
                          dotColor: Colors.deepPurple.shade100,
                          dotHeight: 10,
                          dotWidth: 10,
                          expansionFactor: 3),
                    ),
              const SizedBox(
                height: 30.0,
              )
            ],
          ));
        })));
  }
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage(
      {super.key,
      required this.size,
      required this.title,
      required this.description,
      required this.imageUrl});

  final Size size;
  final String title;
  final String description;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(
            image: AssetImage(imageUrl),
            height: size.height * 0.4,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              Text(
                description,
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ],
      ),
    );
  }
}

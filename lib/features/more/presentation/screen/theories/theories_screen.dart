import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/routes/app_router.dart';
import '../../../../../core/constants/endpoints.dart';
import '../../../../../core/constants/app_theme.dart';

@RoutePage(name: 'TheoriesRouter')
class TheoriesRouterScreen extends AutoRouter {}

@RoutePage()
class TheoriesScreen extends StatelessWidget {
  const TheoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBG,
      appBar: AppBar(
        backgroundColor: AppColor.lightBG,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.router.pop();
          },
          icon: RotatedBox(quarterTurns: 2, child: SvgPicture.asset('assets/icons/arrow.svg')),
        ),
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: 'Теория к курсу и',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColor.blk),
              children: const [
                TextSpan(
                  text: '\nформы документов',
                ),
              ]),
        ),
      ),
      body: FutureBuilder(
          future: getAllTheoryPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List theories = snapshot.data['theories'];

              return ListView.builder(
                  itemCount: theories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: index == 0
                          ? const EdgeInsets.only(right: 20, left: 20, top: 25, bottom: 15)
                          : const EdgeInsets.only(right: 20, left: 20, bottom: 15),
                      child: InkWell(
                        onTap: () {
                          context.router
                              .push(TheoryPostScreenRoute(postId: theories[index]['id'], data: theories[index]));
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                                decoration: AppLayout.boxDecorationShadowBG,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        theories[index]['title'],
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(color: AppColor.accent, shape: BoxShape.circle),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          'assets/icons/arrow.svg',
                                          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

Future getAllTheoryPosts() async {
  final dio = Dio();

  Response response = await dio.get('${Endpoints.baseUrl}${Endpoints.allTheoryPosts}');

  return response.data;
}

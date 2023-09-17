import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_theme.dart';

final Uri _googlePlayService = Uri.parse('https://policies.google.com/privacy?hl=ru');

// Future<void> _launchGooglePlayService() async {
//   if (!await launchUrl(_googlePlayService)) {
//     throw Exception('Could not launch $_googlePlayService');
//   }
// }

@RoutePage()
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text(
          'Политики конфидециальности',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          decoration: const BoxDecoration(color: Colors.white),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 15),
              const Text(
                'Максим Киктенко built the "Развитие воли и самоорганизации" app. This SERVICE is provided by Максим Киктенко and is intended for use as is. This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                'If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that | collect is used for providing and improving the Service. | will not use or share your information with anyone except as described in this Privacy Policy.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                'The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at "Развитие воли и самоорганизации" unless otherwise defined in this Privacy Policy.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                'Information Collection and Use',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                'For a better experience, while using our Service, | may require you to provide us with certain personally identifiable information, including but not limited to phone number.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                'The information that | request will be retained on your device and is not collected by me in any way. The app does use third-party services that may collect information used to identify you.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                'Link to the privacy policy of third-party service providers used by the app',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              // const SizedBox(height: 15),
              // GestureDetector(
              //   onTap: _launchGooglePlayService,
              //   child: Text(
              //     'Google Play Services',
              //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColor.primary),
              //   ),
              // ),
              const SizedBox(height: 15),
              Link(
                uri: _googlePlayService,
                target: LinkTarget.blank,
                builder: (context, openLink) => TextButton(
                    onPressed: openLink,
                    child: Text(
                      'Google Play Services',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColor.primary),
                    )),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionText extends StatelessWidget {
  final String font;

  const TermsAndConditionText({super.key, required this.font});

  final String termsUrl =
      "https://www.nammadaiva.com/terms-and-conditions";
  final String privacyUrl =
      "https://www.nammadaiva.com/privacy-policy";

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: font),
          children: [
            const TextSpan(text: "I agree to the "),
            TextSpan(
              text: "Terms & Conditions",
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _launchUrl(termsUrl),
            ),
            const TextSpan(text: " and "),
            TextSpan(
              text: "Privacy Policy",
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _launchUrl(privacyUrl),
            ),
          ],
        ),
      ),
    );
  }
}

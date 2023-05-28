import 'dart:convert';

import 'package:converter_youtube/constants/padding.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

//Widgets
import '../widgets/build_snack_bar.dart';
import '../widgets/download_container.dart';
import '../widgets/input_field.dart';

enum MenuItem { quality360, quality720 }

class VideoLinkPage extends StatefulWidget {
  const VideoLinkPage({Key? key}) : super(key: key);

  @override
  State<VideoLinkPage> createState() => _VideoLinkPageState();
}

class _VideoLinkPageState extends State<VideoLinkPage> {
  TextEditingController textController = new TextEditingController();
  String jsonsDataString = '';
  var jsonData;
  InterstitialAd? _interstitialAd;
  //18 = 360p, 22 = 720p is itag code

  Future<http.Response> callYoutubeICode() async {
    var url = Uri.parse(
        "https://youtube-video-download-info.p.rapidapi.com/dl?id=${textController.text.substring(17, 28)}");
    var response = await http.get(url, headers: {
      'X-RapidAPI-Key': '40ec6fbcfemshb5562115e05973bp18c723jsn175e4908806a',
      'X-RapidAPI-Host': 'youtube-video-download-info.p.rapidapi.com'
    });

    if (response.statusCode == 200) {
      setState(() {
        //liste kullanacaklar için dynamic değer alıyor
        //result['link'] dynamic bir değerdir
        jsonsDataString = response.body.toString();
        //burda jsonData değişkenine tüm verileri aktardık
        jsonData = jsonDecode(jsonsDataString);
      });
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: ProjectDecorations.allPadding,
          child: Column(
            children: [
              InputField(textController: textController),
              GestureDetector(
                onTap: () async {
                  if (textController.text.isEmpty ||
                      textController.text == ' ') {
                    BuildSnackBar(
                        context, 'No video url', Colors.red, Colors.white);
                  } else {
                    callYoutubeICode();
                    BuildSnackBar(
                        context,
                        'After the ad is closed, the download window will open..',
                        Colors.green,
                        Colors.white);

                    await lowDownload(context);
                  }
                },
                child: DownloadContainer(text: '360P Download',),
              ),
              GestureDetector(
                onTap: () async {
                  if (textController.text.isEmpty ||
                      textController.text == ' ') {
                    BuildSnackBar(
                        context, 'No video url', Colors.red, Colors.white);
                  } else {
                    callYoutubeICode();
                    BuildSnackBar(
                        context,
                        'After the ad is closed, the download window will open..',
                        Colors.green,
                        Colors.white);
                    await hdDownload(context);
                  }
                },
                child: DownloadContainer(text: '720P Download',),
              ),
            ],
          ),
        ),
      ),
    );
  }

  lowDownload(BuildContext context) async {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-8924173754312904/3034082248',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          this._interstitialAd = ad;
          _interstitialAd!.show();
          print('ad loaded');
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
                  onAdFailedToShowFullScreenContent: ((ad, error) {
            ad.dispose();
            _interstitialAd!.dispose();
          }), onAdDismissedFullScreenContent: (ad) async {
            ad.dispose();
            _interstitialAd!.dispose();
            if (await canLaunchUrl(Uri.parse(jsonData['link']['18'][0]))) {
              await launch(jsonData['link']['18'][0]);
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('There is a problem')));
            }
          });
        }, onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed ' + error.toString());
        }));
  }

  hdDownload(BuildContext context) async {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-8924173754312904/3034082248',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          this._interstitialAd = ad;
          _interstitialAd!.show();
          print('ad loaded');
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
                  onAdFailedToShowFullScreenContent: ((ad, error) {
            ad.dispose();
            _interstitialAd!.dispose();
          }), onAdDismissedFullScreenContent: (ad) async {
            ad.dispose();
            _interstitialAd!.dispose();
            if (await canLaunchUrl(Uri.parse(jsonData['link']['22'][0]))) {
              await launch(jsonData['link']['22'][0]);
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('There is a problem')));
            }
          });
        }, onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed ' + error.toString());
        }));
  }
}

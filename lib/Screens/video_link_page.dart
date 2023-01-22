import 'dart:convert';

import 'package:converter_youtube/constants/padding.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

enum MenuItem { quality360, quality720 }

class VideoLinkPage extends StatefulWidget {
  const VideoLinkPage({Key? key}) : super(key: key);

  @override
  State<VideoLinkPage> createState() => _VideoLinkPageState();
}

class _VideoLinkPageState extends State<VideoLinkPage> {
  TextEditingController _textController = new TextEditingController();
  String jsonsDataString = '';
  var jsonData;
  InterstitialAd? _interstitialAd;
  //18, 22 is Youtube quality itag code

  Future<http.Response> callICode18() async {
    var url = Uri.parse(
        "https://youtube-video-download-info.p.rapidapi.com/dl?id=${_textController.text.substring(17, 28)}");
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

  Future<http.Response> callICode22() async {
    var url = Uri.parse(
        "https://youtube-video-download-info.p.rapidapi.com/dl?id=${_textController.text.substring(17, 28)}");
    var response = await http.get(url, headers: {
      'X-RapidAPI-Key': '40ec6fbcfemshb5562115e05973bp18c723jsn175e4908806a',
      'X-RapidAPI-Host': 'youtube-video-download-info.p.rapidapi.com'
    });

    if (response.statusCode == 200) {
      setState(() {
        jsonsDataString = response.body.toString();
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
              _inputFields(),
              GestureDetector(
                onTap: () async {
                  if (_textController.text.isEmpty ||
                      _textController.text == ' ') {
                    buildShowSnackBar(context,'No video url',Colors.red,Colors.white);

                  } else {
                    callICode18();
                    buildShowSnackBar(context,'After the ad is closed, the download window will open..',Colors.green,Colors.white);

                    await LaunchUrlDwnload18(context);
                  }
                },
                child: Quality360DownloadContainer(context),
              ),
              GestureDetector(
                onTap: () async {
                  if (_textController.text.isEmpty ||
                      _textController.text == ' ') {
                    buildShowSnackBar(context,'No video url',Colors.red,Colors.white);
                  } else {
                    callICode22();
                    buildShowSnackBar(context,'After the ad is closed, the download window will open..',Colors.green,Colors.white);
                    await LaunchUrlDwnload22(context);
                  }
                },
                child: VideoDownloadContainer(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LaunchUrlDwnload18(BuildContext context) async {
    InterstitialAd.load(
                      adUnitId: 'ca-app-pub-8924173754312904/3034082248',
                      request: AdRequest(),
                      adLoadCallback: InterstitialAdLoadCallback(
                          onAdLoaded: (ad){
                            this._interstitialAd = ad;
                            _interstitialAd!.show();
                            print('ad loaded');
                            _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
                                onAdFailedToShowFullScreenContent: ((ad, error){
                                  ad.dispose();
                                  _interstitialAd!.dispose();
                                }),
                                onAdDismissedFullScreenContent: (ad) async {
                                  ad.dispose();
                                  _interstitialAd!.dispose();
                                  if (await canLaunchUrl(
                                  Uri.parse(jsonData['link']['18'][0]))) {
                                  await launch(jsonData['link']['18'][0]);
                                  } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('There is a problem')));
                                  }
                                }
                            );
                          }, onAdFailedToLoad: (LoadAdError error){
                        print('InterstitialAd failed '+error.toString());
                      }));
  }

  Container Quality360DownloadContainer(BuildContext context) {
    return Container(
                color: Colors.red,
                margin: ProjectDecorations.onlyTopPadding,
                width: MediaQuery.of(context).size.width,
                padding: ProjectDecorations.allPadding,
                alignment: Alignment.center,
                child: Text(
                  "360p Download",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color:Colors.white),
                ),
              );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildShowSnackBar(
      BuildContext context, String msg, Color bgColor, Color textColor) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg,style: Theme.of(context).textTheme.bodyText1?.copyWith(color: textColor)),backgroundColor: bgColor,));
  }
  Container VideoDownloadContainer(BuildContext context) {
    return Container(
                color: Colors.red,
                margin: ProjectDecorations.onlyTopPadding,
                width: MediaQuery.of(context).size.width,
                padding: ProjectDecorations.allPadding,
                alignment: Alignment.center,
                child: Text(
                  "720p Download",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
              );
  }

  LaunchUrlDwnload22(BuildContext context) async {
    InterstitialAd.load(
                      adUnitId: 'ca-app-pub-8924173754312904/3034082248',
                      request: AdRequest(),
                      adLoadCallback: InterstitialAdLoadCallback(
                          onAdLoaded: (ad){
                            this._interstitialAd = ad;
                            _interstitialAd!.show();
                            print('ad loaded');
                            _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
                                onAdFailedToShowFullScreenContent: ((ad, error){
                                  ad.dispose();
                                  _interstitialAd!.dispose();
                                }),
                                onAdDismissedFullScreenContent: (ad) async {
                                  ad.dispose();
                                  _interstitialAd!.dispose();
                                  if (await canLaunchUrl(
                                      Uri.parse(jsonData['link']['22'][0]))) {
                                    await launch(jsonData['link']['22'][0]);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('There is a problem')));
                                  }
                                }
                            );
                          }, onAdFailedToLoad: (LoadAdError error){
                        print('InterstitialAd failed '+error.toString());
                      }));
  }

  Padding _inputFields() {
    return Padding(
      padding: ProjectDecorations.symetricPadding,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: Colors.red,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
              ),
              controller: _textController,
            ),
          ),
        ],
      ),
    );
  }
}

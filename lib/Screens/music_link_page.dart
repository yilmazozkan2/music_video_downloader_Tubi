import 'dart:convert';
import 'package:converter_youtube/constants/padding.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MusicLinkPage extends StatefulWidget {
  const MusicLinkPage({Key? key}) : super(key: key);

  @override
  State<MusicLinkPage> createState() => _MusicLinkPageState();
}

class _MusicLinkPageState extends State<MusicLinkPage> {
  TextEditingController _textController = new TextEditingController();
  String title = '';
  List link = [];
  String jsonsDataString = '';
  var jsonData;
  InterstitialAd? _interstitialAd;

  // RAPIDAPI CONNECTİON
  Future<http.Response> fetchapi() async {
    var url = Uri.parse(
        "https://youtube-mp3-download1.p.rapidapi.com/dl?id=${_textController.text.substring(17, 28)}");
    var response = await http.get(url, headers: {
      'X-RapidAPI-Key': '40ec6fbcfemshb5562115e05973bp18c723jsn175e4908806a',
      'X-RapidAPI-Host': 'youtube-mp3-download1.p.rapidapi.com'
    });

    if (response.statusCode == 200) {
      setState(() {
        final result = jsonDecode(response.body);
        //liste dynamic değer alıyor
        //result['link'] dynamic bir değer
        link.add(result['link']);
        print(link);
      });
    }
    //gelen verileri gör
    print(response.body);
    //gelen verileri kullan
    jsonsDataString = response.body.toString();
    jsonData = jsonDecode(jsonsDataString);
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
                    buildShowSnackBar(context,'No music url',Colors.red, Colors.white);
                  } else {
                    fetchapi();
                    await LoadInterstitialAd(context);
                    buildShowSnackBar(context, 'After the ad is closed, the download window will open..', Colors.green, Colors.white);
                  }
                },
                child: MusicDownloadContainer(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildShowSnackBar(
      BuildContext context, String msg, Color bgColor, Color textColor) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg,style: Theme.of(context).textTheme.bodyText1?.copyWith(color: textColor)),backgroundColor: bgColor,));
  }

  LoadInterstitialAd(BuildContext context) async {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-8924173754312904/3034082248',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              this._interstitialAd = ad;
              _interstitialAd!.show();
              _interstitialAd!.fullScreenContentCallback =
                  FullScreenContentCallback(
                      onAdFailedToShowFullScreenContent: ((ad, error) {
                ad.dispose();
                _interstitialAd!.dispose();
              }), onAdDismissedFullScreenContent: (ad) async {
                ad.dispose();
                _interstitialAd!.dispose();
                if (await canLaunchUrl(Uri.parse(jsonData['link']))) {
                  await launch(jsonData['link']);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('There is a problem')));
                }
              });
            },
            onAdFailedToLoad: (LoadAdError error) {}));
  }

  Container MusicDownloadContainer(BuildContext context) {
    return Container(
      color: Colors.red,
      margin: ProjectDecorations.onlyTopPadding,
      width: MediaQuery.of(context).size.width,
      padding: ProjectDecorations.allPadding,
      alignment: Alignment.center,
      child: Text(
        "Mp3 Download",
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
    );
  }

  Padding _inputFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
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

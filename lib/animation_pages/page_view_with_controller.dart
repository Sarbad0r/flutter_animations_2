import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_animations_2/models/product.dart';

class PageViewWithController extends StatefulWidget {
  const PageViewWithController({Key? key}) : super(key: key);

  @override
  State<PageViewWithController> createState() => _PageViewWithControllerState();
}

class _PageViewWithControllerState extends State<PageViewWithController> {
  List<String> pictureAssets = [
    'assets/images/ice_cream.jpg',
    'assets/images/mister_bean.jpg',
    'assets/images/nuka_cola.jpg'
  ];

  late PageController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller =
        PageController(initialPage: 0, viewportFraction: 0.5, keepPage: true);

    Product newP = Product(id: 1, price: 15, name: "Apple", pack_qty: 15);

    newP.qty = 1.2;

    debugPrint("get qty: ${newP.getFromDouble()}");
  }

  int initialPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          height: 200,
          child: PageView.builder(
              controller: controller,
              itemCount: pictureAssets.length,
              onPageChanged: (v) => setState(() {
                    initialPage = v;
                  }),
              itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: rotateImage(index))))
    ]);
  }

  Widget rotateImage(int index) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          double value = 0;
          double _scale = initialPage == index ? 1 : 0.8;
          if (controller.position.haveDimensions) {
            value = index - (controller.page ?? 0);

            //clamp for doing animation to that index for exmaple,
            //you are in 0 index animate with work (-1 left index, zero is your index, 1 right index)
            value = (value * 0.040).clamp(-1, 1);
          }
          return Transform.rotate(
              //for rotating transform.rotate
              angle: math.pi * value,
              child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: _scale, end: _scale),
                  duration: const Duration(milliseconds: 75),
                  child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 275),
                      opacity: initialPage == index ? 1 : 0.4,
                      child:
                          Image.asset(pictureAssets[index], fit: BoxFit.cover)),
                  builder: (BuildContext context, value, Widget? child) {
                    return Transform.scale(scale: value, child: child);
                  }));
        });
  }
}

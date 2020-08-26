import 'package:flutter/material.dart';

class Ipod extends StatefulWidget {
  @override
  _IpodState createState() => _IpodState();
}

class _IpodState extends State<Ipod> {
  final PageController _pageController = PageController(viewportFraction: .6);
  double currentPage = 0.0;

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white38,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 300,
              color: Colors.black,
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return AlbumCard(
                        color: Colors.accents[index],
                        currentIndex: index,
                        currentPage: currentPage);
                  }),
            ),
            Spacer(),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onPanUpdate: _panHandler,
                    child: Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black),
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            alignment: Alignment.topCenter,
                            child: Text(
                              "MENU",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.only(bottom: 30),
                            child: IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.pause),
                              iconSize: 32,
                              onPressed: () {},
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(right: 30),
                            child: IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.fast_forward),
                                iconSize: 32,
                                onPressed: () => _pageController.animateToPage(
                                    (_pageController.page + 1).toInt(),
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn)),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 30),
                            child: IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.fast_rewind),
                                iconSize: 32,
                                onPressed: () => _pageController.animateToPage(
                                    (_pageController.page - 1).toInt(),
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white38),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _panHandler(DragUpdateDetails details) {
    double radius = 150;
    bool onTop = details.localPosition.dy <= radius;
    bool onLeftSide = details.localPosition.dx <= radius;

    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    bool panUp = details.delta.dy <= 0;
    bool panLeft = details.delta.dx <= 0;

    bool panRight = !panLeft;
    bool panDown = !panUp;

    double yChange = details.delta.dy.abs();
    double xChange = details.delta.dx.abs();

    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;

    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

    double rotationalChange =
        (verticalRotation + horizontalRotation) * (details.delta.distance * .2);

    _pageController.jumpTo(_pageController.offset + rotationalChange);
  }
}

class AlbumCard extends StatelessWidget {
  final Color color;
  final currentIndex;
  final currentPage;

  const AlbumCard({Key key, this.color, this.currentIndex, this.currentPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //left side if -ve , right side if +ve
    double relativePosition = currentIndex - currentPage;
    return Container(
      width: 250,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.003)
          ..scale((1 - relativePosition.abs()).clamp(.2, .6) + .4)
          ..rotateY(relativePosition),
        alignment: relativePosition >= 0
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Container(
            margin: EdgeInsets.only(top: 20, bottom: 20, left: 5, right: 5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(12)
                // image: DecorationImage(image: AssetImage("")),
                )),
      ),
    );
  }
}

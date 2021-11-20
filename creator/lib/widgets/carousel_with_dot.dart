import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselWithDotsPage extends StatefulWidget {
  List<String> imgList;
  CarouselWithDotsPage({this.imgList, Key key}) : super(key: key);

  @override
  _CarouselWithDotsPageState createState() => _CarouselWithDotsPageState();
}

class _CarouselWithDotsPageState extends State<CarouselWithDotsPage> {
  int _current = 0;

  Widget _bottomTextOfCarousel(String item) {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Container(
        decoration: _buildCarouselTextDecoration(),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Text(
          'No. ${widget.imgList.indexOf(item)} image',
          style: Theme.of(context).textTheme.subtitle2.apply(
                color: Colors.white,
              ),
        ),
      ),
    );
  }

  BoxDecoration _buildCarouselTextDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromARGB(
            200,
            0,
            0,
            0,
          ),
          Color.fromARGB(
            0,
            0,
            0,
            0,
          ),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ),
    );
  }

  Widget _dotPageStateOfCarousel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.imgList.map((url) {
        int index = widget.imgList.indexOf(
          url,
        );
        return Container(
          width: 8,
          height: 8,
          margin: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 3,
          ),
          decoration: _buildCarouselDotDecoration(index),
        );
      }).toList(),
    );
  }

  BoxDecoration _buildCarouselDotDecoration(int index) {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: _current == index
          ? Color.fromRGBO(
              0,
              0,
              0,
              0.9,
            )
          : Color.fromRGBO(
              0,
              0,
              0,
              0.4,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.imgList
        .map(
          (item) => Container(
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
              child: Stack(
                children: [
                  Image.network(
                    item,
                    fit: BoxFit.cover,
                    width: 1000,
                  ),
                  _bottomTextOfCarousel(
                    item,
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();

    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(
                () {
                  _current = index;
                },
              );
            },
          ),
        ),
        _dotPageStateOfCarousel()
      ],
    );
  }
}

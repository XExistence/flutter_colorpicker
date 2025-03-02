/// Material Color Picker

library material_colorpicker;

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

// The Color Picker which contains Material Design Color Palette.
class MaterialPicker extends StatefulWidget {
  const MaterialPicker({
    Key? key,
    required this.pickerColor,
    required this.onColorChanged,
    this.onPrimaryChanged,
    this.enableLabel = false,
    this.portraitOnly = false,
  }) : super(key: key);

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final ValueChanged<Color>? onPrimaryChanged;
  final bool enableLabel;
  final bool portraitOnly;

  @override
  State<StatefulWidget> createState() => _MaterialPickerState();
}

class _MaterialPickerState extends State<MaterialPicker> {
  final List<List<Color>> _colorTypes = [
    [Colors.red],
    [Colors.pink],
    [Colors.purple],
    [Colors.deepPurple],
    [Colors.indigo],
    [Colors.blue],
    [Colors.lightBlue],
    [Colors.cyan],
    [Colors.teal],
    [Colors.green],
    [Colors.lightGreen],
    [Colors.lime],
    [Colors.yellow],
    [Colors.amber],
    [Colors.orange],
    [Colors.deepOrange],
    [Colors.brown],
    [Colors.grey],
    [Colors.blueGrey],
  ];

  List<Color> _currentColorType = [Colors.red, Colors.redAccent];
  Color _currentShading = Colors.transparent;

  List<Map<Color, String>> _shadingTypes(List<Color> colors) {
    List<Map<Color, String>> result = [];

    for (Color colorType in colors) {
      if (colorType is MaterialColor) {
        result.addAll([300, 400, 500, 600, 700, 800, 900]
            .map((int shade) => {colorType[shade]!: shade.toString()})
            .toList());
      }
    }

    return result;
  }

  Color _getLastShade(List<Color> colors) {
    List<Map<Color, String>> shades = _shadingTypes(colors);
    if (shades.isNotEmpty) {
      return shades.last.keys.first;
    }
    return colors[0];
  }

  @override
  void initState() {
    for (List<Color> _colors in _colorTypes) {
      _shadingTypes(_colors).forEach((Map<Color, String> color) {
        if (widget.pickerColor.value == color.keys.first.value) {
          return setState(() {
            _currentColorType = _colors;
            _currentShading = color.keys.first;
          });
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait ||
            widget.portraitOnly;

    Widget _colorList() {
      return Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(),
        child: Container(
          margin: _isPortrait
              ? const EdgeInsets.only(right: 0)
              : const EdgeInsets.only(bottom: 10),
          width: _isPortrait ? 60 : null,
          height: _isPortrait ? null : 60,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context)
                .copyWith(dragDevices: PointerDeviceKind.values.toSet()),
            child: ListView(
              scrollDirection: _isPortrait ? Axis.vertical : Axis.horizontal,
              children: [
                _isPortrait
                    ? const Padding(padding: EdgeInsets.only(top: 7))
                    : const Padding(padding: EdgeInsets.only(left: 7)),
                ..._colorTypes.map((List<Color> _colors) {
                  Color _colorType = _colors[0];
                  return GestureDetector(
                    onTap: () {
                      if (widget.onPrimaryChanged != null)
                        widget.onPrimaryChanged!(_colorType);
                      Color lastShade = _getLastShade(_colors);
                      setState(() {
                        _currentColorType = _colors;
                        _currentShading = lastShade;
                      });
                      widget.onColorChanged(lastShade);
                    },
                    child: Container(
                      color: const Color(0x00000000),
                      padding: _isPortrait
                          ? const EdgeInsets.fromLTRB(0, 7, 0, 7)
                          : const EdgeInsets.fromLTRB(7, 0, 7, 0),
                      child: Align(
                        child: Stack(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: _currentColorType == _colors ? 45 : 35,
                              height: _currentColorType == _colors ? 45 : 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: _colorType,
                                shape: BoxShape.rectangle,
                                border: _colorType ==
                                    Theme.of(context).cardColor
                                    ? Border.all(
                                    color: (Theme.of(context).brightness ==
                                        Brightness.light)
                                        ? Colors.grey[300]!
                                        : Colors.black38,
                                    width: 1)
                                    : null,
                              ),
                              child: _currentColorType == _colors
                                  ? Container(
                                // margin: const EdgeInsets.only(
                                //     right: 26, top: 5),
                                child: const Center(
                                  child: Icon(
                                    EvaIcons.checkmark,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                                  : Container(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                _isPortrait
                    ? const Padding(padding: EdgeInsets.only(top: 5))
                    : const Padding(padding: EdgeInsets.only(left: 5)),
              ],
            ),
          ),
        ),
      );
    }

    Widget _shadingList() {
      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context)
            .copyWith(dragDevices: PointerDeviceKind.values.toSet()),
        child: ListView(
          scrollDirection: _isPortrait ? Axis.vertical : Axis.horizontal,
          children: [
            _isPortrait
                ? const Padding(padding: EdgeInsets.only(top: 15))
                : const Padding(padding: EdgeInsets.only(left: 15)),
            ..._shadingTypes(_currentColorType).map((Map<Color, String> color) {
              final Color _color = color.keys.first;
              return GestureDetector(
                onTap: () {
                  setState(() => _currentShading = _color);
                  widget.onColorChanged(_color);
                },
                child: Container(
                  margin: _isPortrait
                      ? const EdgeInsets.only(right: 10, left: 10)
                      : const EdgeInsets.only(bottom: 10),
                  padding: _isPortrait
                      ? const EdgeInsets.fromLTRB(0, 7, 0, 7)
                      : const EdgeInsets.fromLTRB(7, 0, 7, 0),
                  child: Align(
                    child: AnimatedContainer(
                        curve: Curves.fastOutSlowIn,
                        duration: const Duration(milliseconds: 300),
                        width: _isPortrait
                            ? (_currentShading == _color ? 250 : 230)
                            : (_currentShading == _color ? 60 : 50),
                        height: _isPortrait ? 50 : 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _color,
                          border: (_color == Colors.white) ||
                              (_color == Colors.black)
                              ? Border.all(
                              color: (Theme.of(context).brightness ==
                                  Brightness.light)
                                  ? Colors.grey[300]!
                                  : Colors.black38,
                              width: 1)
                              : null,
                        ),
                        child: _currentShading == _color
                            ? Container(
                          child: Center(
                            child: Icon(
                              EvaIcons.checkmark,
                              color: useWhiteForeground(_color)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        )
                            : Container()),
                  ),
                ),
              );
            }),
            _isPortrait
                ? const Padding(padding: EdgeInsets.only(top: 15))
                : const Padding(padding: EdgeInsets.only(left: 15)),
          ],
        ),
      );
    }

    if (_isPortrait) {
      return SizedBox(
        width: 350,
        height: 500,
        child: Row(
          children: <Widget>[
            _colorList(),
            Expanded(
              child: Container(
                //padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _shadingList(),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: 500,
        height: 300,
        child: Column(
          children: <Widget>[
            _colorList(),
            Expanded(
              child: Container(
                //padding: const EdgeInsets.symmetric(vertical: 12),
                child: _shadingList(),
              ),
            ),
          ],
        ),
      );
    }
  }
}
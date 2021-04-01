import 'package:epilappsy/design/colors.dart';
import 'package:epilappsy/design/text_style.dart';
import 'package:flutter/material.dart';

class SymptomSlider extends StatelessWidget {
  final String label;
  final int sliderIndex;
  final Function onChanged;
  final ValueNotifier<List<double>> sliderValues;

  const SymptomSlider(
      {this.label, this.sliderIndex, this.onChanged, this.sliderValues});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        child: Text(
          '$label: ${sliderValues.value[sliderIndex].toInt()}',
          style: MyTextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.start
        ),),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: DefaultColors.accentColor.withAlpha(170),
            inactiveTrackColor: Colors.grey[200],
            trackShape: RoundedRectSliderTrackShape(),
            trackHeight: 4.0,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
            thumbColor: DefaultColors.accentColor,
            overlayColor: DefaultColors.accentColor.withAlpha(32),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            tickMarkShape: RoundSliderTickMarkShape(),
            activeTickMarkColor: Colors.white,
            inactiveTickMarkColor:  DefaultColors.mainColor,
            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: DefaultColors.accentColor,
            valueIndicatorTextStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          child: Slider(
              value: sliderValues.value[sliderIndex],
              min: 0,
              max: 100,
              divisions: 10,
              label: '${sliderValues.value[sliderIndex]}',
              onChanged: onChanged),
        )
      ],
    );
  }
}

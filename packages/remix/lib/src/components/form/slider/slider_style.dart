part of 'slider.dart';

class SliderStyle extends SpecStyle<SliderSpecUtility> {
  const SliderStyle();

  @override
  Style makeStyle(SpecConfiguration<SliderSpecUtility> spec) {
    final $ = spec.utilities;

    final divisions = $.division.chain
      ..shape.circle()
      ..color.black26()
      ..height(3)
      ..width(3);

    final thumb = $.thumb.chain
      ..shape.circle()
      ..color.white()
      ..height(20)
      ..width(20)
      ..shape.circle.side.width(2)
      ..shape.circle.side.color.black()
      ..shape.circle.side.style.solid()
      ..shape.circle.side.strokeAlign(BorderSide.strokeAlignInside);

    final track = $.track.chain
      ..color.grey.shade300()
      ..height(6)
      ..borderRadius.all(10);

    final activeTrack = $.activeTrack.chain
      ..color.black()
      ..height(6)
      ..borderRadius.all(10);

    final disabled = spec.on.disabled(
      $.activeTrack.color.grey.shade500(),
      $.thumb.shape.circle.side.color.grey.shade600(),
    );

    return Style.create([divisions, thumb, track, activeTrack, disabled])
        .animate(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }
}

class SliderDarkStyle extends SliderStyle {
  const SliderDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<SliderSpecUtility> spec) {
    final $ = spec.utilities;
    final activeTrack = $.activeTrack.color.white();

    final track = $.track.color.grey.shade800();

    final thumb = $.thumb.chain
      ..color.black()
      ..shape.circle.side.color.white();

    return Style.create([
      super.makeStyle(spec).call(),
      activeTrack,
      track,
      thumb,
    ]).animate(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }
}

import 'package:ack/ack.dart';
import 'package:flutter/painting.dart';

final AckSchema<Color> colorSchema = Ack.integer()
    .strictParsing()
    .transform<Color>((value) => Color(value!));

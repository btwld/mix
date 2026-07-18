/**
 * Generated from packages/mix_protocol/schema/style.schema.json.
 * Do not edit by hand; run `npm run gen:types`.
 */

export type MixProtocolStyleDocument =
  | {
      type: "box";
      alignment?: MixProtocolPropertyTerm;
      padding?: MixProtocolDoublePropertyTerm;
      margin?: MixProtocolDoublePropertyTerm;
      constraints?: MixProtocolPropertyTerm;
      clipBehavior?: MixProtocolPropertyTerm;
      transform?: MixProtocolPropertyTerm;
      transformAlignment?: MixProtocolPropertyTerm;
      decoration?: MixProtocolBoxDecorationLiteral | MixProtocolPropertyControlTerm;
      foregroundDecoration?: MixProtocolBoxDecorationLiteral | MixProtocolPropertyControlTerm;
      variants?: (
        | {
            kind: "named";
            name: string;
            style: MixProtocolStyle;
          }
        | {
            kind: "widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "enabled";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_brightness";
            brightness: "light" | "dark";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_breakpoint";
            token?: string;
            minWidth?: number;
            maxWidth?: number;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_directionality";
            textDirection: "ltr" | "rtl";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not";
            variant: MixProtocolContextVariantSelector;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not_widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_orientation";
            orientation: "portrait" | "landscape";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_platform";
            platform: "android" | "fuchsia" | "iOS" | "linux" | "macOS" | "windows";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_web";
            style: MixProtocolStyle;
          }
      )[];
      modifiers?:
        | (
            | {
                type: "align";
                alignment?: MixProtocolPropertyTerm;
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
              }
            | {
                type: "aspect_ratio";
                aspectRatio?: MixProtocolPropertyTerm;
              }
            | {
                type: "blur";
                sigma: MixProtocolPropertyTerm;
              }
            | {
                type: "box";
                style: MixProtocolStyle;
              }
            | {
                type: "clip_oval";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_rect";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_r_rect";
                borderRadius?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_triangle";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_style";
                style?: MixProtocolPropertyTerm;
                textAlign?: MixProtocolPropertyTerm;
                softWrap?: MixProtocolPropertyTerm;
                overflow?: MixProtocolPropertyTerm;
                maxLines?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_styler";
                style: MixProtocolStyle;
              }
            | {
                type: "flexible";
                flex?: MixProtocolPropertyTerm;
                fit?: MixProtocolPropertyTerm;
              }
            | {
                type: "fractionally_sized_box";
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "icon_theme";
                color?: MixProtocolPropertyTerm;
                size?: MixProtocolPropertyTerm;
                fill?: MixProtocolPropertyTerm;
                weight?: MixProtocolPropertyTerm;
                grade?: MixProtocolPropertyTerm;
                opticalSize?: MixProtocolPropertyTerm;
                opacity?: MixProtocolPropertyTerm;
                shadows?: MixProtocolPropertyTerm;
                applyTextScaling?: MixProtocolPropertyTerm;
              }
            | {
                type: "intrinsic_height";
              }
            | {
                type: "intrinsic_width";
              }
            | {
                type: "opacity";
                opacity: MixProtocolPropertyTerm;
              }
            | {
                type: "padding";
                padding: MixProtocolPropertyTerm;
              }
            | {
                type: "rotate";
                radians?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "rotated_box";
                quarterTurns?: MixProtocolPropertyTerm;
              }
            | {
                type: "scale";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "scroll_view";
                scrollDirection?: MixProtocolPropertyTerm;
                reverse?: MixProtocolPropertyTerm;
                padding?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "sized_box";
                width?: MixProtocolPropertyTerm;
                height?: MixProtocolPropertyTerm;
              }
            | {
                type: "skew";
                skewX?: MixProtocolPropertyTerm;
                skewY?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "transform";
                transform?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "translate";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
              }
            | {
                type: "visibility";
                visible?: MixProtocolPropertyTerm;
              }
          )[]
        | {
            order?: (
              | "align"
              | "aspect_ratio"
              | "blur"
              | "box"
              | "clip_oval"
              | "clip_rect"
              | "clip_r_rect"
              | "clip_triangle"
              | "default_text_style"
              | "default_text_styler"
              | "flexible"
              | "fractionally_sized_box"
              | "icon_theme"
              | "intrinsic_height"
              | "intrinsic_width"
              | "opacity"
              | "padding"
              | "rotate"
              | "rotated_box"
              | "scale"
              | "scroll_view"
              | "sized_box"
              | "skew"
              | "transform"
              | "translate"
              | "visibility"
            )[];
            items?: (
              | {
                  type: "align";
                  alignment?: MixProtocolPropertyTerm;
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                }
              | {
                  type: "aspect_ratio";
                  aspectRatio?: MixProtocolPropertyTerm;
                }
              | {
                  type: "blur";
                  sigma: MixProtocolPropertyTerm;
                }
              | {
                  type: "box";
                  style: MixProtocolStyle;
                }
              | {
                  type: "clip_oval";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_rect";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_r_rect";
                  borderRadius?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_triangle";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_style";
                  style?: MixProtocolPropertyTerm;
                  textAlign?: MixProtocolPropertyTerm;
                  softWrap?: MixProtocolPropertyTerm;
                  overflow?: MixProtocolPropertyTerm;
                  maxLines?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_styler";
                  style: MixProtocolStyle;
                }
              | {
                  type: "flexible";
                  flex?: MixProtocolPropertyTerm;
                  fit?: MixProtocolPropertyTerm;
                }
              | {
                  type: "fractionally_sized_box";
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "icon_theme";
                  color?: MixProtocolPropertyTerm;
                  size?: MixProtocolPropertyTerm;
                  fill?: MixProtocolPropertyTerm;
                  weight?: MixProtocolPropertyTerm;
                  grade?: MixProtocolPropertyTerm;
                  opticalSize?: MixProtocolPropertyTerm;
                  opacity?: MixProtocolPropertyTerm;
                  shadows?: MixProtocolPropertyTerm;
                  applyTextScaling?: MixProtocolPropertyTerm;
                }
              | {
                  type: "intrinsic_height";
                }
              | {
                  type: "intrinsic_width";
                }
              | {
                  type: "opacity";
                  opacity: MixProtocolPropertyTerm;
                }
              | {
                  type: "padding";
                  padding: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotate";
                  radians?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotated_box";
                  quarterTurns?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scale";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scroll_view";
                  scrollDirection?: MixProtocolPropertyTerm;
                  reverse?: MixProtocolPropertyTerm;
                  padding?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "sized_box";
                  width?: MixProtocolPropertyTerm;
                  height?: MixProtocolPropertyTerm;
                }
              | {
                  type: "skew";
                  skewX?: MixProtocolPropertyTerm;
                  skewY?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "transform";
                  transform?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "translate";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                }
              | {
                  type: "visibility";
                  visible?: MixProtocolPropertyTerm;
                }
            )[];
          };
      animation?: {
        type?: "curve";
        spring?: {
          mass: number;
          stiffness: number;
          damping: number;
        };
        duration?:
          | {
              $token: string;
            }
          | number;
        curve?:
          | (
              | "linear"
              | "decelerate"
              | "fastLinearToSlowEaseIn"
              | "fastEaseInToSlowEaseOut"
              | "ease"
              | "easeIn"
              | "easeInToLinear"
              | "easeInSine"
              | "easeInQuad"
              | "easeInCubic"
              | "easeInQuart"
              | "easeInQuint"
              | "easeInExpo"
              | "easeInCirc"
              | "easeInBack"
              | "easeOut"
              | "linearToEaseOut"
              | "easeOutSine"
              | "easeOutQuad"
              | "easeOutCubic"
              | "easeOutQuart"
              | "easeOutQuint"
              | "easeOutExpo"
              | "easeOutCirc"
              | "easeOutBack"
              | "easeInOut"
              | "easeInOutSine"
              | "easeInOutQuad"
              | "easeInOutCubic"
              | "easeInOutCubicEmphasized"
              | "easeInOutQuart"
              | "easeInOutQuint"
              | "easeInOutExpo"
              | "easeInOutCirc"
              | "easeInOutBack"
              | "fastOutSlowIn"
              | "slowMiddle"
              | "bounceIn"
              | "bounceOut"
              | "bounceInOut"
              | "elasticIn"
              | "elasticOut"
              | "elasticInOut"
            )
          | {
              /**
               * @minItems 4
               * @maxItems 4
               */
              cubic: [number, number, number, number];
            };
        delay?:
          | {
              $token: string;
            }
          | number;
      };
      v: 1;
    }
  | {
      type: "text";
      overflow?: MixProtocolPropertyTerm;
      strutStyle?: MixProtocolStrutStyleLiteral | MixProtocolPropertyControlTerm;
      textAlign?: MixProtocolPropertyTerm;
      textScaler?: MixProtocolPropertyTerm;
      maxLines?: MixProtocolPropertyTerm;
      style?: MixProtocolTextStyleLiteral | MixProtocolPropertyControlTerm;
      textWidthBasis?: MixProtocolPropertyTerm;
      textDirection?: MixProtocolPropertyTerm;
      softWrap?: MixProtocolPropertyTerm;
      selectionColor?: MixProtocolPropertyTerm;
      semanticsLabel?: MixProtocolPropertyTerm;
      locale?: MixProtocolPropertyTerm;
      textHeightBehavior?: MixProtocolPropertyTerm;
      textDirectives?: ("uppercase" | "lowercase" | "capitalize" | "title_case" | "sentence_case")[];
      variants?: (
        | {
            kind: "named";
            name: string;
            style: MixProtocolStyle;
          }
        | {
            kind: "widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "enabled";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_brightness";
            brightness: "light" | "dark";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_breakpoint";
            token?: string;
            minWidth?: number;
            maxWidth?: number;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_directionality";
            textDirection: "ltr" | "rtl";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not";
            variant: MixProtocolContextVariantSelector;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not_widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_orientation";
            orientation: "portrait" | "landscape";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_platform";
            platform: "android" | "fuchsia" | "iOS" | "linux" | "macOS" | "windows";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_web";
            style: MixProtocolStyle;
          }
      )[];
      modifiers?:
        | (
            | {
                type: "align";
                alignment?: MixProtocolPropertyTerm;
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
              }
            | {
                type: "aspect_ratio";
                aspectRatio?: MixProtocolPropertyTerm;
              }
            | {
                type: "blur";
                sigma: MixProtocolPropertyTerm;
              }
            | {
                type: "box";
                style: MixProtocolStyle;
              }
            | {
                type: "clip_oval";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_rect";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_r_rect";
                borderRadius?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_triangle";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_style";
                style?: MixProtocolPropertyTerm;
                textAlign?: MixProtocolPropertyTerm;
                softWrap?: MixProtocolPropertyTerm;
                overflow?: MixProtocolPropertyTerm;
                maxLines?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_styler";
                style: MixProtocolStyle;
              }
            | {
                type: "flexible";
                flex?: MixProtocolPropertyTerm;
                fit?: MixProtocolPropertyTerm;
              }
            | {
                type: "fractionally_sized_box";
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "icon_theme";
                color?: MixProtocolPropertyTerm;
                size?: MixProtocolPropertyTerm;
                fill?: MixProtocolPropertyTerm;
                weight?: MixProtocolPropertyTerm;
                grade?: MixProtocolPropertyTerm;
                opticalSize?: MixProtocolPropertyTerm;
                opacity?: MixProtocolPropertyTerm;
                shadows?: MixProtocolPropertyTerm;
                applyTextScaling?: MixProtocolPropertyTerm;
              }
            | {
                type: "intrinsic_height";
              }
            | {
                type: "intrinsic_width";
              }
            | {
                type: "opacity";
                opacity: MixProtocolPropertyTerm;
              }
            | {
                type: "padding";
                padding: MixProtocolPropertyTerm;
              }
            | {
                type: "rotate";
                radians?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "rotated_box";
                quarterTurns?: MixProtocolPropertyTerm;
              }
            | {
                type: "scale";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "scroll_view";
                scrollDirection?: MixProtocolPropertyTerm;
                reverse?: MixProtocolPropertyTerm;
                padding?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "sized_box";
                width?: MixProtocolPropertyTerm;
                height?: MixProtocolPropertyTerm;
              }
            | {
                type: "skew";
                skewX?: MixProtocolPropertyTerm;
                skewY?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "transform";
                transform?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "translate";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
              }
            | {
                type: "visibility";
                visible?: MixProtocolPropertyTerm;
              }
          )[]
        | {
            order?: (
              | "align"
              | "aspect_ratio"
              | "blur"
              | "box"
              | "clip_oval"
              | "clip_rect"
              | "clip_r_rect"
              | "clip_triangle"
              | "default_text_style"
              | "default_text_styler"
              | "flexible"
              | "fractionally_sized_box"
              | "icon_theme"
              | "intrinsic_height"
              | "intrinsic_width"
              | "opacity"
              | "padding"
              | "rotate"
              | "rotated_box"
              | "scale"
              | "scroll_view"
              | "sized_box"
              | "skew"
              | "transform"
              | "translate"
              | "visibility"
            )[];
            items?: (
              | {
                  type: "align";
                  alignment?: MixProtocolPropertyTerm;
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                }
              | {
                  type: "aspect_ratio";
                  aspectRatio?: MixProtocolPropertyTerm;
                }
              | {
                  type: "blur";
                  sigma: MixProtocolPropertyTerm;
                }
              | {
                  type: "box";
                  style: MixProtocolStyle;
                }
              | {
                  type: "clip_oval";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_rect";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_r_rect";
                  borderRadius?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_triangle";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_style";
                  style?: MixProtocolPropertyTerm;
                  textAlign?: MixProtocolPropertyTerm;
                  softWrap?: MixProtocolPropertyTerm;
                  overflow?: MixProtocolPropertyTerm;
                  maxLines?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_styler";
                  style: MixProtocolStyle;
                }
              | {
                  type: "flexible";
                  flex?: MixProtocolPropertyTerm;
                  fit?: MixProtocolPropertyTerm;
                }
              | {
                  type: "fractionally_sized_box";
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "icon_theme";
                  color?: MixProtocolPropertyTerm;
                  size?: MixProtocolPropertyTerm;
                  fill?: MixProtocolPropertyTerm;
                  weight?: MixProtocolPropertyTerm;
                  grade?: MixProtocolPropertyTerm;
                  opticalSize?: MixProtocolPropertyTerm;
                  opacity?: MixProtocolPropertyTerm;
                  shadows?: MixProtocolPropertyTerm;
                  applyTextScaling?: MixProtocolPropertyTerm;
                }
              | {
                  type: "intrinsic_height";
                }
              | {
                  type: "intrinsic_width";
                }
              | {
                  type: "opacity";
                  opacity: MixProtocolPropertyTerm;
                }
              | {
                  type: "padding";
                  padding: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotate";
                  radians?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotated_box";
                  quarterTurns?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scale";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scroll_view";
                  scrollDirection?: MixProtocolPropertyTerm;
                  reverse?: MixProtocolPropertyTerm;
                  padding?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "sized_box";
                  width?: MixProtocolPropertyTerm;
                  height?: MixProtocolPropertyTerm;
                }
              | {
                  type: "skew";
                  skewX?: MixProtocolPropertyTerm;
                  skewY?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "transform";
                  transform?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "translate";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                }
              | {
                  type: "visibility";
                  visible?: MixProtocolPropertyTerm;
                }
            )[];
          };
      animation?: {
        type?: "curve";
        spring?: {
          mass: number;
          stiffness: number;
          damping: number;
        };
        duration?:
          | {
              $token: string;
            }
          | number;
        curve?:
          | (
              | "linear"
              | "decelerate"
              | "fastLinearToSlowEaseIn"
              | "fastEaseInToSlowEaseOut"
              | "ease"
              | "easeIn"
              | "easeInToLinear"
              | "easeInSine"
              | "easeInQuad"
              | "easeInCubic"
              | "easeInQuart"
              | "easeInQuint"
              | "easeInExpo"
              | "easeInCirc"
              | "easeInBack"
              | "easeOut"
              | "linearToEaseOut"
              | "easeOutSine"
              | "easeOutQuad"
              | "easeOutCubic"
              | "easeOutQuart"
              | "easeOutQuint"
              | "easeOutExpo"
              | "easeOutCirc"
              | "easeOutBack"
              | "easeInOut"
              | "easeInOutSine"
              | "easeInOutQuad"
              | "easeInOutCubic"
              | "easeInOutCubicEmphasized"
              | "easeInOutQuart"
              | "easeInOutQuint"
              | "easeInOutExpo"
              | "easeInOutCirc"
              | "easeInOutBack"
              | "fastOutSlowIn"
              | "slowMiddle"
              | "bounceIn"
              | "bounceOut"
              | "bounceInOut"
              | "elasticIn"
              | "elasticOut"
              | "elasticInOut"
            )
          | {
              /**
               * @minItems 4
               * @maxItems 4
               */
              cubic: [number, number, number, number];
            };
        delay?:
          | {
              $token: string;
            }
          | number;
      };
      v: 1;
    }
  | {
      type: "flex";
      direction?: MixProtocolPropertyTerm;
      mainAxisAlignment?: MixProtocolPropertyTerm;
      crossAxisAlignment?: MixProtocolPropertyTerm;
      mainAxisSize?: MixProtocolPropertyTerm;
      verticalDirection?: MixProtocolPropertyTerm;
      textDirection?: MixProtocolPropertyTerm;
      textBaseline?: MixProtocolPropertyTerm;
      clipBehavior?: MixProtocolPropertyTerm;
      spacing?: MixProtocolDoublePropertyTerm;
      variants?: (
        | {
            kind: "named";
            name: string;
            style: MixProtocolStyle;
          }
        | {
            kind: "widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "enabled";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_brightness";
            brightness: "light" | "dark";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_breakpoint";
            token?: string;
            minWidth?: number;
            maxWidth?: number;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_directionality";
            textDirection: "ltr" | "rtl";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not";
            variant: MixProtocolContextVariantSelector;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not_widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_orientation";
            orientation: "portrait" | "landscape";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_platform";
            platform: "android" | "fuchsia" | "iOS" | "linux" | "macOS" | "windows";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_web";
            style: MixProtocolStyle;
          }
      )[];
      modifiers?:
        | (
            | {
                type: "align";
                alignment?: MixProtocolPropertyTerm;
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
              }
            | {
                type: "aspect_ratio";
                aspectRatio?: MixProtocolPropertyTerm;
              }
            | {
                type: "blur";
                sigma: MixProtocolPropertyTerm;
              }
            | {
                type: "box";
                style: MixProtocolStyle;
              }
            | {
                type: "clip_oval";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_rect";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_r_rect";
                borderRadius?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_triangle";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_style";
                style?: MixProtocolPropertyTerm;
                textAlign?: MixProtocolPropertyTerm;
                softWrap?: MixProtocolPropertyTerm;
                overflow?: MixProtocolPropertyTerm;
                maxLines?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_styler";
                style: MixProtocolStyle;
              }
            | {
                type: "flexible";
                flex?: MixProtocolPropertyTerm;
                fit?: MixProtocolPropertyTerm;
              }
            | {
                type: "fractionally_sized_box";
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "icon_theme";
                color?: MixProtocolPropertyTerm;
                size?: MixProtocolPropertyTerm;
                fill?: MixProtocolPropertyTerm;
                weight?: MixProtocolPropertyTerm;
                grade?: MixProtocolPropertyTerm;
                opticalSize?: MixProtocolPropertyTerm;
                opacity?: MixProtocolPropertyTerm;
                shadows?: MixProtocolPropertyTerm;
                applyTextScaling?: MixProtocolPropertyTerm;
              }
            | {
                type: "intrinsic_height";
              }
            | {
                type: "intrinsic_width";
              }
            | {
                type: "opacity";
                opacity: MixProtocolPropertyTerm;
              }
            | {
                type: "padding";
                padding: MixProtocolPropertyTerm;
              }
            | {
                type: "rotate";
                radians?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "rotated_box";
                quarterTurns?: MixProtocolPropertyTerm;
              }
            | {
                type: "scale";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "scroll_view";
                scrollDirection?: MixProtocolPropertyTerm;
                reverse?: MixProtocolPropertyTerm;
                padding?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "sized_box";
                width?: MixProtocolPropertyTerm;
                height?: MixProtocolPropertyTerm;
              }
            | {
                type: "skew";
                skewX?: MixProtocolPropertyTerm;
                skewY?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "transform";
                transform?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "translate";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
              }
            | {
                type: "visibility";
                visible?: MixProtocolPropertyTerm;
              }
          )[]
        | {
            order?: (
              | "align"
              | "aspect_ratio"
              | "blur"
              | "box"
              | "clip_oval"
              | "clip_rect"
              | "clip_r_rect"
              | "clip_triangle"
              | "default_text_style"
              | "default_text_styler"
              | "flexible"
              | "fractionally_sized_box"
              | "icon_theme"
              | "intrinsic_height"
              | "intrinsic_width"
              | "opacity"
              | "padding"
              | "rotate"
              | "rotated_box"
              | "scale"
              | "scroll_view"
              | "sized_box"
              | "skew"
              | "transform"
              | "translate"
              | "visibility"
            )[];
            items?: (
              | {
                  type: "align";
                  alignment?: MixProtocolPropertyTerm;
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                }
              | {
                  type: "aspect_ratio";
                  aspectRatio?: MixProtocolPropertyTerm;
                }
              | {
                  type: "blur";
                  sigma: MixProtocolPropertyTerm;
                }
              | {
                  type: "box";
                  style: MixProtocolStyle;
                }
              | {
                  type: "clip_oval";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_rect";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_r_rect";
                  borderRadius?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_triangle";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_style";
                  style?: MixProtocolPropertyTerm;
                  textAlign?: MixProtocolPropertyTerm;
                  softWrap?: MixProtocolPropertyTerm;
                  overflow?: MixProtocolPropertyTerm;
                  maxLines?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_styler";
                  style: MixProtocolStyle;
                }
              | {
                  type: "flexible";
                  flex?: MixProtocolPropertyTerm;
                  fit?: MixProtocolPropertyTerm;
                }
              | {
                  type: "fractionally_sized_box";
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "icon_theme";
                  color?: MixProtocolPropertyTerm;
                  size?: MixProtocolPropertyTerm;
                  fill?: MixProtocolPropertyTerm;
                  weight?: MixProtocolPropertyTerm;
                  grade?: MixProtocolPropertyTerm;
                  opticalSize?: MixProtocolPropertyTerm;
                  opacity?: MixProtocolPropertyTerm;
                  shadows?: MixProtocolPropertyTerm;
                  applyTextScaling?: MixProtocolPropertyTerm;
                }
              | {
                  type: "intrinsic_height";
                }
              | {
                  type: "intrinsic_width";
                }
              | {
                  type: "opacity";
                  opacity: MixProtocolPropertyTerm;
                }
              | {
                  type: "padding";
                  padding: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotate";
                  radians?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotated_box";
                  quarterTurns?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scale";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scroll_view";
                  scrollDirection?: MixProtocolPropertyTerm;
                  reverse?: MixProtocolPropertyTerm;
                  padding?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "sized_box";
                  width?: MixProtocolPropertyTerm;
                  height?: MixProtocolPropertyTerm;
                }
              | {
                  type: "skew";
                  skewX?: MixProtocolPropertyTerm;
                  skewY?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "transform";
                  transform?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "translate";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                }
              | {
                  type: "visibility";
                  visible?: MixProtocolPropertyTerm;
                }
            )[];
          };
      animation?: {
        type?: "curve";
        spring?: {
          mass: number;
          stiffness: number;
          damping: number;
        };
        duration?:
          | {
              $token: string;
            }
          | number;
        curve?:
          | (
              | "linear"
              | "decelerate"
              | "fastLinearToSlowEaseIn"
              | "fastEaseInToSlowEaseOut"
              | "ease"
              | "easeIn"
              | "easeInToLinear"
              | "easeInSine"
              | "easeInQuad"
              | "easeInCubic"
              | "easeInQuart"
              | "easeInQuint"
              | "easeInExpo"
              | "easeInCirc"
              | "easeInBack"
              | "easeOut"
              | "linearToEaseOut"
              | "easeOutSine"
              | "easeOutQuad"
              | "easeOutCubic"
              | "easeOutQuart"
              | "easeOutQuint"
              | "easeOutExpo"
              | "easeOutCirc"
              | "easeOutBack"
              | "easeInOut"
              | "easeInOutSine"
              | "easeInOutQuad"
              | "easeInOutCubic"
              | "easeInOutCubicEmphasized"
              | "easeInOutQuart"
              | "easeInOutQuint"
              | "easeInOutExpo"
              | "easeInOutCirc"
              | "easeInOutBack"
              | "fastOutSlowIn"
              | "slowMiddle"
              | "bounceIn"
              | "bounceOut"
              | "bounceInOut"
              | "elasticIn"
              | "elasticOut"
              | "elasticInOut"
            )
          | {
              /**
               * @minItems 4
               * @maxItems 4
               */
              cubic: [number, number, number, number];
            };
        delay?:
          | {
              $token: string;
            }
          | number;
      };
      v: 1;
    }
  | {
      type: "stack";
      alignment?: MixProtocolPropertyTerm;
      fit?: MixProtocolPropertyTerm;
      textDirection?: MixProtocolPropertyTerm;
      clipBehavior?: MixProtocolPropertyTerm;
      variants?: (
        | {
            kind: "named";
            name: string;
            style: MixProtocolStyle;
          }
        | {
            kind: "widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "enabled";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_brightness";
            brightness: "light" | "dark";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_breakpoint";
            token?: string;
            minWidth?: number;
            maxWidth?: number;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_directionality";
            textDirection: "ltr" | "rtl";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not";
            variant: MixProtocolContextVariantSelector;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not_widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_orientation";
            orientation: "portrait" | "landscape";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_platform";
            platform: "android" | "fuchsia" | "iOS" | "linux" | "macOS" | "windows";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_web";
            style: MixProtocolStyle;
          }
      )[];
      modifiers?:
        | (
            | {
                type: "align";
                alignment?: MixProtocolPropertyTerm;
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
              }
            | {
                type: "aspect_ratio";
                aspectRatio?: MixProtocolPropertyTerm;
              }
            | {
                type: "blur";
                sigma: MixProtocolPropertyTerm;
              }
            | {
                type: "box";
                style: MixProtocolStyle;
              }
            | {
                type: "clip_oval";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_rect";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_r_rect";
                borderRadius?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_triangle";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_style";
                style?: MixProtocolPropertyTerm;
                textAlign?: MixProtocolPropertyTerm;
                softWrap?: MixProtocolPropertyTerm;
                overflow?: MixProtocolPropertyTerm;
                maxLines?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_styler";
                style: MixProtocolStyle;
              }
            | {
                type: "flexible";
                flex?: MixProtocolPropertyTerm;
                fit?: MixProtocolPropertyTerm;
              }
            | {
                type: "fractionally_sized_box";
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "icon_theme";
                color?: MixProtocolPropertyTerm;
                size?: MixProtocolPropertyTerm;
                fill?: MixProtocolPropertyTerm;
                weight?: MixProtocolPropertyTerm;
                grade?: MixProtocolPropertyTerm;
                opticalSize?: MixProtocolPropertyTerm;
                opacity?: MixProtocolPropertyTerm;
                shadows?: MixProtocolPropertyTerm;
                applyTextScaling?: MixProtocolPropertyTerm;
              }
            | {
                type: "intrinsic_height";
              }
            | {
                type: "intrinsic_width";
              }
            | {
                type: "opacity";
                opacity: MixProtocolPropertyTerm;
              }
            | {
                type: "padding";
                padding: MixProtocolPropertyTerm;
              }
            | {
                type: "rotate";
                radians?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "rotated_box";
                quarterTurns?: MixProtocolPropertyTerm;
              }
            | {
                type: "scale";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "scroll_view";
                scrollDirection?: MixProtocolPropertyTerm;
                reverse?: MixProtocolPropertyTerm;
                padding?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "sized_box";
                width?: MixProtocolPropertyTerm;
                height?: MixProtocolPropertyTerm;
              }
            | {
                type: "skew";
                skewX?: MixProtocolPropertyTerm;
                skewY?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "transform";
                transform?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "translate";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
              }
            | {
                type: "visibility";
                visible?: MixProtocolPropertyTerm;
              }
          )[]
        | {
            order?: (
              | "align"
              | "aspect_ratio"
              | "blur"
              | "box"
              | "clip_oval"
              | "clip_rect"
              | "clip_r_rect"
              | "clip_triangle"
              | "default_text_style"
              | "default_text_styler"
              | "flexible"
              | "fractionally_sized_box"
              | "icon_theme"
              | "intrinsic_height"
              | "intrinsic_width"
              | "opacity"
              | "padding"
              | "rotate"
              | "rotated_box"
              | "scale"
              | "scroll_view"
              | "sized_box"
              | "skew"
              | "transform"
              | "translate"
              | "visibility"
            )[];
            items?: (
              | {
                  type: "align";
                  alignment?: MixProtocolPropertyTerm;
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                }
              | {
                  type: "aspect_ratio";
                  aspectRatio?: MixProtocolPropertyTerm;
                }
              | {
                  type: "blur";
                  sigma: MixProtocolPropertyTerm;
                }
              | {
                  type: "box";
                  style: MixProtocolStyle;
                }
              | {
                  type: "clip_oval";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_rect";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_r_rect";
                  borderRadius?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_triangle";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_style";
                  style?: MixProtocolPropertyTerm;
                  textAlign?: MixProtocolPropertyTerm;
                  softWrap?: MixProtocolPropertyTerm;
                  overflow?: MixProtocolPropertyTerm;
                  maxLines?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_styler";
                  style: MixProtocolStyle;
                }
              | {
                  type: "flexible";
                  flex?: MixProtocolPropertyTerm;
                  fit?: MixProtocolPropertyTerm;
                }
              | {
                  type: "fractionally_sized_box";
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "icon_theme";
                  color?: MixProtocolPropertyTerm;
                  size?: MixProtocolPropertyTerm;
                  fill?: MixProtocolPropertyTerm;
                  weight?: MixProtocolPropertyTerm;
                  grade?: MixProtocolPropertyTerm;
                  opticalSize?: MixProtocolPropertyTerm;
                  opacity?: MixProtocolPropertyTerm;
                  shadows?: MixProtocolPropertyTerm;
                  applyTextScaling?: MixProtocolPropertyTerm;
                }
              | {
                  type: "intrinsic_height";
                }
              | {
                  type: "intrinsic_width";
                }
              | {
                  type: "opacity";
                  opacity: MixProtocolPropertyTerm;
                }
              | {
                  type: "padding";
                  padding: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotate";
                  radians?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotated_box";
                  quarterTurns?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scale";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scroll_view";
                  scrollDirection?: MixProtocolPropertyTerm;
                  reverse?: MixProtocolPropertyTerm;
                  padding?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "sized_box";
                  width?: MixProtocolPropertyTerm;
                  height?: MixProtocolPropertyTerm;
                }
              | {
                  type: "skew";
                  skewX?: MixProtocolPropertyTerm;
                  skewY?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "transform";
                  transform?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "translate";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                }
              | {
                  type: "visibility";
                  visible?: MixProtocolPropertyTerm;
                }
            )[];
          };
      animation?: {
        type?: "curve";
        spring?: {
          mass: number;
          stiffness: number;
          damping: number;
        };
        duration?:
          | {
              $token: string;
            }
          | number;
        curve?:
          | (
              | "linear"
              | "decelerate"
              | "fastLinearToSlowEaseIn"
              | "fastEaseInToSlowEaseOut"
              | "ease"
              | "easeIn"
              | "easeInToLinear"
              | "easeInSine"
              | "easeInQuad"
              | "easeInCubic"
              | "easeInQuart"
              | "easeInQuint"
              | "easeInExpo"
              | "easeInCirc"
              | "easeInBack"
              | "easeOut"
              | "linearToEaseOut"
              | "easeOutSine"
              | "easeOutQuad"
              | "easeOutCubic"
              | "easeOutQuart"
              | "easeOutQuint"
              | "easeOutExpo"
              | "easeOutCirc"
              | "easeOutBack"
              | "easeInOut"
              | "easeInOutSine"
              | "easeInOutQuad"
              | "easeInOutCubic"
              | "easeInOutCubicEmphasized"
              | "easeInOutQuart"
              | "easeInOutQuint"
              | "easeInOutExpo"
              | "easeInOutCirc"
              | "easeInOutBack"
              | "fastOutSlowIn"
              | "slowMiddle"
              | "bounceIn"
              | "bounceOut"
              | "bounceInOut"
              | "elasticIn"
              | "elasticOut"
              | "elasticInOut"
            )
          | {
              /**
               * @minItems 4
               * @maxItems 4
               */
              cubic: [number, number, number, number];
            };
        delay?:
          | {
              $token: string;
            }
          | number;
      };
      v: 1;
    }
  | {
      type: "icon";
      icon?: MixProtocolPropertyTerm;
      color?: MixProtocolPropertyTerm;
      size?: MixProtocolDoublePropertyTerm;
      weight?: MixProtocolDoublePropertyTerm;
      grade?: MixProtocolDoublePropertyTerm;
      opticalSize?: MixProtocolDoublePropertyTerm;
      shadows?: MixProtocolPropertyTerm;
      textDirection?: MixProtocolPropertyTerm;
      applyTextScaling?: MixProtocolPropertyTerm;
      fill?: MixProtocolDoublePropertyTerm;
      semanticsLabel?: MixProtocolPropertyTerm;
      opacity?: MixProtocolDoublePropertyTerm;
      blendMode?: MixProtocolPropertyTerm;
      variants?: (
        | {
            kind: "named";
            name: string;
            style: MixProtocolStyle;
          }
        | {
            kind: "widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "enabled";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_brightness";
            brightness: "light" | "dark";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_breakpoint";
            token?: string;
            minWidth?: number;
            maxWidth?: number;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_directionality";
            textDirection: "ltr" | "rtl";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not";
            variant: MixProtocolContextVariantSelector;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not_widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_orientation";
            orientation: "portrait" | "landscape";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_platform";
            platform: "android" | "fuchsia" | "iOS" | "linux" | "macOS" | "windows";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_web";
            style: MixProtocolStyle;
          }
      )[];
      modifiers?:
        | (
            | {
                type: "align";
                alignment?: MixProtocolPropertyTerm;
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
              }
            | {
                type: "aspect_ratio";
                aspectRatio?: MixProtocolPropertyTerm;
              }
            | {
                type: "blur";
                sigma: MixProtocolPropertyTerm;
              }
            | {
                type: "box";
                style: MixProtocolStyle;
              }
            | {
                type: "clip_oval";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_rect";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_r_rect";
                borderRadius?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_triangle";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_style";
                style?: MixProtocolPropertyTerm;
                textAlign?: MixProtocolPropertyTerm;
                softWrap?: MixProtocolPropertyTerm;
                overflow?: MixProtocolPropertyTerm;
                maxLines?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_styler";
                style: MixProtocolStyle;
              }
            | {
                type: "flexible";
                flex?: MixProtocolPropertyTerm;
                fit?: MixProtocolPropertyTerm;
              }
            | {
                type: "fractionally_sized_box";
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "icon_theme";
                color?: MixProtocolPropertyTerm;
                size?: MixProtocolPropertyTerm;
                fill?: MixProtocolPropertyTerm;
                weight?: MixProtocolPropertyTerm;
                grade?: MixProtocolPropertyTerm;
                opticalSize?: MixProtocolPropertyTerm;
                opacity?: MixProtocolPropertyTerm;
                shadows?: MixProtocolPropertyTerm;
                applyTextScaling?: MixProtocolPropertyTerm;
              }
            | {
                type: "intrinsic_height";
              }
            | {
                type: "intrinsic_width";
              }
            | {
                type: "opacity";
                opacity: MixProtocolPropertyTerm;
              }
            | {
                type: "padding";
                padding: MixProtocolPropertyTerm;
              }
            | {
                type: "rotate";
                radians?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "rotated_box";
                quarterTurns?: MixProtocolPropertyTerm;
              }
            | {
                type: "scale";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "scroll_view";
                scrollDirection?: MixProtocolPropertyTerm;
                reverse?: MixProtocolPropertyTerm;
                padding?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "sized_box";
                width?: MixProtocolPropertyTerm;
                height?: MixProtocolPropertyTerm;
              }
            | {
                type: "skew";
                skewX?: MixProtocolPropertyTerm;
                skewY?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "transform";
                transform?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "translate";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
              }
            | {
                type: "visibility";
                visible?: MixProtocolPropertyTerm;
              }
          )[]
        | {
            order?: (
              | "align"
              | "aspect_ratio"
              | "blur"
              | "box"
              | "clip_oval"
              | "clip_rect"
              | "clip_r_rect"
              | "clip_triangle"
              | "default_text_style"
              | "default_text_styler"
              | "flexible"
              | "fractionally_sized_box"
              | "icon_theme"
              | "intrinsic_height"
              | "intrinsic_width"
              | "opacity"
              | "padding"
              | "rotate"
              | "rotated_box"
              | "scale"
              | "scroll_view"
              | "sized_box"
              | "skew"
              | "transform"
              | "translate"
              | "visibility"
            )[];
            items?: (
              | {
                  type: "align";
                  alignment?: MixProtocolPropertyTerm;
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                }
              | {
                  type: "aspect_ratio";
                  aspectRatio?: MixProtocolPropertyTerm;
                }
              | {
                  type: "blur";
                  sigma: MixProtocolPropertyTerm;
                }
              | {
                  type: "box";
                  style: MixProtocolStyle;
                }
              | {
                  type: "clip_oval";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_rect";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_r_rect";
                  borderRadius?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_triangle";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_style";
                  style?: MixProtocolPropertyTerm;
                  textAlign?: MixProtocolPropertyTerm;
                  softWrap?: MixProtocolPropertyTerm;
                  overflow?: MixProtocolPropertyTerm;
                  maxLines?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_styler";
                  style: MixProtocolStyle;
                }
              | {
                  type: "flexible";
                  flex?: MixProtocolPropertyTerm;
                  fit?: MixProtocolPropertyTerm;
                }
              | {
                  type: "fractionally_sized_box";
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "icon_theme";
                  color?: MixProtocolPropertyTerm;
                  size?: MixProtocolPropertyTerm;
                  fill?: MixProtocolPropertyTerm;
                  weight?: MixProtocolPropertyTerm;
                  grade?: MixProtocolPropertyTerm;
                  opticalSize?: MixProtocolPropertyTerm;
                  opacity?: MixProtocolPropertyTerm;
                  shadows?: MixProtocolPropertyTerm;
                  applyTextScaling?: MixProtocolPropertyTerm;
                }
              | {
                  type: "intrinsic_height";
                }
              | {
                  type: "intrinsic_width";
                }
              | {
                  type: "opacity";
                  opacity: MixProtocolPropertyTerm;
                }
              | {
                  type: "padding";
                  padding: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotate";
                  radians?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotated_box";
                  quarterTurns?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scale";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scroll_view";
                  scrollDirection?: MixProtocolPropertyTerm;
                  reverse?: MixProtocolPropertyTerm;
                  padding?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "sized_box";
                  width?: MixProtocolPropertyTerm;
                  height?: MixProtocolPropertyTerm;
                }
              | {
                  type: "skew";
                  skewX?: MixProtocolPropertyTerm;
                  skewY?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "transform";
                  transform?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "translate";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                }
              | {
                  type: "visibility";
                  visible?: MixProtocolPropertyTerm;
                }
            )[];
          };
      animation?: {
        type?: "curve";
        spring?: {
          mass: number;
          stiffness: number;
          damping: number;
        };
        duration?:
          | {
              $token: string;
            }
          | number;
        curve?:
          | (
              | "linear"
              | "decelerate"
              | "fastLinearToSlowEaseIn"
              | "fastEaseInToSlowEaseOut"
              | "ease"
              | "easeIn"
              | "easeInToLinear"
              | "easeInSine"
              | "easeInQuad"
              | "easeInCubic"
              | "easeInQuart"
              | "easeInQuint"
              | "easeInExpo"
              | "easeInCirc"
              | "easeInBack"
              | "easeOut"
              | "linearToEaseOut"
              | "easeOutSine"
              | "easeOutQuad"
              | "easeOutCubic"
              | "easeOutQuart"
              | "easeOutQuint"
              | "easeOutExpo"
              | "easeOutCirc"
              | "easeOutBack"
              | "easeInOut"
              | "easeInOutSine"
              | "easeInOutQuad"
              | "easeInOutCubic"
              | "easeInOutCubicEmphasized"
              | "easeInOutQuart"
              | "easeInOutQuint"
              | "easeInOutExpo"
              | "easeInOutCirc"
              | "easeInOutBack"
              | "fastOutSlowIn"
              | "slowMiddle"
              | "bounceIn"
              | "bounceOut"
              | "bounceInOut"
              | "elasticIn"
              | "elasticOut"
              | "elasticInOut"
            )
          | {
              /**
               * @minItems 4
               * @maxItems 4
               */
              cubic: [number, number, number, number];
            };
        delay?:
          | {
              $token: string;
            }
          | number;
      };
      v: 1;
    }
  | {
      type: "image";
      image?: MixProtocolPropertyTerm;
      width?: MixProtocolDoublePropertyTerm;
      height?: MixProtocolDoublePropertyTerm;
      color?: MixProtocolPropertyTerm;
      repeat?: MixProtocolPropertyTerm;
      fit?: MixProtocolPropertyTerm;
      alignment?: MixProtocolPropertyTerm;
      centerSlice?: MixProtocolPropertyTerm;
      filterQuality?: MixProtocolPropertyTerm;
      colorBlendMode?: MixProtocolPropertyTerm;
      semanticLabel?: MixProtocolPropertyTerm;
      excludeFromSemantics?: MixProtocolPropertyTerm;
      gaplessPlayback?: MixProtocolPropertyTerm;
      isAntiAlias?: MixProtocolPropertyTerm;
      matchTextDirection?: MixProtocolPropertyTerm;
      variants?: (
        | {
            kind: "named";
            name: string;
            style: MixProtocolStyle;
          }
        | {
            kind: "widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "enabled";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_brightness";
            brightness: "light" | "dark";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_breakpoint";
            token?: string;
            minWidth?: number;
            maxWidth?: number;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_directionality";
            textDirection: "ltr" | "rtl";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not";
            variant: MixProtocolContextVariantSelector;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not_widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_orientation";
            orientation: "portrait" | "landscape";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_platform";
            platform: "android" | "fuchsia" | "iOS" | "linux" | "macOS" | "windows";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_web";
            style: MixProtocolStyle;
          }
      )[];
      modifiers?:
        | (
            | {
                type: "align";
                alignment?: MixProtocolPropertyTerm;
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
              }
            | {
                type: "aspect_ratio";
                aspectRatio?: MixProtocolPropertyTerm;
              }
            | {
                type: "blur";
                sigma: MixProtocolPropertyTerm;
              }
            | {
                type: "box";
                style: MixProtocolStyle;
              }
            | {
                type: "clip_oval";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_rect";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_r_rect";
                borderRadius?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_triangle";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_style";
                style?: MixProtocolPropertyTerm;
                textAlign?: MixProtocolPropertyTerm;
                softWrap?: MixProtocolPropertyTerm;
                overflow?: MixProtocolPropertyTerm;
                maxLines?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_styler";
                style: MixProtocolStyle;
              }
            | {
                type: "flexible";
                flex?: MixProtocolPropertyTerm;
                fit?: MixProtocolPropertyTerm;
              }
            | {
                type: "fractionally_sized_box";
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "icon_theme";
                color?: MixProtocolPropertyTerm;
                size?: MixProtocolPropertyTerm;
                fill?: MixProtocolPropertyTerm;
                weight?: MixProtocolPropertyTerm;
                grade?: MixProtocolPropertyTerm;
                opticalSize?: MixProtocolPropertyTerm;
                opacity?: MixProtocolPropertyTerm;
                shadows?: MixProtocolPropertyTerm;
                applyTextScaling?: MixProtocolPropertyTerm;
              }
            | {
                type: "intrinsic_height";
              }
            | {
                type: "intrinsic_width";
              }
            | {
                type: "opacity";
                opacity: MixProtocolPropertyTerm;
              }
            | {
                type: "padding";
                padding: MixProtocolPropertyTerm;
              }
            | {
                type: "rotate";
                radians?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "rotated_box";
                quarterTurns?: MixProtocolPropertyTerm;
              }
            | {
                type: "scale";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "scroll_view";
                scrollDirection?: MixProtocolPropertyTerm;
                reverse?: MixProtocolPropertyTerm;
                padding?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "sized_box";
                width?: MixProtocolPropertyTerm;
                height?: MixProtocolPropertyTerm;
              }
            | {
                type: "skew";
                skewX?: MixProtocolPropertyTerm;
                skewY?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "transform";
                transform?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "translate";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
              }
            | {
                type: "visibility";
                visible?: MixProtocolPropertyTerm;
              }
          )[]
        | {
            order?: (
              | "align"
              | "aspect_ratio"
              | "blur"
              | "box"
              | "clip_oval"
              | "clip_rect"
              | "clip_r_rect"
              | "clip_triangle"
              | "default_text_style"
              | "default_text_styler"
              | "flexible"
              | "fractionally_sized_box"
              | "icon_theme"
              | "intrinsic_height"
              | "intrinsic_width"
              | "opacity"
              | "padding"
              | "rotate"
              | "rotated_box"
              | "scale"
              | "scroll_view"
              | "sized_box"
              | "skew"
              | "transform"
              | "translate"
              | "visibility"
            )[];
            items?: (
              | {
                  type: "align";
                  alignment?: MixProtocolPropertyTerm;
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                }
              | {
                  type: "aspect_ratio";
                  aspectRatio?: MixProtocolPropertyTerm;
                }
              | {
                  type: "blur";
                  sigma: MixProtocolPropertyTerm;
                }
              | {
                  type: "box";
                  style: MixProtocolStyle;
                }
              | {
                  type: "clip_oval";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_rect";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_r_rect";
                  borderRadius?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_triangle";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_style";
                  style?: MixProtocolPropertyTerm;
                  textAlign?: MixProtocolPropertyTerm;
                  softWrap?: MixProtocolPropertyTerm;
                  overflow?: MixProtocolPropertyTerm;
                  maxLines?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_styler";
                  style: MixProtocolStyle;
                }
              | {
                  type: "flexible";
                  flex?: MixProtocolPropertyTerm;
                  fit?: MixProtocolPropertyTerm;
                }
              | {
                  type: "fractionally_sized_box";
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "icon_theme";
                  color?: MixProtocolPropertyTerm;
                  size?: MixProtocolPropertyTerm;
                  fill?: MixProtocolPropertyTerm;
                  weight?: MixProtocolPropertyTerm;
                  grade?: MixProtocolPropertyTerm;
                  opticalSize?: MixProtocolPropertyTerm;
                  opacity?: MixProtocolPropertyTerm;
                  shadows?: MixProtocolPropertyTerm;
                  applyTextScaling?: MixProtocolPropertyTerm;
                }
              | {
                  type: "intrinsic_height";
                }
              | {
                  type: "intrinsic_width";
                }
              | {
                  type: "opacity";
                  opacity: MixProtocolPropertyTerm;
                }
              | {
                  type: "padding";
                  padding: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotate";
                  radians?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotated_box";
                  quarterTurns?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scale";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scroll_view";
                  scrollDirection?: MixProtocolPropertyTerm;
                  reverse?: MixProtocolPropertyTerm;
                  padding?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "sized_box";
                  width?: MixProtocolPropertyTerm;
                  height?: MixProtocolPropertyTerm;
                }
              | {
                  type: "skew";
                  skewX?: MixProtocolPropertyTerm;
                  skewY?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "transform";
                  transform?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "translate";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                }
              | {
                  type: "visibility";
                  visible?: MixProtocolPropertyTerm;
                }
            )[];
          };
      animation?: {
        type?: "curve";
        spring?: {
          mass: number;
          stiffness: number;
          damping: number;
        };
        duration?:
          | {
              $token: string;
            }
          | number;
        curve?:
          | (
              | "linear"
              | "decelerate"
              | "fastLinearToSlowEaseIn"
              | "fastEaseInToSlowEaseOut"
              | "ease"
              | "easeIn"
              | "easeInToLinear"
              | "easeInSine"
              | "easeInQuad"
              | "easeInCubic"
              | "easeInQuart"
              | "easeInQuint"
              | "easeInExpo"
              | "easeInCirc"
              | "easeInBack"
              | "easeOut"
              | "linearToEaseOut"
              | "easeOutSine"
              | "easeOutQuad"
              | "easeOutCubic"
              | "easeOutQuart"
              | "easeOutQuint"
              | "easeOutExpo"
              | "easeOutCirc"
              | "easeOutBack"
              | "easeInOut"
              | "easeInOutSine"
              | "easeInOutQuad"
              | "easeInOutCubic"
              | "easeInOutCubicEmphasized"
              | "easeInOutQuart"
              | "easeInOutQuint"
              | "easeInOutExpo"
              | "easeInOutCirc"
              | "easeInOutBack"
              | "fastOutSlowIn"
              | "slowMiddle"
              | "bounceIn"
              | "bounceOut"
              | "bounceInOut"
              | "elasticIn"
              | "elasticOut"
              | "elasticInOut"
            )
          | {
              /**
               * @minItems 4
               * @maxItems 4
               */
              cubic: [number, number, number, number];
            };
        delay?:
          | {
              $token: string;
            }
          | number;
      };
      v: 1;
    }
  | {
      type: "flex_box";
      alignment?: MixProtocolPropertyTerm;
      padding?: MixProtocolDoublePropertyTerm;
      margin?: MixProtocolDoublePropertyTerm;
      constraints?: MixProtocolPropertyTerm;
      clipBehavior?: MixProtocolPropertyTerm;
      transform?: MixProtocolPropertyTerm;
      transformAlignment?: MixProtocolPropertyTerm;
      decoration?: MixProtocolBoxDecorationLiteral | MixProtocolPropertyControlTerm;
      direction?: MixProtocolPropertyTerm;
      mainAxisAlignment?: MixProtocolPropertyTerm;
      crossAxisAlignment?: MixProtocolPropertyTerm;
      mainAxisSize?: MixProtocolPropertyTerm;
      verticalDirection?: MixProtocolPropertyTerm;
      textDirection?: MixProtocolPropertyTerm;
      textBaseline?: MixProtocolPropertyTerm;
      flexClipBehavior?: MixProtocolPropertyTerm;
      spacing?: MixProtocolDoublePropertyTerm;
      variants?: (
        | {
            kind: "named";
            name: string;
            style: MixProtocolStyle;
          }
        | {
            kind: "widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "enabled";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_brightness";
            brightness: "light" | "dark";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_breakpoint";
            token?: string;
            minWidth?: number;
            maxWidth?: number;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_directionality";
            textDirection: "ltr" | "rtl";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not";
            variant: MixProtocolContextVariantSelector;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not_widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_orientation";
            orientation: "portrait" | "landscape";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_platform";
            platform: "android" | "fuchsia" | "iOS" | "linux" | "macOS" | "windows";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_web";
            style: MixProtocolStyle;
          }
      )[];
      modifiers?:
        | (
            | {
                type: "align";
                alignment?: MixProtocolPropertyTerm;
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
              }
            | {
                type: "aspect_ratio";
                aspectRatio?: MixProtocolPropertyTerm;
              }
            | {
                type: "blur";
                sigma: MixProtocolPropertyTerm;
              }
            | {
                type: "box";
                style: MixProtocolStyle;
              }
            | {
                type: "clip_oval";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_rect";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_r_rect";
                borderRadius?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_triangle";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_style";
                style?: MixProtocolPropertyTerm;
                textAlign?: MixProtocolPropertyTerm;
                softWrap?: MixProtocolPropertyTerm;
                overflow?: MixProtocolPropertyTerm;
                maxLines?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_styler";
                style: MixProtocolStyle;
              }
            | {
                type: "flexible";
                flex?: MixProtocolPropertyTerm;
                fit?: MixProtocolPropertyTerm;
              }
            | {
                type: "fractionally_sized_box";
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "icon_theme";
                color?: MixProtocolPropertyTerm;
                size?: MixProtocolPropertyTerm;
                fill?: MixProtocolPropertyTerm;
                weight?: MixProtocolPropertyTerm;
                grade?: MixProtocolPropertyTerm;
                opticalSize?: MixProtocolPropertyTerm;
                opacity?: MixProtocolPropertyTerm;
                shadows?: MixProtocolPropertyTerm;
                applyTextScaling?: MixProtocolPropertyTerm;
              }
            | {
                type: "intrinsic_height";
              }
            | {
                type: "intrinsic_width";
              }
            | {
                type: "opacity";
                opacity: MixProtocolPropertyTerm;
              }
            | {
                type: "padding";
                padding: MixProtocolPropertyTerm;
              }
            | {
                type: "rotate";
                radians?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "rotated_box";
                quarterTurns?: MixProtocolPropertyTerm;
              }
            | {
                type: "scale";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "scroll_view";
                scrollDirection?: MixProtocolPropertyTerm;
                reverse?: MixProtocolPropertyTerm;
                padding?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "sized_box";
                width?: MixProtocolPropertyTerm;
                height?: MixProtocolPropertyTerm;
              }
            | {
                type: "skew";
                skewX?: MixProtocolPropertyTerm;
                skewY?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "transform";
                transform?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "translate";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
              }
            | {
                type: "visibility";
                visible?: MixProtocolPropertyTerm;
              }
          )[]
        | {
            order?: (
              | "align"
              | "aspect_ratio"
              | "blur"
              | "box"
              | "clip_oval"
              | "clip_rect"
              | "clip_r_rect"
              | "clip_triangle"
              | "default_text_style"
              | "default_text_styler"
              | "flexible"
              | "fractionally_sized_box"
              | "icon_theme"
              | "intrinsic_height"
              | "intrinsic_width"
              | "opacity"
              | "padding"
              | "rotate"
              | "rotated_box"
              | "scale"
              | "scroll_view"
              | "sized_box"
              | "skew"
              | "transform"
              | "translate"
              | "visibility"
            )[];
            items?: (
              | {
                  type: "align";
                  alignment?: MixProtocolPropertyTerm;
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                }
              | {
                  type: "aspect_ratio";
                  aspectRatio?: MixProtocolPropertyTerm;
                }
              | {
                  type: "blur";
                  sigma: MixProtocolPropertyTerm;
                }
              | {
                  type: "box";
                  style: MixProtocolStyle;
                }
              | {
                  type: "clip_oval";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_rect";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_r_rect";
                  borderRadius?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_triangle";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_style";
                  style?: MixProtocolPropertyTerm;
                  textAlign?: MixProtocolPropertyTerm;
                  softWrap?: MixProtocolPropertyTerm;
                  overflow?: MixProtocolPropertyTerm;
                  maxLines?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_styler";
                  style: MixProtocolStyle;
                }
              | {
                  type: "flexible";
                  flex?: MixProtocolPropertyTerm;
                  fit?: MixProtocolPropertyTerm;
                }
              | {
                  type: "fractionally_sized_box";
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "icon_theme";
                  color?: MixProtocolPropertyTerm;
                  size?: MixProtocolPropertyTerm;
                  fill?: MixProtocolPropertyTerm;
                  weight?: MixProtocolPropertyTerm;
                  grade?: MixProtocolPropertyTerm;
                  opticalSize?: MixProtocolPropertyTerm;
                  opacity?: MixProtocolPropertyTerm;
                  shadows?: MixProtocolPropertyTerm;
                  applyTextScaling?: MixProtocolPropertyTerm;
                }
              | {
                  type: "intrinsic_height";
                }
              | {
                  type: "intrinsic_width";
                }
              | {
                  type: "opacity";
                  opacity: MixProtocolPropertyTerm;
                }
              | {
                  type: "padding";
                  padding: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotate";
                  radians?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotated_box";
                  quarterTurns?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scale";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scroll_view";
                  scrollDirection?: MixProtocolPropertyTerm;
                  reverse?: MixProtocolPropertyTerm;
                  padding?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "sized_box";
                  width?: MixProtocolPropertyTerm;
                  height?: MixProtocolPropertyTerm;
                }
              | {
                  type: "skew";
                  skewX?: MixProtocolPropertyTerm;
                  skewY?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "transform";
                  transform?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "translate";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                }
              | {
                  type: "visibility";
                  visible?: MixProtocolPropertyTerm;
                }
            )[];
          };
      animation?: {
        type?: "curve";
        spring?: {
          mass: number;
          stiffness: number;
          damping: number;
        };
        duration?:
          | {
              $token: string;
            }
          | number;
        curve?:
          | (
              | "linear"
              | "decelerate"
              | "fastLinearToSlowEaseIn"
              | "fastEaseInToSlowEaseOut"
              | "ease"
              | "easeIn"
              | "easeInToLinear"
              | "easeInSine"
              | "easeInQuad"
              | "easeInCubic"
              | "easeInQuart"
              | "easeInQuint"
              | "easeInExpo"
              | "easeInCirc"
              | "easeInBack"
              | "easeOut"
              | "linearToEaseOut"
              | "easeOutSine"
              | "easeOutQuad"
              | "easeOutCubic"
              | "easeOutQuart"
              | "easeOutQuint"
              | "easeOutExpo"
              | "easeOutCirc"
              | "easeOutBack"
              | "easeInOut"
              | "easeInOutSine"
              | "easeInOutQuad"
              | "easeInOutCubic"
              | "easeInOutCubicEmphasized"
              | "easeInOutQuart"
              | "easeInOutQuint"
              | "easeInOutExpo"
              | "easeInOutCirc"
              | "easeInOutBack"
              | "fastOutSlowIn"
              | "slowMiddle"
              | "bounceIn"
              | "bounceOut"
              | "bounceInOut"
              | "elasticIn"
              | "elasticOut"
              | "elasticInOut"
            )
          | {
              /**
               * @minItems 4
               * @maxItems 4
               */
              cubic: [number, number, number, number];
            };
        delay?:
          | {
              $token: string;
            }
          | number;
      };
      v: 1;
    }
  | {
      type: "stack_box";
      alignment?: MixProtocolPropertyTerm;
      padding?: MixProtocolDoublePropertyTerm;
      margin?: MixProtocolDoublePropertyTerm;
      constraints?: MixProtocolPropertyTerm;
      clipBehavior?: MixProtocolPropertyTerm;
      transform?: MixProtocolPropertyTerm;
      transformAlignment?: MixProtocolPropertyTerm;
      decoration?: MixProtocolBoxDecorationLiteral | MixProtocolPropertyControlTerm;
      stackAlignment?: MixProtocolPropertyTerm;
      fit?: MixProtocolPropertyTerm;
      textDirection?: MixProtocolPropertyTerm;
      stackClipBehavior?: MixProtocolPropertyTerm;
      variants?: (
        | {
            kind: "named";
            name: string;
            style: MixProtocolStyle;
          }
        | {
            kind: "widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "enabled";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_brightness";
            brightness: "light" | "dark";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_breakpoint";
            token?: string;
            minWidth?: number;
            maxWidth?: number;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_directionality";
            textDirection: "ltr" | "rtl";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not";
            variant: MixProtocolContextVariantSelector;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not_widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_orientation";
            orientation: "portrait" | "landscape";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_platform";
            platform: "android" | "fuchsia" | "iOS" | "linux" | "macOS" | "windows";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_web";
            style: MixProtocolStyle;
          }
      )[];
      modifiers?:
        | (
            | {
                type: "align";
                alignment?: MixProtocolPropertyTerm;
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
              }
            | {
                type: "aspect_ratio";
                aspectRatio?: MixProtocolPropertyTerm;
              }
            | {
                type: "blur";
                sigma: MixProtocolPropertyTerm;
              }
            | {
                type: "box";
                style: MixProtocolStyle;
              }
            | {
                type: "clip_oval";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_rect";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_r_rect";
                borderRadius?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_triangle";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_style";
                style?: MixProtocolPropertyTerm;
                textAlign?: MixProtocolPropertyTerm;
                softWrap?: MixProtocolPropertyTerm;
                overflow?: MixProtocolPropertyTerm;
                maxLines?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_styler";
                style: MixProtocolStyle;
              }
            | {
                type: "flexible";
                flex?: MixProtocolPropertyTerm;
                fit?: MixProtocolPropertyTerm;
              }
            | {
                type: "fractionally_sized_box";
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "icon_theme";
                color?: MixProtocolPropertyTerm;
                size?: MixProtocolPropertyTerm;
                fill?: MixProtocolPropertyTerm;
                weight?: MixProtocolPropertyTerm;
                grade?: MixProtocolPropertyTerm;
                opticalSize?: MixProtocolPropertyTerm;
                opacity?: MixProtocolPropertyTerm;
                shadows?: MixProtocolPropertyTerm;
                applyTextScaling?: MixProtocolPropertyTerm;
              }
            | {
                type: "intrinsic_height";
              }
            | {
                type: "intrinsic_width";
              }
            | {
                type: "opacity";
                opacity: MixProtocolPropertyTerm;
              }
            | {
                type: "padding";
                padding: MixProtocolPropertyTerm;
              }
            | {
                type: "rotate";
                radians?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "rotated_box";
                quarterTurns?: MixProtocolPropertyTerm;
              }
            | {
                type: "scale";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "scroll_view";
                scrollDirection?: MixProtocolPropertyTerm;
                reverse?: MixProtocolPropertyTerm;
                padding?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "sized_box";
                width?: MixProtocolPropertyTerm;
                height?: MixProtocolPropertyTerm;
              }
            | {
                type: "skew";
                skewX?: MixProtocolPropertyTerm;
                skewY?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "transform";
                transform?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "translate";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
              }
            | {
                type: "visibility";
                visible?: MixProtocolPropertyTerm;
              }
          )[]
        | {
            order?: (
              | "align"
              | "aspect_ratio"
              | "blur"
              | "box"
              | "clip_oval"
              | "clip_rect"
              | "clip_r_rect"
              | "clip_triangle"
              | "default_text_style"
              | "default_text_styler"
              | "flexible"
              | "fractionally_sized_box"
              | "icon_theme"
              | "intrinsic_height"
              | "intrinsic_width"
              | "opacity"
              | "padding"
              | "rotate"
              | "rotated_box"
              | "scale"
              | "scroll_view"
              | "sized_box"
              | "skew"
              | "transform"
              | "translate"
              | "visibility"
            )[];
            items?: (
              | {
                  type: "align";
                  alignment?: MixProtocolPropertyTerm;
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                }
              | {
                  type: "aspect_ratio";
                  aspectRatio?: MixProtocolPropertyTerm;
                }
              | {
                  type: "blur";
                  sigma: MixProtocolPropertyTerm;
                }
              | {
                  type: "box";
                  style: MixProtocolStyle;
                }
              | {
                  type: "clip_oval";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_rect";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_r_rect";
                  borderRadius?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_triangle";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_style";
                  style?: MixProtocolPropertyTerm;
                  textAlign?: MixProtocolPropertyTerm;
                  softWrap?: MixProtocolPropertyTerm;
                  overflow?: MixProtocolPropertyTerm;
                  maxLines?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_styler";
                  style: MixProtocolStyle;
                }
              | {
                  type: "flexible";
                  flex?: MixProtocolPropertyTerm;
                  fit?: MixProtocolPropertyTerm;
                }
              | {
                  type: "fractionally_sized_box";
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "icon_theme";
                  color?: MixProtocolPropertyTerm;
                  size?: MixProtocolPropertyTerm;
                  fill?: MixProtocolPropertyTerm;
                  weight?: MixProtocolPropertyTerm;
                  grade?: MixProtocolPropertyTerm;
                  opticalSize?: MixProtocolPropertyTerm;
                  opacity?: MixProtocolPropertyTerm;
                  shadows?: MixProtocolPropertyTerm;
                  applyTextScaling?: MixProtocolPropertyTerm;
                }
              | {
                  type: "intrinsic_height";
                }
              | {
                  type: "intrinsic_width";
                }
              | {
                  type: "opacity";
                  opacity: MixProtocolPropertyTerm;
                }
              | {
                  type: "padding";
                  padding: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotate";
                  radians?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotated_box";
                  quarterTurns?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scale";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scroll_view";
                  scrollDirection?: MixProtocolPropertyTerm;
                  reverse?: MixProtocolPropertyTerm;
                  padding?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "sized_box";
                  width?: MixProtocolPropertyTerm;
                  height?: MixProtocolPropertyTerm;
                }
              | {
                  type: "skew";
                  skewX?: MixProtocolPropertyTerm;
                  skewY?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "transform";
                  transform?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "translate";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                }
              | {
                  type: "visibility";
                  visible?: MixProtocolPropertyTerm;
                }
            )[];
          };
      animation?: {
        type?: "curve";
        spring?: {
          mass: number;
          stiffness: number;
          damping: number;
        };
        duration?:
          | {
              $token: string;
            }
          | number;
        curve?:
          | (
              | "linear"
              | "decelerate"
              | "fastLinearToSlowEaseIn"
              | "fastEaseInToSlowEaseOut"
              | "ease"
              | "easeIn"
              | "easeInToLinear"
              | "easeInSine"
              | "easeInQuad"
              | "easeInCubic"
              | "easeInQuart"
              | "easeInQuint"
              | "easeInExpo"
              | "easeInCirc"
              | "easeInBack"
              | "easeOut"
              | "linearToEaseOut"
              | "easeOutSine"
              | "easeOutQuad"
              | "easeOutCubic"
              | "easeOutQuart"
              | "easeOutQuint"
              | "easeOutExpo"
              | "easeOutCirc"
              | "easeOutBack"
              | "easeInOut"
              | "easeInOutSine"
              | "easeInOutQuad"
              | "easeInOutCubic"
              | "easeInOutCubicEmphasized"
              | "easeInOutQuart"
              | "easeInOutQuint"
              | "easeInOutExpo"
              | "easeInOutCirc"
              | "easeInOutBack"
              | "fastOutSlowIn"
              | "slowMiddle"
              | "bounceIn"
              | "bounceOut"
              | "bounceInOut"
              | "elasticIn"
              | "elasticOut"
              | "elasticInOut"
            )
          | {
              /**
               * @minItems 4
               * @maxItems 4
               */
              cubic: [number, number, number, number];
            };
        delay?:
          | {
              $token: string;
            }
          | number;
      };
      v: 1;
    };
export type MixProtocolPropertyTerm =
  | {
      [k: string]: any;
    }
  | MixProtocolPropertyControlTerm;
export type MixProtocolPropertyControlTerm =
  | {
      $token: string;
      /**
       * @minItems 1
       */
      apply?: [MixProtocolDirective, ...MixProtocolDirective[]];
    }
  | {
      /**
       * @minItems 2
       */
      $merge: [MixProtocolPropertyTerm, MixProtocolPropertyTerm, ...MixProtocolPropertyTerm[]];
    }
  | {
      /**
       * @minItems 1
       */
      $merge: [MixProtocolPropertyTerm, ...MixProtocolPropertyTerm[]];
      /**
       * @minItems 1
       */
      apply: [MixProtocolDirective, ...MixProtocolDirective[]];
    };
export type MixProtocolDirective =
  | {
      op: "color_opacity";
      opacity: number;
    }
  | {
      op: "color_with_values";
      alpha?: number;
      red?: number;
      green?: number;
      blue?: number;
      colorSpace?: "sRGB" | "extendedSRGB" | "displayP3";
    }
  | {
      op: "color_alpha";
      alpha: number;
    }
  | {
      op: "color_darken";
      amount: number;
    }
  | {
      op: "color_lighten";
      amount: number;
    }
  | {
      op: "color_saturate";
      amount: number;
    }
  | {
      op: "color_desaturate";
      amount: number;
    }
  | {
      op: "color_tint";
      amount: number;
    }
  | {
      op: "color_shade";
      amount: number;
    }
  | {
      op: "color_brighten";
      amount: number;
    }
  | {
      op: "color_with_red";
      red: number;
    }
  | {
      op: "color_with_green";
      green: number;
    }
  | {
      op: "color_with_blue";
      blue: number;
    }
  | {
      op: "uppercase";
    }
  | {
      op: "lowercase";
    }
  | {
      op: "capitalize";
    }
  | {
      op: "title_case";
    }
  | {
      op: "sentence_case";
    }
  | {
      op: "number_multiply";
      factor: number;
    }
  | {
      op: "number_add";
      addend: number;
    }
  | {
      op: "number_subtract";
      subtrahend: number;
    }
  | {
      op: "number_divide";
      divisor: number;
    }
  | {
      op: "number_clamp";
      min: number;
      max: number;
    }
  | {
      op: "number_abs";
    }
  | {
      op: "number_round";
    }
  | {
      op: "number_floor";
    }
  | {
      op: "number_ceil";
    };
export type MixProtocolDoublePropertyTerm =
  | {
      [k: string]: any;
    }
  | MixProtocolDoublePropertyControlTerm;
export type MixProtocolDoublePropertyControlTerm =
  | {
      $token: string;
      kind?: "space" | "double";
      /**
       * @minItems 1
       */
      apply?: [MixProtocolDirective, ...MixProtocolDirective[]];
    }
  | {
      /**
       * @minItems 2
       */
      $merge: [MixProtocolDoublePropertyTerm, MixProtocolDoublePropertyTerm, ...MixProtocolDoublePropertyTerm[]];
    }
  | {
      /**
       * @minItems 1
       */
      $merge: [MixProtocolDoublePropertyTerm, ...MixProtocolDoublePropertyTerm[]];
      /**
       * @minItems 1
       */
      apply: [MixProtocolDirective, ...MixProtocolDirective[]];
    };
export type MixProtocolStyle =
  | {
      type: "box";
      alignment?: MixProtocolPropertyTerm;
      padding?: MixProtocolPropertyTerm;
      margin?: MixProtocolPropertyTerm;
      constraints?: MixProtocolPropertyTerm;
      clipBehavior?: MixProtocolPropertyTerm;
      transform?: MixProtocolPropertyTerm;
      transformAlignment?: MixProtocolPropertyTerm;
      decoration?: MixProtocolPropertyTerm;
      foregroundDecoration?: MixProtocolPropertyTerm;
      variants?: (
        | {
            kind: "named";
            name: string;
            style: MixProtocolStyle;
          }
        | {
            kind: "widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "enabled";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_brightness";
            brightness: "light" | "dark";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_breakpoint";
            token?: string;
            minWidth?: number;
            maxWidth?: number;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_directionality";
            textDirection: "ltr" | "rtl";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not";
            variant: MixProtocolContextVariantSelector;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not_widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_orientation";
            orientation: "portrait" | "landscape";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_platform";
            platform: "android" | "fuchsia" | "iOS" | "linux" | "macOS" | "windows";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_web";
            style: MixProtocolStyle;
          }
      )[];
      modifiers?:
        | (
            | {
                type: "align";
                alignment?: MixProtocolPropertyTerm;
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
              }
            | {
                type: "aspect_ratio";
                aspectRatio?: MixProtocolPropertyTerm;
              }
            | {
                type: "blur";
                sigma: MixProtocolPropertyTerm;
              }
            | {
                type: "box";
                style: MixProtocolStyle;
              }
            | {
                type: "clip_oval";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_rect";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_r_rect";
                borderRadius?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_triangle";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_style";
                style?: MixProtocolPropertyTerm;
                textAlign?: MixProtocolPropertyTerm;
                softWrap?: MixProtocolPropertyTerm;
                overflow?: MixProtocolPropertyTerm;
                maxLines?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_styler";
                style: MixProtocolStyle;
              }
            | {
                type: "flexible";
                flex?: MixProtocolPropertyTerm;
                fit?: MixProtocolPropertyTerm;
              }
            | {
                type: "fractionally_sized_box";
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "icon_theme";
                color?: MixProtocolPropertyTerm;
                size?: MixProtocolPropertyTerm;
                fill?: MixProtocolPropertyTerm;
                weight?: MixProtocolPropertyTerm;
                grade?: MixProtocolPropertyTerm;
                opticalSize?: MixProtocolPropertyTerm;
                opacity?: MixProtocolPropertyTerm;
                shadows?: MixProtocolPropertyTerm;
                applyTextScaling?: MixProtocolPropertyTerm;
              }
            | {
                type: "intrinsic_height";
              }
            | {
                type: "intrinsic_width";
              }
            | {
                type: "opacity";
                opacity: MixProtocolPropertyTerm;
              }
            | {
                type: "padding";
                padding: MixProtocolPropertyTerm;
              }
            | {
                type: "rotate";
                radians?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "rotated_box";
                quarterTurns?: MixProtocolPropertyTerm;
              }
            | {
                type: "scale";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "scroll_view";
                scrollDirection?: MixProtocolPropertyTerm;
                reverse?: MixProtocolPropertyTerm;
                padding?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "sized_box";
                width?: MixProtocolPropertyTerm;
                height?: MixProtocolPropertyTerm;
              }
            | {
                type: "skew";
                skewX?: MixProtocolPropertyTerm;
                skewY?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "transform";
                transform?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "translate";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
              }
            | {
                type: "visibility";
                visible?: MixProtocolPropertyTerm;
              }
          )[]
        | {
            order?: (
              | "align"
              | "aspect_ratio"
              | "blur"
              | "box"
              | "clip_oval"
              | "clip_rect"
              | "clip_r_rect"
              | "clip_triangle"
              | "default_text_style"
              | "default_text_styler"
              | "flexible"
              | "fractionally_sized_box"
              | "icon_theme"
              | "intrinsic_height"
              | "intrinsic_width"
              | "opacity"
              | "padding"
              | "rotate"
              | "rotated_box"
              | "scale"
              | "scroll_view"
              | "sized_box"
              | "skew"
              | "transform"
              | "translate"
              | "visibility"
            )[];
            items?: (
              | {
                  type: "align";
                  alignment?: MixProtocolPropertyTerm;
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                }
              | {
                  type: "aspect_ratio";
                  aspectRatio?: MixProtocolPropertyTerm;
                }
              | {
                  type: "blur";
                  sigma: MixProtocolPropertyTerm;
                }
              | {
                  type: "box";
                  style: MixProtocolStyle;
                }
              | {
                  type: "clip_oval";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_rect";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_r_rect";
                  borderRadius?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_triangle";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_style";
                  style?: MixProtocolPropertyTerm;
                  textAlign?: MixProtocolPropertyTerm;
                  softWrap?: MixProtocolPropertyTerm;
                  overflow?: MixProtocolPropertyTerm;
                  maxLines?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_styler";
                  style: MixProtocolStyle;
                }
              | {
                  type: "flexible";
                  flex?: MixProtocolPropertyTerm;
                  fit?: MixProtocolPropertyTerm;
                }
              | {
                  type: "fractionally_sized_box";
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "icon_theme";
                  color?: MixProtocolPropertyTerm;
                  size?: MixProtocolPropertyTerm;
                  fill?: MixProtocolPropertyTerm;
                  weight?: MixProtocolPropertyTerm;
                  grade?: MixProtocolPropertyTerm;
                  opticalSize?: MixProtocolPropertyTerm;
                  opacity?: MixProtocolPropertyTerm;
                  shadows?: MixProtocolPropertyTerm;
                  applyTextScaling?: MixProtocolPropertyTerm;
                }
              | {
                  type: "intrinsic_height";
                }
              | {
                  type: "intrinsic_width";
                }
              | {
                  type: "opacity";
                  opacity: MixProtocolPropertyTerm;
                }
              | {
                  type: "padding";
                  padding: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotate";
                  radians?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotated_box";
                  quarterTurns?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scale";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scroll_view";
                  scrollDirection?: MixProtocolPropertyTerm;
                  reverse?: MixProtocolPropertyTerm;
                  padding?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "sized_box";
                  width?: MixProtocolPropertyTerm;
                  height?: MixProtocolPropertyTerm;
                }
              | {
                  type: "skew";
                  skewX?: MixProtocolPropertyTerm;
                  skewY?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "transform";
                  transform?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "translate";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                }
              | {
                  type: "visibility";
                  visible?: MixProtocolPropertyTerm;
                }
            )[];
          };
      animation?: {
        type?: "curve";
        spring?: {
          mass: number;
          stiffness: number;
          damping: number;
        };
        duration?:
          | {
              $token: string;
            }
          | number;
        curve?:
          | (
              | "linear"
              | "decelerate"
              | "fastLinearToSlowEaseIn"
              | "fastEaseInToSlowEaseOut"
              | "ease"
              | "easeIn"
              | "easeInToLinear"
              | "easeInSine"
              | "easeInQuad"
              | "easeInCubic"
              | "easeInQuart"
              | "easeInQuint"
              | "easeInExpo"
              | "easeInCirc"
              | "easeInBack"
              | "easeOut"
              | "linearToEaseOut"
              | "easeOutSine"
              | "easeOutQuad"
              | "easeOutCubic"
              | "easeOutQuart"
              | "easeOutQuint"
              | "easeOutExpo"
              | "easeOutCirc"
              | "easeOutBack"
              | "easeInOut"
              | "easeInOutSine"
              | "easeInOutQuad"
              | "easeInOutCubic"
              | "easeInOutCubicEmphasized"
              | "easeInOutQuart"
              | "easeInOutQuint"
              | "easeInOutExpo"
              | "easeInOutCirc"
              | "easeInOutBack"
              | "fastOutSlowIn"
              | "slowMiddle"
              | "bounceIn"
              | "bounceOut"
              | "bounceInOut"
              | "elasticIn"
              | "elasticOut"
              | "elasticInOut"
            )
          | {
              /**
               * @minItems 4
               * @maxItems 4
               */
              cubic: [number, number, number, number];
            };
        delay?:
          | {
              $token: string;
            }
          | number;
      };
    }
  | {
      type: "text";
      overflow?: MixProtocolPropertyTerm;
      strutStyle?: MixProtocolPropertyTerm;
      textAlign?: MixProtocolPropertyTerm;
      textScaler?: MixProtocolPropertyTerm;
      maxLines?: MixProtocolPropertyTerm;
      style?: MixProtocolPropertyTerm;
      textWidthBasis?: MixProtocolPropertyTerm;
      textDirection?: MixProtocolPropertyTerm;
      softWrap?: MixProtocolPropertyTerm;
      selectionColor?: MixProtocolPropertyTerm;
      semanticsLabel?: MixProtocolPropertyTerm;
      locale?: MixProtocolPropertyTerm;
      textHeightBehavior?: MixProtocolPropertyTerm;
      textDirectives?: ("uppercase" | "lowercase" | "capitalize" | "title_case" | "sentence_case")[];
      variants?: (
        | {
            kind: "named";
            name: string;
            style: MixProtocolStyle;
          }
        | {
            kind: "widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "enabled";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_brightness";
            brightness: "light" | "dark";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_breakpoint";
            token?: string;
            minWidth?: number;
            maxWidth?: number;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_directionality";
            textDirection: "ltr" | "rtl";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not";
            variant: MixProtocolContextVariantSelector;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not_widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_orientation";
            orientation: "portrait" | "landscape";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_platform";
            platform: "android" | "fuchsia" | "iOS" | "linux" | "macOS" | "windows";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_web";
            style: MixProtocolStyle;
          }
      )[];
      modifiers?:
        | (
            | {
                type: "align";
                alignment?: MixProtocolPropertyTerm;
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
              }
            | {
                type: "aspect_ratio";
                aspectRatio?: MixProtocolPropertyTerm;
              }
            | {
                type: "blur";
                sigma: MixProtocolPropertyTerm;
              }
            | {
                type: "box";
                style: MixProtocolStyle;
              }
            | {
                type: "clip_oval";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_rect";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_r_rect";
                borderRadius?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_triangle";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_style";
                style?: MixProtocolPropertyTerm;
                textAlign?: MixProtocolPropertyTerm;
                softWrap?: MixProtocolPropertyTerm;
                overflow?: MixProtocolPropertyTerm;
                maxLines?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_styler";
                style: MixProtocolStyle;
              }
            | {
                type: "flexible";
                flex?: MixProtocolPropertyTerm;
                fit?: MixProtocolPropertyTerm;
              }
            | {
                type: "fractionally_sized_box";
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "icon_theme";
                color?: MixProtocolPropertyTerm;
                size?: MixProtocolPropertyTerm;
                fill?: MixProtocolPropertyTerm;
                weight?: MixProtocolPropertyTerm;
                grade?: MixProtocolPropertyTerm;
                opticalSize?: MixProtocolPropertyTerm;
                opacity?: MixProtocolPropertyTerm;
                shadows?: MixProtocolPropertyTerm;
                applyTextScaling?: MixProtocolPropertyTerm;
              }
            | {
                type: "intrinsic_height";
              }
            | {
                type: "intrinsic_width";
              }
            | {
                type: "opacity";
                opacity: MixProtocolPropertyTerm;
              }
            | {
                type: "padding";
                padding: MixProtocolPropertyTerm;
              }
            | {
                type: "rotate";
                radians?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "rotated_box";
                quarterTurns?: MixProtocolPropertyTerm;
              }
            | {
                type: "scale";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "scroll_view";
                scrollDirection?: MixProtocolPropertyTerm;
                reverse?: MixProtocolPropertyTerm;
                padding?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "sized_box";
                width?: MixProtocolPropertyTerm;
                height?: MixProtocolPropertyTerm;
              }
            | {
                type: "skew";
                skewX?: MixProtocolPropertyTerm;
                skewY?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "transform";
                transform?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "translate";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
              }
            | {
                type: "visibility";
                visible?: MixProtocolPropertyTerm;
              }
          )[]
        | {
            order?: (
              | "align"
              | "aspect_ratio"
              | "blur"
              | "box"
              | "clip_oval"
              | "clip_rect"
              | "clip_r_rect"
              | "clip_triangle"
              | "default_text_style"
              | "default_text_styler"
              | "flexible"
              | "fractionally_sized_box"
              | "icon_theme"
              | "intrinsic_height"
              | "intrinsic_width"
              | "opacity"
              | "padding"
              | "rotate"
              | "rotated_box"
              | "scale"
              | "scroll_view"
              | "sized_box"
              | "skew"
              | "transform"
              | "translate"
              | "visibility"
            )[];
            items?: (
              | {
                  type: "align";
                  alignment?: MixProtocolPropertyTerm;
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                }
              | {
                  type: "aspect_ratio";
                  aspectRatio?: MixProtocolPropertyTerm;
                }
              | {
                  type: "blur";
                  sigma: MixProtocolPropertyTerm;
                }
              | {
                  type: "box";
                  style: MixProtocolStyle;
                }
              | {
                  type: "clip_oval";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_rect";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_r_rect";
                  borderRadius?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_triangle";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_style";
                  style?: MixProtocolPropertyTerm;
                  textAlign?: MixProtocolPropertyTerm;
                  softWrap?: MixProtocolPropertyTerm;
                  overflow?: MixProtocolPropertyTerm;
                  maxLines?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_styler";
                  style: MixProtocolStyle;
                }
              | {
                  type: "flexible";
                  flex?: MixProtocolPropertyTerm;
                  fit?: MixProtocolPropertyTerm;
                }
              | {
                  type: "fractionally_sized_box";
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "icon_theme";
                  color?: MixProtocolPropertyTerm;
                  size?: MixProtocolPropertyTerm;
                  fill?: MixProtocolPropertyTerm;
                  weight?: MixProtocolPropertyTerm;
                  grade?: MixProtocolPropertyTerm;
                  opticalSize?: MixProtocolPropertyTerm;
                  opacity?: MixProtocolPropertyTerm;
                  shadows?: MixProtocolPropertyTerm;
                  applyTextScaling?: MixProtocolPropertyTerm;
                }
              | {
                  type: "intrinsic_height";
                }
              | {
                  type: "intrinsic_width";
                }
              | {
                  type: "opacity";
                  opacity: MixProtocolPropertyTerm;
                }
              | {
                  type: "padding";
                  padding: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotate";
                  radians?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotated_box";
                  quarterTurns?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scale";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scroll_view";
                  scrollDirection?: MixProtocolPropertyTerm;
                  reverse?: MixProtocolPropertyTerm;
                  padding?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "sized_box";
                  width?: MixProtocolPropertyTerm;
                  height?: MixProtocolPropertyTerm;
                }
              | {
                  type: "skew";
                  skewX?: MixProtocolPropertyTerm;
                  skewY?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "transform";
                  transform?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "translate";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                }
              | {
                  type: "visibility";
                  visible?: MixProtocolPropertyTerm;
                }
            )[];
          };
      animation?: {
        type?: "curve";
        spring?: {
          mass: number;
          stiffness: number;
          damping: number;
        };
        duration?:
          | {
              $token: string;
            }
          | number;
        curve?:
          | (
              | "linear"
              | "decelerate"
              | "fastLinearToSlowEaseIn"
              | "fastEaseInToSlowEaseOut"
              | "ease"
              | "easeIn"
              | "easeInToLinear"
              | "easeInSine"
              | "easeInQuad"
              | "easeInCubic"
              | "easeInQuart"
              | "easeInQuint"
              | "easeInExpo"
              | "easeInCirc"
              | "easeInBack"
              | "easeOut"
              | "linearToEaseOut"
              | "easeOutSine"
              | "easeOutQuad"
              | "easeOutCubic"
              | "easeOutQuart"
              | "easeOutQuint"
              | "easeOutExpo"
              | "easeOutCirc"
              | "easeOutBack"
              | "easeInOut"
              | "easeInOutSine"
              | "easeInOutQuad"
              | "easeInOutCubic"
              | "easeInOutCubicEmphasized"
              | "easeInOutQuart"
              | "easeInOutQuint"
              | "easeInOutExpo"
              | "easeInOutCirc"
              | "easeInOutBack"
              | "fastOutSlowIn"
              | "slowMiddle"
              | "bounceIn"
              | "bounceOut"
              | "bounceInOut"
              | "elasticIn"
              | "elasticOut"
              | "elasticInOut"
            )
          | {
              /**
               * @minItems 4
               * @maxItems 4
               */
              cubic: [number, number, number, number];
            };
        delay?:
          | {
              $token: string;
            }
          | number;
      };
    }
  | {
      type: "flex";
      direction?: MixProtocolPropertyTerm;
      mainAxisAlignment?: MixProtocolPropertyTerm;
      crossAxisAlignment?: MixProtocolPropertyTerm;
      mainAxisSize?: MixProtocolPropertyTerm;
      verticalDirection?: MixProtocolPropertyTerm;
      textDirection?: MixProtocolPropertyTerm;
      textBaseline?: MixProtocolPropertyTerm;
      clipBehavior?: MixProtocolPropertyTerm;
      spacing?: MixProtocolPropertyTerm;
      variants?: (
        | {
            kind: "named";
            name: string;
            style: MixProtocolStyle;
          }
        | {
            kind: "widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "enabled";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_brightness";
            brightness: "light" | "dark";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_breakpoint";
            token?: string;
            minWidth?: number;
            maxWidth?: number;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_directionality";
            textDirection: "ltr" | "rtl";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not";
            variant: MixProtocolContextVariantSelector;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not_widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_orientation";
            orientation: "portrait" | "landscape";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_platform";
            platform: "android" | "fuchsia" | "iOS" | "linux" | "macOS" | "windows";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_web";
            style: MixProtocolStyle;
          }
      )[];
      modifiers?:
        | (
            | {
                type: "align";
                alignment?: MixProtocolPropertyTerm;
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
              }
            | {
                type: "aspect_ratio";
                aspectRatio?: MixProtocolPropertyTerm;
              }
            | {
                type: "blur";
                sigma: MixProtocolPropertyTerm;
              }
            | {
                type: "box";
                style: MixProtocolStyle;
              }
            | {
                type: "clip_oval";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_rect";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_r_rect";
                borderRadius?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_triangle";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_style";
                style?: MixProtocolPropertyTerm;
                textAlign?: MixProtocolPropertyTerm;
                softWrap?: MixProtocolPropertyTerm;
                overflow?: MixProtocolPropertyTerm;
                maxLines?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_styler";
                style: MixProtocolStyle;
              }
            | {
                type: "flexible";
                flex?: MixProtocolPropertyTerm;
                fit?: MixProtocolPropertyTerm;
              }
            | {
                type: "fractionally_sized_box";
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "icon_theme";
                color?: MixProtocolPropertyTerm;
                size?: MixProtocolPropertyTerm;
                fill?: MixProtocolPropertyTerm;
                weight?: MixProtocolPropertyTerm;
                grade?: MixProtocolPropertyTerm;
                opticalSize?: MixProtocolPropertyTerm;
                opacity?: MixProtocolPropertyTerm;
                shadows?: MixProtocolPropertyTerm;
                applyTextScaling?: MixProtocolPropertyTerm;
              }
            | {
                type: "intrinsic_height";
              }
            | {
                type: "intrinsic_width";
              }
            | {
                type: "opacity";
                opacity: MixProtocolPropertyTerm;
              }
            | {
                type: "padding";
                padding: MixProtocolPropertyTerm;
              }
            | {
                type: "rotate";
                radians?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "rotated_box";
                quarterTurns?: MixProtocolPropertyTerm;
              }
            | {
                type: "scale";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "scroll_view";
                scrollDirection?: MixProtocolPropertyTerm;
                reverse?: MixProtocolPropertyTerm;
                padding?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "sized_box";
                width?: MixProtocolPropertyTerm;
                height?: MixProtocolPropertyTerm;
              }
            | {
                type: "skew";
                skewX?: MixProtocolPropertyTerm;
                skewY?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "transform";
                transform?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "translate";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
              }
            | {
                type: "visibility";
                visible?: MixProtocolPropertyTerm;
              }
          )[]
        | {
            order?: (
              | "align"
              | "aspect_ratio"
              | "blur"
              | "box"
              | "clip_oval"
              | "clip_rect"
              | "clip_r_rect"
              | "clip_triangle"
              | "default_text_style"
              | "default_text_styler"
              | "flexible"
              | "fractionally_sized_box"
              | "icon_theme"
              | "intrinsic_height"
              | "intrinsic_width"
              | "opacity"
              | "padding"
              | "rotate"
              | "rotated_box"
              | "scale"
              | "scroll_view"
              | "sized_box"
              | "skew"
              | "transform"
              | "translate"
              | "visibility"
            )[];
            items?: (
              | {
                  type: "align";
                  alignment?: MixProtocolPropertyTerm;
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                }
              | {
                  type: "aspect_ratio";
                  aspectRatio?: MixProtocolPropertyTerm;
                }
              | {
                  type: "blur";
                  sigma: MixProtocolPropertyTerm;
                }
              | {
                  type: "box";
                  style: MixProtocolStyle;
                }
              | {
                  type: "clip_oval";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_rect";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_r_rect";
                  borderRadius?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_triangle";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_style";
                  style?: MixProtocolPropertyTerm;
                  textAlign?: MixProtocolPropertyTerm;
                  softWrap?: MixProtocolPropertyTerm;
                  overflow?: MixProtocolPropertyTerm;
                  maxLines?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_styler";
                  style: MixProtocolStyle;
                }
              | {
                  type: "flexible";
                  flex?: MixProtocolPropertyTerm;
                  fit?: MixProtocolPropertyTerm;
                }
              | {
                  type: "fractionally_sized_box";
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "icon_theme";
                  color?: MixProtocolPropertyTerm;
                  size?: MixProtocolPropertyTerm;
                  fill?: MixProtocolPropertyTerm;
                  weight?: MixProtocolPropertyTerm;
                  grade?: MixProtocolPropertyTerm;
                  opticalSize?: MixProtocolPropertyTerm;
                  opacity?: MixProtocolPropertyTerm;
                  shadows?: MixProtocolPropertyTerm;
                  applyTextScaling?: MixProtocolPropertyTerm;
                }
              | {
                  type: "intrinsic_height";
                }
              | {
                  type: "intrinsic_width";
                }
              | {
                  type: "opacity";
                  opacity: MixProtocolPropertyTerm;
                }
              | {
                  type: "padding";
                  padding: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotate";
                  radians?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotated_box";
                  quarterTurns?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scale";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scroll_view";
                  scrollDirection?: MixProtocolPropertyTerm;
                  reverse?: MixProtocolPropertyTerm;
                  padding?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "sized_box";
                  width?: MixProtocolPropertyTerm;
                  height?: MixProtocolPropertyTerm;
                }
              | {
                  type: "skew";
                  skewX?: MixProtocolPropertyTerm;
                  skewY?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "transform";
                  transform?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "translate";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                }
              | {
                  type: "visibility";
                  visible?: MixProtocolPropertyTerm;
                }
            )[];
          };
      animation?: {
        type?: "curve";
        spring?: {
          mass: number;
          stiffness: number;
          damping: number;
        };
        duration?:
          | {
              $token: string;
            }
          | number;
        curve?:
          | (
              | "linear"
              | "decelerate"
              | "fastLinearToSlowEaseIn"
              | "fastEaseInToSlowEaseOut"
              | "ease"
              | "easeIn"
              | "easeInToLinear"
              | "easeInSine"
              | "easeInQuad"
              | "easeInCubic"
              | "easeInQuart"
              | "easeInQuint"
              | "easeInExpo"
              | "easeInCirc"
              | "easeInBack"
              | "easeOut"
              | "linearToEaseOut"
              | "easeOutSine"
              | "easeOutQuad"
              | "easeOutCubic"
              | "easeOutQuart"
              | "easeOutQuint"
              | "easeOutExpo"
              | "easeOutCirc"
              | "easeOutBack"
              | "easeInOut"
              | "easeInOutSine"
              | "easeInOutQuad"
              | "easeInOutCubic"
              | "easeInOutCubicEmphasized"
              | "easeInOutQuart"
              | "easeInOutQuint"
              | "easeInOutExpo"
              | "easeInOutCirc"
              | "easeInOutBack"
              | "fastOutSlowIn"
              | "slowMiddle"
              | "bounceIn"
              | "bounceOut"
              | "bounceInOut"
              | "elasticIn"
              | "elasticOut"
              | "elasticInOut"
            )
          | {
              /**
               * @minItems 4
               * @maxItems 4
               */
              cubic: [number, number, number, number];
            };
        delay?:
          | {
              $token: string;
            }
          | number;
      };
    }
  | {
      type: "stack";
      alignment?: MixProtocolPropertyTerm;
      fit?: MixProtocolPropertyTerm;
      textDirection?: MixProtocolPropertyTerm;
      clipBehavior?: MixProtocolPropertyTerm;
      variants?: (
        | {
            kind: "named";
            name: string;
            style: MixProtocolStyle;
          }
        | {
            kind: "widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "enabled";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_brightness";
            brightness: "light" | "dark";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_breakpoint";
            token?: string;
            minWidth?: number;
            maxWidth?: number;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_directionality";
            textDirection: "ltr" | "rtl";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not";
            variant: MixProtocolContextVariantSelector;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not_widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_orientation";
            orientation: "portrait" | "landscape";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_platform";
            platform: "android" | "fuchsia" | "iOS" | "linux" | "macOS" | "windows";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_web";
            style: MixProtocolStyle;
          }
      )[];
      modifiers?:
        | (
            | {
                type: "align";
                alignment?: MixProtocolPropertyTerm;
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
              }
            | {
                type: "aspect_ratio";
                aspectRatio?: MixProtocolPropertyTerm;
              }
            | {
                type: "blur";
                sigma: MixProtocolPropertyTerm;
              }
            | {
                type: "box";
                style: MixProtocolStyle;
              }
            | {
                type: "clip_oval";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_rect";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_r_rect";
                borderRadius?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_triangle";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_style";
                style?: MixProtocolPropertyTerm;
                textAlign?: MixProtocolPropertyTerm;
                softWrap?: MixProtocolPropertyTerm;
                overflow?: MixProtocolPropertyTerm;
                maxLines?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_styler";
                style: MixProtocolStyle;
              }
            | {
                type: "flexible";
                flex?: MixProtocolPropertyTerm;
                fit?: MixProtocolPropertyTerm;
              }
            | {
                type: "fractionally_sized_box";
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "icon_theme";
                color?: MixProtocolPropertyTerm;
                size?: MixProtocolPropertyTerm;
                fill?: MixProtocolPropertyTerm;
                weight?: MixProtocolPropertyTerm;
                grade?: MixProtocolPropertyTerm;
                opticalSize?: MixProtocolPropertyTerm;
                opacity?: MixProtocolPropertyTerm;
                shadows?: MixProtocolPropertyTerm;
                applyTextScaling?: MixProtocolPropertyTerm;
              }
            | {
                type: "intrinsic_height";
              }
            | {
                type: "intrinsic_width";
              }
            | {
                type: "opacity";
                opacity: MixProtocolPropertyTerm;
              }
            | {
                type: "padding";
                padding: MixProtocolPropertyTerm;
              }
            | {
                type: "rotate";
                radians?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "rotated_box";
                quarterTurns?: MixProtocolPropertyTerm;
              }
            | {
                type: "scale";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "scroll_view";
                scrollDirection?: MixProtocolPropertyTerm;
                reverse?: MixProtocolPropertyTerm;
                padding?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "sized_box";
                width?: MixProtocolPropertyTerm;
                height?: MixProtocolPropertyTerm;
              }
            | {
                type: "skew";
                skewX?: MixProtocolPropertyTerm;
                skewY?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "transform";
                transform?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "translate";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
              }
            | {
                type: "visibility";
                visible?: MixProtocolPropertyTerm;
              }
          )[]
        | {
            order?: (
              | "align"
              | "aspect_ratio"
              | "blur"
              | "box"
              | "clip_oval"
              | "clip_rect"
              | "clip_r_rect"
              | "clip_triangle"
              | "default_text_style"
              | "default_text_styler"
              | "flexible"
              | "fractionally_sized_box"
              | "icon_theme"
              | "intrinsic_height"
              | "intrinsic_width"
              | "opacity"
              | "padding"
              | "rotate"
              | "rotated_box"
              | "scale"
              | "scroll_view"
              | "sized_box"
              | "skew"
              | "transform"
              | "translate"
              | "visibility"
            )[];
            items?: (
              | {
                  type: "align";
                  alignment?: MixProtocolPropertyTerm;
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                }
              | {
                  type: "aspect_ratio";
                  aspectRatio?: MixProtocolPropertyTerm;
                }
              | {
                  type: "blur";
                  sigma: MixProtocolPropertyTerm;
                }
              | {
                  type: "box";
                  style: MixProtocolStyle;
                }
              | {
                  type: "clip_oval";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_rect";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_r_rect";
                  borderRadius?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_triangle";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_style";
                  style?: MixProtocolPropertyTerm;
                  textAlign?: MixProtocolPropertyTerm;
                  softWrap?: MixProtocolPropertyTerm;
                  overflow?: MixProtocolPropertyTerm;
                  maxLines?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_styler";
                  style: MixProtocolStyle;
                }
              | {
                  type: "flexible";
                  flex?: MixProtocolPropertyTerm;
                  fit?: MixProtocolPropertyTerm;
                }
              | {
                  type: "fractionally_sized_box";
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "icon_theme";
                  color?: MixProtocolPropertyTerm;
                  size?: MixProtocolPropertyTerm;
                  fill?: MixProtocolPropertyTerm;
                  weight?: MixProtocolPropertyTerm;
                  grade?: MixProtocolPropertyTerm;
                  opticalSize?: MixProtocolPropertyTerm;
                  opacity?: MixProtocolPropertyTerm;
                  shadows?: MixProtocolPropertyTerm;
                  applyTextScaling?: MixProtocolPropertyTerm;
                }
              | {
                  type: "intrinsic_height";
                }
              | {
                  type: "intrinsic_width";
                }
              | {
                  type: "opacity";
                  opacity: MixProtocolPropertyTerm;
                }
              | {
                  type: "padding";
                  padding: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotate";
                  radians?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotated_box";
                  quarterTurns?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scale";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scroll_view";
                  scrollDirection?: MixProtocolPropertyTerm;
                  reverse?: MixProtocolPropertyTerm;
                  padding?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "sized_box";
                  width?: MixProtocolPropertyTerm;
                  height?: MixProtocolPropertyTerm;
                }
              | {
                  type: "skew";
                  skewX?: MixProtocolPropertyTerm;
                  skewY?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "transform";
                  transform?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "translate";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                }
              | {
                  type: "visibility";
                  visible?: MixProtocolPropertyTerm;
                }
            )[];
          };
      animation?: {
        type?: "curve";
        spring?: {
          mass: number;
          stiffness: number;
          damping: number;
        };
        duration?:
          | {
              $token: string;
            }
          | number;
        curve?:
          | (
              | "linear"
              | "decelerate"
              | "fastLinearToSlowEaseIn"
              | "fastEaseInToSlowEaseOut"
              | "ease"
              | "easeIn"
              | "easeInToLinear"
              | "easeInSine"
              | "easeInQuad"
              | "easeInCubic"
              | "easeInQuart"
              | "easeInQuint"
              | "easeInExpo"
              | "easeInCirc"
              | "easeInBack"
              | "easeOut"
              | "linearToEaseOut"
              | "easeOutSine"
              | "easeOutQuad"
              | "easeOutCubic"
              | "easeOutQuart"
              | "easeOutQuint"
              | "easeOutExpo"
              | "easeOutCirc"
              | "easeOutBack"
              | "easeInOut"
              | "easeInOutSine"
              | "easeInOutQuad"
              | "easeInOutCubic"
              | "easeInOutCubicEmphasized"
              | "easeInOutQuart"
              | "easeInOutQuint"
              | "easeInOutExpo"
              | "easeInOutCirc"
              | "easeInOutBack"
              | "fastOutSlowIn"
              | "slowMiddle"
              | "bounceIn"
              | "bounceOut"
              | "bounceInOut"
              | "elasticIn"
              | "elasticOut"
              | "elasticInOut"
            )
          | {
              /**
               * @minItems 4
               * @maxItems 4
               */
              cubic: [number, number, number, number];
            };
        delay?:
          | {
              $token: string;
            }
          | number;
      };
    }
  | {
      type: "icon";
      icon?: MixProtocolPropertyTerm;
      color?: MixProtocolPropertyTerm;
      size?: MixProtocolPropertyTerm;
      weight?: MixProtocolPropertyTerm;
      grade?: MixProtocolPropertyTerm;
      opticalSize?: MixProtocolPropertyTerm;
      shadows?: MixProtocolPropertyTerm;
      textDirection?: MixProtocolPropertyTerm;
      applyTextScaling?: MixProtocolPropertyTerm;
      fill?: MixProtocolPropertyTerm;
      semanticsLabel?: MixProtocolPropertyTerm;
      opacity?: MixProtocolPropertyTerm;
      blendMode?: MixProtocolPropertyTerm;
      variants?: (
        | {
            kind: "named";
            name: string;
            style: MixProtocolStyle;
          }
        | {
            kind: "widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "enabled";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_brightness";
            brightness: "light" | "dark";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_breakpoint";
            token?: string;
            minWidth?: number;
            maxWidth?: number;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_directionality";
            textDirection: "ltr" | "rtl";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not";
            variant: MixProtocolContextVariantSelector;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not_widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_orientation";
            orientation: "portrait" | "landscape";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_platform";
            platform: "android" | "fuchsia" | "iOS" | "linux" | "macOS" | "windows";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_web";
            style: MixProtocolStyle;
          }
      )[];
      modifiers?:
        | (
            | {
                type: "align";
                alignment?: MixProtocolPropertyTerm;
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
              }
            | {
                type: "aspect_ratio";
                aspectRatio?: MixProtocolPropertyTerm;
              }
            | {
                type: "blur";
                sigma: MixProtocolPropertyTerm;
              }
            | {
                type: "box";
                style: MixProtocolStyle;
              }
            | {
                type: "clip_oval";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_rect";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_r_rect";
                borderRadius?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_triangle";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_style";
                style?: MixProtocolPropertyTerm;
                textAlign?: MixProtocolPropertyTerm;
                softWrap?: MixProtocolPropertyTerm;
                overflow?: MixProtocolPropertyTerm;
                maxLines?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_styler";
                style: MixProtocolStyle;
              }
            | {
                type: "flexible";
                flex?: MixProtocolPropertyTerm;
                fit?: MixProtocolPropertyTerm;
              }
            | {
                type: "fractionally_sized_box";
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "icon_theme";
                color?: MixProtocolPropertyTerm;
                size?: MixProtocolPropertyTerm;
                fill?: MixProtocolPropertyTerm;
                weight?: MixProtocolPropertyTerm;
                grade?: MixProtocolPropertyTerm;
                opticalSize?: MixProtocolPropertyTerm;
                opacity?: MixProtocolPropertyTerm;
                shadows?: MixProtocolPropertyTerm;
                applyTextScaling?: MixProtocolPropertyTerm;
              }
            | {
                type: "intrinsic_height";
              }
            | {
                type: "intrinsic_width";
              }
            | {
                type: "opacity";
                opacity: MixProtocolPropertyTerm;
              }
            | {
                type: "padding";
                padding: MixProtocolPropertyTerm;
              }
            | {
                type: "rotate";
                radians?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "rotated_box";
                quarterTurns?: MixProtocolPropertyTerm;
              }
            | {
                type: "scale";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "scroll_view";
                scrollDirection?: MixProtocolPropertyTerm;
                reverse?: MixProtocolPropertyTerm;
                padding?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "sized_box";
                width?: MixProtocolPropertyTerm;
                height?: MixProtocolPropertyTerm;
              }
            | {
                type: "skew";
                skewX?: MixProtocolPropertyTerm;
                skewY?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "transform";
                transform?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "translate";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
              }
            | {
                type: "visibility";
                visible?: MixProtocolPropertyTerm;
              }
          )[]
        | {
            order?: (
              | "align"
              | "aspect_ratio"
              | "blur"
              | "box"
              | "clip_oval"
              | "clip_rect"
              | "clip_r_rect"
              | "clip_triangle"
              | "default_text_style"
              | "default_text_styler"
              | "flexible"
              | "fractionally_sized_box"
              | "icon_theme"
              | "intrinsic_height"
              | "intrinsic_width"
              | "opacity"
              | "padding"
              | "rotate"
              | "rotated_box"
              | "scale"
              | "scroll_view"
              | "sized_box"
              | "skew"
              | "transform"
              | "translate"
              | "visibility"
            )[];
            items?: (
              | {
                  type: "align";
                  alignment?: MixProtocolPropertyTerm;
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                }
              | {
                  type: "aspect_ratio";
                  aspectRatio?: MixProtocolPropertyTerm;
                }
              | {
                  type: "blur";
                  sigma: MixProtocolPropertyTerm;
                }
              | {
                  type: "box";
                  style: MixProtocolStyle;
                }
              | {
                  type: "clip_oval";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_rect";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_r_rect";
                  borderRadius?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_triangle";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_style";
                  style?: MixProtocolPropertyTerm;
                  textAlign?: MixProtocolPropertyTerm;
                  softWrap?: MixProtocolPropertyTerm;
                  overflow?: MixProtocolPropertyTerm;
                  maxLines?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_styler";
                  style: MixProtocolStyle;
                }
              | {
                  type: "flexible";
                  flex?: MixProtocolPropertyTerm;
                  fit?: MixProtocolPropertyTerm;
                }
              | {
                  type: "fractionally_sized_box";
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "icon_theme";
                  color?: MixProtocolPropertyTerm;
                  size?: MixProtocolPropertyTerm;
                  fill?: MixProtocolPropertyTerm;
                  weight?: MixProtocolPropertyTerm;
                  grade?: MixProtocolPropertyTerm;
                  opticalSize?: MixProtocolPropertyTerm;
                  opacity?: MixProtocolPropertyTerm;
                  shadows?: MixProtocolPropertyTerm;
                  applyTextScaling?: MixProtocolPropertyTerm;
                }
              | {
                  type: "intrinsic_height";
                }
              | {
                  type: "intrinsic_width";
                }
              | {
                  type: "opacity";
                  opacity: MixProtocolPropertyTerm;
                }
              | {
                  type: "padding";
                  padding: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotate";
                  radians?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotated_box";
                  quarterTurns?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scale";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scroll_view";
                  scrollDirection?: MixProtocolPropertyTerm;
                  reverse?: MixProtocolPropertyTerm;
                  padding?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "sized_box";
                  width?: MixProtocolPropertyTerm;
                  height?: MixProtocolPropertyTerm;
                }
              | {
                  type: "skew";
                  skewX?: MixProtocolPropertyTerm;
                  skewY?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "transform";
                  transform?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "translate";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                }
              | {
                  type: "visibility";
                  visible?: MixProtocolPropertyTerm;
                }
            )[];
          };
      animation?: {
        type?: "curve";
        spring?: {
          mass: number;
          stiffness: number;
          damping: number;
        };
        duration?:
          | {
              $token: string;
            }
          | number;
        curve?:
          | (
              | "linear"
              | "decelerate"
              | "fastLinearToSlowEaseIn"
              | "fastEaseInToSlowEaseOut"
              | "ease"
              | "easeIn"
              | "easeInToLinear"
              | "easeInSine"
              | "easeInQuad"
              | "easeInCubic"
              | "easeInQuart"
              | "easeInQuint"
              | "easeInExpo"
              | "easeInCirc"
              | "easeInBack"
              | "easeOut"
              | "linearToEaseOut"
              | "easeOutSine"
              | "easeOutQuad"
              | "easeOutCubic"
              | "easeOutQuart"
              | "easeOutQuint"
              | "easeOutExpo"
              | "easeOutCirc"
              | "easeOutBack"
              | "easeInOut"
              | "easeInOutSine"
              | "easeInOutQuad"
              | "easeInOutCubic"
              | "easeInOutCubicEmphasized"
              | "easeInOutQuart"
              | "easeInOutQuint"
              | "easeInOutExpo"
              | "easeInOutCirc"
              | "easeInOutBack"
              | "fastOutSlowIn"
              | "slowMiddle"
              | "bounceIn"
              | "bounceOut"
              | "bounceInOut"
              | "elasticIn"
              | "elasticOut"
              | "elasticInOut"
            )
          | {
              /**
               * @minItems 4
               * @maxItems 4
               */
              cubic: [number, number, number, number];
            };
        delay?:
          | {
              $token: string;
            }
          | number;
      };
    }
  | {
      type: "image";
      image?: MixProtocolPropertyTerm;
      width?: MixProtocolPropertyTerm;
      height?: MixProtocolPropertyTerm;
      color?: MixProtocolPropertyTerm;
      repeat?: MixProtocolPropertyTerm;
      fit?: MixProtocolPropertyTerm;
      alignment?: MixProtocolPropertyTerm;
      centerSlice?: MixProtocolPropertyTerm;
      filterQuality?: MixProtocolPropertyTerm;
      colorBlendMode?: MixProtocolPropertyTerm;
      semanticLabel?: MixProtocolPropertyTerm;
      excludeFromSemantics?: MixProtocolPropertyTerm;
      gaplessPlayback?: MixProtocolPropertyTerm;
      isAntiAlias?: MixProtocolPropertyTerm;
      matchTextDirection?: MixProtocolPropertyTerm;
      variants?: (
        | {
            kind: "named";
            name: string;
            style: MixProtocolStyle;
          }
        | {
            kind: "widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "enabled";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_brightness";
            brightness: "light" | "dark";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_breakpoint";
            token?: string;
            minWidth?: number;
            maxWidth?: number;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_directionality";
            textDirection: "ltr" | "rtl";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not";
            variant: MixProtocolContextVariantSelector;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not_widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_orientation";
            orientation: "portrait" | "landscape";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_platform";
            platform: "android" | "fuchsia" | "iOS" | "linux" | "macOS" | "windows";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_web";
            style: MixProtocolStyle;
          }
      )[];
      modifiers?:
        | (
            | {
                type: "align";
                alignment?: MixProtocolPropertyTerm;
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
              }
            | {
                type: "aspect_ratio";
                aspectRatio?: MixProtocolPropertyTerm;
              }
            | {
                type: "blur";
                sigma: MixProtocolPropertyTerm;
              }
            | {
                type: "box";
                style: MixProtocolStyle;
              }
            | {
                type: "clip_oval";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_rect";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_r_rect";
                borderRadius?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_triangle";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_style";
                style?: MixProtocolPropertyTerm;
                textAlign?: MixProtocolPropertyTerm;
                softWrap?: MixProtocolPropertyTerm;
                overflow?: MixProtocolPropertyTerm;
                maxLines?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_styler";
                style: MixProtocolStyle;
              }
            | {
                type: "flexible";
                flex?: MixProtocolPropertyTerm;
                fit?: MixProtocolPropertyTerm;
              }
            | {
                type: "fractionally_sized_box";
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "icon_theme";
                color?: MixProtocolPropertyTerm;
                size?: MixProtocolPropertyTerm;
                fill?: MixProtocolPropertyTerm;
                weight?: MixProtocolPropertyTerm;
                grade?: MixProtocolPropertyTerm;
                opticalSize?: MixProtocolPropertyTerm;
                opacity?: MixProtocolPropertyTerm;
                shadows?: MixProtocolPropertyTerm;
                applyTextScaling?: MixProtocolPropertyTerm;
              }
            | {
                type: "intrinsic_height";
              }
            | {
                type: "intrinsic_width";
              }
            | {
                type: "opacity";
                opacity: MixProtocolPropertyTerm;
              }
            | {
                type: "padding";
                padding: MixProtocolPropertyTerm;
              }
            | {
                type: "rotate";
                radians?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "rotated_box";
                quarterTurns?: MixProtocolPropertyTerm;
              }
            | {
                type: "scale";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "scroll_view";
                scrollDirection?: MixProtocolPropertyTerm;
                reverse?: MixProtocolPropertyTerm;
                padding?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "sized_box";
                width?: MixProtocolPropertyTerm;
                height?: MixProtocolPropertyTerm;
              }
            | {
                type: "skew";
                skewX?: MixProtocolPropertyTerm;
                skewY?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "transform";
                transform?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "translate";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
              }
            | {
                type: "visibility";
                visible?: MixProtocolPropertyTerm;
              }
          )[]
        | {
            order?: (
              | "align"
              | "aspect_ratio"
              | "blur"
              | "box"
              | "clip_oval"
              | "clip_rect"
              | "clip_r_rect"
              | "clip_triangle"
              | "default_text_style"
              | "default_text_styler"
              | "flexible"
              | "fractionally_sized_box"
              | "icon_theme"
              | "intrinsic_height"
              | "intrinsic_width"
              | "opacity"
              | "padding"
              | "rotate"
              | "rotated_box"
              | "scale"
              | "scroll_view"
              | "sized_box"
              | "skew"
              | "transform"
              | "translate"
              | "visibility"
            )[];
            items?: (
              | {
                  type: "align";
                  alignment?: MixProtocolPropertyTerm;
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                }
              | {
                  type: "aspect_ratio";
                  aspectRatio?: MixProtocolPropertyTerm;
                }
              | {
                  type: "blur";
                  sigma: MixProtocolPropertyTerm;
                }
              | {
                  type: "box";
                  style: MixProtocolStyle;
                }
              | {
                  type: "clip_oval";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_rect";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_r_rect";
                  borderRadius?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_triangle";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_style";
                  style?: MixProtocolPropertyTerm;
                  textAlign?: MixProtocolPropertyTerm;
                  softWrap?: MixProtocolPropertyTerm;
                  overflow?: MixProtocolPropertyTerm;
                  maxLines?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_styler";
                  style: MixProtocolStyle;
                }
              | {
                  type: "flexible";
                  flex?: MixProtocolPropertyTerm;
                  fit?: MixProtocolPropertyTerm;
                }
              | {
                  type: "fractionally_sized_box";
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "icon_theme";
                  color?: MixProtocolPropertyTerm;
                  size?: MixProtocolPropertyTerm;
                  fill?: MixProtocolPropertyTerm;
                  weight?: MixProtocolPropertyTerm;
                  grade?: MixProtocolPropertyTerm;
                  opticalSize?: MixProtocolPropertyTerm;
                  opacity?: MixProtocolPropertyTerm;
                  shadows?: MixProtocolPropertyTerm;
                  applyTextScaling?: MixProtocolPropertyTerm;
                }
              | {
                  type: "intrinsic_height";
                }
              | {
                  type: "intrinsic_width";
                }
              | {
                  type: "opacity";
                  opacity: MixProtocolPropertyTerm;
                }
              | {
                  type: "padding";
                  padding: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotate";
                  radians?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotated_box";
                  quarterTurns?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scale";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scroll_view";
                  scrollDirection?: MixProtocolPropertyTerm;
                  reverse?: MixProtocolPropertyTerm;
                  padding?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "sized_box";
                  width?: MixProtocolPropertyTerm;
                  height?: MixProtocolPropertyTerm;
                }
              | {
                  type: "skew";
                  skewX?: MixProtocolPropertyTerm;
                  skewY?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "transform";
                  transform?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "translate";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                }
              | {
                  type: "visibility";
                  visible?: MixProtocolPropertyTerm;
                }
            )[];
          };
      animation?: {
        type?: "curve";
        spring?: {
          mass: number;
          stiffness: number;
          damping: number;
        };
        duration?:
          | {
              $token: string;
            }
          | number;
        curve?:
          | (
              | "linear"
              | "decelerate"
              | "fastLinearToSlowEaseIn"
              | "fastEaseInToSlowEaseOut"
              | "ease"
              | "easeIn"
              | "easeInToLinear"
              | "easeInSine"
              | "easeInQuad"
              | "easeInCubic"
              | "easeInQuart"
              | "easeInQuint"
              | "easeInExpo"
              | "easeInCirc"
              | "easeInBack"
              | "easeOut"
              | "linearToEaseOut"
              | "easeOutSine"
              | "easeOutQuad"
              | "easeOutCubic"
              | "easeOutQuart"
              | "easeOutQuint"
              | "easeOutExpo"
              | "easeOutCirc"
              | "easeOutBack"
              | "easeInOut"
              | "easeInOutSine"
              | "easeInOutQuad"
              | "easeInOutCubic"
              | "easeInOutCubicEmphasized"
              | "easeInOutQuart"
              | "easeInOutQuint"
              | "easeInOutExpo"
              | "easeInOutCirc"
              | "easeInOutBack"
              | "fastOutSlowIn"
              | "slowMiddle"
              | "bounceIn"
              | "bounceOut"
              | "bounceInOut"
              | "elasticIn"
              | "elasticOut"
              | "elasticInOut"
            )
          | {
              /**
               * @minItems 4
               * @maxItems 4
               */
              cubic: [number, number, number, number];
            };
        delay?:
          | {
              $token: string;
            }
          | number;
      };
    }
  | {
      type: "flex_box";
      alignment?: MixProtocolPropertyTerm;
      padding?: MixProtocolPropertyTerm;
      margin?: MixProtocolPropertyTerm;
      constraints?: MixProtocolPropertyTerm;
      clipBehavior?: MixProtocolPropertyTerm;
      transform?: MixProtocolPropertyTerm;
      transformAlignment?: MixProtocolPropertyTerm;
      decoration?: MixProtocolPropertyTerm;
      direction?: MixProtocolPropertyTerm;
      mainAxisAlignment?: MixProtocolPropertyTerm;
      crossAxisAlignment?: MixProtocolPropertyTerm;
      mainAxisSize?: MixProtocolPropertyTerm;
      verticalDirection?: MixProtocolPropertyTerm;
      textDirection?: MixProtocolPropertyTerm;
      textBaseline?: MixProtocolPropertyTerm;
      flexClipBehavior?: MixProtocolPropertyTerm;
      spacing?: MixProtocolPropertyTerm;
      variants?: (
        | {
            kind: "named";
            name: string;
            style: MixProtocolStyle;
          }
        | {
            kind: "widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "enabled";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_brightness";
            brightness: "light" | "dark";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_breakpoint";
            token?: string;
            minWidth?: number;
            maxWidth?: number;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_directionality";
            textDirection: "ltr" | "rtl";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not";
            variant: MixProtocolContextVariantSelector;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not_widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_orientation";
            orientation: "portrait" | "landscape";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_platform";
            platform: "android" | "fuchsia" | "iOS" | "linux" | "macOS" | "windows";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_web";
            style: MixProtocolStyle;
          }
      )[];
      modifiers?:
        | (
            | {
                type: "align";
                alignment?: MixProtocolPropertyTerm;
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
              }
            | {
                type: "aspect_ratio";
                aspectRatio?: MixProtocolPropertyTerm;
              }
            | {
                type: "blur";
                sigma: MixProtocolPropertyTerm;
              }
            | {
                type: "box";
                style: MixProtocolStyle;
              }
            | {
                type: "clip_oval";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_rect";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_r_rect";
                borderRadius?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_triangle";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_style";
                style?: MixProtocolPropertyTerm;
                textAlign?: MixProtocolPropertyTerm;
                softWrap?: MixProtocolPropertyTerm;
                overflow?: MixProtocolPropertyTerm;
                maxLines?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_styler";
                style: MixProtocolStyle;
              }
            | {
                type: "flexible";
                flex?: MixProtocolPropertyTerm;
                fit?: MixProtocolPropertyTerm;
              }
            | {
                type: "fractionally_sized_box";
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "icon_theme";
                color?: MixProtocolPropertyTerm;
                size?: MixProtocolPropertyTerm;
                fill?: MixProtocolPropertyTerm;
                weight?: MixProtocolPropertyTerm;
                grade?: MixProtocolPropertyTerm;
                opticalSize?: MixProtocolPropertyTerm;
                opacity?: MixProtocolPropertyTerm;
                shadows?: MixProtocolPropertyTerm;
                applyTextScaling?: MixProtocolPropertyTerm;
              }
            | {
                type: "intrinsic_height";
              }
            | {
                type: "intrinsic_width";
              }
            | {
                type: "opacity";
                opacity: MixProtocolPropertyTerm;
              }
            | {
                type: "padding";
                padding: MixProtocolPropertyTerm;
              }
            | {
                type: "rotate";
                radians?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "rotated_box";
                quarterTurns?: MixProtocolPropertyTerm;
              }
            | {
                type: "scale";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "scroll_view";
                scrollDirection?: MixProtocolPropertyTerm;
                reverse?: MixProtocolPropertyTerm;
                padding?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "sized_box";
                width?: MixProtocolPropertyTerm;
                height?: MixProtocolPropertyTerm;
              }
            | {
                type: "skew";
                skewX?: MixProtocolPropertyTerm;
                skewY?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "transform";
                transform?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "translate";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
              }
            | {
                type: "visibility";
                visible?: MixProtocolPropertyTerm;
              }
          )[]
        | {
            order?: (
              | "align"
              | "aspect_ratio"
              | "blur"
              | "box"
              | "clip_oval"
              | "clip_rect"
              | "clip_r_rect"
              | "clip_triangle"
              | "default_text_style"
              | "default_text_styler"
              | "flexible"
              | "fractionally_sized_box"
              | "icon_theme"
              | "intrinsic_height"
              | "intrinsic_width"
              | "opacity"
              | "padding"
              | "rotate"
              | "rotated_box"
              | "scale"
              | "scroll_view"
              | "sized_box"
              | "skew"
              | "transform"
              | "translate"
              | "visibility"
            )[];
            items?: (
              | {
                  type: "align";
                  alignment?: MixProtocolPropertyTerm;
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                }
              | {
                  type: "aspect_ratio";
                  aspectRatio?: MixProtocolPropertyTerm;
                }
              | {
                  type: "blur";
                  sigma: MixProtocolPropertyTerm;
                }
              | {
                  type: "box";
                  style: MixProtocolStyle;
                }
              | {
                  type: "clip_oval";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_rect";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_r_rect";
                  borderRadius?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_triangle";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_style";
                  style?: MixProtocolPropertyTerm;
                  textAlign?: MixProtocolPropertyTerm;
                  softWrap?: MixProtocolPropertyTerm;
                  overflow?: MixProtocolPropertyTerm;
                  maxLines?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_styler";
                  style: MixProtocolStyle;
                }
              | {
                  type: "flexible";
                  flex?: MixProtocolPropertyTerm;
                  fit?: MixProtocolPropertyTerm;
                }
              | {
                  type: "fractionally_sized_box";
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "icon_theme";
                  color?: MixProtocolPropertyTerm;
                  size?: MixProtocolPropertyTerm;
                  fill?: MixProtocolPropertyTerm;
                  weight?: MixProtocolPropertyTerm;
                  grade?: MixProtocolPropertyTerm;
                  opticalSize?: MixProtocolPropertyTerm;
                  opacity?: MixProtocolPropertyTerm;
                  shadows?: MixProtocolPropertyTerm;
                  applyTextScaling?: MixProtocolPropertyTerm;
                }
              | {
                  type: "intrinsic_height";
                }
              | {
                  type: "intrinsic_width";
                }
              | {
                  type: "opacity";
                  opacity: MixProtocolPropertyTerm;
                }
              | {
                  type: "padding";
                  padding: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotate";
                  radians?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotated_box";
                  quarterTurns?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scale";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scroll_view";
                  scrollDirection?: MixProtocolPropertyTerm;
                  reverse?: MixProtocolPropertyTerm;
                  padding?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "sized_box";
                  width?: MixProtocolPropertyTerm;
                  height?: MixProtocolPropertyTerm;
                }
              | {
                  type: "skew";
                  skewX?: MixProtocolPropertyTerm;
                  skewY?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "transform";
                  transform?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "translate";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                }
              | {
                  type: "visibility";
                  visible?: MixProtocolPropertyTerm;
                }
            )[];
          };
      animation?: {
        type?: "curve";
        spring?: {
          mass: number;
          stiffness: number;
          damping: number;
        };
        duration?:
          | {
              $token: string;
            }
          | number;
        curve?:
          | (
              | "linear"
              | "decelerate"
              | "fastLinearToSlowEaseIn"
              | "fastEaseInToSlowEaseOut"
              | "ease"
              | "easeIn"
              | "easeInToLinear"
              | "easeInSine"
              | "easeInQuad"
              | "easeInCubic"
              | "easeInQuart"
              | "easeInQuint"
              | "easeInExpo"
              | "easeInCirc"
              | "easeInBack"
              | "easeOut"
              | "linearToEaseOut"
              | "easeOutSine"
              | "easeOutQuad"
              | "easeOutCubic"
              | "easeOutQuart"
              | "easeOutQuint"
              | "easeOutExpo"
              | "easeOutCirc"
              | "easeOutBack"
              | "easeInOut"
              | "easeInOutSine"
              | "easeInOutQuad"
              | "easeInOutCubic"
              | "easeInOutCubicEmphasized"
              | "easeInOutQuart"
              | "easeInOutQuint"
              | "easeInOutExpo"
              | "easeInOutCirc"
              | "easeInOutBack"
              | "fastOutSlowIn"
              | "slowMiddle"
              | "bounceIn"
              | "bounceOut"
              | "bounceInOut"
              | "elasticIn"
              | "elasticOut"
              | "elasticInOut"
            )
          | {
              /**
               * @minItems 4
               * @maxItems 4
               */
              cubic: [number, number, number, number];
            };
        delay?:
          | {
              $token: string;
            }
          | number;
      };
    }
  | {
      type: "stack_box";
      alignment?: MixProtocolPropertyTerm;
      padding?: MixProtocolPropertyTerm;
      margin?: MixProtocolPropertyTerm;
      constraints?: MixProtocolPropertyTerm;
      clipBehavior?: MixProtocolPropertyTerm;
      transform?: MixProtocolPropertyTerm;
      transformAlignment?: MixProtocolPropertyTerm;
      decoration?: MixProtocolPropertyTerm;
      stackAlignment?: MixProtocolPropertyTerm;
      fit?: MixProtocolPropertyTerm;
      textDirection?: MixProtocolPropertyTerm;
      stackClipBehavior?: MixProtocolPropertyTerm;
      variants?: (
        | {
            kind: "named";
            name: string;
            style: MixProtocolStyle;
          }
        | {
            kind: "widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "enabled";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_brightness";
            brightness: "light" | "dark";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_breakpoint";
            token?: string;
            minWidth?: number;
            maxWidth?: number;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_directionality";
            textDirection: "ltr" | "rtl";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not";
            variant: MixProtocolContextVariantSelector;
            style: MixProtocolStyle;
          }
        | {
            kind: "context_not_widget_state";
            state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_orientation";
            orientation: "portrait" | "landscape";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_platform";
            platform: "android" | "fuchsia" | "iOS" | "linux" | "macOS" | "windows";
            style: MixProtocolStyle;
          }
        | {
            kind: "context_web";
            style: MixProtocolStyle;
          }
      )[];
      modifiers?:
        | (
            | {
                type: "align";
                alignment?: MixProtocolPropertyTerm;
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
              }
            | {
                type: "aspect_ratio";
                aspectRatio?: MixProtocolPropertyTerm;
              }
            | {
                type: "blur";
                sigma: MixProtocolPropertyTerm;
              }
            | {
                type: "box";
                style: MixProtocolStyle;
              }
            | {
                type: "clip_oval";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_rect";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_r_rect";
                borderRadius?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "clip_triangle";
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_style";
                style?: MixProtocolPropertyTerm;
                textAlign?: MixProtocolPropertyTerm;
                softWrap?: MixProtocolPropertyTerm;
                overflow?: MixProtocolPropertyTerm;
                maxLines?: MixProtocolPropertyTerm;
              }
            | {
                type: "default_text_styler";
                style: MixProtocolStyle;
              }
            | {
                type: "flexible";
                flex?: MixProtocolPropertyTerm;
                fit?: MixProtocolPropertyTerm;
              }
            | {
                type: "fractionally_sized_box";
                widthFactor?: MixProtocolPropertyTerm;
                heightFactor?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "icon_theme";
                color?: MixProtocolPropertyTerm;
                size?: MixProtocolPropertyTerm;
                fill?: MixProtocolPropertyTerm;
                weight?: MixProtocolPropertyTerm;
                grade?: MixProtocolPropertyTerm;
                opticalSize?: MixProtocolPropertyTerm;
                opacity?: MixProtocolPropertyTerm;
                shadows?: MixProtocolPropertyTerm;
                applyTextScaling?: MixProtocolPropertyTerm;
              }
            | {
                type: "intrinsic_height";
              }
            | {
                type: "intrinsic_width";
              }
            | {
                type: "opacity";
                opacity: MixProtocolPropertyTerm;
              }
            | {
                type: "padding";
                padding: MixProtocolPropertyTerm;
              }
            | {
                type: "rotate";
                radians?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "rotated_box";
                quarterTurns?: MixProtocolPropertyTerm;
              }
            | {
                type: "scale";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "scroll_view";
                scrollDirection?: MixProtocolPropertyTerm;
                reverse?: MixProtocolPropertyTerm;
                padding?: MixProtocolPropertyTerm;
                clipBehavior?: MixProtocolPropertyTerm;
              }
            | {
                type: "sized_box";
                width?: MixProtocolPropertyTerm;
                height?: MixProtocolPropertyTerm;
              }
            | {
                type: "skew";
                skewX?: MixProtocolPropertyTerm;
                skewY?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "transform";
                transform?: MixProtocolPropertyTerm;
                alignment?: MixProtocolPropertyTerm;
              }
            | {
                type: "translate";
                x?: MixProtocolPropertyTerm;
                y?: MixProtocolPropertyTerm;
              }
            | {
                type: "visibility";
                visible?: MixProtocolPropertyTerm;
              }
          )[]
        | {
            order?: (
              | "align"
              | "aspect_ratio"
              | "blur"
              | "box"
              | "clip_oval"
              | "clip_rect"
              | "clip_r_rect"
              | "clip_triangle"
              | "default_text_style"
              | "default_text_styler"
              | "flexible"
              | "fractionally_sized_box"
              | "icon_theme"
              | "intrinsic_height"
              | "intrinsic_width"
              | "opacity"
              | "padding"
              | "rotate"
              | "rotated_box"
              | "scale"
              | "scroll_view"
              | "sized_box"
              | "skew"
              | "transform"
              | "translate"
              | "visibility"
            )[];
            items?: (
              | {
                  type: "align";
                  alignment?: MixProtocolPropertyTerm;
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                }
              | {
                  type: "aspect_ratio";
                  aspectRatio?: MixProtocolPropertyTerm;
                }
              | {
                  type: "blur";
                  sigma: MixProtocolPropertyTerm;
                }
              | {
                  type: "box";
                  style: MixProtocolStyle;
                }
              | {
                  type: "clip_oval";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_rect";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_r_rect";
                  borderRadius?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "clip_triangle";
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_style";
                  style?: MixProtocolPropertyTerm;
                  textAlign?: MixProtocolPropertyTerm;
                  softWrap?: MixProtocolPropertyTerm;
                  overflow?: MixProtocolPropertyTerm;
                  maxLines?: MixProtocolPropertyTerm;
                }
              | {
                  type: "default_text_styler";
                  style: MixProtocolStyle;
                }
              | {
                  type: "flexible";
                  flex?: MixProtocolPropertyTerm;
                  fit?: MixProtocolPropertyTerm;
                }
              | {
                  type: "fractionally_sized_box";
                  widthFactor?: MixProtocolPropertyTerm;
                  heightFactor?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "icon_theme";
                  color?: MixProtocolPropertyTerm;
                  size?: MixProtocolPropertyTerm;
                  fill?: MixProtocolPropertyTerm;
                  weight?: MixProtocolPropertyTerm;
                  grade?: MixProtocolPropertyTerm;
                  opticalSize?: MixProtocolPropertyTerm;
                  opacity?: MixProtocolPropertyTerm;
                  shadows?: MixProtocolPropertyTerm;
                  applyTextScaling?: MixProtocolPropertyTerm;
                }
              | {
                  type: "intrinsic_height";
                }
              | {
                  type: "intrinsic_width";
                }
              | {
                  type: "opacity";
                  opacity: MixProtocolPropertyTerm;
                }
              | {
                  type: "padding";
                  padding: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotate";
                  radians?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "rotated_box";
                  quarterTurns?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scale";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "scroll_view";
                  scrollDirection?: MixProtocolPropertyTerm;
                  reverse?: MixProtocolPropertyTerm;
                  padding?: MixProtocolPropertyTerm;
                  clipBehavior?: MixProtocolPropertyTerm;
                }
              | {
                  type: "sized_box";
                  width?: MixProtocolPropertyTerm;
                  height?: MixProtocolPropertyTerm;
                }
              | {
                  type: "skew";
                  skewX?: MixProtocolPropertyTerm;
                  skewY?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "transform";
                  transform?: MixProtocolPropertyTerm;
                  alignment?: MixProtocolPropertyTerm;
                }
              | {
                  type: "translate";
                  x?: MixProtocolPropertyTerm;
                  y?: MixProtocolPropertyTerm;
                }
              | {
                  type: "visibility";
                  visible?: MixProtocolPropertyTerm;
                }
            )[];
          };
      animation?: {
        type?: "curve";
        spring?: {
          mass: number;
          stiffness: number;
          damping: number;
        };
        duration?:
          | {
              $token: string;
            }
          | number;
        curve?:
          | (
              | "linear"
              | "decelerate"
              | "fastLinearToSlowEaseIn"
              | "fastEaseInToSlowEaseOut"
              | "ease"
              | "easeIn"
              | "easeInToLinear"
              | "easeInSine"
              | "easeInQuad"
              | "easeInCubic"
              | "easeInQuart"
              | "easeInQuint"
              | "easeInExpo"
              | "easeInCirc"
              | "easeInBack"
              | "easeOut"
              | "linearToEaseOut"
              | "easeOutSine"
              | "easeOutQuad"
              | "easeOutCubic"
              | "easeOutQuart"
              | "easeOutQuint"
              | "easeOutExpo"
              | "easeOutCirc"
              | "easeOutBack"
              | "easeInOut"
              | "easeInOutSine"
              | "easeInOutQuad"
              | "easeInOutCubic"
              | "easeInOutCubicEmphasized"
              | "easeInOutQuart"
              | "easeInOutQuint"
              | "easeInOutExpo"
              | "easeInOutCirc"
              | "easeInOutBack"
              | "fastOutSlowIn"
              | "slowMiddle"
              | "bounceIn"
              | "bounceOut"
              | "bounceInOut"
              | "elasticIn"
              | "elasticOut"
              | "elasticInOut"
            )
          | {
              /**
               * @minItems 4
               * @maxItems 4
               */
              cubic: [number, number, number, number];
            };
        delay?:
          | {
              $token: string;
            }
          | number;
      };
    };
export type MixProtocolContextVariantSelector =
  | {
      kind: "widget_state";
      state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
    }
  | {
      kind: "enabled";
    }
  | {
      kind: "context_brightness";
      brightness: "light" | "dark";
    }
  | {
      kind: "context_breakpoint";
      token?: string;
      minWidth?: number;
      maxWidth?: number;
    }
  | {
      kind: "context_directionality";
      textDirection: "ltr" | "rtl";
    }
  | {
      kind: "context_not";
      variant: MixProtocolContextVariantSelector;
    }
  | {
      kind: "context_not_widget_state";
      state: "hovered" | "focused" | "pressed" | "dragged" | "selected" | "scrolled_under" | "disabled" | "error";
    }
  | {
      kind: "context_orientation";
      orientation: "portrait" | "landscape";
    }
  | {
      kind: "context_platform";
      platform: "android" | "fuchsia" | "iOS" | "linux" | "macOS" | "windows";
    }
  | {
      kind: "context_web";
    };

export interface MixProtocolBoxDecorationLiteral {
  color?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  border?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  borderRadius?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  shape?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  backgroundBlendMode?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  gradient?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  boxShadow?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
}
export interface MixProtocolStrutStyleLiteral {
  fontFamily?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  fontFamilyFallback?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  fontSize?: MixProtocolDoublePropertyTerm | MixProtocolDoublePropertyControlTerm;
  fontWeight?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  fontStyle?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  height?: MixProtocolDoublePropertyTerm | MixProtocolDoublePropertyControlTerm;
  leading?: MixProtocolDoublePropertyTerm | MixProtocolDoublePropertyControlTerm;
  forceStrutHeight?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
}
export interface MixProtocolTextStyleLiteral {
  color?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  backgroundColor?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  fontSize?: MixProtocolDoublePropertyTerm | MixProtocolDoublePropertyControlTerm;
  fontWeight?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  fontStyle?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  letterSpacing?: MixProtocolDoublePropertyTerm | MixProtocolDoublePropertyControlTerm;
  debugLabel?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  wordSpacing?: MixProtocolDoublePropertyTerm | MixProtocolDoublePropertyControlTerm;
  textBaseline?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  height?: MixProtocolDoublePropertyTerm | MixProtocolDoublePropertyControlTerm;
  fontFamily?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  fontFamilyFallback?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  fontFeatures?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  fontVariations?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  decoration?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  decorationColor?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  decorationStyle?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
  decorationThickness?: MixProtocolDoublePropertyTerm | MixProtocolDoublePropertyControlTerm;
  shadows?: MixProtocolPropertyTerm | MixProtocolPropertyControlTerm;
}

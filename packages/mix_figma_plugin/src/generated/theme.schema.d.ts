/**
 * Generated from packages/mix_protocol/schema/theme.schema.json.
 * Do not edit by hand; run `npm run gen:types`.
 */

export interface MixProtocolThemeDocument {
  type: "theme";
  colors?: {
    [k: string]:
      | string
      | {
          $token: string;
        };
  };
  spaces?: {
    [k: string]:
      | number
      | {
          $token: string;
          kind?: "space";
        };
  };
  doubles?: {
    [k: string]:
      | number
      | {
          $token: string;
          kind?: "double";
        };
  };
  radii?: {
    [k: string]:
      | (
          | number
          | {
              x: number;
              y: number;
            }
        )
      | {
          $token: string;
        };
  };
  textStyles?: {
    [k: string]:
      | {
          color?: string;
          backgroundColor?: string;
          fontSize?: number;
          fontWeight?: "w100" | "w200" | "w300" | "w400" | "w500" | "w600" | "w700" | "w800" | "w900";
          fontStyle?: "normal" | "italic";
          letterSpacing?: number;
          debugLabel?: string;
          wordSpacing?: number;
          textBaseline?: "alphabetic" | "ideographic";
          height?: number;
          fontFamily?: string;
          fontFamilyFallback?: string[];
          fontFeatures?: {
            feature: string;
            value: number;
          }[];
          fontVariations?: {
            axis: string;
            value: number;
          }[];
          decoration?: "none" | "underline" | "overline" | "line_through";
          decorationColor?: string;
          decorationStyle?: "solid" | "double" | "dotted" | "dashed" | "wavy";
          decorationThickness?: number;
          shadows?: {
            color?: string;
            offset?: {
              x: number;
              y: number;
            };
            blurRadius?: number;
          }[];
        }
      | {
          $token: string;
        };
  };
  shadows?: {
    [k: string]:
      | {
          color?: string;
          offset?: {
            x: number;
            y: number;
          };
          blurRadius?: number;
        }[]
      | {
          $token: string;
        };
  };
  boxShadows?: {
    [k: string]:
      | {
          color?: string;
          offset?: {
            x: number;
            y: number;
          };
          blurRadius?: number;
          spreadRadius?: number;
        }[]
      | {
          $token: string;
        };
  };
  borders?: {
    [k: string]:
      | {
          color?: string;
          width?: number;
          style?: "none" | "solid";
          strokeAlign?: number;
        }
      | {
          $token: string;
        };
  };
  fontWeights?: {
    [k: string]:
      | ("w100" | "w200" | "w300" | "w400" | "w500" | "w600" | "w700" | "w800" | "w900")
      | {
          $token: string;
        };
  };
  breakpoints?: {
    [k: string]:
      | {
          minWidth?: number;
          maxWidth?: number;
          minHeight?: number;
          maxHeight?: number;
        }
      | {
          $token: string;
        };
  };
  durations?: {
    [k: string]:
      | number
      | {
          $token: string;
        };
  };
  v: 1;
}

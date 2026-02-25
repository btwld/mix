import { useMDXComponents as getThemeComponents } from 'nextra-theme-docs'; // nextra-theme-blog or your custom theme

import { DartPadEmbed } from '../components/DartPadEmbed';
import { FlutterMultiView } from '../components/FlutterMultiView';
import { FlutterPreview } from '../components/FlutterPreview';
import { FlutterSnippet } from '../components/FlutterSnippet';

// Get the default MDX components
const themeComponents = getThemeComponents()

// Merge components
export function useMDXComponents(components) {
    return {
        ...themeComponents,
        // Interactive embed components
        DartPadEmbed,
        FlutterPreview,
        FlutterMultiView,  // Multi-view mode: single engine, multiple views
        FlutterSnippet,
        ...components
    }
}

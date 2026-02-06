import { useMDXComponents as getThemeComponents } from 'nextra-theme-docs'; // nextra-theme-blog or your custom theme

// Demo embedding components
import { Demo } from '../components/Demo';
import { DartPadEmbed } from '../components/DartPadEmbed';
import { FlutterEmbed } from '../components/FlutterEmbed';
import { FlutterMultiView } from '../components/FlutterMultiView';

// Get the default MDX components
const themeComponents = getThemeComponents()

// Merge components
export function useMDXComponents(components) {
    return {
        ...themeComponents,
        // Demo embedding components for interactive Flutter examples
        Demo,
        DartPadEmbed,
        FlutterEmbed,
        FlutterMultiView,  // Multi-view mode: single engine, multiple views
        ...components
    }
}
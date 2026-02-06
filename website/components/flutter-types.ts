/**
 * Shared TypeScript types for Flutter web embedding.
 *
 * Provides type definitions for both single-view (FlutterEmbed) and
 * multi-view (FlutterMultiView) embedding modes.
 */

// ============================================================================
// Engine Initialization Types
// ============================================================================

/**
 * Configuration options for Flutter engine initialization.
 */
export interface FlutterEngineConfig {
  /** Host element for single-view embedding */
  hostElement?: HTMLElement;
  /** Asset base URL */
  assetBase?: string;
  /** Enable multi-view mode (renders to multiple host elements) */
  multiViewEnabled?: boolean;
}

/**
 * Initializes the Flutter engine with the provided configuration.
 */
export interface FlutterEngineInitializer {
  initializeEngine: (config?: FlutterEngineConfig) => Promise<FlutterAppRunner>;
}

/**
 * Single-view Flutter app runner.
 */
export interface FlutterAppRunner {
  runApp: () => Promise<void>;
}

/**
 * Multi-view Flutter app runner.
 * Returns a FlutterMultiViewApp when multi-view mode is enabled.
 */
export interface FlutterMultiViewRunner {
  runApp: () => Promise<FlutterMultiViewApp>;
}

// ============================================================================
// Multi-View Types
// ============================================================================

/**
 * Flutter multi-view app interface.
 * Manages multiple independent views within a single Flutter engine.
 */
export interface FlutterMultiViewApp {
  /**
   * Add a new view to the Flutter app.
   * @param config View configuration with host element and initial data
   * @returns View ID for later removal
   */
  addView: (config: {
    hostElement: HTMLElement;
    initialData?: Record<string, unknown>;
  }) => number;

  /**
   * Remove a view from the Flutter app.
   * @param viewId View ID returned from addView
   */
  removeView: (viewId: number) => void;
}

// ============================================================================
// Loader Types
// ============================================================================

/**
 * Flutter loader configuration for initial load.
 */
export interface FlutterLoaderConfig {
  /** Host element for the app (single-view mode) */
  hostElement?: HTMLElement;
  /** Base URL for entrypoint resolution */
  entrypointBaseUrl?: string;
}

/**
 * Flutter loader interface.
 */
export interface FlutterLoader {
  load: (options: {
    config?: FlutterLoaderConfig;
    serviceWorkerSettings?: {
      serviceWorkerVersion: string;
    };
    onEntrypointLoaded?: (engineInitializer: FlutterEngineInitializer) => Promise<void>;
  }) => Promise<void>;
  loadEntrypoint: (options: {
    entrypointUrl?: string;
    onEntrypointLoaded?: (engineInitializer: FlutterEngineInitializer) => void;
  }) => Promise<void>;
}

/**
 * Flutter build configuration (from flutter_bootstrap.js).
 */
export interface FlutterBuildConfig {
  engineRevision: string;
  builds: Array<{
    compileTarget: string;
    renderer: string;
    mainJsPath: string;
  }>;
}

// ============================================================================
// Global Window Extensions
// ============================================================================

declare global {
  interface Window {
    /** Flutter loader, set by flutter.js or flutter_bootstrap.js */
    _flutter?: {
      loader: FlutterLoader;
      buildConfig?: FlutterBuildConfig;
    };

    /** Multi-view app instance (set after engine init with multiViewEnabled) */
    flutterApp?: FlutterMultiViewApp;

    /** Convenience function to init multi-view mode (set in index.html) */
    initFlutterMultiView?: () => Promise<FlutterMultiViewApp>;

    /** Convenience function to add a view (set in index.html) */
    addFlutterView?: (
      hostElement: HTMLElement,
      demoId: string,
      options?: Record<string, unknown>
    ) => Promise<number>;

    /** Convenience function to remove a view (set in index.html) */
    removeFlutterView?: (viewId: number) => boolean;

    /** Flag indicating multi-view mode is active */
    FLUTTER_MULTI_VIEW_MODE?: boolean;

    /** Internal flag for multi-view initialization */
    __FLUTTER_MULTI_VIEW_ENABLED__?: boolean;
  }
}

// Empty export to make this a module
export {};

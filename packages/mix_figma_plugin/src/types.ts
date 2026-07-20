import type { MixProtocolStyleDocument } from './generated/style.schema';
import type { MixProtocolThemeDocument } from './generated/theme.schema';

export type { MixProtocolStyleDocument, MixProtocolThemeDocument };

export type JsonPrimitive = boolean | number | string | null;
export type JsonValue = JsonPrimitive | JsonObject | readonly JsonValue[];
export interface JsonObject {
  readonly [key: string]: JsonValue;
}

export type PluginData = Readonly<Record<string, string>>;

export type DiagnosticSeverity = 'error' | 'info' | 'warning';

export interface MixFigmaDiagnostic {
  readonly code: string;
  readonly severity: DiagnosticSeverity;
  readonly path: string;
  readonly message: string;
}

export type MixFigmaSyncAction = 'create' | 'delete' | 'rename' | 'skip' | 'unchanged' | 'update';

export interface MixFigmaSyncOperation {
  readonly action: MixFigmaSyncAction;
  readonly kind: string;
  readonly ref: string;
  readonly sourceId?: string;
  readonly name: string;
  readonly path: string;
  readonly destructive: boolean;
  readonly changes: readonly string[];
  readonly diagnostics: readonly MixFigmaDiagnostic[];
}

export interface FigmaWriteOptions {
  readonly operations?: readonly MixFigmaSyncOperation[];
}

export type MixFigmaSyncDirection = 'figmaToMix' | 'mixToFigma';
export type MixFigmaSyncResource = 'component' | 'selection' | 'tokens';

export interface MixFigmaSyncSummary {
  readonly create: number;
  readonly update: number;
  readonly rename: number;
  readonly delete: number;
  readonly unchanged: number;
  readonly skip: number;
  readonly errors: number;
  readonly warnings: number;
}

export interface MixFigmaSyncPlan {
  readonly schema: 'mix_figma/sync-plan/v1';
  readonly version: 1;
  readonly id: string;
  readonly direction: MixFigmaSyncDirection;
  readonly resource: MixFigmaSyncResource;
  readonly sourceFingerprint: string;
  readonly desiredFingerprint: string;
  readonly summary: MixFigmaSyncSummary;
  readonly operations: readonly MixFigmaSyncOperation[];
  readonly diagnostics: readonly MixFigmaDiagnostic[];
}

export interface SyncPlanRequest {
  readonly version: 1;
  readonly direction: MixFigmaSyncDirection;
  readonly resource: MixFigmaSyncResource;
  readonly current: unknown;
  readonly componentId?: string;
}

export interface SyncPlanResponse {
  readonly plan: MixFigmaSyncPlan;
  readonly artifacts?: unknown;
  readonly payload?: unknown;
}

export interface SyncApplyRequest {
  readonly planId: string;
  readonly allowDeletes: boolean;
  readonly current: unknown;
}

export interface SyncApplyResponse {
  readonly status: 'applied' | 'approved';
  readonly plan: MixFigmaSyncPlan;
  readonly payload?: unknown;
  readonly allowDeletes?: boolean;
  readonly appliedOperations: readonly MixFigmaSyncOperation[];
}

export interface SyncVerifyRequest {
  readonly planId: string;
  readonly current?: unknown;
  readonly writeResult?: unknown;
}

export interface SyncVerificationReport {
  readonly schema: 'mix_figma/sync-report/v1';
  readonly version: 1;
  readonly planId: string;
  readonly direction: MixFigmaSyncDirection;
  readonly resource: MixFigmaSyncResource;
  readonly status: 'failed' | 'verified' | 'verifiedWithRetainedItems';
  readonly remainingMutations: number;
  readonly pendingDeletes: number;
  readonly diagnostics: readonly MixFigmaDiagnostic[];
}

export const MIX_FIGMA_PLUGIN_DATA_KEYS = {
  identity: 'mix_figma.id',
  kind: 'mix_figma.kind',
  protocolVersion: 'mix_figma.protocolVersion',
  tokenGroup: 'mix_figma.tokenGroup',
} as const;

export interface MixIdentityStamp {
  readonly id: string;
  readonly kind: 'collection' | 'component' | 'componentSet' | 'effectStyle' | 'paintStyle' | 'textStyle' | 'token';
  readonly protocolVersion?: number;
  readonly tokenGroup?: string;
}

export interface FigmaModeDocument {
  readonly modeId: string;
  readonly name: string;
}

export interface FigmaVariableCollectionDocument {
  readonly id: string;
  readonly key: string;
  readonly name: string;
  readonly defaultModeId: string;
  readonly modes: readonly FigmaModeDocument[];
  readonly remote: boolean;
  readonly hiddenFromPublishing: boolean;
  readonly variableIds: readonly string[];
  readonly pluginData: PluginData;
}

export type FigmaVariableResolvedType = 'BOOLEAN' | 'COLOR' | 'FLOAT' | 'STRING';
export interface FigmaVariableAliasValue {
  readonly type: 'VARIABLE_ALIAS';
  readonly id?: string;
  readonly ref?: string;
}
export interface FigmaColorValue {
  readonly r: number;
  readonly g: number;
  readonly b: number;
  readonly a?: number;
}
export type FigmaVariableValue = boolean | number | string | FigmaColorValue | FigmaVariableAliasValue;
export type FigmaCodeSyntax = Readonly<Partial<Record<'ANDROID' | 'WEB' | 'iOS', string>>>;

export interface FigmaVariableDocument {
  readonly id: string;
  readonly key: string;
  readonly name: string;
  readonly description: string;
  readonly variableCollectionId: string;
  readonly resolvedType: FigmaVariableResolvedType;
  readonly valuesByMode: Readonly<Record<string, FigmaVariableValue>>;
  readonly scopes: readonly VariableScope[];
  readonly codeSyntax: FigmaCodeSyntax;
  readonly remote: boolean;
  readonly hiddenFromPublishing: boolean;
  readonly pluginData: PluginData;
}

export interface FigmaVariablesDocument {
  readonly version: 1;
  readonly collections: readonly FigmaVariableCollectionDocument[];
  readonly variables: readonly FigmaVariableDocument[];
}

export interface FigmaModeWritePayload {
  readonly ref: string;
  readonly sourceId?: string;
  readonly name: string;
}

export interface FigmaVariableCollectionWritePayload {
  readonly ref: string;
  readonly sourceId?: string;
  readonly name: string;
  readonly modes: readonly FigmaModeWritePayload[];
  readonly hiddenFromPublishing?: boolean;
  readonly pluginData?: PluginData;
  readonly identity?: MixIdentityStamp;
}

export interface FigmaVariableWritePayload {
  readonly ref: string;
  readonly sourceId?: string;
  readonly collectionRef: string;
  readonly name: string;
  readonly description?: string;
  readonly resolvedType: FigmaVariableResolvedType;
  readonly valuesByMode: Readonly<Record<string, FigmaVariableValue>>;
  readonly scopes?: readonly VariableScope[];
  readonly codeSyntax?: FigmaCodeSyntax;
  readonly hiddenFromPublishing?: boolean;
  readonly pluginData?: PluginData;
  readonly identity?: MixIdentityStamp;
}

export interface FigmaVariablesWritePayload {
  readonly version: 1;
  readonly collections: readonly FigmaVariableCollectionWritePayload[];
  readonly variables: readonly FigmaVariableWritePayload[];
}

export interface FigmaVariablesWriteResult {
  readonly collections: Readonly<Record<string, string>>;
  readonly modes: Readonly<Record<string, Readonly<Record<string, string>>>>;
  readonly variables: Readonly<Record<string, string>>;
}

export interface FigmaStyleMetadata {
  readonly id: string;
  readonly key: string;
  readonly name: string;
  readonly description: string;
  readonly remote: boolean;
  readonly pluginData: PluginData;
}

export interface FigmaTextStyleDocument extends FigmaStyleMetadata {
  readonly kind: 'TEXT';
  readonly fontName: FontName;
  readonly fontSize: number;
  readonly letterSpacing: LetterSpacing;
  readonly lineHeight: LineHeight;
  readonly leadingTrim: LeadingTrim;
  readonly paragraphIndent: number;
  readonly paragraphSpacing: number;
  readonly listSpacing: number;
  readonly hangingPunctuation: boolean;
  readonly hangingList: boolean;
  readonly textCase: TextCase;
  readonly textDecoration: TextDecoration;
  readonly boundVariables?: FigmaStyleBoundVariables;
}

export interface FigmaEffectStyleDocument extends FigmaStyleMetadata {
  readonly kind: 'EFFECT';
  readonly effects: readonly Effect[];
  readonly boundVariables?: FigmaStyleBoundVariables;
}

export interface FigmaPaintStyleDocument extends FigmaStyleMetadata {
  readonly kind: 'PAINT';
  readonly paints: readonly Paint[];
  readonly boundVariables?: FigmaStyleBoundVariables;
}

export type FigmaStyleBoundVariables = Readonly<
  Record<string, FigmaVariableAliasValue | readonly FigmaVariableAliasValue[]>
>;

export interface FigmaStylesDocument {
  readonly version: 1;
  readonly textStyles: readonly FigmaTextStyleDocument[];
  readonly effectStyles: readonly FigmaEffectStyleDocument[];
  readonly paintStyles: readonly FigmaPaintStyleDocument[];
}

interface FigmaStyleWriteMetadata {
  readonly ref: string;
  readonly sourceId?: string;
  readonly name: string;
  readonly description?: string;
  readonly pluginData?: PluginData;
  readonly identity?: MixIdentityStamp;
}

export interface FigmaTextStyleWritePayload extends FigmaStyleWriteMetadata {
  readonly fontName?: FontName;
  readonly fontSize?: number;
  readonly letterSpacing?: LetterSpacing;
  readonly lineHeight?: LineHeight;
  readonly leadingTrim?: LeadingTrim;
  readonly paragraphIndent?: number;
  readonly paragraphSpacing?: number;
  readonly listSpacing?: number;
  readonly hangingPunctuation?: boolean;
  readonly hangingList?: boolean;
  readonly textCase?: TextCase;
  readonly textDecoration?: TextDecoration;
  readonly variableBindings?: Readonly<Record<string, string>>;
}

export interface FigmaEffectStyleWritePayload extends FigmaStyleWriteMetadata {
  readonly effects: readonly Effect[];
}

export interface FigmaPaintStyleWritePayload extends FigmaStyleWriteMetadata {
  readonly paints: readonly Paint[];
}

export interface FigmaStylesWritePayload {
  readonly version: 1;
  readonly textStyles: readonly FigmaTextStyleWritePayload[];
  readonly effectStyles: readonly FigmaEffectStyleWritePayload[];
  readonly paintStyles?: readonly FigmaPaintStyleWritePayload[];
}

export interface FigmaStylesWriteResult {
  readonly textStyles: Readonly<Record<string, string>>;
  readonly effectStyles: Readonly<Record<string, string>>;
  readonly paintStyles: Readonly<Record<string, string>>;
}

export interface FigmaTokenWriteResult {
  readonly variables: FigmaVariablesWriteResult;
  readonly styles: FigmaStylesWriteResult;
}

export interface FigmaNodeSnapshot {
  readonly id: string;
  readonly name: string;
  readonly type: string;
  readonly visible?: boolean;
  readonly locked?: boolean;
  readonly opacity?: number;
  readonly pluginData: PluginData;
  readonly properties: JsonObject;
  readonly children?: readonly FigmaNodeSnapshot[];
}

export interface FigmaSelectionDocument {
  readonly version: 1;
  readonly pageId: string;
  readonly pageName: string;
  readonly selection: readonly FigmaNodeSnapshot[];
  readonly diagnostics: readonly MixFigmaDiagnostic[];
}

export type ComponentNodeKind = 'ELLIPSE' | 'FRAME' | 'LINE' | 'RECTANGLE' | 'TEXT' | 'UNSUPPORTED';

export interface ComponentNodeLayoutPayload {
  readonly mode?: 'HORIZONTAL' | 'NONE' | 'VERTICAL';
  readonly primaryAxisAlignItems?: 'CENTER' | 'MAX' | 'MIN' | 'SPACE_BETWEEN';
  readonly counterAxisAlignItems?: 'BASELINE' | 'CENTER' | 'MAX' | 'MIN';
  readonly itemSpacing?: number;
  readonly paddingTop?: number;
  readonly paddingRight?: number;
  readonly paddingBottom?: number;
  readonly paddingLeft?: number;
}

export interface ComponentNodeStylePayload {
  readonly opacity?: number;
  readonly fills?: readonly Paint[];
  readonly strokes?: readonly Paint[];
  readonly strokeWeight?: number;
  readonly cornerRadius?: number;
  readonly effects?: readonly Effect[];
}

export interface ComponentNodeTextPayload {
  readonly characters: string;
  readonly fontName?: FontName;
  readonly fontSize?: number;
  readonly letterSpacing?: LetterSpacing;
  readonly lineHeight?: LineHeight;
}

export interface ComponentNodePayload {
  readonly id: string;
  readonly name: string;
  readonly kind: ComponentNodeKind;
  readonly visible?: boolean;
  readonly width?: number;
  readonly height?: number;
  readonly layout?: ComponentNodeLayoutPayload;
  readonly style?: ComponentNodeStylePayload;
  readonly text?: ComponentNodeTextPayload;
  readonly variableBindings?: Readonly<Record<string, string>>;
  readonly pluginData?: PluginData;
  readonly unsupportedReason?: string;
  readonly children?: readonly ComponentNodePayload[];
}

export interface ComponentVariantWritePayload {
  readonly ref: string;
  readonly properties: Readonly<Record<string, boolean | string>>;
  readonly root: ComponentNodePayload;
}

export interface ComponentSetWritePayload {
  readonly version: 1;
  readonly ref: string;
  readonly sourceId?: string;
  readonly name: string;
  readonly description?: string;
  readonly parentNodeId?: string;
  readonly columns?: number;
  readonly columnGap?: number;
  readonly rowGap?: number;
  readonly variants: readonly ComponentVariantWritePayload[];
  readonly pluginData?: PluginData;
  readonly identity?: MixIdentityStamp;
  readonly diagnostics?: readonly MixFigmaDiagnostic[];
}

export interface ComponentSetWriteResult {
  readonly componentSetId: string;
  readonly variants: Readonly<Record<string, string>>;
  readonly diagnostics: readonly MixFigmaDiagnostic[];
}

export interface ComponentVariantSnapshot {
  readonly id: string;
  readonly name: string;
  readonly pluginData: PluginData;
}

export interface ComponentSetSnapshot {
  readonly id: string;
  readonly name: string;
  readonly pluginData: PluginData;
  readonly variants: readonly ComponentVariantSnapshot[];
}

export interface ComponentSyncSnapshot {
  readonly componentSet: ComponentSetSnapshot | null;
}

export interface PullTokensPayload {
  readonly variables: FigmaVariablesDocument;
  readonly styles: FigmaStylesDocument;
}

export interface PushTokensPayload {
  readonly variables: FigmaVariablesWritePayload;
  readonly styles: FigmaStylesWritePayload;
}

export interface PullNodesPayload {
  readonly nodes: FigmaSelectionDocument;
  readonly variables: FigmaVariablesDocument;
}

export interface BridgeHealth {
  readonly status: string;
  readonly [key: string]: JsonValue;
}

export type UiToSandboxMessage =
  | { readonly type: 'read-tokens'; readonly requestId: string }
  | { readonly type: 'read-selection'; readonly requestId: string }
  | {
      readonly type: 'read-component-set';
      readonly requestId: string;
      readonly componentRef: string;
    }
  | {
      readonly type: 'write-tokens';
      readonly requestId: string;
      readonly payload: PushTokensPayload;
      readonly operations?: readonly MixFigmaSyncOperation[];
    }
  | {
      readonly type: 'write-component-set';
      readonly requestId: string;
      readonly payload: ComponentSetWritePayload;
      readonly operations?: readonly MixFigmaSyncOperation[];
    }
  | { readonly type: 'close-plugin'; readonly requestId: string };

export type SandboxToUiMessage =
  | { readonly type: 'plugin-ready' }
  | { readonly type: 'operation-result'; readonly requestId: string; readonly payload: unknown }
  | { readonly type: 'operation-error'; readonly requestId: string; readonly error: string };

const SOURCE_ASSETS = {
  tailwind: 'assets/real_tailwind/advanced-examples.html',
  flutter: 'assets/lib/advanced_parity_preview.dart',
};

const DART_KEYWORDS = new Set([
  'abstract',
  'as',
  'assert',
  'async',
  'await',
  'base',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'covariant',
  'default',
  'deferred',
  'do',
  'dynamic',
  'else',
  'enum',
  'export',
  'extends',
  'extension',
  'external',
  'factory',
  'false',
  'final',
  'finally',
  'for',
  'get',
  'hide',
  'if',
  'implements',
  'import',
  'in',
  'interface',
  'is',
  'late',
  'library',
  'mixin',
  'new',
  'null',
  'of',
  'on',
  'operator',
  'part',
  'required',
  'rethrow',
  'return',
  'sealed',
  'set',
  'show',
  'static',
  'super',
  'switch',
  'sync',
  'this',
  'throw',
  'true',
  'try',
  'typedef',
  'var',
  'void',
  'when',
  'while',
  'with',
  'yield',
]);

const DART_CORE_TYPES = new Set([
  'BigInt',
  'Function',
  'Future',
  'Iterable',
  'List',
  'Map',
  'Never',
  'Null',
  'Object',
  'Record',
  'Set',
  'Stream',
  'String',
  'Symbol',
  'Type',
  'bool',
  'double',
  'int',
  'num',
]);

const DART_NUMBER = /^(?:0[xX][\dA-Fa-f]+|0[bB][01]+|(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?)/;
const DART_OPERATOR = /^(?:\.\.\.?\??|>>>=|<<=|>>=|\?\?=|~\/=|=>|==|!=|>=|<=|&&|\|\||\+\+|--|\+=|-=|\*=|\/=|%=|\?\?|\?\.\.|\?\.|\.\.|>>>|<<|>>|&=|\|=|\^=|~\/|[=+\-*\/%~<>!&|^?:])/;

export async function loadShowcaseSources(baseUrl = document.baseURI) {
  const [tailwind, flutter] = await Promise.all([
    fetchText(new URL(SOURCE_ASSETS.tailwind, baseUrl)),
    fetchText(new URL(SOURCE_ASSETS.flutter, baseUrl)),
  ]);
  return { tailwind, flutter };
}

export async function loadShowcaseManifest(baseUrl = document.baseURI) {
  const response = await fetch(new URL('showcase-manifest.json', baseUrl));
  if (!response.ok) {
    throw new Error(`Could not load showcase manifest (${response.status}).`);
  }
  return response.json();
}

export async function loadParityData(baseUrl = document.baseURI) {
  const response = await fetch(new URL('generated/parity-data.json', baseUrl));
  if (!response.ok) return null;
  return response.json();
}

export function extractShowcaseRegion(source, region) {
  const markerPairs = [
    [`<!-- showcase:start ${region} -->`, `<!-- showcase:end ${region} -->`],
    [`// showcase:start ${region}`, `// showcase:end ${region}`],
  ];

  for (const [startMarker, endMarker] of markerPairs) {
    const start = source.indexOf(startMarker);
    if (start < 0) continue;
    const contentStart = start + startMarker.length;
    const end = source.indexOf(endMarker, contentStart);
    if (end < 0) {
      throw new Error(`Missing end marker for showcase region “${region}”.`);
    }
    return normalizeIndent(source.slice(contentStart, end));
  }

  throw new Error(`Missing showcase region “${region}”.`);
}

export function presentationTailwindSource(source) {
  return normalizeIndent(
    source
      .replace(/^\s*data-parity-class\s*$/gm, '')
      .replace(/\sdata-parity-class(?=[\s>])/g, ''),
  );
}

export function escapeHtml(value) {
  return String(value)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');
}

// Highlights Dart source without changing its text content. This deliberately
// small lexer covers Dart comments, raw and multiline strings, numbers,
// identifiers, keywords, annotations, and operators. Copied source always
// comes from the untouched input string.
export function highlightDartSource(source, utility = '') {
  const value = String(source);
  let highlighted = '';
  let index = 0;

  while (index < value.length) {
    const character = value[index];

    if (/\s/.test(character)) {
      const end = consumeWhile(value, index, (candidate) => /\s/.test(candidate));
      highlighted += escapeHtml(value.slice(index, end));
      index = end;
      continue;
    }

    if (value.startsWith('//', index)) {
      const end = value.indexOf('\n', index);
      const tokenEnd = end < 0 ? value.length : end;
      highlighted += syntaxToken('comment', value.slice(index, tokenEnd));
      index = tokenEnd;
      continue;
    }

    if (value.startsWith('/*', index)) {
      const end = consumeBlockComment(value, index);
      highlighted += syntaxToken('comment', value.slice(index, end));
      index = end;
      continue;
    }

    if (
      character === "'" ||
      character === '"' ||
      ((character === 'r' || character === 'R') &&
        (value[index + 1] === "'" || value[index + 1] === '"'))
    ) {
      const end = consumeDartString(value, index);
      highlighted += syntaxToken(
        'string',
        value.slice(index, end),
        utility,
      );
      index = end;
      continue;
    }

    if (character === '@' && isIdentifierStart(value[index + 1])) {
      const end = consumeWhile(value, index + 2, isIdentifierPart);
      highlighted += syntaxToken('annotation', value.slice(index, end));
      index = end;
      continue;
    }

    const number = value.slice(index).match(DART_NUMBER)?.[0];
    if (number) {
      highlighted += syntaxToken('number', number);
      index += number.length;
      continue;
    }

    if (isIdentifierStart(character)) {
      const end = consumeWhile(value, index + 1, isIdentifierPart);
      const identifier = value.slice(index, end);
      const nextCharacter = value[nextNonWhitespaceIndex(value, end)];
      const kind = dartIdentifierKind(identifier, nextCharacter);
      highlighted += syntaxToken(kind, identifier);
      index = end;
      continue;
    }

    const operator = value.slice(index).match(DART_OPERATOR)?.[0];
    if (operator) {
      highlighted += syntaxToken('operator', operator);
      index += operator.length;
      continue;
    }

    if ('()[]{},;.'.includes(character)) {
      highlighted += syntaxToken('punctuation', character);
      index += 1;
      continue;
    }

    highlighted += escapeHtml(character);
    index += 1;
  }

  return highlighted;
}

export function normalizeIndent(value) {
  const lines = String(value).replace(/^\n+|\n+$/g, '').split('\n');
  const indents = lines
    .filter((line) => line.trim().length > 0)
    .map((line) => line.match(/^\s*/)?.[0].length ?? 0);
  const minimum = indents.length === 0 ? 0 : Math.min(...indents);
  return lines.map((line) => line.slice(minimum)).join('\n').trim();
}

async function fetchText(url) {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`Could not load ${url.pathname} (${response.status}).`);
  }
  return response.text();
}

function dartIdentifierKind(identifier, nextCharacter) {
  if (DART_KEYWORDS.has(identifier)) return 'keyword';
  if (DART_CORE_TYPES.has(identifier) || /^_?[A-Z]/.test(identifier)) return 'type';
  if (nextCharacter === ':') return 'named-parameter';
  if (nextCharacter === '(') return 'function';
  return 'identifier';
}

function syntaxToken(kind, value, utility = '') {
  const content =
    kind === 'string'
      ? escapeWithUtilityMark(value, utility)
      : escapeHtml(value);
  return `<span class="syntax-${kind}">${content}</span>`;
}

function escapeWithUtilityMark(value, utility) {
  if (!utility || !value.includes(utility)) return escapeHtml(value);

  let highlighted = '';
  let cursor = 0;
  let match = value.indexOf(utility);
  while (match >= 0) {
    highlighted += escapeHtml(value.slice(cursor, match));
    highlighted += `<mark class="utility-match">${escapeHtml(utility)}</mark>`;
    cursor = match + utility.length;
    match = value.indexOf(utility, cursor);
  }
  return highlighted + escapeHtml(value.slice(cursor));
}

function consumeBlockComment(value, start) {
  let depth = 1;
  let index = start + 2;
  while (index < value.length && depth > 0) {
    if (value.startsWith('/*', index)) {
      depth += 1;
      index += 2;
    } else if (value.startsWith('*/', index)) {
      depth -= 1;
      index += 2;
    } else {
      index += 1;
    }
  }
  return index;
}

function consumeDartString(value, start) {
  const isRaw =
    (value[start] === 'r' || value[start] === 'R') &&
    (value[start + 1] === "'" || value[start + 1] === '"');
  const quoteStart = isRaw ? start + 1 : start;
  const quote = value[quoteStart];
  const delimiter = value.startsWith(quote.repeat(3), quoteStart)
    ? quote.repeat(3)
    : quote;
  let index = quoteStart + delimiter.length;

  while (index < value.length) {
    if (!isRaw && value[index] === '\\') {
      index += 2;
      continue;
    }
    if (value.startsWith(delimiter, index)) {
      return index + delimiter.length;
    }
    index += 1;
  }

  return value.length;
}

function nextNonWhitespaceIndex(value, start) {
  let index = start;
  while (index < value.length && /\s/.test(value[index])) index += 1;
  return index;
}

function consumeWhile(value, start, predicate) {
  let index = start;
  while (index < value.length && predicate(value[index])) index += 1;
  return index;
}

function isIdentifierStart(character) {
  return typeof character === 'string' && /[A-Za-z_]/.test(character);
}

function isIdentifierPart(character) {
  return typeof character === 'string' && /[A-Za-z\d_]/.test(character);
}

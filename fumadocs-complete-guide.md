# Fumadocs Complete Guide

> The beautiful docs framework with Next.js - A comprehensive guide for agents and developers

## Table of Contents

1. [Overview](#overview)
2. [Complete Sitemap](#complete-sitemap)
3. [Getting Started](#getting-started)
4. [Core Concepts](#core-concepts)
5. [UI Components](#ui-components)
6. [Layouts](#layouts)
7. [Content Management](#content-management)
8. [Navigation & Structure](#navigation--structure)
9. [Search Implementation](#search-implementation)
10. [Theming & Customization](#theming--customization)
11. [Internationalization](#internationalization)
12. [Advanced Features](#advanced-features)
13. [Deployment](#deployment)
14. [Quick Reference](#quick-reference)

## Overview

Fumadocs is a documentation framework based on Next.js, designed to be fast, flexible, and composes seamlessly into Next.js App Router. It consists of:

- **Fumadocs Core**: Handles document search, content adapters, and Markdown extensions
- **Fumadocs UI**: Default theme for documentation sites
- **Content Source**: Can be a CMS or local data layer (like Fumadocs MDX)
- **Fumadocs CLI**: Command-line tool for installation and automation

### Key Features
- 🚀 Built on Next.js App Router
- 📝 Supports Markdown and MDX
- 🔍 Built-in search (Orama/Algolia)
- 🎨 Beautiful default theme with Tailwind CSS
- 🌐 Internationalization support
- ⚡ Optimized performance with RSC
- 🛠️ CLI for easy setup and customization

## Complete Sitemap

### Main Documentation
- **Homepage**: https://fumadocs.dev/
- **Documentation Root**: https://fumadocs.dev/docs

### Getting Started
- **UI Getting Started**: https://fumadocs.dev/docs/ui
- **Quick Start Guide**: https://fumadocs.dev/docs/ui/quickstart
- **Manual Installation**: https://fumadocs.dev/docs/ui/manual-installation

### Headless/Core Library
- **Core Overview**: https://fumadocs.dev/docs/headless
- **Page Tree**: https://fumadocs.dev/docs/headless/page-tree
- **Content Collections**: https://fumadocs.dev/docs/headless/content-collections
- **Custom Source**: https://fumadocs.dev/docs/headless/custom-source

### UI Components
- **Components Overview**: https://fumadocs.dev/docs/ui/components
- **Accordion**: https://fumadocs.dev/docs/ui/components/accordion
- **Auto Type Table**: https://fumadocs.dev/docs/ui/components/auto-type-table
- **Banner**: https://fumadocs.dev/docs/ui/components/banner
- **Dynamic Code Block**: https://fumadocs.dev/docs/ui/components/dynamic-codeblock
- **Files**: https://fumadocs.dev/docs/ui/components/files
- **GitHub Info**: https://fumadocs.dev/docs/ui/components/github-info
- **Image Zoom**: https://fumadocs.dev/docs/ui/components/image-zoom
- **Inline TOC**: https://fumadocs.dev/docs/ui/components/inline-toc
- **Steps**: https://fumadocs.dev/docs/ui/components/steps
- **Tabs**: https://fumadocs.dev/docs/ui/components/tabs
- **Type Table**: https://fumadocs.dev/docs/ui/components/type-table

### Layouts
- **Docs Layout**: https://fumadocs.dev/docs/ui/layouts/docs
- **Docs Page**: https://fumadocs.dev/docs/ui/layouts/page
- **Home Layout**: https://fumadocs.dev/docs/ui/layouts/home
- **Notebook Layout**: Available via CLI installation

### Content & Writing
- **MDX Setup**: https://fumadocs.dev/docs/mdx
- **Markdown Features**: https://fumadocs.dev/docs/ui/markdown
- **Page Conventions**: https://fumadocs.dev/docs/ui/page-conventions
- **OpenAPI Integration**: https://fumadocs.dev/docs/ui/openapi

### Navigation
- **Navigation Overview**: https://fumadocs.dev/docs/ui/navigation
- **Sidebar Links**: https://fumadocs.dev/docs/ui/navigation/sidebar

### Search
- **Search Overview**: https://fumadocs.dev/docs/headless/search
- **Orama Search**: https://fumadocs.dev/docs/headless/search/orama
- **Orama Cloud**: https://fumadocs.dev/docs/headless/search/orama-cloud
- **Algolia Search**: https://fumadocs.dev/docs/headless/search/algolia

### Theming
- **Themes**: https://fumadocs.dev/docs/ui/theme

### Internationalization
- **i18n Setup**: https://fumadocs.dev/docs/ui/internationalization

### CLI
- **CLI User Guide**: https://fumadocs.dev/docs/cli

### Additional Resources
- **Blog**: https://fumadocs.dev/blog
- **Showcase**: https://fumadocs.dev/showcase
- **GitHub Repository**: https://github.com/fuma-nama/fumadocs

## Getting Started

### Requirements
- Node.js 18+
- Next.js 14+ (App Router)
- Note: Node.js 23.1 might have production build issues

### Quick Installation

```bash
npm create fumadocs-app
```

The CLI will prompt you to:
1. Enter project name
2. Choose React framework (Next.js recommended)
3. Select content source
4. Configure styling options

### Manual Installation

For existing Next.js projects:

```bash
npm install fumadocs-ui fumadocs-core fumadocs-mdx
```

### First MDX File

Create `content/docs/index.mdx`:

```mdx
---
title: Hello World
description: My first documentation page
---

## Welcome to Fumadocs

Start writing your documentation here.
```

### Development

```bash
npm run dev
```

Access at: http://localhost:3000/docs

## Core Concepts

### 1. Content Source

Fumadocs uses a flexible content system:
- **Local files**: MDX/Markdown in your repository
- **Collections**: Type-safe content with validation
- **CMS Integration**: Connect any headless CMS

### 2. Source Loader

Configure in `lib/source.ts`:

```typescript
import { loader } from 'fumadocs-core/source';
import { createMDXSource } from 'fumadocs-mdx';

export const source = loader({
  baseUrl: '/docs',
  source: createMDXSource(docs, meta),
});
```

### 3. Page Tree

Hierarchical structure of your documentation:
- Automatically generated from file system
- Customizable via `meta.json`
- Supports folders, separators, and external links

### 4. Collections

Define in `source.config.ts`:

```typescript
import { defineDocs } from 'fumadocs-mdx/config';

export const docs = defineDocs({
  dir: 'content/docs',
});
```

## UI Components

### Available Components

1. **Accordion** - Collapsible content sections
2. **Auto Type Table** - Auto-generated TypeScript type tables
3. **Banner** - Site-wide announcements
4. **Dynamic Code Block** - Syntax-highlighted code with features
5. **Files** - File tree visualization
6. **GitHub Info** - Repository statistics display
7. **Image Zoom** - Zoomable images
8. **Inline TOC** - Embedded table of contents
9. **Steps** - Step-by-step guides
10. **Tabs** - Tabbed content with persistence
11. **Type Table** - Manual type documentation

### Installing Components

```bash
# Install specific components
npx @fumadocs/cli add accordion tabs

# Install all components
npx @fumadocs/cli add
```

## Layouts

### 1. Docs Layout

Primary documentation layout with sidebar:

```typescript
import { DocsLayout } from 'fumadocs-ui/layouts/docs';

export default function Layout({ children }) {
  return (
    <DocsLayout tree={tree} nav={{ title: 'My Docs' }}>
      {children}
    </DocsLayout>
  );
}
```

### 2. Home Layout

For landing pages and marketing content:

```typescript
import { HomeLayout } from 'fumadocs-ui/layouts/home';
```

### 3. Notebook Layout

Alternative documentation style:

```bash
npx @fumadocs/cli add notebook
```

## Content Management

### Frontmatter

```yaml
---
title: Page Title
description: Page description for SEO
icon: HomeIcon
full: true  # Full-width layout
---
```

### meta.json

Configure folders:

```json
{
  "title": "Getting Started",
  "icon": "BookOpen",
  "defaultOpen": true,
  "pages": ["intro", "installation", "configuration"]
}
```

### MDX Features

- **Components**: Import and use React components
- **Code Blocks**: Syntax highlighting with Shiki
- **Callouts**: Tips, warnings, info boxes
- **Cards**: Link cards for navigation
- **Math**: LaTeX equation rendering
- **Diagrams**: Mermaid support

## Navigation & Structure

### File-based Routing

```
content/
├── docs/
│   ├── index.mdx          → /docs
│   ├── getting-started.mdx → /docs/getting-started
│   └── guides/
│       ├── meta.json
│       └── installation.mdx → /docs/guides/installation
```

### Folder Groups

Use parentheses to organize without affecting URLs:

```
(getting-started)/
├── installation.mdx → /installation
└── configuration.mdx → /configuration
```

### Sidebar Configuration

```typescript
<DocsLayout 
  sidebar={{
    defaultOpenLevel: 2,
    collapsible: true,
    tabs: {
      transform: (option, node) => ({
        ...option,
        icon: <MyIcon />,
      }),
    },
  }}
/>
```

## Search Implementation

### Orama (Default)

```typescript
// app/api/search/route.ts
import { createFromSource } from 'fumadocs-core/search/server';

export const { GET } = createFromSource(source, {
  language: 'english',
});
```

### Algolia Integration

1. Set up Algolia account and get API keys
2. Create search indexes:

```typescript
// scripts/algolia.js
import { sync } from 'fumadocs-core/search/algolia';

sync(client, {
  indexName: 'docs',
  documents: records,
});
```

### Chinese/Japanese Support

```typescript
import { createTokenizer } from '@orama/tokenizers/mandarin';

export const { GET } = createFromSource(source, {
  localeMap: {
    cn: {
      components: {
        tokenizer: createTokenizer(),
      },
    },
  },
});
```

## Theming & Customization

### Available Themes

- Neutral (default)
- Black
- Vitepress
- Dusk
- Catppuccin
- Ocean
- Purple

### Apply Theme

```css
/* app/global.css */
@import 'fumadocs-ui/css/purple.css';
@import 'fumadocs-ui/css/preset.css';
```

### Custom Colors

```css
:root {
  --color-fd-background: hsl(0, 0%, 100%);
  --color-fd-foreground: hsl(0, 0%, 0%);
  --color-fd-primary: hsl(240, 5.9%, 10%);
}

.dark {
  --color-fd-background: hsl(0, 0%, 0%);
  --color-fd-foreground: hsl(0, 0%, 100%);
}
```

### Layout Width

```css
:root {
  --fd-layout-width: 1400px;
}
```

## Internationalization

### Setup i18n

1. Configure languages:

```typescript
// lib/i18n.ts
export const i18n = {
  defaultLanguage: 'en',
  languages: ['en', 'zh', 'ja'],
};
```

2. Create middleware:

```typescript
// middleware.ts
import { createI18nMiddleware } from 'fumadocs-core/i18n';

export default createI18nMiddleware(i18n);
```

3. Update folder structure:

```
app/
├── [lang]/
│   ├── layout.tsx
│   └── docs/
│       └── [[...slug]]/
│           └── page.tsx
```

4. Localized content:

```
content/docs/
├── index.mdx
├── index.zh.mdx
├── index.ja.mdx
```

## Advanced Features

### OpenAPI Documentation

```bash
npm install fumadocs-openapi shiki
```

Generate API docs:

```typescript
// scripts/generate-openapi.ts
import { generateFiles } from 'fumadocs-openapi';

generateFiles({
  input: './openapi.json',
  output: './content/api',
});
```

### TypeScript Twoslash

Enable TypeScript tooltips in code blocks:

```typescript
// source.config.ts
export default defineDocs({
  mdx: {
    twoslash: true,
  },
});
```

### Static Export

For static hosting:

```typescript
// next.config.js
module.exports = {
  output: 'export',
};
```

Use static search:

```typescript
export const revalidate = false;
export const { staticGET: GET } = createFromSource(source);
```

## Deployment

### Vercel (Recommended)

1. Push to GitHub
2. Import project in Vercel
3. Deploy with default settings

### Netlify

1. Build command: `npm run build`
2. Publish directory: `.next` or `out` (static)
3. Environment variables if needed

### Docker

Include `source.config.ts` in Dockerfile:

```dockerfile
COPY source.config.ts ./
```

### Important Notes

- Doesn't work on Edge runtime
- Supports server components
- Automatic image optimization
- Built-in prefetching

## Quick Reference

### CLI Commands

```bash
# Create new project
npm create fumadocs-app

# Add components
npx @fumadocs/cli add [component]

# Customize layouts
npx @fumadocs/cli customise

# Generate file tree
npx @fumadocs/cli tree ./dir ./output.tsx

# Configure CLI
npx @fumadocs/cli
```

### Common Patterns

#### Basic Style Configuration

```typescript
// app/layout.config.tsx
export const baseOptions = {
  nav: {
    title: 'My Docs',
    transparentMode: 'top',
  },
  githubUrl: 'https://github.com/user/repo',
};
```

#### Search Setup

```typescript
// Client component
import { useDocsSearch } from 'fumadocs-core/search/client';

const search = useDocsSearch({
  type: 'static', // or 'algolia'
});
```

#### Custom Components in MDX

```mdx
import { MyComponent } from '@/components/my-component';

<MyComponent />
```

### Best Practices

1. **Performance**
   - Use static generation when possible
   - Minimize client components
   - Enable prefetching for navigation

2. **Organization**
   - Use folder groups for logical organization
   - Keep meta.json files updated
   - Follow consistent naming conventions

3. **Content**
   - Use descriptive frontmatter
   - Implement proper heading hierarchy
   - Add alt text to images

4. **Search**
   - Configure language-specific tokenizers
   - Update search indexes regularly
   - Test search functionality across languages

5. **Deployment**
   - Test production builds locally
   - Monitor build times
   - Use appropriate caching strategies

### Troubleshooting

- **Build Issues**: Check Node.js version (18+)
- **Search Not Working**: Verify API route configuration
- **Styling Issues**: Ensure Tailwind CSS is configured
- **i18n Problems**: Check middleware matcher patterns
- **Component Errors**: Run `npm run dev` for detailed errors

---

This guide provides comprehensive coverage of fumadocs features and implementation details. For the latest updates and detailed API references, visit the official documentation at https://fumadocs.dev/
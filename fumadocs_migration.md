# Fumadocs Migration Guide: From Nextra to Modern Documentation

> Status: This is a forward-looking plan. The current docs site still uses Nextra (see `website/package.json`). Keep this for reference and update or remove it when a migration is scheduled.

## Table of Contents
1. [Introduction & Prerequisites](#introduction--prerequisites)
2. [Project Setup Using Official CLI](#project-setup-using-official-cli)
3. [Vercel Deployment Configuration](#vercel-deployment-configuration)
4. [Vercel Deployment Automation](#vercel-deployment-automation)
5. [Content Migration from Nextra](#content-migration-from-nextra)
6. [Multi-Version Documentation Setup](#multi-version-documentation-setup)
7. [Advanced Features Configuration](#advanced-features-configuration)
8. [Testing & Deployment](#testing--deployment)
9. [Maintenance & Best Practices](#maintenance--best-practices)

---

## Introduction & Prerequisites

### Why Migrate to Fumadocs?

Fumadocs is a modern documentation framework built on Next.js App Router that offers significant advantages over Nextra:

- **🚀 Modern Architecture**: Built for Next.js App Router with React Server Components
- **⚡ Better Performance**: 36.9% smaller bundle size compared to alternatives
- **🔍 Superior Search**: Built-in Orama search with better results than FlexSearch
- **📱 Mobile-First**: Responsive design with excellent mobile experience
- **🎨 Customizable**: Highly customizable themes and components
- **🔧 Developer Experience**: Better TypeScript support and development tools

### Prerequisites

Before starting the migration, ensure you have:

- **Node.js 18+** installed
- **Git** version control
- **GitHub account** with repository access
- **Basic knowledge** of Next.js and React
- **Terminal/Command line** access

### Timeline Estimate

- **CLI Setup**: 30 minutes
- **Configuration**: 2 hours (more complex due to existing Vercel setup)
- **Content Migration**: 4-6 hours (Mix has extensive documentation)
- **Component Migration**: 2-3 hours (Nextra-specific components)
- **Asset Migration**: 1 hour (images, icons, OG images)
- **Deployment Setup**: 1 hour
- **Testing & Polish**: 2-3 hours

**Total: 10-16 hours** (can be completed over multiple sessions)

---

## Project Setup Using Official CLI

### Step 1: Navigate to Repository Root

```bash
cd /path/to/your/mix/project
```

### Step 2: Create Fumadocs App

Use the official CLI to create a new Fumadocs application:

```bash
npm create fumadocs-app docs
```

### Step 3: Interactive Setup

The CLI will prompt you with several options. Here are the recommended choices for the Mix project:

```
◇ Project name
│ docs

◆ Choose a content source
│ ● Fumadocs MDX          # ← Select this (recommended)
│ ○ Content Collections

◆ Would you like to use Tailwind CSS for styling?
│ ● Yes                   # ← Select this (consistent with existing website)
│ ○ No

◆ Would you like to install packages?
│ ● Yes                   # ← Select this for automatic installation
│ ○ No
```

### Step 4: Verify Installation

After installation completes, verify the setup:

```bash
cd docs
npm run dev
```

Visit `http://localhost:3000/docs` to see your new Fumadocs site.

### Generated Project Structure

The CLI creates the following structure:

```
docs/
├── app/
│   ├── layout.tsx                # Root layout
│   ├── globals.css              # Global styles
│   ├── page.tsx                 # Homepage
│   └── docs/
│       ├── layout.tsx           # Docs layout
│       └── [[...slug]]/
│           └── page.tsx         # Dynamic docs pages
├── content/
│   └── docs/
│       └── index.mdx            # Sample documentation
├── components/
│   └── ui/                      # Shadcn UI components
├── lib/
│   └── source.ts                # Content source configuration
├── components.json              # Shadcn UI configuration
├── next.config.mjs              # Next.js configuration
├── package.json                 # Dependencies
├── source.config.ts             # Fumadocs content config
├── tailwind.config.ts           # Tailwind configuration
└── tsconfig.json               # TypeScript configuration
```

---

## Vercel Deployment Configuration

Since Mix currently uses Vercel, we'll configure Fumadocs to work with Vercel for better performance and features.

Edit `docs/next.config.mjs` for Vercel deployment:

```javascript
import { createMDX } from 'fumadocs-mdx/next';

const withMDX = createMDX();

/** @type {import('next').NextConfig} */
const config = {
  // No output: 'export' needed for Vercel
  // No basePath needed for Vercel custom domains
  reactStrictMode: true,

  // Preserve existing redirects from Mix website
  async redirects() {
    return [
      {
        source: "/docs/changelog",
        destination: "https://github.com/btwld/mix/releases",
        permanent: true,
      },
    ];
  },
};

export default withMDX(config);
```

### Step 2: Update Source Configuration

Edit `docs/source.config.ts`:

```typescript
import { defineDocs, defineConfig } from 'fumadocs-mdx/config';

export const { docs, meta } = defineDocs({
  docs: {
    dir: './content/docs',
    baseUrl: '/docs',
  },
});

export default defineConfig();
```

### Step 3: Configure Vercel Deployment

1. Connect your GitHub repository to Vercel
2. Set the **Root Directory** to `docs`
3. Vercel will automatically detect Next.js and deploy
4. Configure custom domain if needed

---

## Vercel Deployment Automation

Vercel automatically deploys when you push to your repository. No additional configuration needed.

**Vercel Configuration:**
1. Root Directory: `docs`
2. Build Command: `npm run build`
3. Output Directory: `.next` (automatic)
4. Node.js Version: 18.x or higher

**Optional: Vercel Preview Deployments**

Vercel automatically creates preview deployments for pull requests. No additional configuration needed - just push to a branch or create a PR and Vercel will generate a preview URL.

---

## Content Migration from Nextra

### Step 1: Understand Structure Differences

**Current Mix Nextra Structure:**
```
website/pages/docs/
├── _meta.json (with separators and display children)
├── overview/
│   ├── _meta.json
│   ├── index.mdx (Introduction)
│   ├── getting-started.mdx
│   ├── utility-first.mdx
│   ├── comparison.mdx
│   ├── best-practices.mdx
│   ├── migration.mdx
│   └── faq.mdx
├── guides/ (6 files)
├── tutorials/ (5 files)
├── widgets/ (8 files)
├── utilities/ (2 files)
└── tools/ (2 files)
```

**Target Fumadocs Structure:**
```
docs/content/docs/
├── v1/
│   ├── meta.json
│   ├── index.mdx
│   ├── overview/
│   │   ├── meta.json
│   │   └── getting-started.mdx
│   ├── guides/
│   ├── tutorials/
│   ├── widgets/
│   ├── utilities/
│   └── tools/
└── v2/
    ├── meta.json
    └── index.mdx
```

### Step 2: Convert Meta Files

**Current Mix Nextra `_meta.json` (main):**
```json
{
  "-- Overview": {
    "type": "separator",
    "title": "Overview"
  },
  "overview": {
    "title": "Overview",
    "display": "children"
  },
  "-- Guides": {
    "type": "separator",
    "title": "Guides"
  },
  "guides": {
    "title": "Guides",
    "display": "children"
  }
}
```

**Target Fumadocs `meta.json`:**
```json
{
  "title": "Mix v1 Documentation",
  "pages": [
    {
      "type": "separator",
      "title": "Overview"
    },
    "overview",
    {
      "type": "separator",
      "title": "Guides"
    },
    "guides",
    {
      "type": "separator",
      "title": "Tutorials"
    },
    "tutorials",
    {
      "type": "separator",
      "title": "Widgets"
    },
    "widgets",
    {
      "type": "separator",
      "title": "Utilities"
    },
    "utilities",
    {
      "type": "separator",
      "title": "Tools"
    },
    "tools"
  ]
}
```

### Step 3: Create Multi-Version Structure

Set up version-specific folders:

```bash
mkdir -p docs/content/docs/v1
mkdir -p docs/content/docs/v2
```

### Step 4: Migrate Content Files

1. **Copy MDX files** from `website/pages/docs/` to `docs/content/docs/v1/`
2. **Convert meta files** using the format above
3. **Update frontmatter** to include required `title` property
4. **Migrate assets** from `website/public/` to `docs/public/`

**Enhanced migration script for Mix:**

```bash
#!/bin/bash
# Run from repository root

# Create directories
mkdir -p docs/content/docs/v1
mkdir -p docs/public

# Copy content
cp -r website/pages/docs/* docs/content/docs/v1/

# Copy assets (images, icons, etc.)
cp -r website/public/* docs/public/

# Rename meta files
find docs/content/docs/v1 -name "_meta.json" -exec sh -c 'mv "$1" "${1%/*}/meta.json"' _ {} \;

echo "Content migration completed. Review and update meta.json files manually."
echo "Don't forget to:"
echo "1. Update meta.json files to new format"
echo "2. Convert Nextra components to Fumadocs equivalents"
echo "3. Update image paths if needed"
echo "4. Update component imports (Steps, Callout, FileTree, Tabs, Bleed)"
echo "5. Test all components render correctly"
```

### Step 5: Update Content Links

Update internal links in MDX files:

**Before (Nextra):**
```markdown
[Getting Started](/docs/overview/getting-started)
```

**After (Fumadocs):**
```markdown
[Getting Started](/docs/v1/overview/getting-started)
```

### Step 6: Component Migration

Mix documentation uses several Nextra-specific components that need conversion:

**Component Mapping:**
- `<Steps>` from `nextra/components` → `import { Step, Steps } from 'fumadocs-ui/components/steps'`
- `<Callout>` from `nextra-theme-docs` → `import { Callout } from 'fumadocs-ui/components/callout'`
- `<FileTree>` from `nextra/components` → `import { Files, File, Folder } from 'fumadocs-ui/components/files'`
- `<Tabs>` from `nextra/components` → `import { Tabs, Tab } from 'fumadocs-ui/components/tabs'`
- `<Bleed>` from `nextra-theme-docs` → Custom CSS implementation or remove

**Example conversion:**
```mdx
// Before (Nextra)
import { Steps } from "nextra/components";

<Steps>
### Installation
Run the following command...
</Steps>

// After (Fumadocs)
import { Step, Steps } from 'fumadocs-ui/components/steps';

<Steps>
<Step>

### Installation
Run the following command...

</Step>
</Steps>
```

### Step 7: Add Required Frontmatter

Ensure all MDX files have required frontmatter:

```mdx
---
title: Page Title
description: Optional page description
---

# Page Content
```

---

## Multi-Version Documentation Setup

### Step 1: Configure Root Folders

Create `docs/content/docs/v1/meta.json`:

```json
{
  "title": "Mix v1",
  "description": "Current stable version",
  "root": true,
  "pages": [
    "index",
    "overview",
    "guides",
    "utilities",
    "widgets",
    "tutorials",
    "tools"
  ]
}
```

Create `docs/content/docs/v2/meta.json`:

```json
{
  "title": "Mix v2",
  "description": "Next major version",
  "root": true, 
  "pages": [
    "index",
    "migration",
    "new-features",
    "breaking-changes"
  ]
}
```

### Step 2: Update Source Configuration

Edit `docs/lib/source.ts` to handle multiple versions:

```typescript
import { docs, meta } from '@/.source';
import { createMDXSource } from 'fumadocs-mdx';
import { loader } from 'fumadocs-core/source';

export const source = loader({
  baseUrl: '/docs',
  source: createMDXSource(docs, meta),
});

// Export page tree for layouts
export const pageTree = source.pageTree;
```

### Step 3: Configure Sidebar Tabs

The root folders with `"root": true` will automatically create sidebar tabs for version switching.

---

## Advanced Features Configuration

### Search Configuration

Fumadocs includes built-in search. Configure it in `docs/app/layout.tsx`:

```typescript
import { RootProvider } from 'fumadocs-ui/provider';

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>
        <RootProvider
          search={{
            enabled: true,
            // Configure search options
          }}
        >
          {children}
        </RootProvider>
      </body>
    </html>
  );
}
```

### Theme Customization

Update `docs/app/layout.tsx` to match Mix branding:

```typescript
import { DocsLayout } from 'fumadocs-ui/layouts/docs';
import { source } from '@/lib/source';

export default function Layout({ children }: { children: React.ReactNode }) {
  return (
    <DocsLayout
      tree={source.pageTree}
      nav={{
        title: 'Mix Documentation',
        logo: <MixLogo />, // Your logo component
      }}
      links={[
        {
          text: 'GitHub',
          url: 'https://github.com/btwld/mix',
          external: true,
        },
        {
          text: 'Discord',
          url: 'https://discord.gg/Ycn6GV3m2k',
          external: true,
        },
      ]}
    >
      {children}
    </DocsLayout>
  );
}
```

---

## Testing & Deployment

### Local Testing

1. **Start development server:**
   ```bash
   cd docs
   npm run dev
   ```

2. **Test build process:**
   ```bash
   npm run build
   npm start
   ```

3. **Verify functionality:**
   - Navigation between versions (v1/v2 tabs)
   - Search functionality
   - Mobile responsiveness
   - All links and images work
   - Component rendering (Steps, Callouts, FileTree, Tabs)
   - Asset loading (images, icons, OG images)
   - Redirects working properly
   - All Nextra components converted successfully

### Deployment Verification

1. **Push changes to trigger deployment:**
   ```bash
   git add .
   git commit -m "Add Fumadocs documentation"
   git push origin main
   ```

2. **Monitor Vercel Dashboard:**
   - Check deployment status in Vercel dashboard
   - Review build logs for any errors
   - Verify deployment URL

3. **Verify live site:**
   - Visit your Vercel deployment URL
   - Test all functionality
   - Check mobile responsiveness

### Troubleshooting Common Issues

**Build Failures:**
- Check Node.js version (18+ required)
- Verify all MDX files have valid frontmatter
- Ensure component imports are correct
- Check for Nextra-specific syntax that needs conversion

**Missing Images:**
- Images must be in `docs/public/` directory
- Use relative paths: `/images/example.png`
- Verify asset migration completed successfully
- For static export: ensure `images.unoptimized: true` in config

**Component Issues:**
- Convert Nextra components to Fumadocs equivalents
- Check import paths for components (see component mapping above)
- Verify component syntax matches Fumadocs format
- Handle `<Bleed>` component (no direct equivalent - may need custom CSS)
- Test all converted components render correctly

**Routing Issues:**
- Ensure no conflicting basePath settings in Vercel
- Verify redirects are working properly
- Check version navigation (v1/v2 tabs)

---

## Maintenance & Best Practices

### Content Authoring Guidelines

1. **Always include frontmatter:**
   ```mdx
   ---
   title: Page Title
   description: Brief description
   ---
   ```

2. **Use consistent heading structure:**
   - Only one H1 per page
   - Use H2-H6 for subsections
   - Maintain logical hierarchy

3. **Optimize images:**
   - Use WebP format when possible
   - Include alt text for accessibility
   - Keep file sizes reasonable

### Update Procedures

1. **Regular updates:**
   ```bash
   cd docs
   npm update
   ```

2. **Fumadocs updates:**
   ```bash
   npm install fumadocs-ui@latest fumadocs-core@latest fumadocs-mdx@latest
   ```

3. **Test after updates:**
   - Run local build
   - Test all functionality
   - Deploy to staging first

### Performance Monitoring

- Monitor build times in Vercel dashboard
- Check Core Web Vitals with tools like PageSpeed Insights
- Review bundle size reports
- Monitor search performance

### Security Considerations

- Keep dependencies updated
- Review and approve external contributors' PRs
- Use GitHub's security advisories
- Implement proper CORS if needed

---

## Conclusion

This updated migration guide provides a comprehensive path from Nextra to Fumadocs specifically tailored for the Mix project. The guide addresses:

### ✅ **What's Covered**
- **Mix-Specific Structure**: Accounts for Mix's complex documentation hierarchy
- **Vercel Deployment**: Optimized for Mix's current Vercel setup
- **Component Migration**: Handling Nextra-specific components used in Mix docs
- **Asset Migration**: Proper handling of images, icons, and other assets
- **Multi-Version Setup**: v1 and v2 documentation structure

### 🚀 **Benefits of Migration**
- **Better Performance**: Faster builds and loading times
- **Modern Architecture**: Built on latest Next.js App Router
- **Enhanced Search**: Superior Orama search vs FlexSearch
- **Mobile Optimization**: Excellent mobile experience
- **Easy Maintenance**: Simplified content management
- **Vercel Integration**: Seamless deployment with current setup

### 📊 **Realistic Timeline**
- **Total Effort**: 10-16 hours (vs original 5-8 hours)
- **Complexity**: Higher due to Mix's extensive documentation
- **Components**: Additional time needed for Nextra component conversion

### 🔗 **Resources**
For questions or issues during migration, refer to:
- [Fumadocs Documentation](https://fumadocs.dev/docs)
- [Fumadocs GitHub](https://github.com/fuma-nama/fumadocs)
- [Mix Repository](https://github.com/btwld/mix)

### 🎯 **Next Steps**
1. Set up Fumadocs project structure with Vercel
2. Begin content migration section by section
3. Test thoroughly before switching

---

*Last updated: December 2024*
*Migration guide version: 2.0 - Mix Project Specific*

import { defineDocs, defineConfig } from 'fumadocs-mdx/config';

export const { docs, meta } = defineDocs({
  docs: {
    dir: './content/docs',
  },
});

export default defineConfig();

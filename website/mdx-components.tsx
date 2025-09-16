import { useMDXComponents as useDocsMDXComponents } from 'nextra-theme-docs';
import type { UseMDXComponents } from 'nextra/mdx-components';

export const useMDXComponents: UseMDXComponents<any> = (components) => {
    return useDocsMDXComponents(components);
};

import { useMDXComponents as getDocsMDXComponents } from "nextra-theme-docs";
import { generateStaticParamsFor, importPage } from "nextra/pages";

export const generateStaticParams = generateStaticParamsFor("mdxPath");

export default async function Page(props: { params: Promise<{ mdxPath?: string[] }> }) {
    const params = await props.params;
    const result = await importPage(params.mdxPath);
    const { default: MDXContent, toc, metadata } = result as any;
    const Wrapper = getDocsMDXComponents().wrapper as any;
    return (
        <Wrapper toc={toc} metadata={metadata}>
            <MDXContent {...props} params={params} />
        </Wrapper>
    );
}



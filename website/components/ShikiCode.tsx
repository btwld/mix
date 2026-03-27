import { codeToHtml } from "shiki";

interface ShikiCodeProps {
  code: string;
  lang?: string;
  theme?: string;
  className?: string;
}

export async function ShikiCode({
  code,
  lang = "dart",
  theme = "tokyo-night",
  className = "",
}: ShikiCodeProps) {
  const html = await codeToHtml(code.trim(), {
    lang,
    theme,
    structure: "inline",
  });

  return (
    <pre
      className={`m-0 overflow-auto p-5 text-[13px] leading-[1.8] ${className}`}
      style={{ background: "transparent" }}
    >
      <code dangerouslySetInnerHTML={{ __html: html }} />
    </pre>
  );
}

"use client";

import { useEffect, useState } from "react";
import type { Highlighter } from "shiki";

let highlighterPromise: Promise<Highlighter> | null = null;

function getHighlighter(): Promise<Highlighter> {
  if (!highlighterPromise) {
    highlighterPromise = import("shiki").then((shiki) =>
      shiki.createHighlighter({
        themes: ["github-dark"],
        langs: ["dart"],
      })
    );
  }
  return highlighterPromise;
}

interface HighlightedCodeProps {
  code: string;
  className?: string;
}

export function HighlightedCode({ code, className = "" }: HighlightedCodeProps) {
  const [html, setHtml] = useState<string>("");

  useEffect(() => {
    let mounted = true;
    getHighlighter().then((highlighter) => {
      if (!mounted) return;
      const result = highlighter.codeToHtml(code, {
        lang: "dart",
        theme: "github-dark",
      });
      setHtml(result);
    });
    return () => { mounted = false; };
  }, [code]);

  if (!html) {
    return (
      <pre className={`text-sm leading-relaxed text-[var(--mix-text-muted)] ${className}`}>
        <code>{code}</code>
      </pre>
    );
  }

  return (
    <div
      className={`text-sm leading-relaxed [&_pre]:!bg-transparent [&_pre]:!m-0 [&_pre]:!p-0 [&_code]:!text-sm [&_code]:!leading-relaxed ${className}`}
      dangerouslySetInnerHTML={{ __html: html }}
    />
  );
}

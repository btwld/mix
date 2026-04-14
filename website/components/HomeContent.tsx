
"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { Button } from "./Button";
import { FeatureShowcase } from "./FeatureShowcase";
import { HeroBackground } from "./HeroBackground";

import Layout from "./Layout";
import { Logo } from "./Logo";

const fadeUp = {
  hidden: { opacity: 0, y: 20 },
  visible: (delay: number) => ({
    opacity: 1,
    y: 0,
    transition: {
      duration: 0.6,
      delay,
      ease: [0.25, 0.4, 0.25, 1] as const,
    },
  }),
};

const sectionReveal = {
  initial: { opacity: 0, y: 40 },
  whileInView: { opacity: 1, y: 0 },
  viewport: { once: true, margin: "-80px" } as const,
  transition: { duration: 0.6, ease: [0.25, 0.4, 0.25, 1] as const },
};

function CopyTerminal({ command }: { command: string }) {
  const [copied, setCopied] = useState(false);

  const handleCopy = () => {
    navigator.clipboard.writeText(command);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="terminal">
      <span className="terminal-prompt">$</span>
      <span className="terminal-cmd">{command}</span>
      <button
        onClick={handleCopy}
        className="terminal-copy"
        aria-label="Copy command"
      >
        {copied ? (
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <polyline points="20 6 9 17 4 12" />
          </svg>
        ) : (
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <rect x="9" y="9" width="13" height="13" rx="2" ry="2" />
            <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1" />
          </svg>
        )}
      </button>
    </div>
  );
}

export const HomeContent = () => {
  return (
    <>
      <HeroBackground />

      {/* Hero + Features header — constrained width */}
      <Layout>
        <div className="relative z-10">
          {/* Hero */}
          <div className="hero-section">
            <motion.div
              initial="hidden"
              animate="visible"
              custom={0}
              variants={fadeUp}
            >
              <Logo />
            </motion.div>

            <motion.div
              initial="hidden"
              animate="visible"
              custom={0.1}
              variants={fadeUp}
            >
              <h1 className="headline">
                Composable styles that live
                <br className="hidden sm:inline" />
                outside your widget tree.
              </h1>
            </motion.div>

            <motion.div
              initial="hidden"
              animate="visible"
              custom={0.2}
              variants={fadeUp}
            >
              <p className="subtitle">
                Build design systems that scale.
              </p>
            </motion.div>

            <motion.div
              className="not-prose mt-10 flex flex-col sm:flex-row gap-4"
              initial="hidden"
              animate="visible"
              custom={0.3}
              variants={fadeUp}
            >
              <Button href="/documentation/overview/getting-started" arrow="right">
                <>Get Started</>
              </Button>
              <Button href="https://github.com/btwld/mix" variant="secondary" target="_blank">
                <>GitHub</>
              </Button>
            </motion.div>
          </div>

          {/* Features header */}
          <section className="section-gap">
            <motion.div
              className="section-header"
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, margin: "-80px" }}
              transition={{ duration: 0.6, ease: [0.25, 0.4, 0.25, 1] as const }}
            >
              <span className="mono-label">Features</span>
              <h2 className="section-title">Style composition, reactive variants, and design tokens — in one package.</h2>
              <p className="mt-4 max-w-[540px] text-base leading-relaxed text-[var(--mix-text-muted)]">
                Mix uses Dart&apos;s type system to make styles composable and type-safe.
                Chain methods to build styles, compose them with variants, and let the framework handle the rest.
              </p>
            </motion.div>
          </section>
        </div>
      </Layout>

      {/* Feature showcase — full width to breakpoint */}
      <div className="relative z-10 mx-auto w-full max-w-7xl px-4 md:px-8">
        <FeatureShowcase />
      </div>

      {/* Install + CTA — constrained width */}
      <Layout>
        <div className="relative z-10">
          {/* Install */}
          <motion.section
            className="not-prose cli-section section-gap"
            {...sectionReveal}
          >
            <span className="mono-label">Get Started</span>
            <h2 className="section-title">Add Mix to your project.</h2>
            <CopyTerminal command="flutter pub add mix" />
          </motion.section>

          {/* Bottom CTA */}
          <motion.section
            className="not-prose cta-section section-gap"
            {...sectionReveal}
          >
            <h2 className="section-title">Ready to build?</h2>
            <p className="mt-4 text-[var(--mix-text-muted)] max-w-[440px] text-base leading-relaxed">
              Start building your first Mix-styled widget in under 5 minutes.
            </p>
            <div className="mt-8 flex flex-col sm:flex-row gap-4">
              <Button href="/documentation/overview/introduction" variant="filled" arrow="right">
                <>Read the docs</>
              </Button>
              <Button href="/documentation/overview/getting-started" variant="outline">
                <>Quick start</>
              </Button>
            </div>
          </motion.section>
        </div>
      </Layout>

      <style jsx global>{`
        .hero-section {
          padding-top: 80px;
          padding-bottom: 40px;
        }

        .section-gap {
          margin-top: 120px;
        }

        .headline {
          display: block;
          font-size: min(5.5rem, max(9vw, 3.25rem));
          font-weight: 600;
          letter-spacing: -0.03em;
          line-height: 1.1;
          margin-top: 1.5rem;
          background-image: linear-gradient(to bottom right, #fff, #a1a1aa);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          background-clip: text;
          text-align: left;
        }

        .subtitle {
          font-size: 1.125rem;
          line-height: 1.6;
          color: var(--mix-text-muted);
          margin-top: 1.5rem;
          max-width: 480px;
        }

        .mono-label {
          display: inline-block;
          font-family: var(--font-jetbrains-mono), ui-monospace, monospace;
          font-size: 12px;
          text-transform: uppercase;
          letter-spacing: 0.1em;
          color: var(--mix-accent);
        }

        .section-header {
          text-align: left;
          margin-bottom: 48px;
        }

        .section-title {
          font-size: clamp(1.5rem, 4vw, 2.25rem);
          font-weight: 600;
          color: #fff;
          letter-spacing: -0.03em;
          margin-top: 12px;
        }

        .cli-section {
          background: var(--mix-surface);
          border: 1px solid var(--mix-border-card);
          border-radius: 16px;
          padding: 48px 48px;
          text-align: center;
        }

        @media (max-width: 640px) {
          .cli-section {
            padding: 36px 24px;
          }
        }

        .terminal {
          display: inline-flex;
          align-items: center;
          gap: 12px;
          background: var(--mix-bg);
          border-radius: 10px;
          padding: 14px 24px;
          font-family: var(--font-jetbrains-mono), ui-monospace, monospace;
          font-size: 14px;
          border: 1px solid var(--mix-border-card);
          margin-top: 28px;
        }

        .terminal-prompt {
          color: var(--mix-accent);
          font-weight: 600;
        }

        .terminal-cmd {
          color: var(--mix-text-main);
        }

        .terminal-copy {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          background: none;
          border: none;
          color: var(--mix-text-muted);
          cursor: pointer;
          padding: 4px;
          margin-left: 4px;
          border-radius: 4px;
          transition: color 0.2s;
        }

        .terminal-copy:hover {
          color: var(--mix-text-main);
        }

        .cta-section {
          margin-bottom: 80px;
          border-top: 1px solid var(--mix-border-card);
          padding-top: 60px;
          text-align: center;
          display: flex;
          flex-direction: column;
          align-items: center;
        }
      `}</style>
    </>
  );
};

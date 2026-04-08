
"use client";

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

export const HomeContent = () => {
  return (
    <>
      <HeroBackground />
      <Layout>
        <div className="home-content relative z-10">
          <div className="content-container">
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
                  Build design systems
                  <br className="hidden sm:inline" />
                  with surgical precision.
                </h1>
              </motion.div>

              <motion.div
                initial="hidden"
                animate="visible"
                custom={0.2}
                variants={fadeUp}
              >
                <p className="subtitle">
                  Mix is a developer-first styling framework for Flutter where
                  every property is composable, type-safe, and reactive to context.
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

            {/* Features */}
            <section className="mt-36">
              <motion.div
                className="section-header"
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true, margin: "-80px" }}
                transition={{ duration: 0.6, ease: [0.25, 0.4, 0.25, 1] as const }}
              >
                <span className="mono-label">Features</span>
                <h2 className="section-title">Expressive by design, precise by nature.</h2>
                <p className="mt-4 max-w-[540px] text-base leading-relaxed text-[var(--mix-text-muted)]">
                  Mix takes advantage of Dart&apos;s type system and fluent APIs to make
                  styling composable, reactive, and delightful to write.
                </p>
              </motion.div>
              <FeatureShowcase />
            </section>

            {/* Install */}
            <motion.section
              className="not-prose cli-section"
              initial={{ opacity: 0, y: 40 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, margin: "-80px" }}
              transition={{ duration: 0.6, ease: [0.25, 0.4, 0.25, 1] as const }}
            >
              <span className="mono-label">Get Started</span>
              <h2 className="section-title mt-3">Add Mix to your project.</h2>
              <div className="terminal">
                <span className="terminal-prompt">$</span>
                <span className="terminal-cmd">flutter pub add mix</span>
              </div>
            </motion.section>

            {/* Bottom CTA */}
            <motion.section
              className="not-prose cta-section"
              initial={{ opacity: 0, y: 40 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, margin: "-80px" }}
              transition={{ duration: 0.6, ease: [0.25, 0.4, 0.25, 1] as const }}
            >
              <h2 className="section-title">Ready to build?</h2>
              <p className="mt-4 text-[var(--mix-text-muted)] max-w-[440px] text-base leading-relaxed">
                Explore the full API, learn the patterns, and start
                building your design system with Mix.
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

          <style jsx>{`
            .content-container {
              margin: 0 auto;
            }

            .hero-section {
              padding-top: 80px;
              padding-bottom: 40px;
            }

            .headline {
              display: inline-flex;
              font-size: min(4rem, max(7vw, 2.5rem));
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
              margin-top: 100px;
              background: linear-gradient(180deg, var(--mix-surface) 0%, var(--mix-bg) 100%);
              border: 1px solid var(--mix-border-card);
              border-radius: 20px;
              padding: 60px;
              text-align: center;
            }

            .terminal {
              display: inline-flex;
              align-items: center;
              gap: 12px;
              background: #000;
              border-radius: 8px;
              padding: 14px 24px;
              font-family: var(--font-jetbrains-mono), ui-monospace, monospace;
              font-size: 14px;
              border: 1px solid var(--mix-border-card);
              margin-top: 32px;
              box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
            }

            .terminal-prompt {
              color: var(--mix-accent);
              font-weight: bold;
            }

            .terminal-cmd {
              color: #e1e4e8;
            }

            .cta-section {
              margin-top: 100px;
              margin-bottom: 80px;
              border-top: 1px solid var(--mix-border-card);
              padding-top: 60px;
              text-align: center;
              display: flex;
              flex-direction: column;
              align-items: center;
            }
          `}</style>
        </div>
      </Layout>
    </>
  );
};

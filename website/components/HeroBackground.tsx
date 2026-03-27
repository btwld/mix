"use client";

import { motion } from "framer-motion";

export const HeroBackground = () => {
  return (
    <div className="pointer-events-none fixed inset-0 w-full h-full z-0">
      {/* Noise overlay for premium texture */}
      <svg
        className="absolute inset-0 h-full w-full opacity-[0.04] mix-blend-screen z-20"
      >
        <filter id="noise">
          <feTurbulence
            type="fractalNoise"
            baseFrequency="0.65"
            numOctaves="3"
            stitchTiles="stitch"
          />
        </filter>
        <rect width="100%" height="100%" filter="url(#noise)" />
      </svg>

      {/* Fluid lava blobs */}
      <div className="absolute inset-0 w-full h-full overflow-hidden blur-[100px] md:blur-[160px] saturate-[1.3] opacity-50 z-0">
        {/* Blob 1 — Deep Violet */}
        <motion.div
          className="absolute top-[-10%] left-[-10%] w-[70vw] h-[70vw] md:w-[45vw] md:h-[45vw] rounded-full bg-[#7c3aed] opacity-40"
          animate={{
            x: ["0%", "25%", "-15%", "0%"],
            y: ["0%", "20%", "-25%", "0%"],
            scale: [1, 1.2, 0.8, 1],
          }}
          transition={{
            duration: 22,
            repeat: Infinity,
            ease: "easeInOut",
          }}
        />

        {/* Blob 2 — Soft Purple */}
        <motion.div
          className="absolute top-[15%] right-[-10%] w-[65vw] h-[65vw] md:w-[40vw] md:h-[40vw] rounded-full bg-[#c084fc] opacity-30"
          animate={{
            x: ["0%", "-30%", "15%", "0%"],
            y: ["0%", "-20%", "25%", "0%"],
            scale: [1, 0.9, 1.1, 1],
          }}
          transition={{
            duration: 26,
            repeat: Infinity,
            ease: "easeInOut",
          }}
        />

        {/* Blob 3 — Cool Indigo */}
        <motion.div
          className="absolute bottom-[-15%] left-[10%] w-[75vw] h-[75vw] md:w-[50vw] md:h-[50vw] rounded-full bg-[#818cf8] opacity-25"
          animate={{
            x: ["0%", "20%", "-25%", "0%"],
            y: ["0%", "-30%", "15%", "0%"],
            scale: [1, 1.1, 0.9, 1],
          }}
          transition={{
            duration: 30,
            repeat: Infinity,
            ease: "easeInOut",
          }}
        />

        {/* Blob 4 — Deep Purple */}
        <motion.div
          className="absolute bottom-[5%] right-[5%] w-[60vw] h-[60vw] md:w-[35vw] md:h-[35vw] rounded-full bg-[#6d28d9] opacity-30"
          animate={{
            x: ["0%", "-25%", "20%", "0%"],
            y: ["0%", "25%", "-20%", "0%"],
            scale: [1, 1.15, 0.85, 1],
          }}
          transition={{
            duration: 24,
            repeat: Infinity,
            ease: "easeInOut",
          }}
        />
      </div>
    </div>
  );
};

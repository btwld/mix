"use client";

export const HeroBackground = () => {
  return (
    <div className="pointer-events-none fixed inset-0 w-full h-full z-0">
      {/* Static radial glow — brand presence without the lava lamp */}
      <div
        className="absolute inset-0"
        style={{
          background: [
            "radial-gradient(ellipse 60% 50% at 20% 10%, var(--mix-blob-1) 0%, transparent 70%)",
            "radial-gradient(ellipse 50% 40% at 80% 20%, var(--mix-blob-2) 0%, transparent 70%)",
          ].join(", "),
          opacity: 0.12,
        }}
      />
    </div>
  );
};

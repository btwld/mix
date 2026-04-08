"use client";

export const HeroBackground = () => {
  return (
    <div className="pointer-events-none fixed inset-0 w-full h-full z-0">
      {/* Radial glow */}
      <div
        className="absolute inset-0"
        style={{
          background:
            "radial-gradient(circle at 50% -20%, rgba(139, 92, 246, 0.12) 0%, transparent 60%)",
        }}
      />
      {/* Grid lines */}
      <div
        className="absolute inset-0 opacity-[0.04]"
        style={{
          backgroundImage: [
            "linear-gradient(to right, rgba(255,255,255,0.5) 1px, transparent 1px)",
            "linear-gradient(to bottom, rgba(255,255,255,0.5) 1px, transparent 1px)",
          ].join(", "),
          backgroundSize: "40px 40px",
        }}
      />
    </div>
  );
};

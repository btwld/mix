"use client";
import Image from "next/image";

export const Logo = ({ size = 150 }) => (
  <Image
    alt="Mix logo"
    width={95}
    height={105}
    src="/assets/icon_logo.svg"
    style={{ width: size, height: 'auto' }}
  />
);

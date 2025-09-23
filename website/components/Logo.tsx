import Image from "next/image";

export const Logo = ({ size = 150 }) => (
  <Image
    alt="Mix logo"
    width={size}
    height={size}
    src="/assets/mix-icon-dark.svg"
  />
);

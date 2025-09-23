import { PropsWithChildren } from "react";

const Layout = ({ children }: PropsWithChildren) => {
  return (
    <div className="flex justify-center">
      <div className="w-full max-w-5xl px-4 md:px-8">{children}</div>
    </div>
  );
};

export default Layout;

import Document, { Head, Html, Main, NextScript } from "next/document";

// data-theme="dark"

class CustomDocument extends Document {
  render() {
    return (
      <Html data-theme="dark">
        <Head />
        <body>
          <Main />
          <NextScript />
        </body>
      </Html>
    );
  }
}

export default CustomDocument;

import React from "react";
import NextDocument, { Html, Head, Main, NextScript } from "next/document";

class Document extends NextDocument {
    render() {
        return (
            <Html>
                <Head />
                <body className="font-sans text-black font-thin antialiased text-black">
                    <Main />
                    <NextScript />
                </body>
            </Html>
        );
    }
}

export default Document

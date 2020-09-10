import React from "react";
import NextDocument, { Html, Head, Main, NextScript } from "next/document";
import { cn } from "@scaling/utils";

class Document extends NextDocument {
    render(): JSX.Element {
        return (
            <Html className={cn("h-full", "w-full")} lang="en">
                <Head />
                <body className={cn("w-full" ,"h-full", "font-sans", "text-black", "font-thin", "antialiased", "text-black")}>
                    <Main />
                    <NextScript />

                    <style jsx global={true}>{`
                        #__next {
                            width: 100%;
                            height: 100%;
                        }
                    `}
                    </style>
                </body>
            </Html>
        );
    }
}

export default Document

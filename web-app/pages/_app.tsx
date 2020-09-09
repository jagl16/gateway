import React from "react";
import { AppProps, AppInitialProps } from "next/app";

import "./main.css"

interface ApplicationProps extends AppInitialProps, AppProps {}

const Application = ({
    pageProps,
    Component
}: ApplicationProps) => <Component {...pageProps} />

export default Application

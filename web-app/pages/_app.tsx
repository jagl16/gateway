import React from "react";
import App, {
    AppProps,
    AppInitialProps,
    AppContext
} from "next/app";

import "./main.css"

import { createInitializers, InitializerData } from "@scaling/application-initializers";

const initializers = require.context('../initializers/', true, /\.ts(x)$/);
const Initializers = createInitializers<AppContext>(initializers);

interface ApplicationInitialProps extends AppInitialProps {
    initializersData: InitializerData;
}

interface ApplicationProps extends ApplicationInitialProps, AppProps {}

const Application = ({
    initializersData,
    pageProps,
    Component
}: ApplicationProps) => (
    <Initializers data={initializersData}>
        <Component {...pageProps} />
    </Initializers>
);

Application.getInitialProps = async (
    appContext: AppContext,
): Promise<ApplicationInitialProps> => {
    const [initializersData, appProps] = await Promise.all([
        Initializers.getInitializerProps(appContext),
        App.getInitialProps(appContext),
    ]);

    return {
        initializersData,
        ...appProps,
    };
};

export default Application

import React from "react";
import { GetStaticProps, NextPage } from "next";

import { LoggerProvider } from "@scaling/logger"

import { Login, Initializers } from "@scaling-applications/auth";
import { InitializerData } from "@scaling/application-initializers";

interface IndexPageInitialProps {
    data: InitializerData;
}

interface IndexPageProps extends IndexPageInitialProps {}

const IndexPage: NextPage<IndexPageProps, IndexPageInitialProps> = ({ data }) => {
    return (
        <Initializers data={data}>
            <LoggerProvider>
                <Login />
            </LoggerProvider>
        </Initializers>
    )
}

export const getStaticProps: GetStaticProps = async (context) => {
    const data = await Initializers.getInitializerProps(context);

    return {
        props: {
            data,
        },
    };
};

export default IndexPage

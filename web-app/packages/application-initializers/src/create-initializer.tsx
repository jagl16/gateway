import React from 'react';

import {
    InitializationProvidersProps,
    Initializer,
    InitializerData,
    InitializersProvider,
    RequireContext
} from "../types";

import { Optional } from "@scaling/utils";
import { getInitializers } from "./get";

const createInitializerId = (idx: number) => `i${idx}`;

/* eslint-disable @typescript-eslint/no-explicit-any */
const createGetInitializerProps = <C, D extends any>(
    initializers: Initializer<C, D>[],
) => async (context: C): Promise<InitializerData<D>> => {
    const results = await Promise.all(
        initializers.map((initializer) => {
            const { getInitializerProps } = initializer;
            if (!getInitializerProps) return Promise.resolve(undefined);

            return getInitializerProps(context);
        }),
    );

    return results.reduce((acc: any, result, idx) => {
        const id = createInitializerId(idx);
        if (result) acc[id] = result;
        return acc;
    }, {});
};

export const createInitializers = <C, D = Record<string, unknown>>(
    requireContext: RequireContext,
) => {
    const initializers = getInitializers<C, D>(requireContext);
    const Initializers: InitializersProvider<
        InitializationProvidersProps<D>,
        C,
        D
        > = ({ children, data }) =>
        initializers.reduce((children, initializer, idx) => {
            const { Provider } = initializer;
            const id = createInitializerId(idx);
            const providerData = Optional.ofNullable(data as any)
                .map((d) => d[id])
                .orElse({});

            return <Provider {...providerData}>{children}</Provider>;
        }, children);

    const getInitializerProps = createGetInitializerProps(initializers);
    Initializers.getInitializerProps = getInitializerProps;

    return Initializers;
};

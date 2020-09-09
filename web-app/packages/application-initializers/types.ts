import React, { ComponentType, ReactElement } from "react";
import { Nullable } from "@scaling/types";

export type InitializerData<D = Record<string, unknown>> = D | null;

export type RequireContext = __WebpackModuleApi.RequireContext;

export type GetInitializerProps<C, IP> = Nullable<
    (context: C) => Promise<IP> | IP
>;

export interface Initializer<C, IP = Record<string, unknown>> {
    Provider: React.FC<IP> | ComponentType<IP>;
    getInitializerProps?: GetInitializerProps<C, IP>;
    // prop types are not relevant for this, so type `any` is fine here
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    after?: Initializer<C, any>[];
}

export type InitializersProvider<P, C, D> = ComponentType<P> & {
    getInitializerProps(
        context: C,
    ): InitializerData<D> | Promise<InitializerData<D>>;
};

export interface InitializationProvidersProps<D> {
    children: ReactElement;
    data: InitializerData<D>;
}

import { Initializer, RequireContext } from "../types";
import { resolve } from "./resolve";

export const getInitializers = <C, P>(requireContext: RequireContext): Initializer<C, P>[] => {
    const initializers = requireContext.keys().map((fileName) => {
        const module = requireContext(fileName);
        return module.default as Initializer<C, P>;
    });

    return resolve(initializers);
};

import {createContext} from "react";
import { LogInterface } from "../types";
import { noop } from "@scaling/utils";

export const Log = createContext<LogInterface>({
    log: noop
})

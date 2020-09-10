import { useContext } from "react";
import { Log } from "../context/log";
import { LogInterface } from "../types";

export const useLogger = (): LogInterface => useContext(Log)

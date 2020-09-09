import { useContext } from "react";
import { Log } from "../context/log";

export const useLogger = () => useContext(Log)

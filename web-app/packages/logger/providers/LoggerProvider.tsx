import React, { FC, useCallback, useMemo} from "react";

import { Log } from "../context/log";
import { LogEvent } from "@scaling/logger/types";

const createLogger = () => {
    const log = useCallback((event: LogEvent) => {
        if (typeof window === 'undefined') {
            return;
        }

        if (process.env.NODE_ENV !== 'production') {
            console.debug('Log', { ...event });
        }
    }, [])

    return useMemo(() => ({ log }), [log])
}

export const LoggerProvider: FC = ({ children }) => {
    const logger = createLogger()

    return (
        <Log.Provider value={logger}>
            { children }
        </Log.Provider>
    )
}

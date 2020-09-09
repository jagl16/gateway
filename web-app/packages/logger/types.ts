export interface LogEvent {
    message: string
}

export interface LogInterface {
    log: LogFunction;
}

export type LogFunction = (event: LogEvent) => void;

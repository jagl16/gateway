import { Nullable } from '@scaling/types';

abstract class Optional<T> {
    abstract isPresent(): this is Some<T>;
    abstract ifPresent(fn: (value: T) => void): void;
    abstract map<U>(fn: (value: T) => U): Optional<U>;
    abstract mapTo<U>(value: U): Optional<U>;
    abstract filter(fn: (value: T) => boolean): Optional<T>;
    abstract flatMap<U>(fn: (value: T) => Optional<U>): Optional<U>;
    abstract orElse(alternative: T): T;
    abstract orElseGet(supplier: () => T): T;
    abstract orElseThrow(supplier: () => void): T;

    /**
     * If value is present apply the fn on it otherwise return falsy, useful
     * when dealing with jsx templates where we can show the element only if
     * the value actually exists.
     *
     * @param fn - a function that receives the value if present
     *
     * eg: item.optionValue.toValueOrFalse(value => (<span>{value}</span>));
     */
    toValueOrFalse<U>(fn: (value: T) => U): U | false {
        return this.isPresent() && fn(this.value);
    }

    fold<U>(asNone: () => U, asSome: (value: T) => U): U {
        return this.map(asSome).orElseGet(asNone);
    }

    static of<T>(value: T): Optional<T> {
        // eslint-disable-next-line @typescript-eslint/no-use-before-define
        return new Some<T>(value);
    }

    static ofNullable<T>(value: Nullable<T>): Optional<T> {
        return value === null || typeof value === 'undefined'
            ? Optional.empty<T>()
            : Optional.of(value);
    }

    static empty<T>(): Optional<T> {
        // eslint-disable-next-line @typescript-eslint/no-use-before-define
        return new None<T>();
    }
}

class None<T> extends Optional<T> {
    isPresent() {
        return false;
    }

    ifPresent(): void {
        return;
    }
    map<U>(): Optional<U> {
        return Optional.empty<U>();
    }
    mapTo<U>(): Optional<U> {
        return Optional.empty<U>();
    }
    filter(): Optional<T> {
        return this;
    }
    flatMap<U>(): Optional<U> {
        return Optional.empty<U>();
    }
    orElse(alternative: T): T {
        return alternative;
    }
    orElseGet(supplier: () => T): T {
        return supplier();
    }
    orElseThrow(supplier: () => void): T {
        throw supplier();
    }
}

class Some<T> extends Optional<T> {
    value: T;
    constructor(value: T) {
        super();
        this.value = value;
    }
    isPresent(): boolean {
        return true;
    }
    ifPresent(fn: (value: T) => void): void {
        fn(this.value);
    }
    map<U>(fn: (value: T) => U): Optional<U> {
        return Optional.of(fn(this.value));
    }
    mapTo<U>(value: U): Optional<U> {
        return Optional.of(value);
    }
    filter(fn: (value: T) => boolean): Optional<T> {
        return fn(this.value) ? this : Optional.empty<T>();
    }
    flatMap<U>(fn: (value: T) => Optional<U>): Optional<U> {
        return fn(this.value);
    }
    orElse(): T {
        return this.value;
    }
    orElseGet(): T {
        return this.value;
    }
    orElseThrow(): T {
        return this.value;
    }
}

export const isSome = <T>(opt: Optional<T>): opt is Some<T> => {
    return opt.isPresent();
};

export { Optional };

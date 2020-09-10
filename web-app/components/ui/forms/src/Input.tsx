import React, { ChangeEvent, FC } from "react";
import { cn } from "@scaling/utils";

export const Input: FC<{
    value: string | number | readonly string[] | undefined,
    type: string,
    onChange: (event: ChangeEvent<HTMLInputElement>) => void
    placeholder?: string,
}> = ({ value, type, placeholder, onChange }) => (
    <span className="relative">
        <input
            type={type}
            value={value}
            onChange={onChange}
            placeholder={placeholder}
            className={cn("rounded", "shadow", "border", "p-2", "block", "w-full", "text-black", "leading-normal", "align-middle", "bg-white", "text-base")}
        />
    </span>
)

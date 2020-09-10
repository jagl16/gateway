import React, { FC } from "react";
import { cn } from "@scaling/utils";

export const Label: FC = ({ children }) => {
    return (
        <label className={cn("block", "mb-2", "text-sm", "font-medium")}>
            { children }
        </label>
    )
}

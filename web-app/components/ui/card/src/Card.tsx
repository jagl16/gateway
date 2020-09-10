import React, { FC } from "react";
import { cn } from "@scaling/utils";

export const Card: FC = ({ children }) => (
    <div className={cn("bg-white", "rounded", "border-2", "border-gray-200")}>
        { children }
    </div>
)

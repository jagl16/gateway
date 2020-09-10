import React, { FC } from "react";
import { cn } from "@scaling/utils";

const GuestLayout: FC = ({ children }) => (
    <div className={cn("w-full", "h-full", "overflow-hidden", "flex", "flex-col", "bg-gray-100")}>
        { children }
    </div>
);

export default GuestLayout;

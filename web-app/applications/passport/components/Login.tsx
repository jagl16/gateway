import React, { FormEvent, useState } from "react";
import { cn } from "@scaling/utils";
import { Card } from "@ui/card";
import { Button, Group, Input, Label } from "@ui/forms";

export const Login = (): JSX.Element => {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');

    const handleSubmit = (event: FormEvent<HTMLFormElement>) => {
        event.preventDefault()

        console.log("Submit event has been handled.")
    }

    return (
        <div className={cn("w-full", "max-w-sm", "px-3", "m-auto", "md:px-0")}>
            <Card>
                <form onSubmit={handleSubmit} className={cn("p-4", "border-b", "border-gray-200", "last:border-b-0")}>
                    <Group>
                        <Label>Email</Label>
                            <Input placeholder={"Email"} type={"email"} value={email} onChange={(event => setEmail(event.target.value))} />
                    </Group>
                    <Group>
                        <Label>Password</Label>
                        <Input placeholder={"Password"} type={"password"} value={password} onChange={(event => setPassword(event.target.value))} />
                    </Group>
                    <Button type={"submit"} block={true} rounded={true} color={cn("bg-blue-500", "hover:bg-blue-400", "text-white")}>Login</Button>
                </form>
            </Card>
        </div>
    )
}

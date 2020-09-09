import React, { FC, useEffect } from 'react';

import { createMicroApplicationInitializer } from '@scaling/application-initializers';
import { useLogger } from '@scaling/logger';

const LoginLoggingProvider: FC = (props) => {
    const logger = useLogger();

    useEffect(() => {
        logger.log({
            message: "Log in page has been loaded."
        });
    }, []);

    return <>{props.children}</>;
};

export default createMicroApplicationInitializer({
    Provider: LoginLoggingProvider,
});

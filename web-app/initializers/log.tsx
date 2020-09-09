import { createApplicationInitializer } from '@scaling/application-initializers';
import { LoggerProvider } from '@scaling/logger';

export default createApplicationInitializer({
    Provider: LoggerProvider,
});

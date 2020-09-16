import { GetStaticPropsContext, NextPageContext } from 'next'

import { createInitializers } from '@scaling/application-initializers'

export { Login } from './components/Login'

const initializers = require.context('./initializers/', true, /\.ts(x)$/)

export const Initializers = createInitializers<
  NextPageContext | GetStaticPropsContext
>(initializers)

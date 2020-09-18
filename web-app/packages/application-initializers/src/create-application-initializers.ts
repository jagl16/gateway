import { Initializer } from '../types'

import { AppContext } from 'next/app'
import { NextPageContext } from 'next'

export const createApplicationInitializer = <P>(
  initializer: Initializer<AppContext, P>,
): Initializer<AppContext, P> => initializer

export const createMicroApplicationInitializer = <P>(
  initializer: Initializer<NextPageContext, P>,
): Initializer<NextPageContext, P> => initializer

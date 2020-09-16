import React, { FC } from 'react'
import { cn } from '@scaling/utils'

export const Group: FC = ({ children }) => {
  return <label className={cn('block', 'mb-6', 'w-full')}>{children}</label>
}

import React, { FC } from 'react'
import { cn } from '@scaling/utils'

export const CardSection: FC = ({ children }) => (
  <div className={cn('p-4', 'border-b', 'border-gray-200', 'last:border-b-0')}>
    {children}
  </div>
)

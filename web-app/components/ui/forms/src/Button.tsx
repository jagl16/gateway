import React, { FC } from 'react'
import { cn } from '@scaling/utils'

export const Button: FC<{
  color?: string
  type?: 'submit' | 'button'
  block?: boolean
  rounded?: boolean
  disabled?: boolean
}> = ({
  type = 'submit',
  block = false,
  color,
  disabled = false,
  rounded = false,
  children,
}) => {
  return (
    <button
      type={type}
      className={cn(
        'relative',
        'px-3',
        'py-2',
        color,
        block ? 'w-full' : '',
        rounded ? 'rounded' : '',
      )}
      disabled={disabled}
    >
      {children}
    </button>
  )
}

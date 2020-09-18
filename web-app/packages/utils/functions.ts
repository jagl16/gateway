export const noop = (): void => {}

export const cn = (
  ...classes: (false | null | undefined | string)[]
): string => {
  return classes.filter(Boolean).join(' ')
}

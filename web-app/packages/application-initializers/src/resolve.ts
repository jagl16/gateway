import { Initializer } from '@scaling/application-initializers/types'

export const resolve = <C, P>(
  initializers: Initializer<C, P>[],
): Initializer<C, P>[] => {
  const result: Initializer<C, P>[] = []
  const done = new Set<Initializer<C, P>>()
  const processing = new Set<Initializer<C, P>>()

  const visit = (initializer: Initializer<C, P>) => {
    // We already visited this one
    if (done.has(initializer)) {
      return
    }

    if (processing.has(initializer)) {
      const displayName = initializer.Provider.displayName || 'Unknown'
      throw new Error(
        'Could not resolve initializers due to a circluar dependecy. ' +
          'Check Initializer with Provider `' +
          displayName +
          '`',
      )
    }

    // Mark initializer as being processed
    processing.add(initializer)

    // Visit dependencies first
    const dependencies = initializer.after || []
    dependencies.forEach(visit)

    // Allocate node
    processing.delete(initializer)
    done.add(initializer)

    // Move to head of result
    result.unshift(initializer)
  }

  initializers.forEach(visit)

  return result
}

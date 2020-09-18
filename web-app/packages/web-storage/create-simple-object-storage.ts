export const createSimpleObjectStorage = (): Storage => {
  let storage: Record<string, string> = {}

  const getItem = (key: string): string | null => {
    if (Object.prototype.hasOwnProperty.call(storage, key)) {
      return storage[key]
    }

    return null
  }

  const setItem = (key: string, value: string): void => {
    storage[key] = value
  }

  const removeItem = (key: string): void => {
    delete storage[key]
  }

  const clear = (): void => {
    storage = {}
  }

  const length = (): number => Object.keys(storage).length

  const key = (index: number): string | null =>
    Object.keys(storage)[index] || null

  return {
    key,
    getItem,
    setItem,
    removeItem,
    clear,
    get length() {
      return length()
    },
  }
}

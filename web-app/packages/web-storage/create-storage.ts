import { Nullable } from '@scaling/types'

import { createSimpleObjectStorage } from './create-simple-object-storage'

export interface WebStorage extends Omit<Storage, 'getItem' | 'setItem'> {
  getItem<T>(key: string): Nullable<T>

  setItem<T>(key: string, value: T): void
}

const isSupportedStorage = (getStorage: () => Nullable<Storage>): boolean => {
  try {
    const storage = getStorage()

    if (!storage) {
      return false
    }

    storage.setItem('key', 'value')
    storage.removeItem('key')

    return true
  } catch (e) {
    return false
  }
}

const getSupportedStorage = (getStorage: () => Nullable<Storage>): Storage => {
  if (isSupportedStorage(getStorage)) {
    return getStorage() as Storage
  }

  return createSimpleObjectStorage()
}

export const createStorage = (
  getStorage: () => Nullable<Storage>,
): WebStorage => {
  const storage = getSupportedStorage(getStorage)

  const getItem = <T>(key: string): Nullable<T> => {
    const value = storage.getItem(key)

    return value ? JSON.parse(value) : value
  }

  const setItem = <T>(key: string, value: T): void => {
    storage.setItem(key, JSON.stringify(value))
  }

  const removeItem = (key: string): void => {
    storage.removeItem(key)
  }

  const clear = (): void => {
    storage.clear()
  }

  const length = (): number => storage.length

  return {
    getItem,
    setItem,
    removeItem,
    clear,
    get length() {
      return length()
    },
  }
}

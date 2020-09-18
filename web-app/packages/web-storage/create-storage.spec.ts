import { createStorage } from './create-storage'
import { createStorageTests, createCustomStorageTests } from './utils'

describe('createStorage', () => {
  describe('with: localStorage', () => {
    const storage = () => createStorage(() => window.localStorage)

    createCustomStorageTests(storage)
    createStorageTests(storage)
  })

  describe('with: fallback', () => {
    const storage = () =>
      createStorage(() => {
        throw Error
      })

    createCustomStorageTests(storage)
    createStorageTests(storage)
  })
})

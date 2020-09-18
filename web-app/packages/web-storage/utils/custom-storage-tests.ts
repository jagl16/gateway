import { WebStorage } from '@scaling/web-storage/create-storage'

export const createCustomStorageTests = (
  createStorage: () => WebStorage,
): void => {
  let storage: WebStorage

  beforeEach(() => {
    storage = createStorage()
  })

  afterEach(() => {
    storage.clear()
  })

  describe('`.setItem` and `.getItem`', () => {
    describe('can set/get the key and value, with different data types', () => {
      it('string', () => {
        const key = 'key'
        const value = 'value'

        storage.setItem(key, value)

        expect(storage.getItem(key)).toBe(value)
      })

      it('number', () => {
        const key = 'key'
        const value = 3

        storage.setItem(key, value)

        expect(storage.getItem(key)).toBe(value)
      })

      it('boolean', () => {
        const key = 'key'
        const value = true

        storage.setItem(key, value)

        expect(storage.getItem(key)).toBe(value)
      })

      it('array', () => {
        const key = 'key'

        storage.setItem(key, [1, 2, 3, null, undefined])

        expect(storage.getItem(key)).toEqual([1, 2, 3, null, null])
      })

      it('object', () => {
        const key = 'key'

        storage.setItem(key, {
          name: 'Erik',
          age: 99,
          email: undefined,
          projects: [undefined, null],
        })

        expect(storage.getItem(key)).toEqual({
          name: 'Erik',
          age: 99,
          projects: [null, null],
        })
      })
    })
  })
}

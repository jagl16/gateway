import { WebStorage } from '../create-storage'

export const createStorageTests = (
  createStorage: () => WebStorage | Storage,
): void => {
  let storage: WebStorage | Storage

  beforeEach(() => {
    storage = createStorage()
  })

  afterEach(() => {
    storage.clear()
  })

  describe('.setItem', () => {
    it('overwrites already set value', () => {
      const key = 'key'
      const value = 'value'
      const value2 = 'value2'

      storage.setItem(key, value)
      expect(storage.getItem(key)).toBe(value)

      storage.setItem(key, value2)
      expect(storage.getItem(key)).toBe(value2)
    })
  })

  describe('.getItem', () => {
    it('returns `null` if the key does not exist', () => {
      expect(storage.getItem('key_does_not_exist')).toBe(null)
    })
  })

  describe('.removeItem', () => {
    it('deletes the key from the storage', () => {
      const key = 'key'
      const value = 'value'

      storage.setItem(key, value)
      expect(storage.getItem(key)).toBe(value)

      storage.removeItem(key)
      expect(storage.getItem(key)).toBe(null)
    })

    it('does not throw, when removing a non existing key', () => {
      expect(() => {
        storage.removeItem('key_does_not_exist')
      }).not.toThrow()
    })
  })

  describe('.clear', () => {
    it('removes all entries from the storage', () => {
      storage.setItem('key1', 'value1')
      storage.setItem('key2', 'value2')

      expect(storage.length).toBe(2)

      storage.clear()
      expect(storage.length).toBe(0)
    })

    it('does not throw, if storage is empty', () => {
      expect(() => {
        storage.clear()
      }).not.toThrow()
    })
  })
}

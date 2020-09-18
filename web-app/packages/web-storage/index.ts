import { createStorage } from '@scaling/web-storage/create-storage'

export const local = createStorage(() => localStorage)

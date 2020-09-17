module.exports = {
  setupFilesAfterEnv: ['@testing-library/jest-dom/extend-expect'],
  testPathIgnorePatterns: ['/node_modules/', '/.next/'],
  testMatch: ['**/?(*.)+(spec|test).[jt]s?(x)'],
  transform: {
    '^.+\\.(ts|tsx)$': '<rootDir>/node_modules/ts-jest',
  },
  transformIgnorePatterns: ['/node_modules/'],
  moduleNameMapper: {
    '@scaling-applications/(.+)': ['<rootDir>/applications/$1'],
    '@scaling/(.+)': ['<rootDir>/packages/$1'],
  },
  globals: {
    'ts-jest': {
      tsConfig: '<rootDir>/tsconfig.jest.json',
    },
  },
}

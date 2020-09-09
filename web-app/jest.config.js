module.exports = {
  setupFilesAfterEnv: ["@testing-library/jest-dom/extend-expect"],
  testMatch: ['**/?(*.)+(spec|test).[jt]s?(x)'],
  transformIgnorePatterns: [
    '/node_modules/',
  ],
  moduleNameMapper: {
    '@scaling-applications/(.+)': ['<rootDir>/applications/$1'],
    '@scaling/(.+)': ['<rootDir>/packages/$1'],
  },
};

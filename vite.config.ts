import { defineConfig } from "vite-plus";

export default defineConfig({
  staged: {
    "*": "vp check --fix",
  },
  lint: {
    jsPlugins: [{ name: "vite-plus", specifier: "vite-plus/oxlint-plugin" }],
    rules: { "vite-plus/prefer-vite-plus-imports": "error" },
    options: { typeAware: true, typeCheck: true },
  },
  fmt: {
    printWidth: 80,
    sortPackageJson: false,
    astro: {},
    associations: [
      {
        files: ["*.astro"],
        language: "astro",
      },
    ],
    ignorePatterns: [],
  },
});

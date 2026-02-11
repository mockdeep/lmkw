import {defineConfig} from "vitest/config";

export default defineConfig({
  test: {
    coverage: {
      exclude: ["app/javascript/@types/**"],
      include: ["app/javascript/**/*.ts"],
      provider: "v8",
      reportsDirectory: "coverage",
      thresholds: {
        branches: 100,
        functions: 100,
        lines: 0,
        statements: 0,
      },
    },
    deps: {
      moduleDirectories: [
        "node_modules",
        "app/javascript",
        "spec/javascript",
      ],
    },
    environment: "jsdom",
    environmentOptions: {
      jsdom: {
        url: "http://test.host",
      },
    },
    globals: true,
    include: ["spec/javascript/**/*_spec.ts"],
    mockReset: true,
    reporters: [
      "default",
      ["junit", {outputFile: "test_results/vitest-junit.xml"}],
    ],
    restoreMocks: true,
    setupFiles: ["spec/javascript/test_helper.ts"],
  },
});

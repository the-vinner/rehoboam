import { defineConfig } from 'vite'
import jsx from '@vitejs/plugin-vue-jsx'
// @ts-ignore
import fs from 'fs'
// @ts-ignore
import { resolve } from "path";

export default defineConfig({
  base: process.env.NODE_ENV === "production" ? "/public/client/" : "/",
  resolve: {
    alias: {
      // @ts-ignore
      'components': resolve(__dirname, './src/components'),
      // @ts-ignore
      'hooks': resolve(__dirname, './src/hooks'),
      // @ts-ignore
      'root': resolve(__dirname, './src'),
      // @ts-ignore
      'shared': resolve(__dirname, '../../shared/src')
    }
  },
  build: {
    emptyOutDir: true,
    manifest: true,
    outDir: "../../priv/static/public/client",
    rollupOptions: {
      // overwrite default .html entry
      input: './src/entry-client.ts'
    }
  },
  plugins: [
    jsx(),
    {
      name: "css",
      transform (src, id) {
        if (
          ~id.indexOf('@fontsource') &&
          /\.(css)$/.test(id) &&
          process.env.NODE_ENV !== "production"
        ) {
          return {
            code:  src.replace(/url\('\/node_/g, `url('http://localhost:3000/node_`),
            map: null
          }
        }
      }
    },
    {
      name: "gql",
      transform (src, id) {
        if (/\.(gql)$/.test(id)) {
          return {
            code: `export default \`${src}\``,
            map: null
          }
        }
      }
    }
  ]
})

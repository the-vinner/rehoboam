import cacheExchange from './cacheExchange'
import {
  dedupExchange,
  errorExchange,
  CombinedError,
  Operation,
  makeOperation,
  createClient
} from '@urql/core';
import {
  multipartFetchExchange
} from '@urql/exchange-multipart-fetch';
import {
  ssrExchange
} from '@urql/vue';
import {
  authExchange
} from '@urql/exchange-auth'

import schema from 'shared/introspection.json'
import sessionRenew from 'shared/sessionRenew'
import useIsLoggedOut from 'hooks/useIsLoggedOut';

export default (args : {headers?: string[]} = {}) => {
  // The `ssrExchange` must be initialized with `isClient` and `initialState`
  const ssr = ssrExchange({
    isClient: !
      import.meta.env.SSR,
    initialState: !
      import.meta.env.SSR ?
      JSON.parse((window as any).__URQL_DATA__ || "{}") :
      undefined,
  });

  const { isLoggedOut } = useIsLoggedOut()

  const client = createClient({
    fetchOptions: {
      credentials: "same-origin"
    },
    url: import.meta.env.SSR ? 'http://localhost:4000/graphql/v1' : "/graphql/v1",
    exchanges: [
      dedupExchange,
      cacheExchange(schema),
      errorExchange({
        onError: (error: CombinedError, operation: Operation) => {
          console.error(error.message, operation)
        },
      }),
      authExchange({
        addAuthToOperation: ({
          authState,
          operation
        }) => {
          if (!args?.headers) {
            return operation;
          }
          // fetchOptions can be a function (See Client API) but you can simplify this based on usage
          const fetchOptions =
            typeof operation.context.fetchOptions === 'function' ?
            operation.context.fetchOptions() :
            operation.context.fetchOptions || {};

          return makeOperation(
            operation.kind,
            operation, {
              ...operation.context,
              fetchOptions: {
                ...fetchOptions,
                headers: {
                  ...fetchOptions.headers,
                  ...args.headers as any
                },
              },
            },
          );
        },
        didAuthError: ({
          error
        }) => {
          return error.message === "[GraphQL] unauthorized"
        },
        getAuth: async ({
          authState,
          mutate
        }) => {
          if (
            import.meta.env.SSR) return null
          if (
            !window.location.href.includes("/login") &&
            typeof document !== 'undefined' && !document.cookie.includes('frontend')
          ) {
            const res = await sessionRenew()
            if (
              res.data?.sessionRenew?.error &&
              location.pathname.includes('/me')
            ) {
              window.location.href = "/login"
              isLoggedOut.value = true
            }
          }
          return null;
        }
      }),
      ssr,
      multipartFetchExchange
    ]
  })

  return {
    client,
    ssr
  }
}
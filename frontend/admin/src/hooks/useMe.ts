import { RequestPolicy } from "@urql/core";
import { ClientHandle, useQuery } from "@urql/vue";
import meQuery from 'shared/models/Users/User/me.gql'
import { RootQueryType } from "shared/types";
import { computed } from "vue";

export default (requestPolicy: RequestPolicy = 'cache-only', handle?: ClientHandle) => {
  const { data } = (handle?.useQuery || useQuery)<RootQueryType>({
    query: meQuery,
    requestPolicy
  })

  return {
    user: computed(() => {
      return data.value?.me
    })
  }
}
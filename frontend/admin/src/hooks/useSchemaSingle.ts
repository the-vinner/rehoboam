import { computed } from "vue";
import { useRoute } from "vue-router"
import schemaSingle from "shared/models/Schemas/Schema/schemaSingle.gql";
import useQueryTyped from "./useQueryTyped";
import { RootQueryTypeSchemaSingleArgs } from "shared/types";
import { RequestPolicy } from "@urql/core";

export default (requestPolicy : RequestPolicy = 'cache-only') => {
    const route = useRoute()
    const isNew = computed(() => {
        return route.params.id === "0";
      });

    const { data } = useQueryTyped({
        requestPolicy,
        pause: isNew,
        query: schemaSingle,
        variables: computed(() => {
          const vars: RootQueryTypeSchemaSingleArgs = {
            filters: {
              id: route.params.id,
            },
          };
          return vars;
        }),
      });

    return {
        isNew,
        schema: computed(() => data.value?.schemaSingle)
    }
}
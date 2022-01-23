import { computed } from "vue";
import { RequestPolicy } from "@urql/core";
import { RootQueryTypeSchemaSingleArgs } from "shared/types";
import { useRoute } from "vue-router"
import fieldSingle from "shared/models/Schemas/Field/fieldSingle.gql";
import useQueryTyped from "./useQueryTyped";

export default (requestPolicy : RequestPolicy = 'cache-only') => {
    const route = useRoute()
    const isNew = computed(() => {
        return route.params.fieldId === "0";
      });

    const { data } = useQueryTyped({
        requestPolicy,
        pause: isNew,
        query: fieldSingle,
        variables: computed(() => {
          const vars: RootQueryTypeSchemaSingleArgs = {
            filters: {
              id: route.params.fieldId
            },
          };
          return vars;
        }),
      });

    return {
        field: computed(() => data.value?.fieldSingle),
        isNew
    }
}
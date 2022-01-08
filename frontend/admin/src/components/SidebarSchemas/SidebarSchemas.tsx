import { defineComponent } from "vue";
import { faEdit, faPencilAlt, faPlus } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@potionapps/utils";
import { RootQueryTypeSchemaCollectionArgs } from "shared/types";
import { routeNames } from "root/routes/routeNames";
import BtnSmallBordered from "components/Btn/BtnSmallBordered";
import schemaCollection from "shared/models/Schemas/Schema/schemaCollection.gql";
import useQueryTyped from "hooks/useQueryTyped";

export default defineComponent({
  setup() {
    const variables: RootQueryTypeSchemaCollectionArgs = {
      first: 200,
    };
    const { data } = useQueryTyped({
      query: schemaCollection,
      variables,
    });
    return () => {
      return (
        <div>
          <BtnSmallBordered
            class="border-1 border-slate-300 gap-3 w-full"
            to={{ name: routeNames.schema, params: { id: "0" } }}
          >
            New Content Type
            <FontAwesomeIcon icon={faPlus} />
          </BtnSmallBordered>
          <div class="flex flex-col gap-1 mt-3">
            {data.value?.schemaCollection?.edges?.map((edge) => {
              if (edge?.node) {
                return (
                  <button
                    class={[
                      "capitalize",
                      "flex",
                      "group",
                      "items-center",
                      "gap-2",
                      "hover:text-slate-900",
                      "text-slate-600",
                      "py-1.5",
                      "text-sm",
                    ]}
                  >
                    <div>{edge.node.titleI18n}</div>
                    <router-link
                      class={[
                        "group-hover:opacity-100",
                        "opacity-0"
                      ]}
                      to={{ name: routeNames.schema, params: { id: edge.node?.internalId } }}
                    >
                      <FontAwesomeIcon icon={faPencilAlt} />
                    </router-link>
                  </button>
                );
              }
            })}
          </div>
        </div>
      );
    };
  },
});

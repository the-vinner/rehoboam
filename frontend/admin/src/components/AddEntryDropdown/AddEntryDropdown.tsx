import { computed, defineComponent, PropType } from "vue";
import {
  Listbox,
  ListboxButton,
  ListboxOptions,
  ListboxOption,
} from "@headlessui/vue";
import { FontAwesomeIcon } from "@potionapps/utils";
import { faPlus } from "@fortawesome/free-solid-svg-icons";
import { Schema } from "shared/types";
import schemaPublishedCollection from "shared/models/Schemas/Schema/schemaPublishedCollection.gql";
import useQueryTyped from "hooks/useQueryTyped";
import BtnSmallBordered from "components/Btn/BtnSmallBordered";

export default defineComponent({
  name: "AddEntryDropdown",
  props: {
    schemas: Array as PropType<Schema[]>,
  },
  setup(props) {
    const { data } = useQueryTyped({
      query: schemaPublishedCollection,
      variables: {
        first: 200,
      },
    });
    // const { executeMutation } = 
    const selected = computed<any>({
      get() {
        return null;
      },
      set(val) {
        //   exec
      },
    });

    return () => {
      return (
        <Listbox v-model={selected.value}>
          <div class="relative mt-1">
            <ListboxButton class="w-full">
              <BtnSmallBordered class="border-1 border-slate-300 gap-3 w-full">
                Add Entry
                <FontAwesomeIcon icon={faPlus} />
              </BtnSmallBordered>
            </ListboxButton>

            <transition
              leave-active-class="transition duration-100 ease-in"
              leave-from-class="opacity-100"
              leave-to-class="opacity-0"
            >
              <ListboxOptions
                class={[
                  "absolute",
                  "w-full",
                  "py-1",
                  "mt-1",
                  "overflow-auto",
                  "text-base",
                  "bg-white",
                  "rounded-md",
                  "shadow-lg",
                  "max-h-60",
                  "ring-1",
                  "ring-black",
                  "ring-opacity-5",
                  "focus:outline-none",
                  "sm:text-sm",
                ]}
              >
                {data.value?.schemaPublishedCollection?.edges?.map((edge) => {
                  if (!edge?.node) return;
                  return (
                    <ListboxOption
                      key={edge.node.id}
                      value={edge.node}
                      v-slots={{
                        default: ({ active, selected }: any) => {
                          return (
                            <li
                              class={[
                                active
                                  ? "text-blue-900 bg-slate-100"
                                  : "text-slate-900",
                                "cursor-pointer text-sm select-none relative py-2 pl-10 pr-4",
                              ]}
                            >
                              <span
                                class={[
                                  selected ? "font-medium" : "font-normal",
                                  "block truncate",
                                ]}
                              >
                                {edge.node!.titleI18n}
                              </span>
                            </li>
                          );
                        },
                      }}
                    />
                  );
                })}
              </ListboxOptions>
            </transition>
          </div>
        </Listbox>
      );
    };
  },
});

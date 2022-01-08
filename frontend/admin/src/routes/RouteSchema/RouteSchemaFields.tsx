import { computed, defineComponent, ref } from "vue";
import {
  faPlus,
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@potionapps/utils";
import {
  FieldUpdateInput,
  RootMutationType,
} from "shared/types";
import { useMutation } from "@urql/vue";
import { useRoute } from "vue-router";
import BtnSmallBordered from "components/Btn/BtnSmallBordered";
import Draggable from 'vuedraggable/src/vuedraggable'
import schemaMutation from "shared/models/Schemas/Schema/schemaMutation.gql";
import Title from "components/Title/Title";
import fieldCollection from 'shared/models/Schemas/Field/fieldCollection.gql'
import useQueryTyped from "hooks/useQueryTyped";
import SchemaFieldRow from "components/SchemaFieldRow/SchemaFieldRow";
import { SchemaField } from "@urql/exchange-graphcache/dist/types/ast";

export default defineComponent({
  name: "RouteSchemaFields",
  setup() {
    const draggableState = ref<SchemaField[]>([])
    const route = useRoute();
    let toSave : FieldUpdateInput[] = []

    const {
      data
    } = useQueryTyped({
      query: fieldCollection,
      variables: computed(() => {
        return {
          first: 200,
          filters: {
            schemaId: route.params.id
          }
        }
      })
    })

    // const onChange = (res: {moved: {element: PlaylistPage, newIndex: number, oldIndex: number}}) => {
    //   toSave =
    //     draggableState.value.reduce((acc: PlaylistPageManyUpdateInput[], pp, i) => {
    //       if (i !== props.playlistPages?.find(pp2 => pp2.id === pp.id)?.ordering) {
    //         acc.push({
    //           id: pp.id,
    //           ordering: i
    //         })
    //       }
    //       return acc
    //     }, [])
    //   showSavebar.value = !!toSave.length
    // }

    return () => {
      return <>
        <div class="flex items-center justify-between mb-3">
          <Title>Fields</Title>
          <BtnSmallBordered class="gap-3">
            New Field <FontAwesomeIcon icon={faPlus} />
          </BtnSmallBordered>
        </div>
        <div
          class={[
            "border-slate-300",
            "border-1",
            "flex",
            "flex-col",
            "gap-1.5",
            "px-4",
            "py-6",
            "rounded-xl",
            "shadow-sm",
            "w-full",
          ]}
        >
          {
            data.value?.fieldCollection?.edges?.map(edge => {
              if (edge?.node) {
                return <SchemaFieldRow title={edge?.node?.titleI18n} />
              }
            })
          }
        </div>
      </>;
    };
  },
});

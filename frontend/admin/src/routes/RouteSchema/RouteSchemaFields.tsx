import { computed, defineComponent } from "vue";
import {
  faAlignLeft,
  faHeading,
  faImage,
  faPlus,
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@potionapps/utils";
import {
  RootMutationType,
  RootMutationTypeSchemaMutationArgs,
  Schema,
} from "shared/types";
import { useMutation } from "@urql/vue";
import { useRoute } from "vue-router";
import BtnSmallBordered from "components/Btn/BtnSmallBordered";
import SchemaFieldRow from "components/SchemaFieldRow/SchemaFieldRow";
import schemaMutation from "shared/models/Schemas/Schema/schemaMutation.gql";
import SwitchSmall from "components/Switch/SwitchSmall";
import Title from "components/Title/Title";
import useSchemaSingle from "hooks/useSchemaSingle";

export default defineComponent({
  name: "RouteSchemaFields",
  setup() {
    const { executeMutation } = useMutation<RootMutationType>(schemaMutation);
    const route = useRoute();
    const { schema } = useSchemaSingle();
    const defaultFields = [
      {
        icon: faHeading,
        name: "title",
        title: "Title",
        toggleName: "enableTitle",
      },
      {
        icon: faAlignLeft,
        name: "description",
        title: "Description",
        toggleName: "enableDescription",
      },
      {
        icon: faImage,
        name: "image",
        title: "Images",
        toggleName: "enableImage",
      },
      {
        icon: faImage,
        name: "thumbnail",
        title: "Thumbnails",
        toggleName: "enableThumbnail",
      },
    ];
    const defaultFieldsDisabled = computed(() => {
      return defaultFields.filter(
        (s) => schema.value && schema.value?.[s.toggleName as keyof Schema]
      );
    });
    const defaultFieldsEnabled = computed(() => {
      return defaultFields.filter(
        (s) => schema.value?.[s.toggleName as keyof Schema]
      );
    });

    const toggleUpdate = (key: keyof Schema, value: boolean) => {
      const vars: RootMutationTypeSchemaMutationArgs = {
        changes: {
          [key]: value,
        },
        filters: {
          id: route.params.id,
        },
      };
      executeMutation(vars);
    };
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
          {defaultFieldsEnabled.value.map((field) => {
            return (
              <SchemaFieldRow
                key={field.name}
                icon={field.icon}
                title={field.title}
              >
                <div class="flex grow justify-end">
                  <SwitchSmall
                    change={(val) =>
                      toggleUpdate(field.toggleName as keyof Schema, val)
                    }
                    val={!!schema.value?.[field.toggleName as keyof Schema]}
                  />
                </div>
              </SchemaFieldRow>
            );
          })}
          <div class="mt-6 mb-1 text-lg text-slate-800">
            Disabled Default Fields
          </div>
          {defaultFieldsDisabled.value.map((field) => {
            return (
              <SchemaFieldRow
                key={field.name}
                icon={field.icon}
                title={field.title}
              >
                <div class="flex grow justify-end">
                  <SwitchSmall
                    change={(val) =>
                      toggleUpdate(field.toggleName as keyof Schema, val)
                    }
                    val={!!schema.value?.[field.toggleName as keyof Schema]}
                  />
                </div>
              </SchemaFieldRow>
            );
          })}
        </div>
      </>;
    };
  },
});

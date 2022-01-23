import { Field as FormField, useForm } from "@potionapps/forms";
import { useMutation } from "@urql/vue";
import { Field, FieldTypes, RootMutationType, RootMutationTypeFieldMutationArgs } from "shared/types";
import { computed, defineComponent, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import fieldMutation from 'shared/models/Schemas/Field/fieldMutation.gql'
import useFieldSingle from "hooks/useFieldSingle";
import { routeNames } from "../routeNames";

type FieldTypeOption = {
  title: String;
  value: FieldTypes;
};

export default defineComponent({
  setup() {
    const route = useRoute()
    const router = useRouter()
    const serverError = ref("");
    const {
        field,
        isNew
    } = useFieldSingle('cache-and-network')
    const { executeMutation } = useMutation<RootMutationType>(fieldMutation)
    const fieldTypeOptions: FieldTypeOption[] = [
      {
        title: "Link to One or More Images",
        value: FieldTypes.Images,
      },
      {
        title: "Link to One or More Entries",
        value: FieldTypes.Relationships,
      },
      {
        title: "Number",
        value: FieldTypes.Number,
      },
      {
        title: "Text",
        value: FieldTypes.Text,
      },
      {
        title: "Yes/No",
        value: FieldTypes.Boolean,
      },
      {
        title: "Multiple Choice",
        value: FieldTypes.Checkbox,
      },
      {
        title: "Single Choice",
        value: FieldTypes.Select,
      },
    ];
    const fields: Partial<{ [k in keyof Field]: FormField }> = {
      handle: {
        label: "Handle",
        name: "handle",
        placeholder: "handle",
      },
      titleI18n: {
        name: "titleI18n",
        label: "Title",
      },
      type: {
        label: "Field Type",
        name: "type",
        options: fieldTypeOptions,
      },
    };
    const form = useForm({
      data: computed(() => {
        if (isNew.value) {
          return {};
        }
        return field.value;
      }),
      fields: [],
      onSubmit: (cs) => {
        serverError.value = "";
        const params: RootMutationTypeFieldMutationArgs = {
          changes: {
            ...cs.changes,
            schemaId: route.params.id
          },
        };
        if (!isNew.value) {
            params.filters = { id: route.params.fieldId };
        }
        return executeMutation(params).then((res) => {
          if (res.error || res.data?.schemaMutation?.errorsFields?.length) {
            if (res.data?.fieldMutation?.errorsFields?.length) {
              res.data?.fieldMutation?.errorsFields.forEach((err) => {
                form.setServerError(err?.field, err?.message);
              });
            }
            if (res.error) serverError.value = res.error.message;
            return false;
          } else if (isNew.value) {
            router.push({
              name: routeNames.field,
              params: {
                fieldId: res.data?.fieldMutation?.node?.internalId,
                id: route.params.id
              }
            });
            return false;
          }
          return false
        });
      },
    });

    return () => {
      return <form class="flex flex-col"></form>;
    };
  },
});

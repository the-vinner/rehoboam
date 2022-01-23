import { Field as FormField, useForm } from "@potionapps/forms";
import { useMutation } from "@urql/vue";
import {
  Field,
  FieldTypes,
  RootMutationType,
  RootMutationTypeFieldMutationArgs,
} from "shared/types";
import { computed, defineComponent, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import fieldMutation from "shared/models/Schemas/Field/fieldMutation.gql";
import useFieldSingle from "hooks/useFieldSingle";
import { routeNames } from "../routeNames";
import FieldInput from "components/FieldInput/FieldInput";
import FieldTextarea from "components/FieldTextarea/FieldTextarea";
import Wrapper from "root/layout/Wrapper/Wrapper";
import BtnSubmit from "components/Btn/BtnSubmit";
import Title from "components/Title/Title";

type FieldTypeOption = {
  title: String;
  value: FieldTypes;
};

export default defineComponent({
  setup() {
    const route = useRoute();
    const router = useRouter();
    const serverError = ref("");
    const { field, isNew } = useFieldSingle("cache-and-network");
    const { executeMutation } = useMutation<RootMutationType>(fieldMutation);
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
      descriptionI18n: {
        label: "Description",
        name: "description",
        placeholder: "Description...",
      },
      isDescription: {
        label: "This field is the description",
        name: "isDescription",
      },
      isImage: {
        label: "This field is the main image",
        name: "isTitle",
      },
      handle: {
        label: "Handle",
        name: "handle",
        placeholder: "Handle...",
      },
      isTitle: {
        label: "This field is the title",
        name: "isTitle",
      },
      isThumbnail: {
        label: "This field is the main thumbnail",
        name: "isThumbnail",
      },
      placeholderI18n: {
        name: "placeholderI18n",
        label: "Placeholder Text",
        placeholder: "Placeholder Text..."
      },
      titleI18n: {
        label: "Title",
        name: "titleI18n",
        placeholder: "Title..."
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
            schemaId: route.params.id,
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
              name: routeNames.schema,
              params: {
                fieldId: res.data?.fieldMutation?.node?.internalId,
                id: route.params.id,
              },
            });
            return false;
          }
          return false;
        });
      },
    });

    return () => {
      return (
          <form>
            <div class={[
              "flex",
              "flex-col",
              "gap-4",
              "px-4",
              "s650:px-12",
            ]}>
              <Title>{isNew.value ? "New Field" : field.value?.titleI18n}</Title>
              <div>
                <FieldInput inputClasses={["text-2xl"]} {...fields.titleI18n!} />
              </div>
              <div>
                <FieldTextarea {...fields.descriptionI18n!} />
              </div>
              <div>
                <FieldInput {...fields.placeholderI18n!} />
              </div>
              {!isNew.value && (
                <div>
                  <FieldInput
                    disabled={true}
                    {...fields.handle!}
                  />
                </div>
              )}
            </div>
            <div class={[
              "bg-slate-200",
              "bottom-0",
              "mt-10",
              "px-4",
              "s650:px-12",
              "py-6",
              "sticky"
            ]}>
              <BtnSubmit class="w-full" />
            </div>
          </form>
      );
    };
  },
});

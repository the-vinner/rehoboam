import { computed, defineComponent, ref } from "vue";
import schemaMutation from "shared/models/Schemas/Schema/schemaMutation.gql";
import { useForm } from "@potionapps/forms";
import useSchemaSingle from "hooks/useSchemaSingle";
import {
  RootMutationType,
  RootMutationTypeSchemaMutationArgs,
} from "shared/types";
import { useMutation } from "@urql/vue";
import { useRoute, useRouter } from "vue-router";
import { routeNames } from "../routeNames";
import Wrapper from "root/layout/Wrapper/Wrapper";
import FieldInput from "components/FieldInput/FieldInput";
import FieldTextarea from "components/FieldTextarea/FieldTextarea";
import BtnSubmit from "components/Btn/BtnSubmit";

export default defineComponent({
  setup() {
    const { isNew, schema } = useSchemaSingle();
    const { executeMutation } = useMutation<RootMutationType>(schemaMutation);
    const route = useRoute();
    const router = useRouter();
    const serverError = ref("");
    const form = useForm({
      data: computed(() => {
        if (isNew.value) {
          return {};
        }
        return schema.value;
      }),
      fields: [],
      onSubmit: (cs) => {
        serverError.value = "";
        const params: RootMutationTypeSchemaMutationArgs = {
          changes: {
            ...cs.changes,
          },
        };
        if (!isNew.value) params.filters = { id: route.params.id };
        return executeMutation(params).then((res) => {
          if (res.error || res.data?.schemaMutation?.errorsFields?.length) {
            if (res.data?.schemaMutation?.errorsFields?.length) {
              res.data?.schemaMutation?.errorsFields.forEach((err) => {
                form.setServerError(err?.field, err?.message);
              });
            }
            if (res.error) serverError.value = res.error.message;
            return false;
          } else {
            router.push({
              name: routeNames.schema,
              params: {
                id: res.data?.schemaMutation?.node?.internalId,
              },
            });
            return false;
          }
        });
      },
    });

    return () => (
      <Wrapper class={["max-w-screen", "mx-auto", "pt-6", "w-[600px]"]}>
        <form class={["flex", "flex-col", "gap-4"]} onSubmit={form.submit}>
          <div>
            <FieldInput
              inputClasses={["text-2xl"]}
              name="titleI18n"
              placeholder="Content Type Title..."
            />
          </div>
          <FieldTextarea name="descriptionI18n" placeholder="Description..." />
          {!isNew.value && (
            <div>
              <FieldInput
                disabled={true}
                label="Handle"
                name="handle"
                placeholder="Handle..."
              />
            </div>
          )}
          <footer class={["sticky", "bottom-2"]}>
            <BtnSubmit class="w-full" />
          </footer>
        </form>
      </Wrapper>
    );
  },
});

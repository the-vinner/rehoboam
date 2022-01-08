import { computed, defineComponent, ref } from "vue";
import { faArrowLeft } from "@fortawesome/free-solid-svg-icons";
import { routeNames } from "../routeNames";
import { useForm } from "@potionapps/forms";
import { useRoute, useRouter } from "vue-router";
import BtnIcon from "components/Btn/BtnIcon";
import BtnSubmit from "components/Btn/BtnSubmit";
import FieldInput from "components/FieldInput/FieldInput";
import FieldTextarea from "components/FieldTextarea/FieldTextarea";
import schemaMutation from "shared/models/Schemas/Schema/schemaMutation.gql";
import Title from "components/Title/Title";
import Wrapper from "root/layout/Wrapper/Wrapper";
import {
  RootMutationType,
  RootMutationTypeSchemaMutationArgs,
} from "shared/types";
import { useMutation } from "@urql/vue";
import useSchemaSingle from "hooks/useSchemaSingle";
import RouteSchemaFields from "./RouteSchemaFields";

export default defineComponent({
  setup() {
    const serverError = ref("");
    const route = useRoute();
    const router = useRouter();
    const { executeMutation } = useMutation<RootMutationType>(schemaMutation);

    const { isNew, schema } = useSchemaSingle("cache-and-network");

    const form = useForm({
      data: computed(() => {
        if (isNew.value) {
          return {
          };
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

    return () => {
      return (
        <div class={["min-h-screen", "flex-col", "flex"]}>
          <Wrapper
            class={[
              "border-b-1",
              "border-slate-300",
              "flex",
              "items-center",
              "gap-4",
              "py-3",
            ]}
          >
            <BtnIcon
              icon={faArrowLeft}
              to={{ name: routeNames.content }}
            ></BtnIcon>
            <div>
              <p class="flex gap-1 text-sm">
                <span class="text-slate-300">/</span>
                <router-link
                  class={[
                    "hover:text-slate-800",
                    "flex",
                    "items-center",
                    "text-slate-500",
                  ]}
                  to="/"
                >
                  Content
                </router-link>
                <span class="text-slate-300">/</span>
              </p>
              <Title class="pt-0.5">
                <h1>New Content Type</h1>
              </Title>
            </div>
          </Wrapper>
          <div class={["flex", "grow"]}>
            <Wrapper class={["max-w-screen", "mx-auto", "pt-6", "w-[600px]"]}>
              <form
                class={["flex", "flex-col", "gap-4"]}
                onSubmit={form.submit}
              >
                <div>
                  <FieldInput
                    inputClasses={["text-2xl"]}
                    name="titleI18n"
                    placeholder="Content Type Title..."
                  />
                </div>
                <FieldTextarea
                  name="descriptionI18n"
                  placeholder="Description..."
                />
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
            {route.params.id !== "0" && (
              <Wrapper
                class={["border-l-1", "border-slate-300", "grow", "pt-4"]}
              >
                <RouteSchemaFields />
              </Wrapper>
            )}
          </div>
        </div>
      );
    };
  },
});

import { defineComponent } from "vue";
import { faArrowLeft, faRocket } from "@fortawesome/free-solid-svg-icons";
import { routeNames } from "../routeNames";
import { useRoute, useRouter } from "vue-router";
import BtnIcon from "components/Btn/BtnIcon";
import schemaPublish from "shared/models/Schemas/Schema/schemaPublish.gql";
import Title from "components/Title/Title";
import Wrapper from "root/layout/Wrapper/Wrapper";
import {
  RootMutationType,
} from "shared/types";
import { useMutation } from "@urql/vue";
import useSchemaSingle from "hooks/useSchemaSingle";
import RouteSchemaFields from "./RouteSchemaFields";
import BtnSmallSecondary from "components/Btn/BtnSmallSecondary";
import RouteSchemaForm from "./RouteSchemaForm";
import Modal from "components/Modal/Modal";
import RouteField from "../RouteField/RouteField";
import useModal from "components/Modal/useModal";

export default defineComponent({
  setup() {
    const route = useRoute();
    const router = useRouter()
    const {
      bodyModalClassAdd,
      bodyModalClassRemove
    } = useModal()
    const closeModal = () => {
      bodyModalClassRemove()
      router.push({
        name: route.name!,
        params: {
          id: route.params.id
        }
      })
    }
    const { executeMutation: executePublish, fetching: publishing } =
      useMutation<RootMutationType>(schemaPublish);

    const { isNew, schema } = useSchemaSingle("cache-and-network");
    const publish = () => {
      executePublish({ filters: { id: route.params.id } });
    };

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
            <div class="flex-1">
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
                <h1>{isNew.value ? "New Content Type" : schema.value?.titleI18n}</h1>
              </Title>
            </div>
            <div class="flex flex-col items-end gap-1.5">
              <BtnSmallSecondary
                class="grow-0"
                click={publish}
                disabled={publishing.value}
                label="Publish"
                icon={faRocket}
              />
              <p class="text-slate-500 text-xs">
                Last published:{" "}
                <span class="text-slate-600">
                  {schema.value?.publishedAtHuman || "Never"}
                </span>
              </p>
            </div>
          </Wrapper>
          <div class={["flex", "grow"]}>
            {
              !!route.params.fieldId &&
              <Modal close={closeModal} onMounted={bodyModalClassAdd}>
                <div class="pt-12">
                  <RouteField />
                </div>
              </Modal>
            }
            <RouteSchemaForm />
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

import { faArrowLeft } from "@fortawesome/free-solid-svg-icons";
import { useForm } from "@potionapps/forms";
import _default from "@potionapps/forms/dist/fields/FieldCheckbox/useFieldCheckbox";
import BtnIcon from "components/Btn/BtnIcon";
import BtnSubmit from "components/Btn/BtnSubmit";
import FieldFile from "components/FieldFile/FieldFile";
import FieldInput from "components/FieldInput/FieldInput";
import FieldSwitchSmall from "components/FieldSwitch/FieldSwitchSmall";
import FieldTextarea from "components/FieldTextarea/FieldTextarea";
import Title from "components/Title/Title";
import TitleSidebar from "components/Title/TitleSidebar";
import Sidebar from "root/layout/Sidebar/Sidebar";
import Wrapper from "root/layout/Wrapper/Wrapper";
import { computed, defineComponent } from "vue";
import { routeNames } from "../routeNames";

export default defineComponent({
  setup() {
    const { consolidated } = useForm({
      data: computed(() => {
        return {
          enableDescription: true,
          enableImage: true,
          enableTitle: true,
        };
      }),
      fields: [],
      onSubmit: () => {
        return Promise.resolve(true);
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
            <Wrapper
              class={[
                "flex",
                "flex-col",
                "gap-4",
                "max-w-screen",
                "pt-6",
                "w-[600px]",
              ]}
            >
              {consolidated.value.enableTitle && (
                <FieldInput
                  inputClasses={["text-2xl"]}
                  name="title"
                  placeholder="Content Type Title..."
                />
              )}
              {consolidated.value.enableTitle && (
                <FieldTextarea
                  name="description"
                  placeholder="Description..."
                />
              )}
              <div>
                <TitleSidebar class="mb-3">Options</TitleSidebar>
                <div class={["flex", "flex-col", "gap-3"]}>
                  <FieldSwitchSmall label="Enable Title" name="enableTitle" />
                  <FieldSwitchSmall
                    label="Enable Description"
                    name="enableDescription"
                  />
                  <FieldSwitchSmall label="Enable Image" name="enableImage" />
                  <FieldSwitchSmall
                    label="Enable Thumbnail"
                    name="enableThumbnail"
                  />
                </div>
              </div>
              <div>
                <FieldInput
                  label="Handle"
                  name="handle"
                  placeholder="Handle..."
                />
              </div>
              <footer class={["sticky", "bottom-2"]}>
                <BtnSubmit class="w-full" />
              </footer>
            </Wrapper>
            <Wrapper class={["border-l-1", "border-slate-300", 'grow', "pt-4"]}>
              <Title class="mb-3">Fields</Title>
              <div class={['border-slate-300', 'border-1', 'py-8', 'rounded-xl', 'shadow-sm', 'w-full']}>

              </div>
            </Wrapper>
          </div>
        </div>
      );
    };
  },
});

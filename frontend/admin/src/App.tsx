import AccountCircle from "components/AccountCircle/AccountCircle";
import useMe from "hooks/useMe";
import { defineComponent, Suspense } from "vue";
import Wrapper from "./layout/Wrapper/Wrapper";

export default defineComponent({
  name: "App",
  setup() {
    const { user } = useMe("network-only");

    return () => {
      return (
        <div id="main">
          <Wrapper
            class={[
              "border-b-1",
              "border-slate-300",
              "flex",
              "items-center",
              "justify-between",
              "py-2",
              "shadow-base",
              "w-full",
            ]}
          >
            <div class={["text-2xl", "font-bold", "s650:w-[140px]"]}>Rehoboam</div>
            <div class={["flex", "grow", "s650:justify-center"]}>
              <router-link
                class={["text-sm", "opacity-50"]}
                activeClass="font-bold opacity-100"
                to="/"
              >
                Content
              </router-link>
            </div>
            {user.value && (
              <div class="flex justify-end s650:w-[140px]">
                <AccountCircle
                  initials={user.value.initials}
                  fileUrl={user.value?.file?.url}
                />
              </div>
            )}
          </Wrapper>
          <Suspense>
            <router-view class="flex-1" />
          </Suspense>
        </div>
      );
    };
  },
});

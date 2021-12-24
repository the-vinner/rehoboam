import AccountCircle from "components/AccountCircle/AccountCircle";
import useMe from "hooks/useMe";
import { defineComponent, Suspense } from "vue";

export default defineComponent({
  name: "App",
  setup() {
    const { user } = useMe('network-only');

    return () => {
      return (
        <div id="main">
          <div class={["flex", "justify-between", 'px-4', 'py-4', 'w-full']}>
            <div class={["text-2xl", "text-bold"]}>Rehoboam</div>
            {user.value && (
              <AccountCircle
                initials={user.value.initials}
                fileUrl={user.value?.file?.url}
              />
            )}
          </div>
          <Suspense>
            <router-view class="flex-1" />
          </Suspense>
        </div>
      );
    };
  },
});

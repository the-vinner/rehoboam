import AccountCircle from "components/AccountCircle/AccountCircle";
import useDropdown from "components/Dropdown/useDropdown";
import useMe from "hooks/useMe";
import signOut from "shared/signOut";
import { FontAwesomeIcon } from "@potionapps/utils";
import { defineComponent, ref, Suspense } from "vue";
import Wrapper from "./layout/Wrapper/Wrapper";
import { faSignOutAlt } from "@fortawesome/free-solid-svg-icons";

export default defineComponent({
  name: "App",
  setup() {
    const { user } = useMe("network-only");
    const $container = ref<HTMLElement | null>(null);
    const { isDropdownVisible, toggleDropdown } = useDropdown({
      $container,
    });

    return () => {
      return (
        <div id="main">
          {user.value && (
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
              <div class={["text-2xl", "font-bold", "s650:w-[140px]"]}>
                Rehoboam
              </div>
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
                <div
                  class="flex justify-end relative s650:w-[140px]"
                  ref={$container}
                >
                  <button onClick={toggleDropdown}>
                    <AccountCircle
                      initials={user.value.initials}
                      fileUrl={user.value?.file?.url}
                    />
                  </button>
                  {isDropdownVisible.value && (
                    <div class="absolute bg-white max-w-screen right-0 shadow-lg w-full s650:w-[150px] top-10">
                      <button
                        class={[
                          "border-1",
                          "border-gray-300",
                          "flex",
                          "hover:text-blue-600",
                          "items-center",
                          "justify-between",
                          "px-3",
                          "py-2",
                          "rounded",
                          "text-sm",
                          "w-full",
                        ]}
                        onClick={signOut}
                      >
                        Sign Out
                        <FontAwesomeIcon icon={faSignOutAlt} />
                      </button>
                    </div>
                  )}
                </div>
              )}
            </Wrapper>
          )}
          <Suspense>
            <router-view class="flex-1" />
          </Suspense>
        </div>
      );
    };
  },
});

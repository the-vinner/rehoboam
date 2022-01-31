import AddEntryDropdown from "components/AddEntryDropdown/AddEntryDropdown";
import SidebarSchemas from "components/SidebarSchemas/SidebarSchemas";
import StateEmpty from "components/StateEmpty/StateEmpty";
import Sidebar from "root/layout/Sidebar/Sidebar";
import Wrapper from "root/layout/Wrapper/Wrapper";
import { defineComponent } from "vue";

export default defineComponent({
  setup() {
    return () => (
      <div class={["flex", "min-h-screen"]}>
        <Sidebar>
          <SidebarSchemas />
        </Sidebar>
        <Wrapper class="grow py-4">
          <div class="mx-auto max-w-[1200px]">
            <input class="mb-6 w-full" type="text" />
            <StateEmpty label="No Content" />
          </div>
        </Wrapper>
        <Sidebar right={true}>
          <AddEntryDropdown />
        </Sidebar>
      </div>
    );
  },
});

import { faPlus } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@potionapps/utils";
import BtnSmallBordered from "components/Btn/BtnSmallBordered";
import { routeNames } from "root/routes/routeNames";
import { defineComponent } from "vue";

export default defineComponent({
  setup() {
    return () => {
      return (
        <div>
          <BtnSmallBordered
            class="border-1 border-slate-300 gap-3 w-full"
            to={{ name: routeNames.schema, params: { id: "0" } }}
          >
            New Content Type
            <FontAwesomeIcon icon={faPlus} />
          </BtnSmallBordered>
        </div>
      );
    };
  },
});

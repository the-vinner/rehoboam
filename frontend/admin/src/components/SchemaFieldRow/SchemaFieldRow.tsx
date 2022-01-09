import { FontAwesomeIcon } from "@potionapps/utils";
import { defineComponent, PropType } from "vue";

export default defineComponent({
  props: {
    icon: Object,
    title: String as PropType<null | string>,
  },
  setup(props, { slots }) {
    return () => {
      return (
        <div
          class={[
            "border-1",
            "border-slate-300",
            "flex",
            "gap-2",
            "items-center",
            "px-4",
            "py-2.5",
            "rounded",
          ]}
        >
          {
          props.icon &&
            <div class="text-slate-500">
              <FontAwesomeIcon icon={props.icon} />
            </div>
          }
          <div class="text-slate-800 text-sm">{props.title}</div>
          {
              slots.default && slots.default()
          }
        </div>
      );
    };
  },
});

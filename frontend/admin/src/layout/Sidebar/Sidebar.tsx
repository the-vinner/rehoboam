import { defineComponent } from "vue";
import Wrapper from "../Wrapper/Wrapper";

export default defineComponent({
  props: {
    border: {
        default: () => true,
        type: Boolean
    },
    right: Boolean,
  },
  setup(props, { slots }) {
    return () => (
      <Wrapper
        class={[
          "border-slate-300",
          props.border && (props.right ? "border-l-1" : "border-r-1"),
          "py-4",
          "w-[250px]",
        ]}
      >
        {slots.default && slots.default()}
      </Wrapper>
    );
  },
});

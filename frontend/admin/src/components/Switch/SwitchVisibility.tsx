import { faEye, faEyeSlash } from "@fortawesome/pro-duotone-svg-icons";
import { FontAwesomeIcon } from "@potionapps/utils";
import { computed, defineComponent, PropType } from "vue";

export default defineComponent({
  name: "Switch",
  props: {
    change: Function as PropType<(v: boolean) => void>,
    label: String,
    val: Boolean,
  },
  setup(props, ctx) {
    const click = (e: MouseEvent) => {
      e.preventDefault();
      props.change?.(!internalValue.value);
    };

    const internalValue = computed({
      get() {
        return props.val || false;
      },
      set(val: boolean) {
        props.change?.(val);
      },
    });

    return () => {
      return (
        <>
          <button
            class={[
              "bg-gray-200",
              "border-1",
              "border-gray-300",
              "relative",
              "inline-flex",
              "items-center",
              "flex-shrink-0",
              "h-[28px]",
              "px-2.5",
              "justify-between",
              "w-[67px]",
              "rounded-full",
              "cursor-pointer",
              "transition-colors",
              "ease-in-out",
              "duration-200",
              "focus:outline-none",
              "focus-visible:ring-2",
              "focus-visible:ring-white",
              "focus-visible:ring-opacity-75",
              "text-sm",
              "text-gray-900"
            ].join(" ")}
            onClick={click}
          >
            <FontAwesomeIcon class="relative z-3" icon={faEye} />
            <FontAwesomeIcon class="relative z-2" icon={faEyeSlash} />
            <span
              aria-hidden="true"
              class={[
                "absolute",
                internalValue.value ? "translate-x-7" : "translate-x-0",
                "left-0.5",
                "pointer-events-none",
                "inline-block",
                "h-[24px]",
                "w-[32px]",
                "rounded-full",
                "bg-white",
                "shadow-lg",
                "transform",
                "ring-0",
                "transition",
                "ease-in-out",
                "duration-200",
              ]}
            />
          </button>
        </>
      );
    };
  },
});

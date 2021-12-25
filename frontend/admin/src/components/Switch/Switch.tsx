import { computed, defineComponent, PropType } from "vue";

export default defineComponent({
  name: "Switch",
  props: {
    change: Function as PropType<(v: boolean) => void>,
    label: String,
    val: Boolean
  },
  setup (props, ctx) {
    const click = (e: MouseEvent) => {
      e.preventDefault()
      props.change?.(!internalValue.value)
    }

    const internalValue = computed({
      get () {
        return props.val || false
      },
      set (val: boolean) {
        props.change?.(val)
      }
    })

    return () => {
      return <>
        <button
          class={[
            internalValue.value ? 'bg-green-500' : 'bg-gray-600',
            "relative", "inline-flex", "flex-shrink-0", "h-[28px]", "w-[60px]", "border-2", "border-transparent",
            "rounded-full", "cursor-pointer", "transition-colors",
            "ease-in-out", "duration-200", "focus:outline-none", "focus-visible:ring-2",
            "focus-visible:ring-white", "focus-visible:ring-opacity-75"
          ].join(' ')}
          onClick={click}
        >
          <span class="sr-only">{props.label}</span>
          <span
            aria-hidden="true"
            class={[
              internalValue.value ? 'translate-x-8' : 'translate-x-0',
              "pointer-events-none", "inline-block", "h-[24px]", "w-[24px]", "rounded-full", "bg-white", "shadow-lg",
              "transform", "ring-0", "transition",
              "ease-in-out", "duration-200" 
            ]}
          />
        </button>
      </>
    }
  }
})
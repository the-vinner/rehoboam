import { computed, defineComponent, PropType, ref, watch } from "vue";

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
      internalValue.value = !internalValue.value
      props.change?.(internalValue.value)
    }
    const internalValue = ref(false)

    watch(computed(() => props.val), (next, prev) => {
      if (next !== prev) {
        internalValue.value = props.val
      }
    }, { immediate: true })


    return () => {
      return <>
        <button
          class={[
            internalValue.value ? 'bg-emerald-500' : 'bg-gray-600',
            "relative", "inline-flex", "flex-shrink-0", "h-[22px]", "w-[48px]", "border-2", "border-transparent",
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
              internalValue.value ? 'translate-x-[26px]' : 'translate-x-0',
              "pointer-events-none", "inline-block", "h-[18px]", "w-[18px]", "rounded-full", "bg-white", "shadow-lg",
              "transform", "ring-0", "transition",
              "ease-in-out", "duration-200" 
            ]}
          />
        </button>
      </>
    }
  }
})
import { computed, defineComponent } from "vue";
import { useField } from "@potionapps/forms";
import FieldLabel from "components/FieldLabel/FieldLabel";
import FieldError from "components/FieldError/FieldError";

export type FieldCheckboxOptionProps = {
  label: string
  value: any
}

export interface FieldCheckboxProps {
  label?: string
  labelSwitch?: string
  name: string
  options?: FieldCheckboxOptionProps[]
  unstyled?: boolean
}

export default defineComponent({
  name: "FieldSwitch",
  props: {
    label: String,
    labelSwitch: String,
    name: {
      required: true,
      type: String
    },
    unstyled: Boolean
  },
  setup (props: FieldCheckboxProps, ctx) {
    const {
      change,
      errors,
      showErrors,
      val
    } = useField({
      name: computed(() => props.name)
    })

    const click = (e: MouseEvent) => {
      e.preventDefault()
      change?.(props.name, !internalValue.value)
    }

    const internalValue = computed({
      get () {
        return val.value || false
      },
      set (val: boolean) {
        change?.(props.name, val)
      }
    })

    return () => {
      return <div class={['flex', 'gap-2', 'items-center']}>
        <button
          class={[
            internalValue.value ? 'bg-green-500' : 'bg-gray-600',
            "relative", "inline-flex", "flex-shrink-0", "h-[20px]", "w-[40px]", "border-2", "border-transparent",
            "rounded-full", "cursor-pointer", "transition-colors",
            "ease-in-out", "duration-200", "focus:outline-none", "focus-visible:ring-2",
            "focus-visible:ring-white", "focus-visible:ring-opacity-75"
          ].join(' ')}
          onClick={click}
        >
          <span class="sr-only">{props.labelSwitch}</span>
          <span
            aria-hidden="true"
            class={[
              internalValue.value ? 'translate-x-5' : 'translate-x-0',
              "pointer-events-none", "inline-block", "h-[16px]", "w-[16px]", "rounded-full", "bg-white", "shadow-lg",
              "transform", "ring-0", "transition",
              "ease-in-out", "duration-200" 
            ]}
          />
        </button>
        <div class={["text-sm"]}>{props.label}</div>
        {
          showErrors.value &&
          <FieldError>{errors.value.join(", ")}</FieldError>
        }
      </div>
    }
  }
})
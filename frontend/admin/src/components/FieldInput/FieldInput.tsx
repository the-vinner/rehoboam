import { computed, defineComponent, ref, onMounted, PropType } from "vue";
import { useField, useFieldInput } from "@potionapps/forms";
import FieldError from "../FieldError/FieldError";
import FieldLabel from "../FieldLabel/FieldLabel";
import { FontAwesomeIcon } from "@potionapps/utils";
import { faTimes } from "@fortawesome/free-solid-svg-icons";

export interface FieldInputProps {
  disabled?: boolean
  disableAutocomplete?: boolean
  focusOnMount?: boolean,
  label?: string
  name: string
  placeholder?: string
  small?: boolean
  showClearIcon?: boolean,
  type?: string
  unstyled?: boolean
}

export default defineComponent({
  name: "FieldInput",
  props: {
    disabled: Boolean,
    disableAutocomplete: Boolean,
    enableBrowserAutofill: Boolean,
    focusOnMount: Boolean,
    inputClasses: Array as PropType<string[]>,
    label: String,
    name: {
      required: true,
      type: String
    },
    placeholder: String,
    small: Boolean,
    showClearIcon: Boolean,
    type: {
      default: "text",
      type: String
    },
    unstyled: Boolean
  },
  setup (props, ctx) {
    const $el = ref<HTMLElement | null>(null)
    const {
      change,
      errors,
      onBlur,
      showErrors,
      val
    } = useField({
      name: computed(() => props.name)
    })

    const {
      internalValue,
      onInput
    } = useFieldInput({
      change: (name: string, value: any) => {
        if (props.type === 'number') {
          const n = parseInt(value)
          if (!isNaN(n)) value = n
        }
        change?.(name, value)
      },
      name: props.name,
      showErrors,
      val
    })

    const classes = computed(() => {
      const classes : string[] = "disabled:opacity-50 rounded-md shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50 w-full".split(" ")
      if (showErrors?.value) classes.push("border-red-300", "text-red-800")
      else classes.push("border-gray-300")
      if (props.small) classes.push("px-3", "py-0.5")
      return classes.concat(props.inputClasses || [])
    })

    onMounted(() => {
      if (props.focusOnMount) {
        $el.value?.focus()
      }
      if (($el.value as HTMLInputElement)?.value) {
        props.enableBrowserAutofill && change(props.name, ($el.value as HTMLInputElement).value)
      }
    })

    return () => {
      return <>
      {
        props.label &&
        <FieldLabel>{props.label}</FieldLabel>
      }
      <div class='relative'>
        <input
          class={classes.value}
          disabled={props.disabled}
          readonly={props.disabled}
          onBlur={onBlur}
          onInput={onInput}
          name={!props.disableAutocomplete && props.name || ""}
          placeholder={props.placeholder}
          {...ctx.attrs}
          ref={$el}
          type="text"
          value={internalValue.value}
        />
        {
          props.showClearIcon && internalValue.value &&
          <button
            class="absolute bg-white bg-opacity-80 flex items-center justify-center p-2 right-1 top-1/2 transform -translate-y-1/2"
            onClick={() => change?.(props.name, '')}
          >
            <FontAwesomeIcon
              icon={faTimes}
              key="close"
            />
          </button>
        }
      </div>
      {
        showErrors.value &&
        <FieldError>{errors.value.join(", ")}</FieldError>
      }
    </>
    }
  }
})
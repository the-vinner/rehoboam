import { defineComponent, computed, PropType } from "vue";
import { FormSubmitStatus, useFormButton } from "@potionapps/forms";
import BtnPrimary from "./BtnPrimary";
import { FontAwesomeIcon } from "@potionapps/utils";
import { faSpinner } from "@fortawesome/free-solid-svg-icons";

export default defineComponent({
  name: "BtnSubmit",
  props: {
    click: Function as PropType<() => any>,
    loadingLabel: String,
  },
  setup (props, ctx) {
    const {
      formNumberOfChanges,
      formSubmitStatus
    } = useFormButton()

    const disabled = computed(() => {
      return formSubmitStatus?.value === FormSubmitStatus.loading || !formNumberOfChanges?.value
    })

    return () => {
      return <BtnPrimary
        click={props.click}
        disabled={disabled.value}
      >
        {
          FormSubmitStatus.loading !== formSubmitStatus?.value &&
          (ctx.slots.default && ctx.slots.default() || "Save")
        } 
        {
          FormSubmitStatus.loading === formSubmitStatus?.value &&
          (props.loadingLabel || "Saving...")
        } 
        {
          FormSubmitStatus.loading === formSubmitStatus?.value &&
          <FontAwesomeIcon class="ml-2" icon={faSpinner} pulse={true} key="spinner" />
        }
      </BtnPrimary>
    }
  }
})
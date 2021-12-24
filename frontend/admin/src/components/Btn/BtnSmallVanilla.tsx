import Btn, { btnProps } from './Btn'
import { defineComponent } from "vue";

export default defineComponent({
  name: "BtnSmallPrimary",
  props: btnProps,
  setup (props, ctx) {
    return () => { 
      return (
        <Btn 
          class={[
            "s550:px-3",
            "font-semibold",
            "p-2", 
            "rounded",
            "text-xs"
          ]}
          {...props}
        >{ctx.slots.default && ctx.slots.default()}</Btn>
      )
    }
  } 
})


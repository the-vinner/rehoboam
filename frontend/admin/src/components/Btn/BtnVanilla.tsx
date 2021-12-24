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
            "font-semibold",
            "p-2", 
            "rounded",
            "text-sm",
            "s550:px-3",
            "s550:text-base"
          ]}
          {...props}
        >{ctx.slots.default && ctx.slots.default()}</Btn>
      )
    }
  } 
})


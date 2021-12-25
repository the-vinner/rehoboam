import Btn, { btnProps, BtnProps } from './Btn'
import { defineComponent } from "vue";

export default defineComponent({
  name: "BtnSmallSecondary",
  props: btnProps,
  setup (props, ctx) {
    return () => { 
      return (
        <Btn 
          class={
            [
                "border-1",
                "border-slate-300",
                "focus:bg-slate-100",
                "hover:bg-gray-100",
                "hover:border-slate-400",
                "font-semibold",
                "p-2",
                "s550:px-3",
                "rounded",
                "shadow-sm",
                "text-xs",
                "text-slate-700",
                "focus:text-slate-900",
                "hover:text-slate-900"
            ]
          }
          {...props}
        >{ctx.slots.default && ctx.slots.default()}</Btn>
      )
    }
  } 
})


import Btn, { btnProps, BtnProps } from './Btn'
import { defineComponent } from "vue";

export default defineComponent({
  name: "BtnWhite",
  props: btnProps,
  setup (props, ctx) {
    return () => { 
      return (
        <Btn 
          class="bg-white focus:bg-gray-300 hover:bg-gray-500 font-semibold py-2 px-2 s550:px-3 rounded text-sm s550:text-base text-gray-700 focus:text-gray-900 hover:text-white transition"
          {...props}
        >{ctx.slots.default && ctx.slots.default()}</Btn>
      )
    }
  } 
})


import Btn, { btnProps, BtnProps } from './Btn'
import { defineComponent } from "vue";

export default defineComponent({
  name: "BtnSmallWhite",
  props: btnProps,
  setup (props: BtnProps, ctx) {
    return () => { 
      return (
        <Btn 
          class="bg-white-200 focus:bg-gray-300 hover:bg-blue-600  font-semibold p-2 s550:px-3 rounded text-xs text-gray-700 focus:text-gray-900 hover:text-white transition"
          {...props}
        >{ctx.slots.default && ctx.slots.default()}</Btn>
      )
    }
  } 
})


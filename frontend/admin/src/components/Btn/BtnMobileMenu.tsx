import Btn, { btnProps } from './Btn'
import { defineComponent } from "vue";

export default defineComponent({
  name: "BtnMobileMenu",
  props: btnProps,
  setup (props) {
    return () => { 
      return (
      <Btn 
        {...props}
        class="bg-gray-100 border-1 border-gray-300 focus:bg-gray-200 hover:bg-gray-200 font-semibold mr-2 rounded text-gray-600 text-sm w-full"
      />
    )
  }
}})


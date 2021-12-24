import Btn, { btnProps, BtnProps } from './Btn'
import { defineComponent } from "vue";

export default defineComponent({
  name: "LoginButton",
  props: btnProps,
  setup (props) {
    return () => <Btn
      class={[
        "bg-blue-800",
        "focus:bg-blue-900", 
        "hover:bg-blue-900",
        "flex",
        "flex-nowrap",
        "font-medium",
        "items-center",
        "justify-center", 
        "py-2", 
        "px-4", 
        "rounded-md", 
        "shadow", 
        "focus:shadow-md", 
        "hover:shadow-md", 
        "text-slate-100", 
        "focus:text-white", 
        "hover:text-white", 
        "text-lg", 
        "transition", 
        "w-full"
      ]}
      click={props.click}
      icon={props.icon}
      label={props.label}
      reverse={true}
    />
  }
})
import { defineComponent, PropType } from "vue";

export default defineComponent({
  props: {
    initials: String as PropType<string | null>,
    fileUrl: String as PropType<string | null>
  },
  setup (props) {
    return () => {
      return <div
        class={
          [
            "bg-gray-200",
            "flex",
            "h-7",
            "items-center",
            "justify-center",
            "p-1",
            "relative",
            "rounded-full",
            "text-gray-700",
            "text-sm",
            "uppercase",
            "w-7"
          ]
        }
      >
        {
          props.fileUrl && <img class="absolute inset-0 rounded-full" src={props.fileUrl + "?w=64&h=64"} />
        }
        {
          !props.fileUrl && props.initials
        }
      </div>
    }
  }
})
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
            "font-bold",
            "h-20",
            "s650:h-28",
            "items-center",
            "justify-center",
            "p-1",
            "relative",
            "rounded-full",
            "text-gray-700",
            "text-3xl",
            "uppercase",
            "w-20",
            "s650:w-28",
          ]
        }
      >
        {
          props.fileUrl && <img class="absolute inset-0 rounded-full" src={props.fileUrl + "?w=224&h=224"} />
        }
        {
          !props.fileUrl && props.initials
        }
      </div>
    }
  }
})
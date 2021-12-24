import { defineComponent, PropType } from "vue";

export default defineComponent({
  props: {
    initials: String as PropType<string | null>,
    fileUrl: String as PropType<string | null>
  },
  setup (props, ctx) {
    return () => {
      return <div
        class={
          [
            "bg-gray-200",
            "flex",
            "font-bold",
            "items-center",
            "justify-center",
            "p-1",
            "relative",
            "rounded-full",
            "text-gray-700",
            "uppercase",
          ]
        }
      >
        {
          props.fileUrl && <img class="absolute inset-0 rounded-full" src={props.fileUrl + "?w=64&h=64"} />
        }
        {
          !props.fileUrl && props.initials
        }
        {
          ctx.slots.default && ctx.slots.default()
        }
      </div>
    }
  }
})
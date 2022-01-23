import { defineComponent, Teleport, PropType, ref, Transition, onMounted, onBeforeUnmount } from "vue";
import { FontAwesomeIcon } from "@potionapps/utils";
import { faTimes } from "@fortawesome/pro-regular-svg-icons";

export default defineComponent({
  props: {
    close: Function as PropType<(e: MouseEvent | KeyboardEvent | undefined) => void>,
    lightbox: Boolean
  },
  setup (props, ctx) {
    const $container = ref<HTMLElement | null>(null)

    const maybeClose = (e: MouseEvent | KeyboardEvent) => {
      const $target = e.target as HTMLElement
      if ((e as KeyboardEvent).key === "Escape") {
        return props.close?.(e)
      }
      if ((e as KeyboardEvent).key) return
      if (
        $target === $container.value ||
        $container.value?.contains($target) ||
        !document.body.contains($target)
       ) {
        return
      }
      props.close?.(e as MouseEvent)
    }
    onBeforeUnmount(() => {
      document.removeEventListener('keyup', maybeClose)
    })
    onMounted(() => {
      document.addEventListener('keyup', maybeClose, { passive: true })
    })

    return () => {
      return <Teleport to="#modals">
        <Transition
          appear={true}
          appearFromClass="opacity-0"
          enterFromClass="opacity-0"
          leaveToClass="opacity-0"
        >
          <div
            class={[
              "s650:fixed",
              props.lightbox ? "bg-black" : "bg-white s650:bg-black",
              "s650:bg-opacity-50",
              "s650:flex",
              "h-screen",
              "items-center",
              "justify-center",
              "left-0",
              'relative',
              "top-0",
              "transition",
              "w-screen",
              "z-99"
            ]}
            onClick={maybeClose}
          >
            <div class={[
              "s650:rounded",
              "max-w-full",
              "relative",
              (props.lightbox ? 's650:w-auto' : 'bg-white s650:w-[500px]'),
              "w-full"
             ]}
             ref={$container}
            >
              {
                props.close && 
                <div
                  class="hidden s650:flex absolute bg-slate-200 cursor-pointer hover:bg-slate-400 items-center justify-center shadow-xl rounded-full h-7 w-7 -top-2 -right-2 z-2"
                  onClick={props.close}
                >
                  <FontAwesomeIcon icon={faTimes} />
                </div>
              }
                {
                  ctx.slots.prose && 
                  <div class="prose px-6 s1050:px-8 py-8">
                    {ctx.slots.prose()}
                  </div>
                }
                {
                  ctx.slots.default &&
                  <div class="max-h-[90vh] overflow-auto">
                    {ctx.slots.default()}
                  </div>
                }
              {
                ctx.slots.footer && ctx.slots.footer() &&
                <footer class="bottom-0 bg-slate-200 fixed s650:static rounded-b border-t-1 border-slate-300 flex flex-wrap justify-end px-6 s1050:px-8 py-4 w-full">
                  {ctx.slots.footer()}
                </footer>
              }
            </div>
          </div>
          </Transition>
        </Teleport>
    }
  }
})
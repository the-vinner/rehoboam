import { defineComponent, computed, PropType } from "vue";
import { FontAwesomeIcon } from '@potionapps/utils';
import { RouteLocationRaw } from "vue-router";

export const btnProps = {
  click: Function as PropType<(e?: MouseEvent) => any>,
  disabled: Boolean,
  icon: Object as PropType<any>,
  label: String,
  reverse: Boolean,
  to: {
    type: [Object, String] as PropType<RouteLocationRaw>
  },
  toExternal: String,
  type: String,
  useRouterReplace: Boolean
}

export interface BtnProps {
  click?: (e?: MouseEvent) => any
  disabled?: boolean
  icon?: {}
  id?: string
  label?: string
  reverse?: boolean
  to?: RouteLocationRaw
  toExternal?: string
  type?: "button" | "submit",
  useRouterReplace?: boolean
}

export default defineComponent({
  name: "Btn",
  props: btnProps,
  setup (props, ctx) {
    const classes = computed(() => [
      "flex items-center justify-center transition",
      props.disabled && "opacity-50 pointer-events-none",
      props.reverse && "flex-row-reverse"
    ])

    const imgClasses = computed(() => {
      return {
        "ml-2": props.reverse && props.label,
        "mr-2": !props.reverse && props.label
      }
    })

    return () => {
      const slot = <>
        {props.icon && <FontAwesomeIcon class={imgClasses.value} icon={props.icon} />}
        {props.label && <span class="whitespace-nowrap">{props.label}</span>}
        {ctx.slots.default && ctx.slots.default()}
      </>

      if (props.toExternal) {
        return <a class={classes.value} href={props.toExternal} target="_blank">{slot}</a>
      }

      const eventHandlers : any = {}

      if (!props.to) {
        if (props.click) eventHandlers.onClick = props.click
        return <button class={classes.value} {...eventHandlers} type={props.type}>{slot}</button>
      }

      return <router-link
        class={classes.value}
        replace={props.useRouterReplace}
        to={props.to}
      >
        {slot}
      </router-link>
    }
  }
})

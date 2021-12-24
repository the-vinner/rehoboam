import { computed, defineComponent } from "vue";

export default defineComponent({
    props: {
        leftOnly: Boolean,
        rightOnly: Boolean,
    },
    setup (props, { slots }) {
        const classes = computed(() => {
            return {
                "pl-5 s1050:pl-8": props.leftOnly,
                "pr-5 s1050:pr-8": props.rightOnly,
                "px-5 s1050:px-8": !props.leftOnly && !props.rightOnly,
            }
        })


        return () => <div class={classes.value}>
            {slots.default && slots.default()}
        </div>
    }
})
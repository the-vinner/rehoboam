import { defineComponent } from "vue";

export default defineComponent({
  setup(props, { slots }) {
    return () => <div class="font-bold text-lg text-slate-700">{slots.default && slots.default()}</div>;
  },
});

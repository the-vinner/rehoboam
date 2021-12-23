import { ref } from "@vue/reactivity";

const isLoggedOut = ref(false)

export default () => {
  return {
    isLoggedOut
  }
}
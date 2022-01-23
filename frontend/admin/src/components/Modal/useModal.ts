import { onMounted, ref } from "vue"
import { useRoute, useRouter } from "vue-router"


type ModalOpts = {
  routeQueryKey: string
}

export default (opts?: ModalOpts) => {
  const isModalVisible = ref(false)
  const modalClass = "appModalActive"
  const route = useRoute()
  const router = useRouter()


  if (opts?.routeQueryKey) {
    onMounted(() => {
      if (route.query?.modal === opts?.routeQueryKey) {
        showModal()
      }
    })
  }

  const hideModal = (e?: Event, queryKeys : string[] = []) => {
    isModalVisible.value = false
    bodyModalClassRemove()
    if (opts?.routeQueryKey) {
      const queryNext = {...route.query}
      delete queryNext.modal
      queryKeys.forEach(k => delete queryNext[k])
      router.push({
        query: queryNext
      })
    }
  }

  const bodyModalClassAdd = () => {
    document.body.classList.add(modalClass)
  }
  const bodyModalClassRemove = () => {
    document.body.classList.remove(modalClass)
  }

  const showModal = (query = {}) => {
    isModalVisible.value = true
    bodyModalClassAdd()
    if (opts?.routeQueryKey) {
      router.push({
        query: {
          ...route.query,
          ...query,
          modal: opts.routeQueryKey
        }
      })
    }
  }

  return {
    bodyModalClassAdd,
    bodyModalClassRemove,
    hideModal,
    isModalVisible,
    modalClass,
    showModal
  }
}
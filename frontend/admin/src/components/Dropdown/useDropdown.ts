import { ref, Ref, watch, onMounted, onBeforeUnmount } from "vue"

export interface UseDropdownSearchArgs {
  clearAfterSelect?: boolean
  $container?: Ref<HTMLElement | null>
  onEnter?: (highlightedIndex: number) => any
  multiSelect?: boolean
  options?: Ref<any[]>
  onSelect?: (value: any) => void,
  onSearch?: (s: string) => void,
  searchText?: Ref<string>,
  val?: Ref<any>
}

export default (args: UseDropdownSearchArgs) => {
  let blurTimeout : number
  const focused = ref<boolean>(false)
  const highlightedIndex = ref<number>(0)
  const showResults = ref(false)

  const chooseHighlighted = () => {
    selectOption(args.options?.value[highlightedIndex.value])
  }

  const cancel = () => {
    onEsc()
  }

  const clear = () => {
    if (args.searchText?.value) {
      window.clearTimeout(blurTimeout)
      args.onSearch?.("")
      getInput()!.focus()
    }
  }

  const getInput = () => {
    return args.$container?.value?.querySelector('input')
  }

  const maybeHideResults = (e: MouseEvent) => {
    if (!args.$container?.value) return
    const $target = e.target as HTMLElement

    if (
      $target === args.$container.value ||
      args.$container.value!.contains($target)
    ) {
      return
    }
    showResults.value = false
  }

  const onArrowDown = () => {
    const length = args.options?.value.length
    if (!length) return -1
    highlightedIndex.value  = highlightedIndex.value === length - 1
      ? 0
      : Math.min(highlightedIndex.value + 1, length - 1)
  }

  const onArrowUp = () => {
    if (highlightedIndex.value - 1 === -1) {
      highlightedIndex.value = (args.options?.value.length || 1) - 1
    } else {
      highlightedIndex.value = Math.max(0, highlightedIndex.value - 1)
    }
  }

  const onBlur = () => {
    focused.value = false
  }

  const onClickOption = (e: MouseEvent) => {
    const t = e.currentTarget as HTMLElement

    if (t.dataset.i === undefined) {
      throw new Error("The selected option is missing a data-i property with a number. Add data-i='index-of-option' to each option")
    }
    
    if (t.dataset.i) {
      selectOption(args.options?.value[parseInt(t.dataset.i)])
    }
    if (!args.val && args.onSearch) {
      args.onSearch("")
    }
  }

  const onEnter = (e: KeyboardEvent) => {
    e.preventDefault()
    e.stopPropagation()
    if (args.onEnter) {
      args.onEnter(highlightedIndex.value)
      return
    }
    if (highlightedIndex.value !== -1) {
      e.preventDefault()
      chooseHighlighted()
    }
  }

  const onEsc = () => {
    const $input = getInput()
    $input?.blur()
    if (!$input) {
      focused.value = false
    }
    showResults.value = false
  }

  const onFocus = () => {
    window.clearTimeout(blurTimeout)
    focused.value = true
    showResults.value = true
  }

  const onInput = (e: Event) => {
    args.onSearch?.((e.target as HTMLInputElement).value)
    highlightedIndex.value = 0
    showResults.value = true
  }

  const onKeydown = (e: KeyboardEvent) => {
    switch (e.key) {
      case "Enter": 
        if (highlightedIndex.value !== -1) {
          e.preventDefault()
          e.stopPropagation()
        }
        break;
      case "ArrowUp":
      case "ArrowDown":
        e.preventDefault()
        break;
    }
  }

  const onKeyup = (e: KeyboardEvent) => {
    switch (e.key) {
      case "Enter": 
        onEnter(e)
        break;
      case "ArrowUp":
        e.preventDefault()
        onArrowUp();
        break;
      case "ArrowDown":
        e.preventDefault()
        onArrowDown();
        break;
      case "Escape":
        onEsc();
        break;
    }
  }

  const selectOption = (opt: any) => {
    args.onSelect?.(opt)
    if (args.multiSelect) return
    args.onSearch?.(
      args.clearAfterSelect ? "" : opt?.title || ""
    )
    showResults.value = false
  }

  onBeforeUnmount(() => {
    document.removeEventListener('click', maybeHideResults)
  })
  onMounted(() => {
    document.addEventListener('click', maybeHideResults)
  })

  const toggleDropdown = () => {
    showResults.value = !showResults.value
  }

  return {
    cancel,
    clear,
    highlightedIndex,
    isDropdownVisible: showResults,
    on: {
      onBlur,
      onFocus,
      onInput,
      onKeydown,
      onKeyup
    },
    onClickOption,
    options: args.options,
    selectOption,
    toggleDropdown
  }
}
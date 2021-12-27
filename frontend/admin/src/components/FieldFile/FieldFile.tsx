import { computed, defineComponent, ref, PropType, onMounted, onBeforeUnmount, watch, popScopeId } from "vue";
import { faFileAlt } from "@fortawesome/free-solid-svg-icons";
import { faTimes } from "@fortawesome/free-solid-svg-icons";
import { File as RehoboamFile } from "shared/types";
import { FontAwesomeIcon } from "@potionapps/utils";
import { useField } from "@potionapps/forms";
import BtnSecondary from "components/Btn/BtnSecondary";
import FieldError from "../FieldError/FieldError";
import FieldFileChosen from "./FieldFileChosen";
import FieldLabel from "../FieldLabel/FieldLabel";

type Value = null | File | RehoboamFile
type ValueMultiple = (RehoboamFile | File)[]

export default defineComponent({
  name: "FieldFile",
  props: {
    accept: {
      required: true,
      type: Array as PropType<string[]>
    },
    btnLabel: String,
    fileIcons: Object,
    imageCover: Boolean,
    isImg: Boolean,
    label: String,
    multiple: Boolean,
    name: {
      required: true,
      type: String
    },
    subtitle: String,
    unstyled: Boolean
  },
  setup (props, ctx) {
    const defaultIcon = faFileAlt
    const isDraggedOver = ref(false)
    const internalValue = ref<Value | ValueMultiple>(null)

    const chosenFile = computed<Value>(() => {
      if (!props.multiple && Array.isArray(internalValue.value)) {
        return internalValue.value[0]
      } else {
        return internalValue.value as Value
      }
    })
    const clear = () => {
      change?.(
        props.name,
        null
      )
    }
    const clearOne = (e: Event, i: number) => {
      e.stopPropagation()
      if (!props.multiple || (internalValue.value as (File | RehoboamFile)[]).length === 1) {
        clear()
      } else {
        change?.(
          props.name,
          (internalValue.value as (File | RehoboamFile)[])?.slice(0).splice(i, 1)
        )
      }
    }
    const fileInput = ref<HTMLInputElement | null>(null)

    const filterFiles = (files: File[]) => {
      return files.filter(f => {
        const type = (f.type || '').split('/').pop()
        return props.accept.includes('.' + type)
      })
    }

    const icon = computed(() => {
      const type = ((internalValue.value as RehoboamFile)?.mimeType || '').split('/').pop()
      return type && props.fileIcons?.[type] || defaultIcon
    })

    const {
      change,
      errors,
      showErrors,
      val
    } = useField({
      name: computed(() => props.name)
    })

    const onDragleave = (e: DragEvent) => {
      isDraggedOver.value = false
    }
    const onDragover = (e: DragEvent) => {
      e.preventDefault()
      isDraggedOver.value = true
    }
    const onPaste = (e: any) => {
      if (e.dataTransfer) {
        e.preventDefault()
      }
      if (e.clipboardData || e.dataTransfer) {
        const items : any[] = e.clipboardData?.items || e.dataTransfer.items;
        if (!items) return;
        const files = filterFiles(
          Array.from(items)
            .map(i => i.getAsFile())
        ) 
        if (files.length) {
          change?.(
            props.name,
            props.multiple ? files : files[0]
          )
        }
      }
      isDraggedOver.value = false
    }

    const onFileChange = () => {
      const files = filterFiles(
        Array.from(fileInput.value!.files || [])
      ) 

      if (files.length) {
        change?.(
          props.name,
          props.multiple ? files : files[0]
        )
        fileInput.value!.value = ''
      }
    }

    const previews = computed<string[]>(() => {
      if (!internalValue.value) return []
      return props.multiple
        ? (internalValue.value as ValueMultiple)?.map((v: File | RehoboamFile) => {
          return generatePreviewUrl(v)
        })
        : [generatePreviewUrl(internalValue.value as Value)]
    })

    const generatePreviewUrl = (v: Value) : string => {
      if ((v as RehoboamFile)?.id) {
        return (v as RehoboamFile).url!
      } else if ((v as File)?.name) {
        return URL.createObjectURL(v)
      }
      return ''
    }

    const triggerFileInput = (e: Event) => {
      e.preventDefault()
      e.stopPropagation()
      fileInput.value!.click()
    }

    onBeforeUnmount(() => {
      document.body.removeEventListener('paste', onPaste, false)
    })
    onMounted(() => {
      document.body.addEventListener('paste', onPaste, false);
    })
    watch(val, (updatedVal: Value) => {
      if (JSON.stringify(updatedVal) !== JSON.stringify(internalValue.value)) {
        internalValue.value = updatedVal
      }
    }, { immediate: true })

    return () => { 
      return <>
        {
          props.label &&
          <FieldLabel>{props.label}</FieldLabel>
        }
        <div
          class={[
            isDraggedOver.value ? "bg-gray-100" : "bg-white",
            isDraggedOver.value ? "border-blue-700" : "border-gray-300",
            "border-2",
            "border-dashed",
            "cursor-pointer", 
            "hover:border-blue-700",
            "px-4",
            "py-4",
            "rounded",
            "flex",
            "flex-col",
            "items-center",
            "justify-center"
          ]}
          onDragleave={onDragleave}
          onClick={triggerFileInput}
          onDragover={onDragover}
          onDrop={onPaste}
        >
          {
            !props.multiple &&
            chosenFile.value &&
            !props.isImg &&
            <FieldFileChosen
              class="mb-3"
              icon={icon.value}
              remove={clear}
              title=""
            />
          }
          {
            props.isImg &&
            !!previews.value.length &&
            <div class="flex mb-4">
            {
              previews.value.map((src: string, i: number) => {
                return <div class={!props.imageCover && 'relative'} key={src}>
                  <img
                    class={`rounded ${props.imageCover && `absolute left-0 top-0 w-full h-full object-cover`}`}
                    src={src}
                  />
                  <div
                    class={[
                      "absolute",
                      "bg-gray-900",
                      "border-2",
                      "border-white",
                      "flex",
                      "items-center",
                      "justify-center",
                      "-right-2",
                      "-top-2",
                      "h-7",
                      "rounded-full",
                      "w-7"
                    ]}
                    onClick={(e) => clearOne(e, i)}
                  >
                    <FontAwesomeIcon class="text-white" icon={faTimes} />
                  </div>
                </div>
              })
            }
            </div>
          }
          <BtnSecondary class="s550:px-8" >
            <span class="mr-2">
              {
                !props.multiple && internalValue.value ? props.btnLabel || "Replace File" : props.btnLabel || "Add File"
              }
            </span>
            <FontAwesomeIcon class="text-gray-500" icon={faFileAlt} />
          </BtnSecondary>
          {
            props.subtitle &&
            <div class="mt-2 text-gray-900 text-base">
              {props.subtitle}
            </div>
          }
        <div class="mt-1.5 text-gray-600 text-sm">
          {`Click or Drag & Drop. Accepts: ${props.accept.join(', ')}`}</div>
        </div>
        <input
          accept={props.accept.join(', ')}
          class="absolute hidden opacity-0"
          onChange={onFileChange}
          name={props.name}
          {...ctx.attrs}
          multiple={props.multiple}
          ref={fileInput}
          type="file"
        />
        {
          showErrors.value &&
          <FieldError>{errors.value.join(", ")}</FieldError>
        }
      </>
    }
  }
})
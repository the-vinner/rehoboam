import { Field } from "@potionapps/forms";
import FieldCheckbox from "components/FieldCheckbox/FieldCheckbox";
import FieldInput from "components/FieldInput/FieldInput";
import FieldRadio from "components/FieldRadio/FieldRadio";
import FieldSelect from "components/FieldSelect/FieldSelect";
import FieldTextarea from "components/FieldTextarea/FieldTextarea";
import { defineComponent, PropType } from "vue";
import { FieldTypes } from "./RehoboamField";

export default defineComponent({
    props: {
        fields: {
            required: true,
            type: Array as PropType<Field[]>
        }
    },
    setup (props) {
        return () => <>
            {
                props.fields.map(field => {
                    switch (field.type) {
                        case FieldTypes.checkbox:
                            return <FieldCheckbox {...field} />
                        case FieldTypes.radio:
                            return <FieldRadio {...field} />
                        case FieldTypes.select:
                            return <FieldSelect {...field} />
                        case FieldTypes.textarea:
                            return <FieldTextarea {...field} />
                        default:
                            return <FieldInput {...field} />
                    }
                })
            }
        </>
    }
})
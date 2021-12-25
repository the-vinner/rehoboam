import { Field } from "@potionapps/forms";

export enum FieldTypes {
    checkbox = "checkbox",
    file = "file",
    radio = "radio",
    select = "select",
    text = "text",
    textarea = "textarea"
}
export interface RehoboamField extends Field {
    type: FieldTypes
}
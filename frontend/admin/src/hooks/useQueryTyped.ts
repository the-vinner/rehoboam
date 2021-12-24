import { useQuery, UseQueryArgs } from "@urql/vue";
import { RootQueryType } from "shared/types";

export default (args: UseQueryArgs<RootQueryType, object>) => useQuery<RootQueryType>(args)
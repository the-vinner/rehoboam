import { cacheExchange} from '@urql/exchange-graphcache';
import fieldCollection from "shared/models/Schemas/Field/fieldCollection.gql";
import { RootQueryType } from 'shared/types';

export default (schema: any) => {
  return cacheExchange({
    schema,
    updates: {
      Mutation: {
        fieldDelete: (result, args: any, cache, _info) => {
          cache
          .inspectFields('RootQueryType')
          .filter(field => field.fieldName === 'fieldCollection')
          .forEach(field => {
            cache.updateQuery(
              {
                query: fieldCollection,
                variables: field.arguments,
              },
              (data: RootQueryType | null) => {
                if (!data?.fieldCollection?.edges) return data
                data.fieldCollection.edges = data.fieldCollection.edges.filter(edge => edge?.node?.id !== args.filters.id);
                return data;
              }
            );
          });
        },
      }
    }
  })
}
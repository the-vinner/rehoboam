defmodule Rehoboam.Schemas.SchemaToSdl do
  @moduledoc """
  Generates a GraphQL schema in schema definition language (SDL) from Rehoboam schemas.
  """
  alias Rehoboam.Schemas.{Schema, Field, SchemaService}

  def field_type_to_graphql(type) do
    case type do
      :boolean -> "Boolean"
      :files -> "[File]"
      :images -> "[File]"
      :location -> "Location"
      :number -> "Integer"
      :price -> "Integer"
      # :relationships -> "[Record]"
      _ -> "String"
    end
  end

  @spec generate_sdl(list(Schema.t())) :: String.t()
  def generate_sdl(schemas) do
    Enum.reduce(
      schemas,
      {[], [], []},
      fn schema, {inputs, queries, types} ->
        {
          inputs ++ generate_input_sdl_for_schema(schema),
          queries ++ generate_query_sdl_for_schema(schema),
          types ++ generate_type_sdl_for_schema(schema)
        }
      end
    )
    |> then(fn {inputs, queries, types} ->
      """
      type Query {
        #{Enum.join(queries, "\n")}
      }
      #{Enum.join(types, "\n")}
      #{Enum.join(inputs, "\n")}
      """
    end)
  end

  def generate_field_sdl(%Field{handle: handle, type: type}) do
    "#{Rehoboam.Utils.Text.camelize(handle)}: #{field_type_to_graphql(type)}"
  end

  def generate_input_sdl_for_schema(%Schema{handle: handle, schema_id: master_id}) do
    []
  end

  def generate_query_sdl_for_schema(%Schema{handle: handle, schema_id: master_id}) do
    [
      "# Query Schema##{to_string(master_id)}",
      Rehoboam.Utils.Text.camelize(handle) <> "Collection: [#{handle_to_type(handle)}]",
      Rehoboam.Utils.Text.camelize(handle) <> ": #{handle_to_type(handle)}",
    ]
  end

  def generate_type_sdl_for_schema(%Schema{fields: fields, handle: handle, schema_id: master_id}) do
    [
      "# Type Schema##{to_string(master_id)}",
      """
      type #{handle_to_type(handle)} {
        id: ID
        internalId: ID
        #{
          Enum.map_join(
            fields,
            "\n",
            &generate_field_sdl/1
          )
        }
      }
      """
    ]
  end
  def handle_to_type(handle), do: Macro.camelize(handle)

  @spec run() :: {:ok, String.t()} | {:error, String.t()}
  def run do
    SchemaService.get_published_schemas()
    |> generate_sdl()
  end
end

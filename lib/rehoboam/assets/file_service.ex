defmodule Rehoboam.Assets.FileService do
  alias Potionx.Context.Service
  alias Rehoboam.Assets.File
  alias Rehoboam.Repo
  import Ecto.Query
  @file_upload Application.compile_env(:rehoboam, :file_upload)

  def count(%Service{} = ctx) do
    from(item in query(ctx))
    |> select([i], count(i.id))
    |> exclude(:order_by)
    |> Repo.one!()
  end

  def delete(%Service{} = ctx) do
    query(ctx)
    |> Repo.one()
    |> case do
      nil ->
        {:error, "not_found"}

      entry ->
        entry
        |> Repo.delete()
    end
  end

  def mutation(%Service{filters: %{id: id}} = ctx) when not is_nil(id) do
    query(ctx)
    |> Repo.one()
    |> case do
      nil ->
        {:error, "not_found"}

      entry ->
        File.changeset(entry, ctx.changes)
        |> Repo.update()
    end
  end

  def mutation(%Service{} = ctx) do
    Ecto.Multi.new()
    |> mutation_multi(ctx)
    |> Repo.transaction()
  end

  def mutation_multi(multi, ctx) do
    mutation_multi(multi, ctx, nil)
  end

  def mutation_multi(multi, %Service{changes: %{file_url: file_url}} = ctx, opts)
      when not is_nil(file_url) do
    %Tesla.Env{body: body} = Tesla.get!(file_url)

    [ext, mime_type] =
      Fastimage.type(body)
      |> case do
        {:ok, res} -> [to_string(res), "image/#{to_string(res)}"]
        {:error, _} -> ["unknown", "unknown"]
    end

    name = String.split(file_url, "/") |> Enum.at(-1)
    name = String.split(name, ".") |> Enum.at(0)
    name = Enum.join([Slugger.slugify_downcase(name), ext], ".")
    path = Path.join(System.tmp_dir!(), name)
    Elixir.File.write!(path, body)

    multi
    |> Ecto.Multi.run(:file, fn _, _ ->
      %File{
        mime_type: mime_type,
        title: name,
        uuid: Ecto.UUID.generate()
      }
      |> File.changeset(ctx.changes, opts)
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:upload, fn _, %{file: file} ->
      @file_upload.upload(%Rehoboam.FileUpload{
        mime_type: file.mime_type,
        path: path,
        public: true,
        title_safe: file.title_safe,
        type:
          String.split(file.mime_type, "/")
          |> Enum.at(1),
        uuid: file.uuid
      })
    end)
  end

  def mutation_multi(
        multi,
        %Service{changes: %{file: _} = changes, user: %{id: user_id}} = ctx,
        opts
      ) do
    mime_type =
      if Elixir.File.exists?(changes.file.path) do
        Fastimage.type(changes.file.path)
        |> case do
          {:ok, res} -> "image/#{to_string(res)}"
          {:error, _} -> "unknown"
        end
      else
        "unknown"
      end

    multi
    |> Ecto.Multi.run(:file, fn _, _ ->
      %File{
        uuid: Ecto.UUID.generate(),
        user_id: user_id
      }
      |> File.changeset(ctx.changes, opts)
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:upload, fn _, %{file: file} ->
      case changes do
        %{file: %Plug.Upload{path: path}} ->
          @file_upload.upload(%Rehoboam.FileUpload{
            mime_type: mime_type,
            title_safe: file.title_safe,
            path: path,
            public: true,
            type:
              String.split(mime_type, "/")
              |> Enum.at(1),
            uuid: file.uuid
          })

        _ ->
          {:ok, nil}
      end
    end)
  end

  def mutation_multi(multi, _, _) do
    multi
  end

  def one(%Service{} = ctx) do
    query(ctx)
    |> Repo.one()
  end

  def query(%Service{} = ctx) do
    File
    |> where(
      ^(ctx.filters
        |> Map.to_list())
    )
    |> order_by(desc: :id)
  end

  def query(q, _args), do: q

  def upload(%Rehoboam.FileUpload{} = upload) do
    @file_upload.upload(upload)
  end
end

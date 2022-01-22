export type Maybe<T> = T | null;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: string;
  String: string;
  Boolean: boolean;
  Int: number;
  Float: number;
  /**
   * The `DateTime` scalar type represents a date and time in the UTC
   * timezone. The DateTime appears in a JSON response as an ISO8601 formatted
   * string, including UTC timezone ("Z"). The parsed date and time string will
   * be converted to UTC if there is an offset.
   */
  DateTime: any;
  GlobalId: any;
  /**
   * The `Json` scalar type represents arbitrary json string data, represented as UTF-8
   * character sequences. The Json type is most often used to represent a free-form
   * human-readable json string.
   */
  Json: any;
  Localized: any;
  /**
   * The `Naive DateTime` scalar type represents a naive date and time without
   * timezone. The DateTime appears in a JSON response as an ISO8601 formatted
   * string.
   */
  NaiveDateTime: any;
  /** Represents an uploaded file. */
  Upload: any;
};


export type Error = {
  __typename?: 'Error';
  field?: Maybe<Scalars['String']>;
  message?: Maybe<Scalars['String']>;
};

export type Field = Node & {
  __typename?: 'Field';
  deletedAt?: Maybe<Scalars['DateTime']>;
  descriptionI18n?: Maybe<Scalars['String']>;
  file?: Maybe<File>;
  fileId?: Maybe<Scalars['ID']>;
  handle?: Maybe<Scalars['String']>;
  /** The ID of an object */
  id: Scalars['ID'];
  image?: Maybe<File>;
  imageId?: Maybe<Scalars['ID']>;
  insertedAt?: Maybe<Scalars['NaiveDateTime']>;
  internalId?: Maybe<Scalars['ID']>;
  isBody?: Maybe<Scalars['Boolean']>;
  isDescription?: Maybe<Scalars['Boolean']>;
  isImage?: Maybe<Scalars['Boolean']>;
  isLocation?: Maybe<Scalars['Boolean']>;
  isThumbnail?: Maybe<Scalars['Boolean']>;
  isTime?: Maybe<Scalars['Boolean']>;
  isTitle?: Maybe<Scalars['Boolean']>;
  meta?: Maybe<Scalars['Json']>;
  ordering?: Maybe<Scalars['Int']>;
  placeholderI18n?: Maybe<Scalars['Json']>;
  schema?: Maybe<Field>;
  schemaId?: Maybe<Scalars['ID']>;
  titleI18n?: Maybe<Scalars['String']>;
  type?: Maybe<FieldTypes>;
  updatedAt?: Maybe<Scalars['NaiveDateTime']>;
  user?: Maybe<User>;
  userId?: Maybe<Scalars['ID']>;
  validations?: Maybe<Scalars['Json']>;
};

export type FieldConnection = {
  __typename?: 'FieldConnection';
  count: Scalars['Int'];
  countBefore: Scalars['Int'];
  edges?: Maybe<Array<Maybe<FieldEdge>>>;
  pageInfo: PageInfo;
};

export type FieldEdge = {
  __typename?: 'FieldEdge';
  cursor?: Maybe<Scalars['String']>;
  node?: Maybe<Field>;
};

export type FieldFilters = {
  deletedAt?: Maybe<Scalars['DateTime']>;
  descriptionI18n?: Maybe<Scalars['Json']>;
  fileId?: Maybe<Scalars['GlobalId']>;
  handle?: Maybe<Scalars['String']>;
  imageId?: Maybe<Scalars['GlobalId']>;
  insertedAt?: Maybe<Scalars['NaiveDateTime']>;
  isBody?: Maybe<Scalars['Boolean']>;
  isDescription?: Maybe<Scalars['Boolean']>;
  isImage?: Maybe<Scalars['Boolean']>;
  isLocation?: Maybe<Scalars['Boolean']>;
  isThumbnail?: Maybe<Scalars['Boolean']>;
  isTime?: Maybe<Scalars['Boolean']>;
  isTitle?: Maybe<Scalars['Boolean']>;
  meta?: Maybe<Scalars['Json']>;
  ordering?: Maybe<Scalars['Int']>;
  placeholderI18n?: Maybe<Scalars['Json']>;
  schemaId: Scalars['GlobalId'];
  titleI18n?: Maybe<Scalars['Json']>;
  type?: Maybe<FieldTypes>;
  updatedAt?: Maybe<Scalars['NaiveDateTime']>;
  userId?: Maybe<Scalars['GlobalId']>;
  validations?: Maybe<Scalars['Json']>;
};

export type FieldFiltersSingle = {
  id: Scalars['GlobalId'];
};

export type FieldInput = {
  deletedAt?: Maybe<Scalars['DateTime']>;
  descriptionI18n?: Maybe<Scalars['Json']>;
  fileId?: Maybe<Scalars['GlobalId']>;
  handle?: Maybe<Scalars['String']>;
  imageId?: Maybe<Scalars['GlobalId']>;
  insertedAt?: Maybe<Scalars['NaiveDateTime']>;
  isBody?: Maybe<Scalars['Boolean']>;
  isDescription?: Maybe<Scalars['Boolean']>;
  isImage?: Maybe<Scalars['Boolean']>;
  isLocation?: Maybe<Scalars['Boolean']>;
  isThumbnail?: Maybe<Scalars['Boolean']>;
  isTime?: Maybe<Scalars['Boolean']>;
  isTitle?: Maybe<Scalars['Boolean']>;
  meta?: Maybe<Scalars['Json']>;
  ordering?: Maybe<Scalars['Int']>;
  placeholderI18n?: Maybe<Scalars['Json']>;
  schemaId?: Maybe<Scalars['GlobalId']>;
  titleI18n?: Maybe<Scalars['Json']>;
  type?: Maybe<FieldTypes>;
  updatedAt?: Maybe<Scalars['NaiveDateTime']>;
  userId?: Maybe<Scalars['GlobalId']>;
  validations?: Maybe<Scalars['Json']>;
};

export type FieldMutationManyResult = {
  __typename?: 'FieldMutationManyResult';
  errors?: Maybe<Array<Maybe<Scalars['String']>>>;
  errorsFields?: Maybe<Array<Maybe<Error>>>;
  nodes?: Maybe<Array<Maybe<Field>>>;
  successMsg?: Maybe<Scalars['String']>;
};

export type FieldMutationResult = {
  __typename?: 'FieldMutationResult';
  errors?: Maybe<Array<Maybe<Scalars['String']>>>;
  errorsFields?: Maybe<Array<Maybe<Error>>>;
  node?: Maybe<Field>;
  successMsg?: Maybe<Scalars['String']>;
};

export enum FieldTypes {
  Boolean = 'BOOLEAN',
  Checkbox = 'CHECKBOX',
  Custom = 'CUSTOM',
  Date = 'DATE',
  Datetime = 'DATETIME',
  Email = 'EMAIL',
  Files = 'FILES',
  Images = 'IMAGES',
  Location = 'LOCATION',
  Number = 'NUMBER',
  Phone = 'PHONE',
  Price = 'PRICE',
  Radio = 'RADIO',
  Relationships = 'RELATIONSHIPS',
  Select = 'SELECT',
  Text = 'TEXT',
  TextLong = 'TEXT_LONG',
  TextRich = 'TEXT_RICH',
  Time = 'TIME',
  Url = 'URL'
}

export type FieldUpdateInput = {
  id: Scalars['GlobalId'];
  ordering: Scalars['Int'];
};

export type File = Node & {
  __typename?: 'File';
  /** The ID of an object */
  id: Scalars['ID'];
  insertedAt?: Maybe<Scalars['NaiveDateTime']>;
  mimeType?: Maybe<Scalars['String']>;
  organizationId?: Maybe<Scalars['GlobalId']>;
  title?: Maybe<Scalars['String']>;
  titleSafe?: Maybe<Scalars['String']>;
  updatedAt?: Maybe<Scalars['NaiveDateTime']>;
  url?: Maybe<Scalars['String']>;
  userId?: Maybe<Scalars['GlobalId']>;
  uuid?: Maybe<Scalars['ID']>;
};

export type FileConnection = {
  __typename?: 'FileConnection';
  count: Scalars['Int'];
  countBefore: Scalars['Int'];
  edges?: Maybe<Array<Maybe<FileEdge>>>;
  pageInfo: PageInfo;
};

export type FileEdge = {
  __typename?: 'FileEdge';
  cursor?: Maybe<Scalars['String']>;
  node?: Maybe<File>;
};

export type FileFilters = {
  insertedAt?: Maybe<Scalars['NaiveDateTime']>;
  mimeType?: Maybe<Scalars['String']>;
  organizationId?: Maybe<Scalars['GlobalId']>;
  title?: Maybe<Scalars['String']>;
  titleSafe?: Maybe<Scalars['String']>;
  updatedAt?: Maybe<Scalars['NaiveDateTime']>;
  userId?: Maybe<Scalars['GlobalId']>;
  uuid?: Maybe<Scalars['ID']>;
};

export type FileFiltersSingle = {
  id: Scalars['GlobalId'];
};

export type FileInput = {
  file?: Maybe<Scalars['Upload']>;
  fileUrl?: Maybe<Scalars['String']>;
  insertedAt?: Maybe<Scalars['NaiveDateTime']>;
  mimeType?: Maybe<Scalars['String']>;
  organizationId?: Maybe<Scalars['GlobalId']>;
  title?: Maybe<Scalars['String']>;
  titleSafe?: Maybe<Scalars['String']>;
  updatedAt?: Maybe<Scalars['NaiveDateTime']>;
  userId?: Maybe<Scalars['GlobalId']>;
  uuid?: Maybe<Scalars['ID']>;
};

export type FileMutationResult = {
  __typename?: 'FileMutationResult';
  errors?: Maybe<Array<Maybe<Scalars['String']>>>;
  errorsFields?: Maybe<Array<Maybe<Error>>>;
  node?: Maybe<File>;
  successMsg?: Maybe<Scalars['String']>;
};





export type Node = {
  /** The ID of the object. */
  id: Scalars['ID'];
};

export type PageInfo = {
  __typename?: 'PageInfo';
  /** When paginating forwards, the cursor to continue. */
  endCursor?: Maybe<Scalars['String']>;
  /** When paginating forwards, are there more items? */
  hasNextPage: Scalars['Boolean'];
  /** When paginating backwards, are there more items? */
  hasPreviousPage: Scalars['Boolean'];
  /** When paginating backwards, the cursor to continue. */
  startCursor?: Maybe<Scalars['String']>;
};

export type RootMutationType = {
  __typename?: 'RootMutationType';
  fieldDelete?: Maybe<FieldMutationResult>;
  fieldMutation?: Maybe<FieldMutationResult>;
  fieldOrderingMutation?: Maybe<FieldMutationManyResult>;
  fileDelete?: Maybe<FileMutationResult>;
  fileMutation?: Maybe<FileMutationResult>;
  schemaDelete?: Maybe<SchemaMutationResult>;
  schemaMutation?: Maybe<SchemaMutationResult>;
  schemaPublish?: Maybe<SchemaMutationResult>;
  sessionRenew?: Maybe<SignInProviderResult>;
  signInProvider?: Maybe<SignInProviderResult>;
  signOut?: Maybe<SignInProviderResult>;
  userDelete?: Maybe<UserMutationResult>;
  userMeMutation?: Maybe<UserMutationResult>;
  userMutation?: Maybe<UserMutationResult>;
};


export type RootMutationTypeFieldDeleteArgs = {
  filters?: Maybe<FieldFiltersSingle>;
};


export type RootMutationTypeFieldMutationArgs = {
  changes?: Maybe<FieldInput>;
  filters?: Maybe<FieldFiltersSingle>;
};


export type RootMutationTypeFieldOrderingMutationArgs = {
  fields?: Maybe<Array<Maybe<FieldUpdateInput>>>;
};


export type RootMutationTypeFileDeleteArgs = {
  filters?: Maybe<FileFiltersSingle>;
};


export type RootMutationTypeFileMutationArgs = {
  changes?: Maybe<FileInput>;
  filters?: Maybe<FileFiltersSingle>;
};


export type RootMutationTypeSchemaDeleteArgs = {
  filters?: Maybe<SchemaFiltersSingle>;
};


export type RootMutationTypeSchemaMutationArgs = {
  changes?: Maybe<SchemaInput>;
  filters?: Maybe<SchemaFiltersSingle>;
};


export type RootMutationTypeSchemaPublishArgs = {
  filters: SchemaFiltersSingle;
};


export type RootMutationTypeSignInProviderArgs = {
  provider: Scalars['String'];
  redirectUrl?: Maybe<Scalars['String']>;
};


export type RootMutationTypeUserDeleteArgs = {
  filters?: Maybe<UserFiltersSingle>;
};


export type RootMutationTypeUserMeMutationArgs = {
  changes?: Maybe<UserPublicInput>;
  filters?: Maybe<UserFiltersSingle>;
};


export type RootMutationTypeUserMutationArgs = {
  changes?: Maybe<UserInput>;
  filters?: Maybe<UserFiltersSingle>;
};

export type RootQueryType = {
  __typename?: 'RootQueryType';
  fieldCollection?: Maybe<FieldConnection>;
  fieldSingle?: Maybe<Field>;
  fileCollection?: Maybe<FileConnection>;
  fileSingle?: Maybe<File>;
  me?: Maybe<User>;
  schemaCollection?: Maybe<SchemaConnection>;
  schemaPublishedCollection?: Maybe<SchemaConnection>;
  schemaPublishedSingle?: Maybe<Schema>;
  schemaSingle?: Maybe<Schema>;
  userCollection?: Maybe<UserConnection>;
  userPublicCollection?: Maybe<UserPublicConnection>;
  userPublicSingle?: Maybe<UserPublic>;
  userSingle?: Maybe<User>;
};


export type RootQueryTypeFieldCollectionArgs = {
  after?: Maybe<Scalars['String']>;
  before?: Maybe<Scalars['String']>;
  filters: FieldFilters;
  first?: Maybe<Scalars['Int']>;
  last?: Maybe<Scalars['Int']>;
  order?: Maybe<SortOrder>;
  search?: Maybe<Scalars['String']>;
};


export type RootQueryTypeFieldSingleArgs = {
  filters?: Maybe<FieldFiltersSingle>;
};


export type RootQueryTypeFileCollectionArgs = {
  after?: Maybe<Scalars['String']>;
  before?: Maybe<Scalars['String']>;
  filters?: Maybe<FileFilters>;
  first?: Maybe<Scalars['Int']>;
  last?: Maybe<Scalars['Int']>;
  order?: Maybe<SortOrder>;
  search?: Maybe<Scalars['String']>;
};


export type RootQueryTypeFileSingleArgs = {
  filters?: Maybe<FileFiltersSingle>;
};


export type RootQueryTypeSchemaCollectionArgs = {
  after?: Maybe<Scalars['String']>;
  before?: Maybe<Scalars['String']>;
  filters?: Maybe<SchemaFilters>;
  first?: Maybe<Scalars['Int']>;
  last?: Maybe<Scalars['Int']>;
  order?: Maybe<SortOrder>;
  search?: Maybe<Scalars['String']>;
};


export type RootQueryTypeSchemaPublishedCollectionArgs = {
  after?: Maybe<Scalars['String']>;
  before?: Maybe<Scalars['String']>;
  filters?: Maybe<SchemaFilters>;
  first?: Maybe<Scalars['Int']>;
  last?: Maybe<Scalars['Int']>;
  order?: Maybe<SortOrder>;
  search?: Maybe<Scalars['String']>;
};


export type RootQueryTypeSchemaPublishedSingleArgs = {
  filters?: Maybe<SchemaFiltersSingle>;
};


export type RootQueryTypeSchemaSingleArgs = {
  filters?: Maybe<SchemaFiltersSingle>;
};


export type RootQueryTypeUserCollectionArgs = {
  after?: Maybe<Scalars['String']>;
  before?: Maybe<Scalars['String']>;
  filters?: Maybe<UserFilters>;
  first?: Maybe<Scalars['Int']>;
  last?: Maybe<Scalars['Int']>;
  order?: Maybe<SortOrder>;
  search?: Maybe<Scalars['String']>;
};


export type RootQueryTypeUserPublicCollectionArgs = {
  after?: Maybe<Scalars['String']>;
  before?: Maybe<Scalars['String']>;
  filters?: Maybe<UserFilters>;
  first?: Maybe<Scalars['Int']>;
  last?: Maybe<Scalars['Int']>;
  order?: Maybe<SortOrder>;
  search?: Maybe<Scalars['String']>;
};


export type RootQueryTypeUserPublicSingleArgs = {
  filters?: Maybe<UserFiltersSingle>;
};


export type RootQueryTypeUserSingleArgs = {
  filters?: Maybe<UserFiltersSingle>;
};

export type Schema = Node & {
  __typename?: 'Schema';
  deletedAt?: Maybe<Scalars['DateTime']>;
  descriptionI18n?: Maybe<Scalars['String']>;
  fields?: Maybe<Array<Maybe<Field>>>;
  file?: Maybe<File>;
  fileId?: Maybe<Scalars['ID']>;
  handle?: Maybe<Scalars['String']>;
  /** The ID of an object */
  id: Scalars['ID'];
  insertedAt?: Maybe<Scalars['NaiveDateTime']>;
  internalId?: Maybe<Scalars['ID']>;
  isLatest?: Maybe<Scalars['Boolean']>;
  masterSchemaId?: Maybe<Scalars['ID']>;
  private?: Maybe<Scalars['Boolean']>;
  publishedAt?: Maybe<Scalars['DateTime']>;
  publishedAtHuman?: Maybe<Scalars['String']>;
  schema?: Maybe<Schema>;
  slug?: Maybe<Scalars['String']>;
  titleI18n?: Maybe<Scalars['String']>;
  updatedAt?: Maybe<Scalars['NaiveDateTime']>;
  user?: Maybe<User>;
  userId?: Maybe<Scalars['ID']>;
};

export type SchemaConnection = {
  __typename?: 'SchemaConnection';
  count: Scalars['Int'];
  countBefore: Scalars['Int'];
  edges?: Maybe<Array<Maybe<SchemaEdge>>>;
  pageInfo: PageInfo;
};

export type SchemaEdge = {
  __typename?: 'SchemaEdge';
  cursor?: Maybe<Scalars['String']>;
  node?: Maybe<Schema>;
};

export type SchemaFilters = {
  deletedAt?: Maybe<Scalars['DateTime']>;
  description?: Maybe<Scalars['String']>;
  fileId?: Maybe<Scalars['GlobalId']>;
  handle?: Maybe<Scalars['String']>;
  insertedAt?: Maybe<Scalars['NaiveDateTime']>;
  isLatest?: Maybe<Scalars['Boolean']>;
  masterSchemaId?: Maybe<Scalars['GlobalId']>;
  private?: Maybe<Scalars['Boolean']>;
  publishedAt?: Maybe<Scalars['DateTime']>;
  slug?: Maybe<Scalars['String']>;
  title?: Maybe<Scalars['String']>;
  updatedAt?: Maybe<Scalars['NaiveDateTime']>;
  userId?: Maybe<Scalars['GlobalId']>;
};

export type SchemaFiltersSingle = {
  id: Scalars['GlobalId'];
};

export type SchemaInput = {
  deletedAt?: Maybe<Scalars['DateTime']>;
  descriptionI18n?: Maybe<Scalars['Localized']>;
  fileId?: Maybe<Scalars['GlobalId']>;
  handle?: Maybe<Scalars['String']>;
  insertedAt?: Maybe<Scalars['NaiveDateTime']>;
  isLatest?: Maybe<Scalars['Boolean']>;
  masterSchemaId?: Maybe<Scalars['GlobalId']>;
  private?: Maybe<Scalars['Boolean']>;
  publishedAt?: Maybe<Scalars['DateTime']>;
  slug?: Maybe<Scalars['String']>;
  titleI18n?: Maybe<Scalars['Localized']>;
  updatedAt?: Maybe<Scalars['NaiveDateTime']>;
  userId?: Maybe<Scalars['GlobalId']>;
};

export type SchemaMutationResult = {
  __typename?: 'SchemaMutationResult';
  errors?: Maybe<Array<Maybe<Scalars['String']>>>;
  errorsFields?: Maybe<Array<Maybe<Error>>>;
  node?: Maybe<Schema>;
  successMsg?: Maybe<Scalars['String']>;
};

export type SignInProviderResult = {
  __typename?: 'SignInProviderResult';
  error?: Maybe<Scalars['String']>;
  url?: Maybe<Scalars['String']>;
};

export enum SortOrder {
  Asc = 'ASC',
  Desc = 'DESC'
}


export type User = Node & {
  __typename?: 'User';
  bio?: Maybe<Scalars['String']>;
  deletedAt?: Maybe<Scalars['DateTime']>;
  email?: Maybe<Scalars['String']>;
  file?: Maybe<File>;
  /** The ID of an object */
  id: Scalars['ID'];
  initials?: Maybe<Scalars['String']>;
  insertedAt?: Maybe<Scalars['NaiveDateTime']>;
  internalId?: Maybe<Scalars['ID']>;
  nameFirst?: Maybe<Scalars['String']>;
  nameFull?: Maybe<Scalars['String']>;
  nameLast?: Maybe<Scalars['String']>;
  roles?: Maybe<Array<Maybe<Scalars['String']>>>;
  slug?: Maybe<Scalars['String']>;
  title?: Maybe<Scalars['String']>;
  updatedAt?: Maybe<Scalars['NaiveDateTime']>;
  userIdentities?: Maybe<Array<Maybe<UserIdentity>>>;
};

export type UserConnection = {
  __typename?: 'UserConnection';
  count: Scalars['Int'];
  countBefore: Scalars['Int'];
  edges?: Maybe<Array<Maybe<UserEdge>>>;
  pageInfo: PageInfo;
};

export type UserEdge = {
  __typename?: 'UserEdge';
  cursor?: Maybe<Scalars['String']>;
  node?: Maybe<User>;
};

export type UserFilters = {
  deletedAt?: Maybe<Scalars['DateTime']>;
  insertedAt?: Maybe<Scalars['NaiveDateTime']>;
  nameFirst?: Maybe<Scalars['String']>;
  nameLast?: Maybe<Scalars['String']>;
  roles?: Maybe<Array<Maybe<Scalars['String']>>>;
  slug?: Maybe<Scalars['String']>;
  updatedAt?: Maybe<Scalars['NaiveDateTime']>;
};

export type UserFiltersSingle = {
  id?: Maybe<Scalars['GlobalId']>;
  slug?: Maybe<Scalars['String']>;
};

export type UserIdentity = Node & {
  __typename?: 'UserIdentity';
  /** The ID of an object */
  id: Scalars['ID'];
  insertedAt?: Maybe<Scalars['NaiveDateTime']>;
  provider?: Maybe<Scalars['String']>;
  uid?: Maybe<Scalars['String']>;
  updatedAt?: Maybe<Scalars['NaiveDateTime']>;
  userId?: Maybe<Scalars['ID']>;
};

export type UserInput = {
  bio?: Maybe<Scalars['String']>;
  deletedAt?: Maybe<Scalars['DateTime']>;
  file?: Maybe<Scalars['Upload']>;
  insertedAt?: Maybe<Scalars['NaiveDateTime']>;
  nameFirst?: Maybe<Scalars['String']>;
  nameLast?: Maybe<Scalars['String']>;
  roles?: Maybe<Array<Maybe<Scalars['String']>>>;
  slug?: Maybe<Scalars['String']>;
  updatedAt?: Maybe<Scalars['NaiveDateTime']>;
};

export type UserMutationResult = {
  __typename?: 'UserMutationResult';
  errors?: Maybe<Array<Maybe<Scalars['String']>>>;
  errorsFields?: Maybe<Array<Maybe<Error>>>;
  node?: Maybe<User>;
  successMsg?: Maybe<Scalars['String']>;
};

export type UserPublic = Node & {
  __typename?: 'UserPublic';
  bio?: Maybe<Scalars['String']>;
  file?: Maybe<File>;
  /** The ID of an object */
  id: Scalars['ID'];
  initials?: Maybe<Scalars['String']>;
  internalId?: Maybe<Scalars['ID']>;
  nameFirst?: Maybe<Scalars['String']>;
  nameFull?: Maybe<Scalars['String']>;
  nameLast?: Maybe<Scalars['String']>;
  slug?: Maybe<Scalars['String']>;
  title?: Maybe<Scalars['String']>;
};

export type UserPublicConnection = {
  __typename?: 'UserPublicConnection';
  count: Scalars['Int'];
  countBefore: Scalars['Int'];
  edges?: Maybe<Array<Maybe<UserPublicEdge>>>;
  pageInfo: PageInfo;
};

export type UserPublicEdge = {
  __typename?: 'UserPublicEdge';
  cursor?: Maybe<Scalars['String']>;
  node?: Maybe<UserPublic>;
};

export type UserPublicInput = {
  bio?: Maybe<Scalars['String']>;
  file?: Maybe<Scalars['Upload']>;
  nameFirst?: Maybe<Scalars['String']>;
  nameLast?: Maybe<Scalars['String']>;
  slug?: Maybe<Scalars['String']>;
};

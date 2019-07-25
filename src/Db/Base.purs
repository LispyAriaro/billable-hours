module Db.Base (findOne, find, executeWithResult) where

import Prelude

import Data.Array (last)
-- import Data.Array.Unsafe (last)
import Data.Either (either)
import Data.Maybe (Maybe(Nothing, Just))
import Database.Postgres (Client, Pool, Query(Query), connect, queryOne_, query_, release)
import Effect.Aff (Aff, throwError)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Effect.Class (liftEffect)
import Foreign (Foreign)
import Db.InsertResult (InsertResult(..), InsertResultRow(..))
import Utils as Utils
import Simple.JSON as JSON


foreign import runInsertQuery_ :: String -> Client -> EffectFnAff Foreign


findOne :: forall a. JSON.ReadForeign a => Pool -> String -> Aff (Maybe a)
findOne dbPool query = do
  conn <- connect dbPool
  result <- queryOne_ Utils.readForeignJson (Query query :: Query a) conn
  liftEffect $ release conn

  pure result

find :: forall a. JSON.ReadForeign a => Pool -> String -> Aff (Array a)
find dbPool query = do
  conn <- connect dbPool
  results <- query_ Utils.readForeignJson (Query query :: Query a) conn
  liftEffect $ release conn

  pure results

executeWithResult :: forall a. Query a -> Client -> Aff (Maybe Int)
executeWithResult (Query sql) client = do
  val <- fromEffectFnAff $ runInsertQuery_ sql client
  either throwError (\x -> (pure (getInsertedId x))) $ (Utils.readForeignJson val)

getInsertedId :: InsertResult -> Maybe Int
getInsertedId insertResult@(InsertResult{rowCount, rows}) = do
  if rowCount > 0 then do
    let lastInsertRow = last rows
    case lastInsertRow of
      Just mii@(InsertResultRow{id}) -> Just id
      Nothing -> Nothing
    else Nothing

module Db.Query (
  getAllQ, getByQ, getWhereQ,
  insertQ, updateQ,
  WhereClause(..)
) where


data WhereClause = IntWhereClause String String Int
                 | BoolWhereClause String String Boolean
                 | StringWhereClause String String String

foreign import getAllQ :: String -> String

foreign import getByQ :: forall a. String -> String -> a -> String

foreign import getWhereQ :: String -> Array WhereClause -> String

-- foreign import getNotBy :: forall a. String -> String -> a -> String

foreign import insertQ :: forall a. a -> String -> String

foreign import updateQ :: forall a. a -> Array WhereClause -> String -> String

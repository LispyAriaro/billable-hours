module Utils (readForeignJson, getDevDbConfig, getDbEnv, jsonOpts, logger, errorHandler, respond) where

import Prelude

import Data.Bifunctor (lmap)
import Data.Either (Either)
import Data.Int (fromString)
import Data.Maybe (Maybe)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Exception (error, Error, message)
import Foreign (Foreign)
import Foreign.Generic (defaultOptions)
import Foreign.Generic.Types (Options)
import Node.Express.Handler (Handler, next)
import Node.Express.Request (getOriginalUrl, setUserData)
import Node.Express.Response (sendJson, setStatus)
import Simple.JSON as JSON
import Types (DbConfig)

import Control.Monad.Maybe.Trans (runMaybeT, MaybeT(..))
import Data.Maybe
import Control.Monad.Trans.Class (lift)

import Effect (Effect)
import Node.Process (lookupEnv)


-- getDbConfig :: String -> Either String Pg.ClientConfig
getDevDbConfig :: String -> Either String DbConfig
getDevDbConfig s = lmap show (JSON.readJSON s)

getDbEnv :: Maybe String -> Maybe String -> Maybe String -> Maybe String -> Maybe String -> Maybe DbConfig
getDbEnv mDatabase mHost mPort mUser mPassword =
  do
    database <- mDatabase
    host <- mHost
    port <- mPort
    numPort <- fromString port
    user <- mUser
    password <- mPassword

    pure $ {
      database: database, host: host, port: numPort,
      user: user, password: password,
      ssl: false
    }

liftMaybe :: forall m a. Applicative m => Maybe a -> MaybeT m a
liftMaybe m = MaybeT (pure m)

liftMaybeM :: forall m a. Monad m => m (Maybe a) -> MaybeT m a
liftMaybeM m = MaybeT m

-- getDbConfig :: forall a. MaybeT (Effect Unit) a
-- getDbConfig = do
--   database <- lift $ lookupEnv "database"
--   -- host <- lookupEnv "host"
--   -- user <- lookupEnv "user"
--   -- password <- lookupEnv "password"
--   -- dbPort <- lookupEnv "port"
--   pure unit

logger :: Handler
logger = do
  url   <- getOriginalUrl
  liftEffect $ log (">>> " <> url)
  setUserData "logged" url
  next

errorHandler :: Error -> Handler
errorHandler err = do
  setStatus 400
  sendJson {error: message err}

respond :: forall a. Int -> a -> Handler
respond status body = do
  setStatus status
  sendJson body

jsonOpts :: Options
jsonOpts = defaultOptions { unwrapSingleConstructors = true }

readForeignJson :: forall a. JSON.ReadForeign a => Foreign -> Either Error a
readForeignJson = lmap (error <<< show) <<< JSON.read

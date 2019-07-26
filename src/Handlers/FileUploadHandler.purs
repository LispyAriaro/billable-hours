module Handlers.FileUploadHandler (uploadServiceImage) where

import Prelude (pure)

import Control.Promise as Promise
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Monoid ((<>))
import Data.String.CodeUnits as Str
import Database.Postgres (Pool, Query(Query), connect, execute_, query_, release) as Pg
import Database.Postgres.Transaction (withTransaction)
import Db.Base as Db
import Db.Query as Query
import Db.TableColumns as Columns
import Db.TableNames as Tables
import Effect.Aff (Aff)
import Effect.Aff.Class (liftAff)
import Effect.Class (liftEffect)
import Effect.Console (log, logShow)
import Effect.Exception (error, Error, message)
import Node.Express.Handler (Handler)
import Node.Express.Request (getBody')
import Node.Express.Response (sendJson)
import Node.Express.Types (Request, Response)
import Prelude (Unit, bind, discard, show, ($), (==), (>>=), (<))
import Utils (readForeignJson, respond)
import FFI.Multiparty
import Foreign (Foreign)



-- uploadServiceImage :: Request -> Response -> Pg.Pool -> Handler
uploadServiceImage :: Request -> Response -> Pg.Pool -> Aff (Promise.Promise Foreign)
uploadServiceImage req res dbPool = do
  uploadData <- liftEffect (grabUploadData req "file")

  -- liftEffect $ log $ "uploadData: " <> show uploadData <> "\n"

-- respond 200 {
--   status: "success",
--   message: "File upload was successful!"
-- }
  pure uploadData

module Handlers.FileUploadHandler (uploadServiceImage) where

import Control.Promise (toAff)
import Data.Either (Either(..))
import Database.Postgres (Pool) as Pg
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Exception (Error)
import FFI.Express (sendResponse, sendResponseWithStatus)
import FFI.Multiparty (grabUploadData)
import Node.Express.Types (Request, Response)
import Prelude (Unit, bind, discard, pure, unit, ($), (>>=))
import Utils (readForeignJson)


uploadServiceImage :: Request -> Response -> Pg.Pool -> Aff Unit
uploadServiceImage req res dbPool = do
  fileResult <- liftEffect (grabUploadData req "file") >>= toAff

  let fileContent = (readForeignJson fileResult) :: Either Error String
  case fileContent of
    Right actualData -> liftEffect $ sendResponse res {status: "success", data: actualData}
    Left error -> liftEffect $ sendResponseWithStatus res 400 {status: "fail"}

  pure unit

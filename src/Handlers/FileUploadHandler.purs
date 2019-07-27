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
import Prelude (bind, discard, pure, ($))
import Utils (readForeignJson)

-- import Prelude (Unit, bind, discard, show, ($), (==), (>>=), (<))


-- uploadServiceImage :: Request -> Response -> Pg.Pool -> Handler
uploadServiceImage :: Request -> Response -> Pg.Pool -> Aff String
uploadServiceImage req res dbPool = do
  fileContentPromise <- liftEffect (grabUploadData req "file")
  fileContent <- toAff fileContentPromise

  let actualData = (readForeignJson fileContent) :: Either Error String
  case actualData of
    Right theData -> liftEffect $ sendResponse res {status: "success", data: theData}
    Left error -> liftEffect $ sendResponseWithStatus res 400 {status: "fail"}

  pure "Done"

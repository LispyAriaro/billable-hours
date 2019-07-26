module FFI.Multiparty (grabUploadData) where

import Control.Promise

import Effect (Effect)
import Foreign (Foreign)
import Node.Express.Types (Request)
import Effect.Aff (Aff)


foreign import grabUploadData :: Request -> String -> Effect (Promise Foreign)

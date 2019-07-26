module FFI.Express (sendResponse, sendResponseWithStatus) where

import Prelude
import Effect (Effect)

import Node.Express.Types (Response)

foreign import sendResponse :: forall a. Response -> a -> Effect Unit

foreign import sendResponseWithStatus :: forall a. Response -> Int -> a-> Effect Unit

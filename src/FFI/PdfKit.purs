module FFI.PdfKit (generatePdf) where

import Effect (Effect)
import Prelude

foreign import generatePdf :: String -> String -> Effect Unit

module Types (DbConfig) where

type DbConfig =
  { database :: String
  , host :: String
  , port :: Int
  , user :: String
  , password :: String
  , ssl :: Boolean
  }

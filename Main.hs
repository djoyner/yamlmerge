import Control.Monad (unless)
import qualified Data.ByteString as BS
import qualified Data.HashMap.Strict as HM
import qualified Data.Vector as V
import Data.Yaml
import System.Environment (getArgs)
import System.IO (stdout)

main :: IO ()
main = do
  vs <- getArgs >>= decodeFiles
  unless (null vs) $ do
    let bs = encode $ foldr1 mergeObjects vs
    BS.hPut stdout bs

decodeFiles :: [String] -> IO [Value]
decodeFiles = mapM $ \f -> do
  e <- decodeFileEither f
  case e of
     Left ex -> error $ showParseException ex
     Right v -> return v

mergeObjects :: Value -> Value -> Value
mergeObjects (Object o1) (Object o2) = Object $ HM.unionWith mergeObjects o1 o2
mergeObjects (Array a1) (Array a2)   = Array $ (V.++) a1 a2
mergeObjects v1 v2                   = error $ "Cannot merge " ++ show v1 ++ " with " ++ show v2

showParseException :: ParseException -> String
showParseException (InvalidYaml (Just ex)) = showYamlException ex
showParseException (AesonException s)      = s
showParseException ex                      = show ex

showYamlException :: YamlException -> String
showYamlException (YamlException s)          = show s
showYamlException (YamlParseException p c m) = p ++ " " ++ c ++ " at " ++ show m

import Parsing

import Data.Text as T

main :: IO ()
main = do
  logs <- T.readFile "./logs/sample.log"
  let output = parseLogs logs
  putStr output

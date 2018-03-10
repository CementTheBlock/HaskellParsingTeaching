module Main where

import Parsing

import qualified Data.Text.IO as TIO
import qualified Data.Text as T

main :: IO ()
main = do
  logs <- TIO.readFile "./logs/sample.log"
  let output = parseLogs logs
  putStr . T.unpack $ output

{-# LANGUAGE 
module Main where

import System.ZMQ
import Data.ByteString.Char8 (pack)
import Control.Concurrent (threadDelay)
import Control.Monad(forM_)

main :: IO ()
main = withContext 1 $ \context -> do
    withSocket context Pull $ \sync -> do
        bind sync "tcp://*:5564"
        withSocket context Pub $ \publisher -> do
          bind publisher "tcp://*:5565"
          forM_ [0..9] $ \update_nbr -> do
                let string = "Update " ++ (show update_nbr)
                putStrLn string
                send publisher (pack string) []
                threadDelay $ 1 * 1000 * 1000
          send publisher (pack "END") []

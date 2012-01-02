{-# LANGUAGE OverloadedStrings #-}
module Main where
import qualified Data.ByteString.Char8 as BS
import System.ZMQ

main :: IO ()
main = withContext 1 $ \context -> do
    withSocket context Sub $ \subscriber -> do
        setOption subscriber (Identity "Hello")
        subscribe subscriber ""
        connect subscriber "tcp://localhost:5565"
        withSocket context Push $ \sync -> do
            connect sync "tcp://localhost:5564"
            send sync "" []
            get_updates subscriber
            
get_updates sock = do
    msg <- receive sock []
    BS.putStrLn msg
    if msg == "END" then return () else get_updates sock
module 	Ircclient where

import Control.Monad
import Network
import System.IO
import Text.Printf
import Control.Exception
import Control.Concurrent(forkIO,killThread,threadDelay)
import Data.Char(toUpper)

--server = "irc.freenode.org"
--chan   = "#tutbot-testing"
port = 6667

{- isQuit checks the stopping condition -}

isQuit:: String -> Bool 

isQuit s = (s == "~quit") 


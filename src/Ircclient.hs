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

{- removeTilde  removes the paded ~ for irc commands and ~~ for nickserver commands -}

removeTilde::String->String

removeTilde (x:xs) | (x =='~') = xs
				   | otherwise = (x:xs)

{-isTilde checks if the command is a nickserv command or irc command or message  -}

isTilde::String->Bool

isTilde (x:xs)     | (x =='~') = True
				   | otherwise = False


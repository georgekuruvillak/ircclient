module  Main where

import Control.Monad
import Network
import System.IO
import Text.Printf
import Control.Exception
import Control.Concurrent(forkIO,killThread,threadDelay)
import Data.Char(toUpper)
import Ircclient 
 
main = forever $ do
					print "Enter server to connect(like irc.freenode.org) to : "
					server <- getLine
					print "Enter channel to join(like #tutbot-testing) to : "
					chan <- getLine

					h <- connectTo server (PortNumber (fromIntegral port))
					hSetBuffering h NoBuffering;

					print "Enter nick to connect to : "
					nick <- getLine
					write h ("NICK "++nick)
					
					
					hClose h;
						

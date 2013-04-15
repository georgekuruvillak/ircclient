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

{- getCommand seperates the command from the user input-}
				   
getCommand::String -> String
			
getCommand str = head $ words (removeTilde str)

{- getParams seperates the parameters from the whole user input -}

getParams::String -> String

getParams str = drop (length $ getCommand (removeTilde str)) (removeTilde str)

{-parseCmd' parses the user command and decides the type-}
				
parseCmd'::String->String

parseCmd' str=	case (isTilde str) of
									True  -> do 
												case (isTilde (removeTilde str)) of 
																					True -> parseCmd''' str
																					False -> parseCmd'' str
													
									False -> "PRIVMSG " ++ annotateAsMsg str

{-parseCmd'' is the helper function of parseCmd' -}

parseCmd'' :: String -> String

parseCmd'' str = (map toUpper (getCommand str)) ++ (getParams str)													

{-parseCmd''' is the helper function of parseCmd'' -}

parseCmd'''::String->String
											
parseCmd''' str = "NickServ " ++ (parseCmd'' (removeTilde str))

annotateAsMsg :: String->String	

annotateAsMsg s=unwords((head(words s)):((annotateHelper s):(rest s)))

annotateHelper :: String->String

annotateHelper s=(':':((words s)!!1))

rest::String->[String]

rest s= tail $ tail $ words s

{-listen listens the messages from -}

listen :: Handle -> IO ()

listen h = forever $ do
				s <- hGetLine h
				printf    "> %s \n" s				 

{-write writes on the socket-}

write :: Handle -> String -> IO ()

write h s = do
				hPrintf h "%s \n" s
				print s
				
printStr str = do
				putStr str
				hFlush stdout

{-getPassword hides user password-}

getPassword :: IO String
getPassword = do
				  --putStr "Password: "
				  --hFlush stdout
				  pass <- withEcho False getLine
				  putChar '\n'
				  return pass



withEcho :: Bool -> IO a -> IO a

withEcho echo action = do
				  old <- hGetEcho stdin
				  bracket_ (hSetEcho stdin echo) (hSetEcho stdin old) action

{-identify captures the identity of the user or gives the user a temporary usage -}

identify::Handle->String->IO()
				
identify h x = case (head x) of 
								'y' -> do 
										printf "Enter password : \n"
										pass <- getPassword
										write h ("NickServ IDENTIFY " ++ pass);
								'n' -> do 
										printf "Then you should get one \n"
										threadDelay 5000
								
								_   ->do
											printf "Invalid entry give yes/no \n"
											x<-getLine
											identify h x


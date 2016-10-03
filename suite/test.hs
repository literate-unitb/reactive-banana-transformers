{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Concurrent
import Control.Lens ()
import Control.Monad

import Data.List

-- import Document.Document
-- import qualified UnitB.Test as UB
-- import qualified Latex.Test as LT
-- import Logic.UnitTest ()
-- import qualified Z3.Test as ZT
-- import qualified Document.Test as DOC
-- import qualified Utilities.Test as UT
-- import qualified Code.Test as Code
-- import qualified Documentation.Test as Sum

import Reactive.Banana.Test as RB

import Shelly hiding (time,get)

import System.Directory
import System.Exit

import Test.UnitTest
-- import Test.QuickCheck.Lens ()

-- import Utilities.Table
import System.TimeIt

test_case :: TestCase
test_case = RB.test_case

main :: IO ()
main = timeIt $ do
    xs <- getDirectoryContents "."
    setNumCapabilities 8
    let prefix ys = any (ys `isPrefixOf`) xs
    when (prefix "actual-") $
        shelly $ rm_f "actual-*.txt"
    when (prefix "expected-") $
        shelly $ rm_f "expected-*.txt"
    when (prefix "po-") $
        shelly $ rm_f "po-*.z3"
    -- b <- run_quickCheck_suite_with Main.test_case $ argMaxSuccess .= 1000
    -- b <- run_poTestSuite Main.test_case
    b <- run_test_cases Main.test_case
    if b 
    then do
        putStrLn "\n***************"
        putStrLn   "*** SUCCESS ***"
        putStrLn   "***************"
        exitSuccess
    else do
        putStrLn "\n***************"
        putStrLn   "*** FAILURE ***"
        putStrLn   "***************"
        exitFailure

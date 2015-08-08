module ElmMain where

import Signal
import Signal exposing ((<~), Signal)

import IO          exposing (..)
import Tests       exposing (..)
import Init        exposing (..)
import Search      exposing (..)
import List        exposing (map, take, head)
import Queue       exposing (push, empty, Queue, peek)
import DataStructs exposing (..)
import Maybe       exposing (..)
import Graphics.Element exposing (Element)

import Time
import Debug  exposing (watch)

import Viewer exposing (viewer)

-- port output : Signal String
-- port output = Signal.map toString (Time.every Time.second)

-- Nasty hack to make the compiler happy
main : Signal Element
main = looper ()

-- Broken things:
-- Rotation can do something catostrophic in test2 / test3. Linear shapes seem to be the problem.
-- This is probably because rotation isn't around the 'center point'. Hrm...
-- The visualizer in test1 sets the falling hex off-center. Also, the 'i' is screwed up.

looper : () -> Signal Element
looper = \ () ->
  let init = withDefault emptyModel <| head (initGameState (fromJson test2))
      initModel : Running (Queue (HexModel, List Command), (List Command, Int)) 
      initModel = More ((push empty (init, [])),([], 0))
  in  Signal.map viewer  <| Signal.foldp (\ i m -> m) 
                           initModel
                           (Time.fps 3)


-- Copyright 2016 Morgan Thomas
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--    http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

module Data.Zippable where

import Data.Functor (class Functor, map)
import Data.Array as A
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested (Tuple3, tuple3, Tuple4, Tuple5)

-- | The motivation for `Zippable` is to describe container types where you can combine two
-- | instances of the type by applying a binary operation pointwise between the elements of
-- | the two instances to create a new structurally congruent instance.
-- | 
-- | `Zippable`s must satisfy the following laws, in addition to the `Functor` laws:
-- |
-- | ```text
-- | zip (\x y -> x) v u == v
-- | zip (\x y -> y) v u == u
-- | zip (\x y -> f (g x) (h y)) v u == zip f (map g v) (map h u)
-- | ```
class (Functor f) <= Zippable f where
  zip :: forall a b c. (a -> b -> c) -> (f a -> f b -> f c)

instance arrayZippable :: Zippable Array where
  zip f a1 a2 = map (\(Tuple x y) -> f x y) (A.zip a1 a2)

zip2 :: forall f a b. (Zippable f) => f a -> f b -> f (Tuple a b)
zip2 = zip Tuple

zip3 :: forall f a b c. (Zippable f) => f a -> f b -> f c -> f (Tuple3 a b c)
zip3 u v w = zip (\x (Tuple y z) -> tuple3 x y z) u (zip2 v w)

zip4 :: forall f a b c d. (Zippable f) => f a -> f b -> f c -> f d -> f (Tuple4 a b c d)
zip4 t u v w = zip Tuple t (zip3 u v w)

zip5 :: forall f a b c d e. (Zippable f) => f a -> f b -> f c -> f d -> f e -> f (Tuple5 a b c d e)
zip5 s t u v w = zip Tuple s (zip4 t u v w)

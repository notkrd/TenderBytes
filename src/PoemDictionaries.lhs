"Singing the way they did, in the old time, we can sometimes see through the tissues
and tracings the genetic process has laid down between us and them. The tendrils can
suggest a hand; or a specific color — the yellow of the tulip, for instance — will 
flash for a moment in such a way that after it has been withdrawn we can be sure that 
there was no imagining, no auto-suggestion here, but at the same time it becomes as 
useless as all subtracted memories. It has brought certainty without heat or light. 
Yet still in the old time, in the faraway summer evenings, they must have had a word 
for this, or known that we would someday need one, and wished to help."

-John Ashberry,  "Wherever it is, Wherever You Are"

\begin{code}
module PoemDictionaries where

import PoemUnits
import System.Random
\end{code}

We're going to try to define dictionaries in a more general way. We didn't care how a
dictionary is stored and published, we care about what it does: we want to be able
to look up words. And we want to be able to add and take away elements from a
dictionary. We also want to be able to take a list of words, and make it a dictionary.
We will probably also a want a way to get a random element from a dictionary.

Note: this implementation requires using the FunctionalDependencies extension

\begin{code}
{-# LANGUAGE FunctionalDependencies #-}
class (Eq dict, PoemUnit unit) => PoemDictionary dict unit | dict -> unit where
    add_to_dict :: dict -> unit -> dict
    remove_from_dict :: dict -> unit -> dict
    make_dict_from :: [unit] -> dict
    make_list_from :: dict -> [unit]
    get_rand_elt :: dict -> StdGen -> (Maybe unit, StdGen)
    dict_contains :: dict -> unit -> Bool
\end{code}

One example of a PoemDictionary is just a list of words. Again, this requires the FlexibleInstances
extension which hopefully doesn't involve secretly clubbing baby seals. 

\begin{code}
{-# LANGUAGE FlexibleInstances #-}

chooseRandWordFromList :: (PoemUnit a) => [a] -> StdGen -> (Maybe a, StdGen)
chooseRandWordFromList dict g
    |(dict == []) = (Nothing, g)
    |otherwise = let (i, g') = randomR (0, (length dict) - 1) g in let next_word = dict !! i in
                                (Just next_word, g')


instance (PoemUnit a) => PoemDictionary [a] a where
    add_to_dict = \d u -> u : d
    remove_from_dict = \d u -> filter (\w -> w /= u) d
    make_dict_from = id
    make_list_from = id
    get_rand_elt = chooseRandWordFromList
    dict_contains = \d u -> u `elem` d
\end{code}

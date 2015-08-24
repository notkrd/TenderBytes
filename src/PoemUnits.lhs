1
apricot trees exist, apricot trees exist

2
bracken exists; and blackberries, blackberries;
bromine exists; and hydrogen, hydrogen

3
cicadas exist; chicory, chromium,
citrus trees; cicadas exist;
cicadas, cedars, cypresses, the cerebellum

4
doves exist, dreamers, and dolls;
killers exist, and doves, and doves;
haze, dioxin, and days; days
exist, days and death; and poems
exist; poems, days, death

5
early fall exists; aftertaste, afterthought;
seclusion and angels exist;
widows and elk exist; every
detail exists; memory, memory's light;
afterglow exists; oaks, elms,
junipers, sameness, loneliness exist;
eider ducks, spiders, and vinegar
exist, and the future, the future

-Inger Christensen, \emph{Alphabet}

\section{Paperwork}

\begin{code}
module PoemUnits where

import Syllables
\end{code}

\section{What is a Word}

The question here is, what is a word? 

A word is something someone says. But it seems like we get by representing words as strings, and anyway,
this thing's goal is to write poems, so ultimately, a word can be a string of characters. But a word isn't just that:
a word is a string of characters with various properties attached - perhaps sonic, syntactic, or vaguer. Maybe a word
has its own sort of mood, or maybe it gets along well with some collection of words, but can't being associated with
certain others. So it seems like the place to start would be to have words be a class PoemUnit of types that can work like words.

We'll call it a PoemUnit instead of PoemWord for the sake of generality - we want to be able to break a poem down into its component
parts in whatever way is most convenient at the time.

All we need for a PoemWord to be a word is to have a way to turn it into a list of letters. You know - a word. It's worth noting however
that the underlying word might not be the same as the "show" function: since "show" might display other data, beyond the final
word that might end up in the poem. 

We also want to know when two words are the same, and should have some way of ordering them. Plus, we should have a sort of failure word.

\begin{code}
class (Eq a, Ord a) => PoemUnit a where
    write_it :: a -> String
    just_word :: String -> a
    cellar_door :: a
\end{code}

\section{Instances of PoemWord}

Here, we'll define various representations of words:

A string like "word" should probably be a PoemUnit.

Note that this requires some FlexibleInstances thing. Hopefully this doesn't create any black holes or summon Satan.

\begin{code}
{-# LANGUAGE FlexibleInstances #-}
instance PoemUnit String where
    write_it = id
    just_word = id
    cellar_door = "cellar-door"
\end{code}

The next representation of a word we will consider is one where we attach another word to it as a label. Now twice as many
words for your literary pleasure, at the same low low price! A labeled could consist of a part of speech, a synonym, or really any
string at all. It could be the text of Anna Karenina, or of the Philadelphia phone book from 1987. The intended use is probably for
parts of speech though.

\begin{code}
data LabeledWord = LabeledWord {the_word :: String, the_label :: String} deriving (Eq, Ord)

instance PoemUnit LabeledWord where
    write_it = (\wrd -> the_word wrd)
    just_word = (\str -> LabeledWord str "")
    cellar_door = LabeledWord "cellar-door" "cellar-door"
\end{code}

\section{Functions on PoemWords}

Here are some things we can do with a PoemWord:

We can count syllables: 

\begin{code}
syllablesInWord :: (PoemUnit a) => a -> Int
syllablesInWord wrd = syllableCount (write_it wrd)
\end{code}

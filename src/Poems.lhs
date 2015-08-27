How To Be a Poet
BY WENDELL BERRY
(to remind myself)

i   

Make a place to sit down.   
Sit down. Be quiet.   
You must depend upon   
affection, reading, knowledge,   
skill—more of each   
than you have—inspiration,   
work, growing older, patience,   
for patience joins time   
to eternity. Any readers   
who like your poems,   
doubt their judgment.   

ii   

Breathe with unconditional breath   
the unconditioned air.   
Shun electric wire.   
Communicate slowly. Live   
a three-dimensioned life;   
stay away from screens.   
Stay away from anything   
that obscures the place it is in.   
There are no unsacred places;   
there are only sacred places   
and desecrated places.   

iii   

Accept what comes from silence.   
Make the best you can of it.   
Of the little words that come   
out of the silence, like prayers   
prayed back to the one who prays,   
make a poem that does not disturb   
the silence from which it came.

\section{Paperwork}

\begin{code}
module Poems where

import PoemUnits
\end{code}

\section{What's a Poem}

A poem is a bunch of words.

\begin{code}
newtype (PoemUnit a) => Poem a = Poem {the_words :: [a]}
\end{code}

\section{Things a Poem Can Do}

We can get the words in it. We can write it

\begin{code}
writePoem :: (PoemUnit a) => (Poem a) -> [String]
writePoem some_poem = map writeIt (the_words some_poem)
\end{code}
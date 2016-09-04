{-# language TemplateHaskell #-}

{-|

-}
module Capabilities.Types where
import Capabilities.Extra()
import Control.Lens

{-| A product of functors (invariant, covariant, contravariant, or both) on some type.

like a set of (unary) constraints.
first-class and explicit, unlike (single-parameter) typeclasses. 

@
Capabilities [f,g,h] a
~
OpRec a [f,g,h]
~
Rec (Apply a) [f,g,h]
~
Rec Identity [f a, g a, h a]
@

-}

-- newtype Capabilities cs a = Capabilities (OpRec a cs)
-- -- deriving (Eq, Ord, Monoid, Storable)
-- makePrisms ''Capabilities

{-


1. Capabilities = ... Rec ...

data Command cs a
 { cGrammar      :: RHS a
 , cCapabilities :: Capabilities cs a
 }

e.g.
type MyCommand = Capabilities MyCapabilities
type MyCapabilities = [Executable MyMonad, Invertible, Showable, Readable, ...]
newtype MyMonad
type MyRoot

newtype Execute m a = a -> m ()
makePrisms ''Execute
type Executable m = "execute" ::: Execute m
pExecutable = [p|Executable|]

type Showable = "show" ::: Dict Show    -- Dict :: c a => Dict c a
pShowable = [p|Showable|]
-- can't use with OverloadedLabels, via Wrapped

newtype Show_ a = a -> String
makePrisms ''Show
type Showable = "show" ::: Show_
pShowable = [p|Showable|]


vinyl-generics?


reflection?
features:
 1. propagating configurations that are available at run-time
 2. allowing multiple configurations to coexist
We only care about lawless type classes.



2. (no library)

MyDictionary a = MyDictionary {
 phrase  :: RHS a
 execute :: a -> MyMonad ()
 invert  :: a -> Maybe a
 display :: a -> String
 ...
}

RecordWildCards

_Phrase :: MyDictionary Phrase
_Phrase = MyDictionary{..} where
 grammar = phrase
 execute = runPhrase
 invert  = const Nothing
 display = show

use:
1. let MyDictionary{..} = _Phrase in ... execute ...
2. (_Phrase&execute)


-- | a closed-world of capabilities.
class HasDictionary dictionary a | a -> dictionary where
 dictionary :: forall a. dictionary a

instance HasDictionary MyDictionary Phrase where
 dictionary = _Phrase

1. execute p where MyDictionary{..} = _Phrase
2. (dictionary @Phrase & execute)

the functional dependency (+ canonicity) is anti-modular:
If someone imports your phrase type for reuse they can't add their own capabilities to it that another server requires. Type classes are open, a capabilities record is first class, and even HasDictionary can have multiple instances for the same type without the fundep.

-- | a typeclass is an overloaded product of functions
data family Dictionary (c :: * -> Constraint) :: (* -> *)

data instance Dictionary Show   a = Show_   { _show :: a -> String }
data instance Dictionary Monoid a = Monoid_ { _mempty :: a, _mappend :: a -> a }



-}

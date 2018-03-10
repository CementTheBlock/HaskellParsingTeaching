{ package ? "parser-learning", compiler ? "ghc822" }:

(import ./default.nix {
  inherit package compiler;
}).parser-learning

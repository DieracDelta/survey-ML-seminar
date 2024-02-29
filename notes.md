- no room for error
- no room for hallucination
- NO llm-based provers are open source though there are many (TODO referecnes 14-21), creating one takes lots of compute
-

- the data
  - extracting data includes the "implicit" part derived by the ITP including the premises. THIS is a primary contribution
  - enabling models to interact with lean (which is ITP)
    - Lean becomes "Gym" (see ref 22)
    - that is:
      - model sees proof state
      - changes state by executing tactic
      - lean replies with new state
      - first to interact with Lean reliability TODO what does the 21% -> 1% mean?
- a difficulty is lemma and definitions that are already defined. Want to use those when applying tactics
  - how do you train around this?? Works fine for already known stuff, but what about theorems not used in training?
  - could add all possible theorems to context, but that is too large
- the soltion proposed by the paper itself: memorization of some theorem/lemmas AND premise selection
  - ReProver (Retrieval-Augmented Prover)
  - f(state) creates tactic with context based on couple of premises from lean math library
  - TODO look at bottom of figure 1
- ReProver
  - Builds on DPR (TODO what is this, paper 26) with modifications
  - not all premises are accessible. Available premises determiend via static analysis (empirically 128k -> 33k)
  - need to give "hard negatives" to DPR. Aka irrelevant theorems/lemmas. Paper retrieves from in-file negatives.

- Benchmark and results
  - previous benchmarks bad because randomly splitting the data results in too much similarity in theorems proved
  - create own benchmark with ~100k theorem + proof from lean's mathlib
  - benchmark used both for training, evaluation, validation of ReProver
    - beat out a zero-shot GPT-4 (aka "prove pls") who only managed 26.5%

- ReProver is LIGHTWEIGHT, only 15 days of training
- ReProver is competitive with non RL provers on other datasets

- Primary contributions
  - tooling for extracing data from and interacting with lean (GYM!)
  - ReProver is the first retrieval-augmented language model for theorem proving
  - constructed a "challenging" benchmark for learning-baed theorem proving
  - open sourced everything

- dojo makes
  - DAG (edges are imports, nodes are files); AST of each file. Used for finding relevant theorems
  - extract al tactics in proof + states to construct proof tree
  - premises: location + usage. LeanDojo deals with name synonyms

"Novel premise" heuristic, so we don't accidentally copy multiple lemmas into the testing/validation datasets



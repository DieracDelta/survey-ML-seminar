/// instructions
// Preferably related to the chosen paper for presentation
// Two page write-up
// Describe: problem/challenge, state-of-the-art, top papers
// Examples: ML for protein folding (alpha-fold)
// ML for financial time-series
#import "template.typ": *
#show: ieee.with(
  title: "Automating Interactive Theorem Proving",
  abstract: [
    Preventing software bugs has always been an important problem in software engineering, due to the usage context. For example, software in both mission critical software and large scale deployment settings should not contain bugs. We present a literature review of the current research on preventing bugs in an automated fashion. Then, we discuss three current works that apply machine learning to solve this problem: LegoProver, Curriculum Learning, and LeanDojo, as well as provide a history of prior approaches to bug prevention.
  ],
  authors: (
    (
      name: "Justin Restivo",
      email: "justin.restivo@yale.edu"
    ),
  ),
  bibliography-file: "refs.bib",
)

= The Task

The task is to prevent software bugs before software is deployed. Software is used in many important contexts in which bugs can be catastrophic. Real world examples include self driving cars, nuclear @STUXNET, medical devices @THERAC25, and financial systems @DEFIHACK . Furthermore, software bugs are becoming worse with time. With introduction of AI assisted coding practices such as Copilot @COPILOT or Codeium @CODEIUM, studies find that software code quality has gone down @CODEQUALITY. Which aggressively increases the liklihood of bugs.

= Task History and Related Work

There have been many approaches and decades of research devoted to solving the problem of writing correct, bug-free software. We mention several of the most popular approaches.

== Programming Languages

According to Microsoft, 70% of their bugs were due to errors in manual memory management (denoted memory safety) @MSFT . One part of the solution has been to write application code in memory safe langauges, like Rust, Golang, Java, or Python. Even the US government recommends the use of memory safe languages to prevent bugs @GOV .

Other common causes of bugs include implicit type coersion and runtime type errors. For example, runtime type errors became so common that languages that allow runtime type errors introduced types. Notably, Javascript has largely been replaced by Typescript. Furthermore, Python has introduced optional type annotations and a type checker.

Type systems serve as a bandaid by using the compiler to prevent bugs. However, this does not solve the entire problem. There still remains a class of logical bugs that are not caught by the compiler. These bugs must be dealt with in other ways.

== Automated Theorem Proving

One way to guarantee correct code is to specify what each function does. This specification is generally created via pre and post conditions for each function (as well as loop invariants ). Then, the function's code can be verified to match the specification. This may be done by converting the code to guarded commands @GC then creating a formula from those commands using hoare logic. If the negation of that formula is satisfiable, then there exists an input such that the specification is violated. That is, a bug has been identified.

A popular implementation of this methodology is Dafny @DAFNY . However, there are still several open problems with this approach. Checking if the formula is satisfiable is a NP-complete problem. So, verifying the code may run for an unbounded and unpredictable period of time. One solution to this is to run several SAT solvers with different techniques/flags at the same time (and possibly propagate information between them) @SAT1 @SAT2 . However, this is an imperfect solution because of the higher compute demands for a potential speedup.

Another downside is the need to specify loop invariants in order for the hoare logic to be applicable. Lots of compute is required. Finally, reasoning about parallel programs is difficult.

== Interactive Theorem Proving

Another prominent approach is to use an interactive theorem prover such as Lean or Coq. Interactive theorem provers are able to, using logical axioms, work with a programmer to interactively prove facts about code. For example, a programmer could define a palindrome, then prove that the reverse of the palindrome is also a palindrome @LEANPALLY . This scales better from a computation standpoint, since NP-complete problems need not be solved to verify the code. On the other hand, this approach is time consuming in programmer hours.

Large scale examples of this approach include:
- CompCert, a verified C compiler, which is 30k lines of ocaml code and took 6 person years to verify @COMPCERT
- Certikos, a verified kernel, which is 6.5k lines of C/asm code and took 3 person years to verify @CERTIKOS
- SEL4, a verified kernel, which is 9k lines of C/asm code and took 11 person years to verify @SEL4

= Interactive Theorem Proving with Machine Learning

If there were a way to automate the theorem proving, then the programmer would not need to spend time proving the code. This would make interactive theorem proving much more feasible, thereby making verified code much more common. Although a relatively new field, we survey recent contributions in three recent works: Curriculum Learning, LeanDojo, and LEGO-Prover.

== Curriculum Learning

Curriculum Learning's primary contribution is the application of expert iteration @EXPERTITERATION to automate the proof generation for theorems in Lean. Though the original usecase for this technique was chess, Karpukhin et al. @EXPERTITERATION applies the same techniques to iteractive theorem proving because of the similarities in search space size and game type.

Karpukhin et al. started with GPT-3 pretrained on Commoncrawl (a web dataset) and webmath (a math dataset). They then defined two objective functions. The ProofStep objective function used the theorem name as a heuristic to enforce recall of related data. And the ProofSize objective function used the estimated size of the proof to prioritize smaller proofs. The model is then trained iteratively starting with the pretrained model, these objective functions and a tree search over the application of different tactics (branches) to different states (goals to prove). This ends up being a best-first search using a heuristic called logprob @LOGPROB to determine which branch to traverse. Note that there is a bootstrapping step involved as well to initially position the model.

This approach worked reasonablely well, as it was able to prove 36.6% of the theroems in the MiniF2F test benchmark @MINIF2F . However, it used LeanStep and contributed lean-gym for data extraction and data training, respectively. These two frameworks have since gone unmaintained.

== LeanDojo

LeanDojo reimplemented data extraction and forked lean-gym, both improving these libraries and upgrading them to handle Lean 4. LeanDojo's second contribution was a computationally cheap to train and run machine learning guided interactive theorem prover, denoted ReProver.

ReProver reuses the insights developed by Karpukhin et al. both of using a large language model to generate tactics to progress through a proof and a best-first search using logprob. but also emphasizes the importance of choosing the right premises (known facts) as arguments to the tactics. ReProver applies the idea of dense passage retrieval @DPR to select related premises to the state to prove. It then feeds these premises and the state into a large language model to generate the tactics to use in the best-first search.

This approach seemed to work really well given the limited resources of the model, proving 26.5% of theorems in MiniF2F. LeanDojo's large language model has an order of magnitude less parameters than Karpukhin et al. and emphasized short training times on consumer-level hardware.

LeanDojo also contributed a large dataset including training data (a large improvement over MiniF2F).

== Lego-Prover

Lego-Prover solves a slightly different, but related problem. Lego-Prover takes a paper proof of the theorem, a english version of the theorem in addition to premises and the theorem itself. Using the paper proof, Lego-Prover then splits the theorem into the composition of simpler lemmas. Lego-Prover uses K nearest neighbors to select premises to feed into the llm to prove the lemmas. Lego-Prover constantly adds to this lemma database, and improves each lemma (denoted "evolution") with a large langauge model before choosing the lemmas to use in progressing the state. Notably, unlike LeanDojo and Karpukhin et al. Lego-Prover does not use a best-first search approach.

Lego-Prover performed better than ReProver or Karpukhin et al. with a 50% success rate on MiniF2F. However, the large language model used was GPT4, which is significantly larger than both LeanDojo and Reprover. So, better performance should be expected simply due to a higher parameter count.

= Conclusion

Bugs in code are a serious problem, and researchers have been working for decades on their prevention to varying levels of success. Common bug prevention techniques include automated theorem proving, better type systems, and interactive theorem proving. However, only recently has the approach of interactive theorem proving begun to become automated using machine learning techniques. LeanDojo, LEGO-Prover, and Curriculum Learning all provide encouraging results that in the future may make writing bug free code far easier.


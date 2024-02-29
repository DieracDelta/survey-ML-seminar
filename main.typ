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
    Preventing software bugs has always been an important problem in software engineering, given the high stakes of much software. For example, both mission critical software and large scale deployment settings. We present a literature review of the current research on preventing bugs in an automated fashion using a combination of machine learning and interactive theorem proving. We discuss three current works: LegoProver, Curriculum Learning, and LeanDojo, as well as provide a history of prior approaches to bug prevention.

    // Most computer programs have bugs. This is of particular importance in many contexts, for example mission critical systems and security protecting sensitive information.
    //
    //
    //
    // In such contexts where there cannot be bugs, there are typically two approaches. First, programming languages like Dafny converts code and its specification into a logical formula that may be verified with an SMT solver. This is fairly hands off, as it involves only writing a spec. However, this approach does not scale well with large code bases, since SMT solvers are solving a NP-complete problem.
    // TODO what's the difference between automated theorem proving and ITP
    // A second common approach is to use an interactive theorem prover. The programmer will write a program and spec, then prove that the program adheres to the specification by using logic to prove the code matches the specification. This is more scalable from a compute perspective, but also much more time consuming in programmer hours.

    // Both approaches have downsides. Showing that code is correct remains a largely unsolved problem. However, recent work /* TODO references */ has explored applying machine learning to interactive theorem proving. LeanDojo TODO
  ],
  authors: (
    (
      name: "Justin Restivo",
      // department: [Computer Science],
      // organization: [Yale],
      // location: [New Haven],
      email: "justin.restivo@yale.edu"
    ),
  ),
  bibliography-file: "refs.bib",
)

= The Task

In short, the task is to prevent software bugs before they are deployed. Software is used in many important contexts in which bugs can be catastrophic. Real world examples include self driving cars, nuclear @STUXNET, medical devices @THERAC25, financial systems @DEFIHACK . And this problem of software bugs is becoming worse with time. With introduction of AI assisted coding practices such as Copilot @COPILOT or Codeium @CODEIUM, studies find that software code quality has gone down @CODEQUALITY. This increases the liklihood of bugs, increasing the importance of this problem as time goes on.

= Task History and Related Work

There have been many approaches and decades of research devoted to solving the problem of writing correct, bug-free software. We mention several of the most popular approaches.

== Programming Languages

According to Microsoft, 70% of their bugs were due to errors in manual memory management (denoted memory safety) TODO cite. A solution for this has been to write application code in memory safe langauges, like Rust, Golang, Java, or Python.

Other common causes of bugs include implicit type coersion and runtime type errors. For example, runtime type errors became so common that languages that allow type errors introduced types. For example, Javascript has largely been replaced by typescript. And Python has introduced optional type annotations and a type checker.

This serves as a bandaid by using the compiler to prevent bugs. However, this does not solve the entire problem. There still remains a class of logical bugs that are not caught by the compiler. These bugs must be dealt with in other ways.

== Automated Theorem Proving

One way to guarantee correct code is to specify what each function does. This specification is generally created via pre and post conditions to a function (and loops). Then, the code can be verified to match the specification. This may be done by converting the code to guarded commands (TODO ref) then creating a formula from those commands using hoare logic. If the negation of that formula is satisfiable, then there exists an input such that the specification is violated. That is, a bug has been identified.

A popular implementation of this methodology is Dafny (TODO ref). However, there are still several open problems with this approach. Checking if the formula is satisfiable is a NP-complete problem. So, verifying the code may run for an unbounded and unpredictable period of time. One solution to this is to run several SAT solvers with different techniques/flags at the same time (and possibly propagate information between them) (TODO cite). However, this is an imperfect solution because of the higher compute demands for a potential speedup.

Another downside is the need to specify loop invariants in order for the hoare logic to be applicable. Lots of compute is required. Finally, reasoning about parallel programs is difficult.

== Interactive Theorem Proving

Another prominent approach is to use an interactive theorem prover such as Lean or Coq. Interactive theorem provers are able to, using logical axioms, work with a programmer to interactively prove facts about code. For example, a programmer could define a palindrome, then prove that the reverse of the palindrome is also a palindrome (TODO ref). This scales better from a computation standpoint, since NP-complete problems need not be solved to verify the code. On the other hand, this approach is time consuming in programmer hours.

Large scale examples of this approach include:
- CompCert (TODO cite), a verified C compiler, which is M lines of code and took N person years to verify
- Certikos (TODO CITE), a verified kernel, which is M lines of code and took N person years to verify
- SEL4 (TODOCITE), a verified kernel, which is M lines of code and took N person years to verify

= Interactive Theorem Proving with Machine Learning

If there were a way to automate the theorem proving, then the programmer would not need to spend time proving the code. This would make interactive theorem proving much more feasible, thereby making verified code much more common. A relatively new field, we survey recent contributions to this solution in three recent works: LeanDojo, Corriculum Learning, and LEGO-Prover.







== LeanDojo

#include("leandojo.typ")

== Curriculum Learning

#include("curriculumlearning.typ")

== Legostep

#include("lego.typ")

= Conclusion

Bugs in code are a serious problem, and researchers have been working for decades on their prevention to varying levels of success. Common bug prevention techniques include automated theorem proving, better type systems, and interactive theorem proving. However, only recently has the approach of interactive theorem proving begun to become automated using machine learning techniques. LeanDojo, LEGO-Prover, and Curriculum Learning all provide encouraging results that in the future may make writing bug free code far easier.


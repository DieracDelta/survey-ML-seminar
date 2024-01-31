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
    The process of scientific writing is often tangled up with the intricacies of typesetting, leading to frustration and wasted time for researchers. In this paper, we introduce Typst, a new typesetting system designed specifically for scientific writing. Typst untangles the typesetting process, allowing researchers to compose papers faster. In a series of experiments we demonstrate that Typst offers several advantages, including faster document creation, simplified syntax, and increased ease-of-use.
  ],
  authors: (
    (
      name: "Justin Restivo",
      department: [Computer Science],
      organization: [Yale],
      location: [New Haven],
      email: "justin.restivo@yale.edu"
    ),
  ),
  index-terms: ("Scientific writing", "Typesetting", "Document creation", "Syntax"),
  bibliography-file: "refs.bib",
)

= Introduction
#include("introduction.typ")



= Existing Work

== LeanDojo

#include("leandojo.typ")

//


== Ilya paper
